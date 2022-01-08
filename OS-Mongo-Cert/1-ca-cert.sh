dn_prefix="/C=US/ST=NJ/L=Chatham/O=Uniken"

# Sign a new CA certificate
openssl genrsa -out mongoCA.key 8192 #-aes256
echo "Creating CRT"
openssl req -x509 -days 365 -new -key mongoCA.key -out mongoCA.crt -subj "$dn_prefix/CN=ROOTCA" -config 1-ca-cert.cnf
cat mongoCA.key mongoCA.crt > ../PEMs/mongoCA.pem

keytool -noprompt -importcert -trustcacerts -file mongoCA.crt -keystore mongokeystore -storepass mongostore
mv mongokeystore ../PEMs

echo "Preparing mongodb-keyfile"
openssl rand -base64 32 > mongodb-keyfile
mv mongodb-keyfile ../PEMs