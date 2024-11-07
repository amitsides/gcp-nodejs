resource "google_container_cluster" "default" {
  name     = "my-cluster"
  location = "us-central1"
  # ... other cluster configurations
}

resource "google_service_account" "mesh_service_account" {
  account_id = "mesh-sa"
}

resource "google_service_account_key" "mesh_service_account_key" {
  project  = google_container_cluster.default.project
  account_id = google_service_account.mesh_service_account.account_id
  private_key_type = "JSON"
}

resource "google_service_account_key_iam_policy" "mesh_service_account_key_iam_policy" {
  project = google_container_cluster.default.project
  full_resource_id = google_service_account_key.mesh_service_account_key.name
  policy = jsonencode({
    bindings = [{
      role = "roles/iam.serviceAccountKey"
      members = ["serviceAccount:${google_container_cluster.default.project}.svc.id.goog[mesh-sa]"]
    }]
  })
}

resource "google_service_attachment" "mesh_attachment" {
  name     = "mesh-attachment"
  producer_service = "mesh-service"
  consumer_service = "mesh-consumer"
  consumer_project = google_container_cluster.default.project
  consumer_region = google_container_cluster.default.location
}

resource "google_backend_service" "backend_service" {
  name         = "backend-service"
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
  protocol      = "HTTP2"
  timeout_sec   = 30
  port          = 8080

  backend {
    group_backend_service = google_service_attachment.mesh_attachment.consumer_service
  }
}

resource "google_url_map" "url_map" {
  name    = "url-map"
  default_service = google_backend_service.backend_service.self_link

  path_matcher {
    name    = "path-matcher"
    default_service = google_backend_service.backend_service.self_link
  }
}

resource "google_target_http_proxy" "target_http_proxy" {
  name           = "target-http-proxy"
  url_map        = google_url_map.url_map.self_link
}

resource "google_global_forwarding_rule" "global_forwarding_rule" {
  name               = "global-forwarding-rule"
  ip_protocol        = "TCP"
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
  port               = 80
  target             = google_target_http_proxy.target_http_proxy.self_link
}

resource "google_compute_address" "global_address" {
  name = "global-address"
  ip_address = google_global_forwarding_rule.global_forwarding_rule.ip_address
}

resource "google_compute_firewall" "allow_http_traffic" {
  name    = "allow-http-traffic"
  network = google_container_cluster.default.network
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}