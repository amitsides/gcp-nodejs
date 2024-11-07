#!/usr/bin/bash

    gcloud iam service-accounts create SERVICE_ACCOUNT_NAME
    gcloud projects add-iam-policy-binding PROJECT_ID --member="serviceAccount:SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com" --role=ROLE
    gcloud iam service-accounts add-iam-policy-binding SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com --member="user:USER_EMAIL" --role=roles/iam.serviceAccountUser

# init GKE
cd ./tf && terraform init && terraform apply

# init LB
git clone https://github.com/terraform-google-modules/terraform-google-lb-http

# build container 
docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME:$CI_COMMIT_SHA .

# push artifact

# run helm chart on GKE
helm install 

