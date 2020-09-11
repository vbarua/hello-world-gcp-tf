project_id = "hello-world-285123"

# Network Settings
network    = "hello-world-net"
subnetwork = "hello-world-subnet"

# Database Settings
db_instance_name = "hello-world-db"
db_name          = "helloworld"
db_zone          = "b"
db_user          = "helloworld"
db_password      = "password"

# Container Settings
container_name        = "hello-world"
container_healthcheck = "/v1/healthcheck"
container_tag         = "0.1.2"

# Managed Instance Group Settings
mig_instance_count = 1
