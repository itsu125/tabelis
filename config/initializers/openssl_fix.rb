require 'openssl'

store = OpenSSL::X509::Store.new
store.add_file("/etc/ssl/certs/ca-certificates.crt")
OpenSSL::SSL::SSLContext::DEFAULT_CERT_STORE = store
