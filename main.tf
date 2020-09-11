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
    env = [
      {
        name  = "SQL_HOST",
        value = module.sql_db.private_ip_address
      },
      {
        name  = "SQL_USERNAME",
        value = var.db_user
      },
      {
        name  = "SQL_PASSWORD"
        value = var.db_password
      },
      {
        name  = "SQL_DBNAME"
        value = var.db_name
      },
    ]
  }

  restart_policy = "Always"
}

# Create an Instance Template and Managed Instance Group
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
module "mig_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "4.0.0"

  network    = google_compute_network.hello_world.self_link
  subnetwork = google_compute_subnetwork.hello_world.self_link

  service_account      = var.mig_service_account
  name_prefix          = var.name_prefix
  source_image_family  = "cos-stable"
  source_image_project = "cos-cloud"
  source_image         = reverse(split("/", module.gce_container.source_image))[0]
  metadata = map(
    # Container metadata is used here
    "gce-container-declaration", module.gce_container.metadata_value,
    "google-logging-enabled", "true"
  )
  tags = [var.http_server_tag]
  labels = {
    "container-vm" = module.gce_container.vm_container_label
  }
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 4.0.0"

  network    = google_compute_network.hello_world.self_link
  subnetwork = google_compute_subnetwork.hello_world.self_link
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

# Create a Load Balancer targetting the Managed Instance Group
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
module "http-lb" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 4.2.0"

  project = var.project_id
  name    = "${var.name_prefix}-lb"
  firewall_networks = [
    google_compute_network.hello_world.self_link
  ]
  target_tags = [var.http_server_tag]

  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = var.container_port
      port_name                       = "hello-world"
      timeout_sec                     = 10
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = var.container_healthcheck
        port                = var.container_port
        host                = null
        logging             = true
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group                        = module.mig.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]
    }
  }
}
