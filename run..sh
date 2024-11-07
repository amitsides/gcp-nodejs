#!/usr/bin/bash

# Cloud Shell #

gcloud iam service-accounts create SERVICE_ACCOUNT_NAME
gcloud projects add-iam-policy-binding PROJECT_ID --member="serviceAccount:SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com" --role=ROLE
gcloud iam service-accounts add-iam-policy-binding SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com --member="user:USER_EMAIL" --role=roles/iam.serviceAccountUser

# init GKE
cd ./tf && terraform init && terraform apply
# or 
 #   gcloud container clusters create nodejs-helloworld \
 #   --enable-autoscaling \
 #   --num-nodes 1 \
 #   --min-nodes 1 \
 #   --max-nodes 3 \
 #   --region=europe-west4

# init LB and init Load balancing infra
git clone https://github.com/terraform-google-modules/terraform-google-lb-http

# build container 
    # docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME:$CI_COMMIT_SHA .
docker build -t nodejs .

# push artifact
gcloud builds submit --tag europe-west4-docker.pkg.dev/gcp/nodejs/nodejshelloworld
    
# run helm chart on GKE

# or
 helm install my-release \
  --set repository=https://github.com/jbianquetti-nami/simple-node-app.git,replicaCount=2 \
    my-repo/node

