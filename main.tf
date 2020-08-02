# Configure Container Registry
# ---- ---- ---- ---- ---- ----
resource "google_container_registry" "registry" {
  location = var.container_registry_region
}

# Generate Container Metadata
# Required when creating Instance Templates
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
data "google_container_registry_image" "app-image" {
  name   = var.container_name
  tag    = var.container_tag
  region = var.container_registry_region
}

module "gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "2.0.0"

  cos_image_name = var.cos_image_name

  container = {
    image = data.google_container_registry_image.app-image.image_url
    env   = []
  }

  restart_policy = "Always"
}

# Create an Instance Template and Managed Instance Group
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
module "mig_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "4.0.0"

  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.default.self_link

  service_account      = var.mig_service_account
  name_prefix          = var.name_prefix
  source_image_family  = "cos-stable"
  source_image_project = "cos-cloud"
  source_image         = reverse(split("/", module.gce_container.source_image))[0]
  metadata = map(
    # Container metadata is used here
    "gce-container-declaration", module.gce_container.metadata_value
  )
  tags = [var.http_server_tag]
  labels = {
    "container-vm" = module.gce_container.vm_container_label
  }
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 4.0.0"

  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.default.self_link
  region     = var.region

  instance_template = module.mig_template.self_link
  hostname          = var.network
  target_size       = var.mig_instance_count
  named_ports = [
    {
      name = "hello-world",
      port = var.container_port
    }
  ]

  health_check = {
    type                = "http"
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = var.container_port
    request             = ""
    request_path        = var.container_healthcheck
    host                = ""
  }

}
