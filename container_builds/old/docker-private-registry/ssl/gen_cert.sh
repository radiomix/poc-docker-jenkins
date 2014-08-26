#!/bin/bash
#
# Generates self signed ssl cert
# https://devcenter.heroku.com/articles/ssl-certificate-self
# http://www.jamescoyle.net/how-to/1073-bash-script-to-create-an-ssl-certificate-key-and-request-csr
# M. Klöckner 2014.06.20
 
#Required
domain=$1
commonname=$domain
 
#Change to your company details
country=DE
state=Hassia
locality="Frankfurt am Main"
organization=im7.de
organizationalunit=IT
email=admin@im7.de
 
#Optional
password=dummypassword
 
if [ -z "$domain" ]
then
    echo "Domain or FQDN not present."
    echo "Usage $0 [FQDN ]"
 
    exit 99
fi
 
echo "Generating key request for $domain"
 
#Generate a key
openssl genrsa -des3 -passout pass:$password -out $domain.key 2048 -noout
 
#Remove passphrase from the key. Comment the line out to keep the passphrase
echo "Removing passphrase from key"
openssl rsa -in $domain.key -passin pass:$password -out $domain.key
 
#Create the request
echo "Creating CSR"
openssl req -new -key $domain.key -out $domain.csr -passin pass:$password \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

#Create the self signed Cert
echo "Creating CRT"
openssl x509 -req -days 365 -in $domain.csr -signkey $domain.key -out $domain.cert 
rm $domain.csr

#echo "---------------------------"
#echo "-----Below is your CERT-----"
#echo "---------------------------"
#echo
#cat $domain.cert
 
#echo
#echo "---------------------------"
#echo "-----Below is your Key-----"
#echo "---------------------------"
#echo
#cat $domain.key

ls -l $domain*
