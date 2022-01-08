#!/bin/bash

dn_prefix="/C=US/ST=NJ/L=Chatham/O=Uniken"
ou_client="RELID"
mongodb_client_hosts=( "mongoAgent" )

# Client 

for HOST_NAME in "${mongodb_client_hosts[@]}"; do
    echo "Generating key for $HOST_NAME client"
    openssl genrsa -out $HOST_NAME.key 4096
    
    openssl req -new -new -key $HOST_NAME.key -out $HOST_NAME.csr -subj "$dn_prefix/OU=$ou_client/CN=${HOST_NAME}" -config 3-agent-cert.cnf
    
    openssl x509 -sha256 -req -days 365 -in $HOST_NAME.csr -CA mongoCA.crt -CAkey mongoCA.key -CAcreateserial -out $HOST_NAME.crt -extfile 3-agent-cert.cnf -extensions v3_req
# Create PEM file
    cat $HOST_NAME.key $HOST_NAME.crt > ../PEMs/$HOST_NAME.pem
# Verify PEM file
    openssl verify -CAfile ../PEMs/mongoCA.pem ../PEMs/$HOST_NAME.pem
    rm $HOST_NAME.csr $HOST_NAME.key $HOST_NAME.crt
done
