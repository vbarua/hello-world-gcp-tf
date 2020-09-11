provider "google" {
  version = "~> 3.32.0"

  credentials = file(".gcp_creds.json")

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  version = "~> 3.32.0"

  credentials = file(".gcp_creds.json")

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "null" {
  version = "~> 2.1.2"
}

provider "random" {
  version = "~> 2.3.0"
}
