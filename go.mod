module github.com/theochva/teleport-plugins

go 1.18

replace (
	github.com/coreos/go-oidc => github.com/gravitational/go-oidc v0.0.3
	github.com/gogo/protobuf => github.com/gravitational/protobuf v1.3.2-0.20201123192827-2b9fcfaffcbf
	github.com/gravitational/teleport => github.com/gravitational/teleport v1.3.3-0.20210527235356-bada2617ae03
	github.com/gravitational/teleport/api => github.com/gravitational/teleport/api v0.0.0-20210527235356-bada2617ae03
	github.com/iovisor/gobpf => github.com/gravitational/gobpf v0.0.1
	github.com/julienschmidt/httprouter => github.com/rw-access/httprouter v1.3.1-0.20210321233808-98e93175c124
	github.com/siddontang/go-mysql v1.1.0 => github.com/gravitational/go-mysql v1.1.1-0.20210212011549-886316308a77
	google.golang.org/grpc => google.golang.org/grpc v1.29.1
)

require (
	github.com/gravitational/teleport v1.3.3-0.20210527235356-bada2617ae03
	github.com/gravitational/teleport/api v0.0.0
	github.com/gravitational/trace v1.1.14
	github.com/hashicorp/go-version v1.2.1
	github.com/jonboulle/clockwork v0.2.2
	github.com/julienschmidt/httprouter v1.3.0
	github.com/pborman/uuid v1.2.1
	github.com/sirupsen/logrus v1.8.1-0.20210219125412-f104497f2b21
	github.com/stretchr/testify v1.7.0
	github.com/theochva/teleport-plugins v0.0.0-20220819144332-17a4ba1eded5
	golang.org/x/crypto v0.0.0-20210220033148-5ea612d1eb83
	google.golang.org/grpc v1.31.0
)

require (
	cloud.google.com/go v0.60.0 // indirect
	cloud.google.com/go/firestore v1.2.0 // indirect
	cloud.google.com/go/storage v1.10.0 // indirect
	github.com/Azure/go-ansiterm v0.0.0-20170929234023-d6e3b3328b78 // indirect
	github.com/Azure/go-autorest/autorest v0.9.6 // indirect
	github.com/Azure/go-autorest/autorest/adal v0.8.2 // indirect
	github.com/Azure/go-autorest/autorest/date v0.2.0 // indirect
	github.com/Azure/go-autorest/logger v0.1.0 // indirect
	github.com/Azure/go-autorest/tracing v0.5.0 // indirect
	github.com/BurntSushi/toml v0.3.1 // indirect
	github.com/Microsoft/go-winio v0.4.16 // indirect
	github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751 // indirect
	github.com/alecthomas/units v0.0.0-20210208195552-ff826a37aa15 // indirect
	github.com/armon/go-radix v1.0.0 // indirect
	github.com/aws/aws-sdk-go v1.37.17 // indirect
	github.com/beevik/etree v1.1.0 // indirect
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/boombuler/barcode v1.0.1 // indirect
	github.com/cespare/xxhash/v2 v2.1.1 // indirect
	github.com/coreos/go-oidc v0.0.4 // indirect
	github.com/coreos/go-semver v0.3.0 // indirect
	github.com/coreos/go-systemd v0.0.0-20190719114852-fd7a80b32e1f // indirect
	github.com/coreos/pkg v0.0.0-20180928190104-399ea9e2e55f // indirect
	github.com/creack/pty v1.1.11 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/dgrijalva/jwt-go v3.2.0+incompatible // indirect
	github.com/docker/spdystream v0.0.0-20170912183627-bc6354cbbc29 // indirect
	github.com/flynn/hid v0.0.0-20190502022136-f1b9b6cc019a // indirect
	github.com/flynn/u2f v0.0.0-20180613185708-15554eb68e5d // indirect
	github.com/ghodss/yaml v1.0.0 // indirect
	github.com/go-logr/logr v0.2.0 // indirect
	github.com/gogo/protobuf v1.3.2 // indirect
	github.com/gokyle/hotp v0.0.0-20160218004637-c180d57d286b // indirect
	github.com/golang/groupcache v0.0.0-20200121045136-8c9f03a8e57e // indirect
	github.com/golang/protobuf v1.4.3 // indirect
	github.com/google/btree v1.0.0 // indirect
	github.com/google/go-cmp v0.5.4 // indirect
	github.com/google/gofuzz v1.1.0 // indirect
	github.com/google/uuid v1.2.0 // indirect
	github.com/googleapis/gax-go/v2 v2.0.5 // indirect
	github.com/googleapis/gnostic v0.4.1 // indirect
	github.com/gravitational/configure v0.0.0-20180808141939-c3428bd84c23 // indirect
	github.com/gravitational/form v0.0.0-20151109031454-c4048f792f70 // indirect
	github.com/gravitational/kingpin v2.1.11-0.20190130013101-742f2714c145+incompatible // indirect
	github.com/gravitational/oxy v0.0.0-20210316180922-c73d80d27348 // indirect
	github.com/gravitational/roundtrip v1.0.0 // indirect
	github.com/gravitational/ttlmap v0.0.0-20171116003245-91fd36b9004c // indirect
	github.com/hashicorp/golang-lru v0.5.4 // indirect
	github.com/imdario/mergo v0.3.5 // indirect
	github.com/iovisor/gobpf v0.0.1 // indirect
	github.com/jackc/chunkreader/v2 v2.0.1 // indirect
	github.com/jackc/pgconn v1.8.0 // indirect
	github.com/jackc/pgio v1.0.0 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgproto3/v2 v2.0.7 // indirect
	github.com/jackc/pgservicefile v0.0.0-20200714003250-2b9c44734f2b // indirect
	github.com/jmespath/go-jmespath v0.4.0 // indirect
	github.com/json-iterator/go v1.1.10 // indirect
	github.com/jstemmer/go-junit-report v0.9.1 // indirect
	github.com/kardianos/osext v0.0.0-20190222173326-2bc1f35cddc0 // indirect
	github.com/kr/pretty v0.2.1 // indirect
	github.com/kr/pty v1.1.8 // indirect
	github.com/kr/text v0.2.0 // indirect
	github.com/kylelemons/godebug v1.1.0 // indirect
	github.com/mailgun/lemma v0.0.0-20170619173223-4214099fb348 // indirect
	github.com/mailgun/metrics v0.0.0-20150124003306-2b3c4565aafd // indirect
	github.com/mailgun/minheap v0.0.0-20170619185613-3dbe6c6bf55f // indirect
	github.com/mailgun/timetools v0.0.0-20170619190023-f3a7b8ffff47 // indirect
	github.com/mailgun/ttlmap v0.0.0-20170619185759-c1c17f74874f // indirect
	github.com/mattermost/xml-roundtrip-validator v0.1.0 // indirect
	github.com/mattn/go-sqlite3 v1.14.6 // indirect
	github.com/matttproud/golang_protobuf_extensions v1.0.1 // indirect
	github.com/mdp/rsc v0.0.0-20160131164516-90f07065088d // indirect
	github.com/moby/term v0.0.0-20201216013528-df9cb8a40635 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.1 // indirect
	github.com/pingcap/errors v0.11.0 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/pquerna/otp v1.3.0 // indirect
	github.com/prometheus/client_golang v1.9.0 // indirect
	github.com/prometheus/client_model v0.2.0 // indirect
	github.com/prometheus/common v0.17.0 // indirect
	github.com/prometheus/procfs v0.2.0 // indirect
	github.com/russellhaering/gosaml2 v0.6.0 // indirect
	github.com/russellhaering/goxmldsig v1.1.0 // indirect
	github.com/satori/go.uuid v1.2.0 // indirect
	github.com/siddontang/go v0.0.0-20180604090527-bdc77568d726 // indirect
	github.com/siddontang/go-log v0.0.0-20180807004314-8d05993dda07 // indirect
	github.com/siddontang/go-mysql v1.1.0 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
	github.com/tstranex/u2f v0.0.0-20160508205855-eb799ce68da4 // indirect
	github.com/vulcand/predicate v1.1.0 // indirect
	github.com/xeipuuv/gojsonpointer v0.0.0-20151027082146-e0fe6f683076 // indirect
	github.com/xeipuuv/gojsonreference v0.0.0-20150808065054-e02fc20de94c // indirect
	github.com/xeipuuv/gojsonschema v0.0.0-20151204154511-3988ac14d6f6 // indirect
	go.etcd.io/etcd v0.5.0-alpha.5.0.20201125193152-8a03d2e9614b // indirect
	go.opencensus.io v0.22.5 // indirect
	go.uber.org/atomic v1.7.0 // indirect
	go.uber.org/multierr v1.3.0 // indirect
	go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee // indirect
	go.uber.org/zap v1.13.0 // indirect
	golang.org/x/lint v0.0.0-20201208152925-83fdc39ff7b5 // indirect
	golang.org/x/mod v0.4.1 // indirect
	golang.org/x/net v0.0.0-20210222171744-9060382bd457 // indirect
	golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d // indirect
	golang.org/x/sys v0.0.0-20210223095934-7937bea0104d // indirect
	golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d // indirect
	golang.org/x/text v0.3.5 // indirect
	golang.org/x/time v0.0.0-20191024005414-555d28b269f0 // indirect
	golang.org/x/tools v0.1.0 // indirect
	golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1 // indirect
	google.golang.org/api v0.29.0 // indirect
	google.golang.org/appengine v1.6.7 // indirect
	google.golang.org/genproto v0.0.0-20210223151946-22b48be4551b // indirect
	google.golang.org/protobuf v1.25.0 // indirect
	gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c // indirect
	gopkg.in/inf.v0 v0.9.1 // indirect
	gopkg.in/mgo.v2 v2.0.0-20190816093944-a6b53ec6cb22 // indirect
	gopkg.in/square/go-jose.v2 v2.5.1 // indirect
	gopkg.in/yaml.v2 v2.4.0 // indirect
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b // indirect
	honnef.co/go/tools v0.0.1-2020.1.5 // indirect
	k8s.io/api v0.0.0-20200821051526-051d027c14e1 // indirect
	k8s.io/apimachinery v0.20.4 // indirect
	k8s.io/client-go v0.0.0-20200827131824-5d33118d4742 // indirect
	k8s.io/klog/v2 v2.4.0 // indirect
	k8s.io/utils v0.0.0-20200729134348-d5654de09c73 // indirect
	sigs.k8s.io/structured-merge-diff/v4 v4.0.2 // indirect
	sigs.k8s.io/yaml v1.2.0 // indirect
)
