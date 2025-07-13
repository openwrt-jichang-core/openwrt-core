#!/bin/sh

cd /tmp
wget -O ppsingbox https://github.com/psjiqi0/jc/releases/download/250623/pp.2
sleep 2
wget https://github.com/openwrt-jichang-core/openwrt-core/releases/download/0.1/sing_origin.json
sleep 2
chmod +x /tmp/ppsingbox

# 写 cf.sh 更新 DNS 记录
cat <<'EOCF' > /tmp/cf.sh
#!/bin/sh
CF_API_KEY="WwmHgslqyTtf-7efbfASsd0wfuo2FGb-EjrRNWDf"
ZONE_ID="b6fb85fc007fc746bb81879e696f4ef4"
DNS_RECORD_NAMES="usip11.333333338.xyz"
CURRENT_IP=$(curl -s http://ipv4.icanhazip.com)

if [ -z "$CURRENT_IP" ]; then
  echo "获取 IP 失败"
  exit 1
fi

delete_dns_record() {
  RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$DNS_RECORD_NAMES" \
    -H "Authorization: Bearer $CF_API_KEY" \
    -H "Content-Type: application/json")
  DNS_RECORD_ID=$(echo "$RESPONSE" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p' | head -n 1)

  if [ -n "$DNS_RECORD_ID" ]; then
    curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" \
      -H "Authorization: Bearer $CF_API_KEY" \
      -H "Content-Type: application/json" > /dev/null
  fi
}

delete_dns_record

curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CF_API_KEY" \
  -H "Content-Type: application/json" \
  --data '{"type":"A","name":"'"$DNS_RECORD_NAMES"'","content":"'"$CURRENT_IP"'","ttl":1,"proxied":false}'
EOCF

chmod +x /tmp/cf.sh
/tmp/cf.sh

# 写 config.json
cat <<EOCONFIG > /tmp/config.json
{
  "Log": { "Level": "error", "Output": "" },
  "Cores": [
    {
      "Type": "sing",
      "Log": { "Level": "error", "Timestamp": true },
      "NTP": { "Enable": false, "Server": "time.apple.com", "ServerPort": 0 },
      "OriginalPath": "/tmp/sing_origin.json"
    }
  ],
  "Nodes": [
    {
      "Core": "sing",
      "ApiHost": "https://apit.666666669.xyz",
      "ApiKey": "tvldryyk-zjdx-4pzp-qjri-e0t9rmt86irx",
      "NodeID": 31,
      "NodeType": "vmess",
      "Timeout": 30,
      "ListenIP": "::",
      "SendIP": "0.0.0.0",
      "DeviceOnlineMinTraffic": 1000,
      "TCPFastOpen": true,
      "SniffEnabled": true,
      "CertConfig": {
        "CertMode": "none",
        "CertDomain": "usip11.333333338.xyz",
        "CertFile": "/tmp/fullchain.cer",
        "KeyFile": "/tmp/cert.key",
        "Email": "ppanel@github.com",
        "Provider": "cloudflare",
        "DNSEnv": { "EnvName": "env1" }
      }
    },
    {
      "Core": "sing",
      "ApiHost": "https://apit.666666669.xyz",
      "ApiKey": "tvldryyk-zjdx-4pzp-qjri-e0t9rmt86irx",
      "NodeID": 32,
      "NodeType": "hysteria2",
      "Timeout": 30,
      "ListenIP": "::",
      "SendIP": "0.0.0.0",
      "DeviceOnlineMinTraffic": 1000,
      "TCPFastOpen": true,
      "SniffEnabled": true,
      "CertConfig": {
        "CertMode": "self",
        "CertDomain": "usip11.333333338.xyz",
        "CertFile": "/tmp/fullchain.cer",
        "KeyFile": "/tmp/cert.key",
        "Email": "ppanel@github.com",
        "Provider": "cloudflare",
        "DNSEnv": { "EnvName": "env1" }
      }
    },
    {
      "Core": "sing",
      "ApiHost": "https://apit.666666669.xyz",
      "ApiKey": "tvldryyk-zjdx-4pzp-qjri-e0t9rmt86irx",
      "NodeID": 33,
      "NodeType": "vless",
      "Timeout": 30,
      "ListenIP": "::",
      "SendIP": "0.0.0.0",
      "DeviceOnlineMinTraffic": 1000,
      "TCPFastOpen": true,
      "SniffEnabled": true,
      "CertConfig": {
        "CertMode": "none",
        "CertDomain": "usip11.333333338.xyz",
        "CertFile": "/tmp/fullchain.cer",
        "KeyFile": "/tmp/cert.key",
        "Email": "ppanel@github.com",
        "Provider": "cloudflare",
        "DNSEnv": { "EnvName": "env1" }
      }
    }
  ]
}
EOCONFIG

# 写证书
cat << 'EOCERT' > /tmp/fullchain.cer
-----BEGIN CERTIFICATE-----
MIIEBjCCA4ugAwIBAgIRAOiJ4pNY/moaS6f5w7VuYdYwCgYIKoZIzj0EAwMwSzEL
MAkGA1UEBhMCQVQxEDAOBgNVBAoTB1plcm9TU0wxKjAoBgNVBAMTIVplcm9TU0wg
RUNDIERvbWFpbiBTZWN1cmUgU2l0ZSBDQTAeFw0yNTA2MzAwMDAwMDBaFw0yNTA5
MjgyMzU5NTlaMBwxGjAYBgNVBAMTEXd3dy4zMzMzMzMzMzgueHl6MFkwEwYHKoZI
zj0CAQYIKoZIzj0DAQcDQgAECTFOvczFxzQHZsg9R5mTfQhMXA0gJU+ZuRnyhoWx
/9e9DQMZz4tNJD4Vf5iD/Vi0eHJ/rtpNgq9mRLBGZjHptKOCAn0wggJ5MB8GA1Ud
IwQYMBaAFA9r5kvOOUeu9n6QHnnwMJGSyF+jMB0GA1UdDgQWBBTD1UPwc7qvKAF8
14EY+4s5svdqFDAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAdBgNVHSUE
FjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwSQYDVR0gBEIwQDA0BgsrBgEEAbIxAQIC
TjAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3RpZ28uY29tL0NQUzAIBgZngQwB
AgEwgYgGCCsGAQUFBwEBBHwwejBLBggrBgEFBQcwAoY/aHR0cDovL3plcm9zc2wu
Y3J0LnNlY3RpZ28uY29tL1plcm9TU0xFQ0NEb21haW5TZWN1cmVTaXRlQ0EuY3J0
MCsGCCsGAQUFBzABhh9odHRwOi8vemVyb3NzbC5vY3NwLnNlY3RpZ28uY29tMIIB
BAYKKwYBBAHWeQIEAgSB9QSB8gDwAHYA3dzKNJXX4RYF55Uy+sef+D0cUN/bADoU
EnYKLKy7yCoAAAGXwA0yDAAABAMARzBFAiEAmgfgCl2R8Dfb+jjYZyHUYyeN6kwf
asHamOVchWEjTJsCICJgxkus5Sgl0vo4gXgg0odvkq9bw234DwNSHrOJj5JMAHYA
DeHyMCvTDcFAYhIJ6lUu/Ed0fLHX6TDvDkIetH5OqjQAAAGXwA0x3wAABAMARzBF
AiEA2muWqpX3LVHseKCZbfAVru5j0QXj/mfVLFSY7eQoibECIHAuYcdpPqQpYkt/
mmIfGOpNMXDbJIoVVk/AV84xSHSwMBwGA1UdEQQVMBOCEXd3dy4zMzMzMzMzMzgu
eHl6MAoGCCqGSM49BAMDA2kAMGYCMQDenHEsj42sOsW/Pd8s7wDeIeqD2/sbZoC5
BsmUCR40rfUYpPUd6MjytR2Tz5e2txcCMQDN9gwOb/6vsUbNwKd1IMs+RqVtI6cH
LTbQnL6dz3sfCwYwot8NGsK0bMgjIgFvF+M=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDhTCCAwygAwIBAgIQI7dt48G7KxpRlh4I6rdk6DAKBggqhkjOPQQDAzCBiDEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNl
eSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMT
JVVTRVJUcnVzdCBFQ0MgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjAwMTMw
MDAwMDAwWhcNMzAwMTI5MjM1OTU5WjBLMQswCQYDVQQGEwJBVDEQMA4GA1UEChMH
WmVyb1NTTDEqMCgGA1UEAxMhWmVyb1NTTCBFQ0MgRG9tYWluIFNlY3VyZSBTaXRl
IENBMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAENkFhFytTJe2qypTk1tpIV+9QuoRk
gte7BRvWHwYk9qUznYzn8QtVaGOCMBBfjWXsqqivl8q1hs4wAYl03uNOXgFu7iZ7
zFP6I6T3RB0+TR5fZqathfby47yOCZiAJI4go4IBdTCCAXEwHwYDVR0jBBgwFoAU
OuEJhtTPGcKWdnRJdtzgNcZjY5owHQYDVR0OBBYEFA9r5kvOOUeu9n6QHnnwMJGS
yF+jMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQW
MBQGCCsGAQUFBwMBBggrBgEFBQcDAjAiBgNVHSAEGzAZMA0GCysGAQQBsjEBAgJO
MAgGBmeBDAECATBQBgNVHR8ESTBHMEWgQ6BBhj9odHRwOi8vY3JsLnVzZXJ0cnVz
dC5jb20vVVNFUlRydXN0RUNDQ2VydGlmaWNhdGlvbkF1dGhvcml0eS5jcmwwdgYI
KwYBBQUHAQEEajBoMD8GCCsGAQUFBzAChjNodHRwOi8vY3J0LnVzZXJ0cnVzdC5j
b20vVVNFUlRydXN0RUNDQWRkVHJ1c3RDQS5jcnQwJQYIKwYBBQUHMAGGGWh0dHA6
Ly9vY3NwLnVzZXJ0cnVzdC5jb20wCgYIKoZIzj0EAwMDZwAwZAIwJHBUDwHJQN3I
VNltVMrICMqYQ3TYP/TXqV9t8mG5cAomG2MwqIsxnL937Gewf6WIAjAlrauksO6N
UuDdDXyd330druJcZJx0+H5j5cFOYBaGsKdeGW7sCMaR2PsDFKGllas=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIID0zCCArugAwIBAgIQVmcdBOpPmUxvEIFHWdJ1lDANBgkqhkiG9w0BAQwFADB7
MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8GA1UE
AwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTE5MDMxMjAwMDAwMFoXDTI4
MTIzMTIzNTk1OVowgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5
MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBO
ZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgRUNDIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEGqxUWqn5aCPnetUkb1PGWthL
q8bVttHmc3Gu3ZzWDGH926CJA7gFFOxXzu5dP+Ihs8731Ip54KODfi2X0GHE8Znc
JZFjq38wo7Rw4sehM5zzvy5cU7Ffs30yf4o043l5o4HyMIHvMB8GA1UdIwQYMBaA
FKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBQ64QmG1M8ZwpZ2dEl23OA1
xmNjmjAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zARBgNVHSAECjAI
MAYGBFUdIAAwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC5jb21vZG9jYS5j
b20vQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwNAYIKwYBBQUHAQEEKDAmMCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEM
BQADggEBABns652JLCALBIAdGN5CmXKZFjK9Dpx1WywV4ilAbe7/ctvbq5AfjJXy
ij0IckKJUAfiORVsAYfZFhr1wHUrxeZWEQff2Ji8fJ8ZOd+LygBkc7xGEJuTI42+
FsMuCIKchjN0djsoTI0DQoWz4rIjQtUfenVqGtF8qmchxDM6OW1TyaLtYiKou+JV
bJlsQ2uRl9EMC5MCHdK8aXdJ5htN978UeAOwproLtOGFfy/cQjutdAFI3tZs4RmY
CV4Ks2dH/hzg1cEo70qLRDEmBDeNiXQ2Lu+lIg+DdEmSx/cQwgwp+7e9un/jX9Wf
8qn0dNW44bOwgeThpWOjzOoEeJBuv/c=
-----END CERTIFICATE-----
EOCERT

cat << 'EOKEY' > /tmp/cert.key
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEID6+9m7F99O50xYCO4RRjoNpidEN7X2IPpqd/MOHh60qoAoGCCqGSM49
AwEHoUQDQgAECTFOvczFxzQHZsg9R5mTfQhMXA0gJU+ZuRnyhoWx/9e9DQMZz4tN
JD4Vf5iD/Vi0eHJ/rtpNgq9mRLBGZjHptA==
-----END EC PRIVATE KEY-----
EOKEY

uci del_list uhttpd.main.listen_http='0.0.0.0:8080'
uci del_list uhttpd.main.listen_http='[::]:8080'
uci commit uhttpd
/etc/init.d/uhttpd restart

cd /tmp
./cf.sh
# 启动服务
./ppsingbox server --config /tmp/config.json &
