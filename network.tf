# Network Configs
# ---- ---- ---- ----
resource "google_compute_network" "hello_world" {
  name                    = var.network
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "hello_world" {
  name                     = var.subnetwork
  ip_cidr_range            = "10.125.0.0/20"
  network                  = google_compute_network.hello_world.self_link
  region                   = var.region
  private_ip_google_access = true
}

## Configuring a Private VPC Connection to enable Private IP
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.hello_world.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.hello_world.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# Firewall Rule Configs
# ---- ---- ---- ----
resource "google_compute_firewall" "http-server" {
  name    = "hello-world-allow-http"
  network = google_compute_network.hello_world.self_link

  allow {
    protocol = "tcp"
    ports    = [var.container_port]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.http_server_tag]
}
