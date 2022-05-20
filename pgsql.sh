#!/bin/bash

SECRET=$(kubectl get secrets/database-user -o json)
DBNAME=$(echo $SECRET | jq -r .data.dbname  | base64 -d)
USERNAME=$(echo $SECRET | jq -r .data.username  | base64 -d)
PASSWORD=$(echo $SECRET | jq -r .data.password  | base64 -d)



kubectl delete pod/pg-client-gm
kubectl run -it pg-client-gm --image launcher.gcr.io/google/postgresql13 --env=PGPASSWORD=$PASSWORD --env=DB_ENDPOINT=postgres --env=DB_USERNAME=$USERNAME --env=DB_NAME=$DBNAME --rm --attach --restart=Never --overrides='{ "apiVersion": "v1", "metadata": {"annotations": { "sidecar.istio.io/inject":"false" } } }' --port=5432 -- psql -h postgres -p 5432 -U $USERNAME -w $DBNAME

