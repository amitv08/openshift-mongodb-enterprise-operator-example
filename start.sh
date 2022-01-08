####start mongoDB deployment ###############
######## create secret ####################
oc create -f 1-ops-manager-config-secret.yaml
########## deploy mongoDB without tls #####
oc create -f 2-mongodb-deployment.yaml
sleep 120
#create external public ip for each mongoDB replica pod##
oc create -f 2.1-mongodb-ext-svc.yaml
###### get ip's of pods ##################
oc get svc
# insert those ip's into NodeHostIP.csv file along with hostnames of replica ####
