#!/bin/bash

SECRET=$(kubectl get secrets/database-user -o json)
DBNAME=$(echo $SECRET | jq -r .data.dbname  | base64 -d)
USERNAME=$(echo $SECRET | jq -r .data.username  | base64 -d)
PASSWORD=$(echo $SECRET | jq -r .data.password  | base64 -d)

#IMAGE=hasura/skor:v0.2.0
IMAGE=bladedancer/skor:latest

kubectl delete pod/skor-gm
kubectl run -it skor-gm --image $IMAGE --env=DBNAME=$DBNAME --env=PGUSER=$USERNAME --env=PGPASS=$PASSWORD --env=PGHOST=postgres --env=PGPORT=5432 --env=WEBHOOKURL=https://webhook.site/8c294cc1-cb08-4839-8841-e8beb1f674e6 --env=LOG_LEVEL=0
