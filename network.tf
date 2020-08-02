# Network Configs
# ---- ---- ---- ----
resource "google_compute_network" "default" {
  name                    = var.network
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = var.subnetwork
  ip_cidr_range            = "10.125.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

# Firewall Rule Configs
# ---- ---- ---- ----
resource "google_compute_firewall" "http-server" {
  name    = "hello-world-allow-http"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = [var.container_port]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.http_server_tag]
}
