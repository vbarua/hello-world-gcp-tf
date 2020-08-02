project_id = "hello-world-285123"

# Network Settings
network    = "hello-world-net"
subnetwork = "hello-world-subnet"

# Container Settings
container_name        = "hello-world"
container_healthcheck = "/v1/healthcheck"
container_tag         = "0.1"

# Managed Instance Group Settings
mig_instance_count = 1
