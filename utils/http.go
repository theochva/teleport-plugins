package utils

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"net/url"
	"os"
	"path"
	"sync"
	"time"

	"github.com/gravitational/teleport/lib/utils"
	"github.com/gravitational/trace"
	"github.com/julienschmidt/httprouter"
	log "github.com/sirupsen/logrus"
)

type TLSConfig struct {
	VerifyClientCertificate bool `toml:"verify_client_cert"`

	VerifyClientCertificateFunc func(chains [][]*x509.Certificate) error
}

type HTTPConfig struct {
	ListenAddr string              `toml:"listen_addr"`
	PublicAddr string              `toml:"public_addr"`
	KeyFile    string              `toml:"https_key_file"`
	CertFile   string              `toml:"https_cert_file"`
	BasicAuth  HTTPBasicAuthConfig `toml:"basic_auth"`
	TLS        TLSConfig           `toml:"tls"`

	Insecure bool
}

type HTTPBasicAuthConfig struct {
	Username string `toml:"user"`
	Password string `toml:"password"`
}

// HTTP is a tiny wrapper around standard net/http.
// It starts either insecure server or secure one with TLS, depending on the settings.
// It also adds a context to its handlers and the server itself has context to.
// So you are guaranteed that server will be closed when the context is cancelled.
type HTTP struct {
	HTTPConfig
	mu      sync.Mutex
	addr    net.Addr
	baseURL *url.URL
	*httprouter.Router
	server http.Server
}

// HTTPBasicAuth wraps a http.Handler with HTTP Basic Auth check.
type HTTPBasicAuth struct {
	HTTPBasicAuthConfig
	handler http.Handler
}

type httpListenChanKey struct{}

func (conf *HTTPConfig) defaultScheme() (scheme string) {
	if conf.Insecure {
		scheme = "http"
	} else {
		scheme = "https"
	}
	return
}

// BaseURL builds a base url depending on "public_addr" parameter.
func (conf *HTTPConfig) BaseURL() (*url.URL, error) {
	if conf.PublicAddr == "" {
		return &url.URL{Scheme: conf.defaultScheme()}, nil
	}
	url, err := url.Parse(conf.PublicAddr)
	if err != nil {
		return nil, err
	}

	scheme := url.Scheme
	if scheme == "" {
		scheme = conf.defaultScheme()
		return url.Parse(fmt.Sprintf("%s://%s", scheme, conf.PublicAddr))
	}

	if scheme != "http" && scheme != "https" {
		return nil, trace.BadParameter("wrong scheme in public_addr parameter: %q", scheme)
	}

	return url, nil
}

// Check validates the http server configuration.
func (conf *HTTPConfig) Check() error {
	baseURL, err := conf.BaseURL()
	if err != nil {
		return trace.Wrap(err)
	}
	if conf.KeyFile != "" && conf.CertFile == "" {
		return trace.BadParameter("https_cert_file is required when https_key_file is specified")
	}
	if conf.CertFile != "" && conf.KeyFile == "" {
		return trace.BadParameter("https_key_file is required when https_cert_file is specified")
	}
	if conf.BasicAuth.Password != "" && conf.BasicAuth.Username == "" {
		return trace.BadParameter("basic_auth.user is required when basic_auth.password is specified")
	}
	if conf.BasicAuth.Username != "" && baseURL != nil && baseURL.User != nil {
		return trace.BadParameter("passing credentials both in basic_auth section and public_addr parameter is not supported")
	}
	return nil
}

func (auth *HTTPBasicAuth) ServeHTTP(rw http.ResponseWriter, r *http.Request) {
	username, password, ok := r.BasicAuth()

	if ok && username == auth.Username && password == auth.Password {
		auth.handler.ServeHTTP(rw, r)
	} else {
		rw.Header().Set("WWW-Authenticate", "Basic realm=Restricted")
		http.Error(rw, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
	}
}

// NewHTTP creates a new HTTP wrapper
func NewHTTP(config HTTPConfig) (*HTTP, error) {
	baseURL, err := config.BaseURL()
	if err != nil {
		return nil, trace.Wrap(err)
	}
	router := httprouter.New()

	if userInfo := baseURL.User; userInfo != nil {
		password, _ := userInfo.Password()
		config.BasicAuth = HTTPBasicAuthConfig{Username: userInfo.Username(), Password: password}
	}

	var handler http.Handler
	handler = router
	if config.BasicAuth.Username != "" {
		handler = &HTTPBasicAuth{config.BasicAuth, handler}
	}

	var tlsConfig *tls.Config
	if !config.Insecure {
		tlsConfig = &tls.Config{}
		if config.TLS.VerifyClientCertificate {
			tlsConfig.ClientAuth = tls.RequireAndVerifyClientCert
			if verify := config.TLS.VerifyClientCertificateFunc; verify != nil {
				tlsConfig.VerifyPeerCertificate = func(_ [][]byte, chains [][]*x509.Certificate) error {
					if err := verify(chains); err != nil {
						log.WithError(err).Error("HTTPS client certificate verification failed")
						return err
					}
					return nil
				}
			}
		} else {
			tlsConfig.ClientAuth = tls.NoClientCert
		}
	}

	return &HTTP{
		HTTPConfig: config,
		Router:     router,
		baseURL:    baseURL,
		server:     http.Server{Handler: handler, TLSConfig: tlsConfig},
	}, nil
}

func BuildURLPath(args ...interface{}) string {
	var pathArgs []string
	for _, a := range args {
		var str string
		switch v := a.(type) {
		case string:
			str = v
		default:
			str = fmt.Sprint(v)
		}
		pathArgs = append(pathArgs, url.PathEscape(str))
	}
	return path.Join(pathArgs...)
}

// ListenAndServe runs a http(s) server on a provided port.
func (h *HTTP) ListenAndServe(ctx context.Context) error {
	defer log.Debug("HTTP server terminated")
	var err error

	h.server.BaseContext = func(_ net.Listener) context.Context {
		return ctx
	}
	go func() {
		<-ctx.Done()
		h.server.Close()
	}()

	listen := h.ListenAddr
	if listen == "" {
		if h.Insecure {
			listen = ":http"
		} else {
			listen = ":https"
		}
	}

	listenCh, _ := ctx.Value(httpListenChanKey{}).(chan<- net.Addr)
	listener, err := net.Listen("tcp", listen)
	if err != nil {
		if listenCh != nil {
			listenCh <- nil
		}
		return trace.Wrap(err)
	}
	addr := listener.Addr()

	h.mu.Lock()
	h.addr = addr
	h.mu.Unlock()

	if listenCh != nil {
		listenCh <- addr
	}

	if h.Insecure {
		log.Debugf("Starting insecure HTTP server on %s", addr)
		err = h.server.Serve(listener)
	} else {
		log.Debugf("Starting secure HTTPS server on %s", addr)
		err = h.server.ServeTLS(listener, h.CertFile, h.KeyFile)
	}
	if err == http.ErrServerClosed {
		return nil
	}
	return trace.Wrap(err)
}

// Shutdown stops the server gracefully.
func (h *HTTP) Shutdown(ctx context.Context) error {
	return h.server.Shutdown(ctx)
}

// ShutdownWithTimeout stops the server gracefully.
func (h *HTTP) ShutdownWithTimeout(ctx context.Context, duration time.Duration) error {
	ctx, cancel := context.WithTimeout(ctx, duration)
	defer cancel()

	return h.Shutdown(ctx)
}

func (h *HTTP) ServiceJob() ServiceJob {
	return NewServiceJob(func(ctx context.Context) error {
		MustGetProcess(ctx).OnTerminate(func(ctx context.Context) error {
			if err := h.ShutdownWithTimeout(ctx, time.Second*5); err != nil {
				log.Error("HTTP server graceful shutdown failed")
				return err
			}
			return nil
		})
		listenChan := make(chan net.Addr)
		var outChan chan<- net.Addr = listenChan
		ctx = context.WithValue(ctx, httpListenChanKey{}, outChan)
		go func() {
			addr := <-listenChan
			close(listenChan)
			MustGetServiceJob(ctx).SetReady(addr != nil)
		}()
		return h.ListenAndServe(ctx)
	})
}

// BaseURL returns an url on which the server is accessible externally.
func (h *HTTP) BaseURL() *url.URL {
	h.mu.Lock()
	defer h.mu.Unlock()
	url := *h.baseURL
	if url.Host == "" && h.addr != nil {
		url.Host = h.addr.String()
	}
	return &url
}

// NewURL builds an external url for a specific path and query parameters.
func (h *HTTP) NewURL(subpath string, values url.Values) *url.URL {
	url := h.BaseURL()
	url.Path = path.Join(url.Path, subpath)

	if values != nil {
		url.RawQuery = values.Encode()
	}

	return url
}

// EnsureCert checks cert and key files consistency. It also generates a self-signed cert if it was not specified.
func (h *HTTP) EnsureCert(defaultPath string) (err error) {
	if h.Insecure {
		return nil
	}
	// If files are specified by user then they should exist and possess right structure
	if h.CertFile != "" {
		_, err = tls.LoadX509KeyPair(h.CertFile, h.KeyFile)
		return err
	}

	log.Warningf("No TLS Keys provided, using self signed certificate.")

	// If files are not specified, try to fall back on self signed certificate.
	h.CertFile = defaultPath + ".crt"
	h.KeyFile = defaultPath + ".key"
	_, err = tls.LoadX509KeyPair(h.CertFile, h.KeyFile)
	if err == nil {
		// self-signed cert was generated previously
		return nil
	}
	if !os.IsNotExist(err) {
		return trace.Wrap(err, "unrecognized error reading certs")
	}

	log.Warningf("Generating self signed key and cert to %v %v.", h.KeyFile, h.CertFile)

	hostname := h.baseURL.Hostname()
	if hostname == "" {
		return trace.BadParameter("http.public_addr parameter must be provided to generate a self-signed certificate")
	}

	creds, err := utils.GenerateSelfSignedCert([]string{hostname, "localhost"})
	if err != nil {
		return trace.Wrap(err)
	}

	if err := ioutil.WriteFile(h.KeyFile, creds.PrivateKey, 0600); err != nil {
		return trace.Wrap(err, "error writing key PEM")
	}
	if err := ioutil.WriteFile(h.CertFile, creds.Cert, 0600); err != nil {
		return trace.Wrap(err, "error writing cert PEM")
	}
	return nil
}
