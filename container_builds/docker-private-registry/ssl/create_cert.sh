#!/bin/bash

#
# Generate a 2048 SSL self signed Cert
# https://devcenter.heroku.com/articles/ssl-certificate-self
#

openssl genrsa -des3 -passout pass:x -out registry.pass.key 2048
openssl rsa -passin pass:x -in registry.pass.key -out registry.key
rm registry.pass.key
openssl req -new -key registry.key -out registry.csr
openssl x509 -req -days 730 -in registry.csr -signkey registry.key -out registry.cert

