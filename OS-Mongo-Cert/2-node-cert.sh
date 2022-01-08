#!/bin/bash

dn_prefix="/C=US/ST=NJ/L=Chatham/O=Uniken"
ou_member="RELIDServer"
mongodb_server_hosts=( "test-project-0" "test-project-1" "test-project-2" )
#mongodb_server_hosts=( "mongoServer" )


#if [ "$1" = "" ]; then
#echo 'Please enter your hostname (CN):'
#exit 1
#fi
#HOST_NAME="$1"
echo "Generating Server keys"
for HOST_NAME in "${mongodb_server_hosts[@]}"; do
	echo "Generating key for $HOST_NAME node"
    openssl genrsa -out $HOST_NAME.key 4096
    openssl req -new -new -key $HOST_NAME.key -out $HOST_NAME.csr -subj "$dn_prefix/OU=$ou_member/CN=${HOST_NAME}" -config 2-node-cert.cnf
    openssl x509 -sha256 -req -days 365 -in $HOST_NAME.csr -CA mongoCA.crt -CAkey mongoCA.key -CAcreateserial -req -out $HOST_NAME.crt -extfile 2-node-cert.cnf -extensions v3_req

    cat $HOST_NAME.key $HOST_NAME.crt > ../PEMs/$HOST_NAME.pem
    openssl verify -CAfile ../PEMs/mongoCA.pem ../PEMs/$HOST_NAME.pem
    rm $HOST_NAME.csr $HOST_NAME.key $HOST_NAME.crt
done
