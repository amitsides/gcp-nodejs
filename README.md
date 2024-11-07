# Secure & Scalable HTTPs Getway for NodeJS App on GCP-GKE 

    git clone https://github.com/amitsides/gcp-nodejs.git 


## GCP Authentication
    gcloud iam service-accounts create SERVICE_ACCOUNT_NAME
    gcloud projects add-iam-policy-binding PROJECT_ID --member="serviceAccount:SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com" --role=ROLE
    gcloud iam service-accounts add-iam-policy-binding SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com --member="user:USER_EMAIL" --role=roles/iam.serviceAccountUser

## Init GKE (Terraform: Auto Scalable GKE Nodes or cli)
./tf terraform (tf/cli)
    
    cluster_autoscaling = true

    gcloud container clusters create nodejs-helloworld \
    --enable-autoscaling \
    --num-nodes 1 \
    --min-nodes 1 \
    --max-nodes 3 \
    --region=europe-west4

    git clone https://github.com/terraform-google-modules/terraform-google-lb-http

## NodeJS code
./src hellworld
cloned

## docker nodejs containerization alphine3.19
./docker  docker NodeJS
Reference:
https://hub.docker.com/_/node

https://github.com/nodejs/docker-node/tree/9d04fec54bd5f51abe840d7af0c70787b6b32de6/23/alpine3.19


## CI/CD: Gitlab CI + GCP artifact registry + GKE
create a GitLab CI pipeline that builds a Node.js container and pushes it to
 Google Artifact Registry + Kubernetes Engine (GKE) 

### Manually: Container Registry + Build
Building containers to Google Registry

https://cloud.google.com/build/docs/building/build-containers#json

    gcloud builds submit --tag europe-west4-docker.pkg.dev/gcp/nodejs/nodejshelloworld

### Automatically:  gitlab ci <b>YAML</b> provided
        - docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME:$CI_COMMIT_SHA .
        - kubectl set image deployment/your-deployment-name nodejs-container=$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME:$CI_COMMIT_SHA

## Kubernetes YAMLs ./k8s-nodejs
- Namespace creation
- ConfigMaps for environment variables
- Secrets management
- Deployment with health checks
- Service exposure
- Ingress configuration with TLS

# Auto Scale: Node+Pod
## Node
- cluster_autoscaling = true
## Pod
- nodejs HorizontalPodAutoscaler
- Keda Event-Driven Pod AutoScaler ScaledObject based on prometheus HTTP requests Formula:
-- query: sum(rate(http_requests_total{deployment="my-deployment"}[2m]))

# Service Mesh
## GKE Service Mesh + Envoy Auto Injector + TLS: HTTPs/443 >> NodeJsPod:3000

Reference: 
https://cloud.google.com/architecture/exposing-service-mesh-apps-through-gke-ingress?hl=en

- Set up Google Kubernetes Engine Pods using automatic Envoy injection
- xDS API: A set of gRPC APIs used for dynamic service discovery and configuration.
- Sidecar Proxy: A lightweight proxy deployed alongside your application pods to intercept and route traffic, often using Envoy Proxy.
- Use a service mesh like Istio or Anthos Service Mesh to inject the sidecar proxy into your pods.
- Configure the service mesh to use the xDS API and point to your Google Cloud control plane.
- Installing the Envoy sidecar injector and enabling injection.
- network endpoint groups (NEGs) 
- Cloud Service Mesh

## Terraform: GKE + ALB + TLS + NEG

https://cloud.google.com/load-balancing/docs/https

- HTTPS ALB: A Google Cloud load balancer that terminates TLS traffic and routes it to your backend services.


    git clone https://github.com/terraform-google-modules/terraform-google-lb-http

https://github.com/terraform-google-modules/terraform-google-lb-http/tree/v12.0.0/examples/https-gke


https://cloud.google.com/service-mesh/legacy/load-balancing-apis/set-up-gke-pods-auto#installing_the_sidecar_injector_to_your_cluster

## Envoy Injection
    kubectl label namespace NAMESPACE istio-injection=enabled istio.io/rev- --overwrite
# Installation/Workflow

1. Authenticatiton Config GCP Credentials for terraform
https://cloud.google.com/docs/terraform/authentication

2. init GCP Kubernetes/GKE 
`terraform init && terraform apply`

3. Build nodejs-helloworld docker container ( FROM alpine:3.19 ENV NODE_VERSION 23.1.0) using gitlab-ci yaml, push to gcp artifact registry & deploy to GKE.

4. Helm Chart Deploy you nodejs app to any scale (support Pod AutoScale with Keda)
    `helm install`

5. Ingress/GCP Service Mesh/Istio/Anthos (see ./service-mesh)

    kubectl label namespace NAMESPACE istio-injection=enabled istio.io/rev- --overwrite

    kubectl \
      --namespace istio-system \
    --context=cluster-with-istio \
    get service --output jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}'

6. Secure your end-point with cloud armor

    
    https://cloud.google.com/armor/docs/integrating-cloud-armor
    
    https://cloud.google.com/architecture/exposing-service-mesh-apps-through-gke-ingress?hl=en


# Advanced Topics: MultiCluster Getways Fleets

    git clone https://github.com/LukeMwila/fleet-multi-cluster-cd

# Summery

Note: Ensure your application is listening on port 3000.
No need to handle HTTPS in your application, as TLS termination occurs at the load balancer.

By following these steps, your GCP Application Load Balancer will handle TLS termination, and your Node.js application running on GKE pods will receive unencrypted HTTP traffic on port 300015. This setup ensures that the SSL/TLS encryption is managed by the load balancer, simplifying your application's configuration and potentially improving performance.

