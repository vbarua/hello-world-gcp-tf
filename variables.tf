# Project Settings
# ---- ---- ---- ----
variable "project_id" {
  type        = string
  description = "Project in which to create resources"
}

variable "region" {
  type        = string
  description = "Region in which to create resources"
  default     = "us-west1"
}

variable "zone" {
  type        = string
  description = "Zone in which to create resources"
  default     = "us-west1-b"
}

variable "name_prefix" {
  type        = string
  description = "Project prefix string for resources"
  default     = "hello-world"
}

# Network Configuration
# ---- ---- ---- ---- ----
variable "network" {
  type        = string
  description = "The GCP network"
}

variable "subnetwork" {
  type        = string
  description = "The GCP subnetwork"
}

variable "http_server_tag" {
  type        = string
  description = "Tag for allowing http traffic"
  default     = "http-server"
}

# Container Settings
# ---- ---- ---- ----
variable "container_registry_region" {
  type        = string
  description = "The GCR region for the container registry"
  default     = "us"
}

variable "container_name" {
  type        = string
  description = "Container name to deploy"
}

variable "container_tag" {
  type        = string
  description = "Container tag to deploy"
}
variable "container_port" {
  type        = number
  description = "Port exposed by the image for requests"
  default     = 8080
}

variable "container_healthcheck" {
  type        = string
  description = "Path for container healthcheck"
}

variable "cos_image_name" {
  type        = string
  description = "Pinned ContainerOS image to use instead of latest"
  default     = "cos-stable-77-12371-89-0"
}

# Managed Instance Group Settings
# ---- ---- ---- ---- ---- ---- ----
variable "mig_instance_count" {
  type        = string
  description = "The number of instances to place in the managed instance group"
  default     = "2"
}

variable "mig_service_account" {
  type = object({
    email  = string,
    scopes = list(string)
  })
  description = "Service account to attach to the managed instance group"
  default = {
    email  = ""
    scopes = ["cloud-platform"]
  }
}
