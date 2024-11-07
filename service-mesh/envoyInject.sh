# The project that contains your GKE cluster.
export CLUSTER_PROJECT_ID=YOUR_CLUSTER_PROJECT_NUMBER_HERE
# The name of your GKE cluster.
export CLUSTER=YOUR_CLUSTER_NAME
# The channel of your GKE cluster. Eg: rapid, regular, stable.
export CHANNEL=YOUR_CLUSTER_CHANNEL
# The location of your GKE cluster, Eg: us-central1 for regional GKE cluster,
# us-central1-a for zonal GKE cluster
export LOCATION=ZONE

# The mesh name of the traffic director load balancing API.
export MESH_NAME=YOUR_MESH_NAME
# The project that holds the mesh resources.
export MESH_PROJECT_NUMBER=YOUR_PROJECT_NUMBER_HERE

export TARGET=projects/${MESH_PROJECT_NUMBER}/locations/global/meshes/${MESH_NAME}

gcloud config set project ${CLUSTER_PROJECT_ID}