resource "random_id" "instance_name_suffix" {
  byte_length = 5
}

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/mysql/delete-instance for details.
  */
  instance_name = "${var.db_instance_name}-${random_id.instance_name_suffix.hex}"
}

module "sql_db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "3.2.0"

  project_id = var.project_id
  region     = var.region
  zone       = var.db_zone

  database_version = "POSTGRES_12"
  tier             = "db-f1-micro"

  name          = local.instance_name
  db_name       = var.db_name
  user_name     = "helloworld"
  user_password = "password"

  ip_configuration = {
    ipv4_enabled    = false
    require_ssl     = false # TODO: Configure SSL cers
    private_network = google_compute_network.hello_world.self_link
    # We never set authorized networks, we need all connections via the
    # public IP to be mediated by Cloud SQL.
    authorized_networks = []
  }

  module_depends_on = [google_service_networking_connection.private_vpc_connection]
}
