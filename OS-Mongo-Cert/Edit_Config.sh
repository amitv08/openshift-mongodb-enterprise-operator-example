
###Lets Cleanup before we start
rm 2-node-cert.cnf 3-agent-cert.cnf mongoCA.* mongokeystore mongodb-keyfile
rm ../PEMs/*

cp templates/2-node-cert.cnf .
cp templates/3-agent-cert.cnf .

InputCSV=../NodeHostIP.csv
ArrFileName=(2-node-cert.cnf 3-agent-cert.cnf)
for file in "${ArrFileName[@]}"; do
    row=0
    while IFS=, read -r col1 col2
    do
        ((row++))
        echo "DNS.$row = $col1" >> $file
        echo "IP.$row = $col2" >> $file
    done < $InputCSV
done
echo "Config Files are ready"

echo "Preparing .PEM and MongoStore"
./1-ca-cert.sh
./2-node-cert.sh
./3-agent-cert.sh
./4-ext-user-cert.sh