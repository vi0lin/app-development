# read in certificate
with open('server.crt', 'rb') as f:
    trusted_certs = f.read()

# create credentials
credentials = grpc.ssl_channel_credentials(root_certificates=trusted_certs)

# create channel using ssl credentials
channel = grpc.secure_channel('{}:{}'.format(host, port), credentials)
