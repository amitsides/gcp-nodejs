resource "google_container_cluster" "primary" {
  name               = "nodejs-helloworld"
  location           = "europe-west4"
  initial_node_count = 1
  cluster_autoscaling = true
  
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      nodejs = "23.1.0"
    }

    tags = ["nodejs", "23.1.0"]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}