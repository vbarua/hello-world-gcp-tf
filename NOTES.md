# Terraform Modules
* https://github.com/terraform-google-modules/terraform-google-vm
* https://github.com/terraform-google-modules/terraform-google-container-vm

# Credentials
Create a Service Account
https://cloud.google.com/iam/docs/service-accounts

* Cloud Resource Manager API
* Cloud SQL Admin API
* Compute Engine API
* Google Container Registry API

# Commands
```sh
terraform apply -var-file="terraform.tfvars"
```

# Pushing Images
Assuming the US container region.
```sh
docker tag <image> us.gcr.io/<project>/<name>:<tag>
docker push us.gcr.io/<project>/<name>:<tag>
```

# Connecting to DB via SQL CloudProxy
```sh
cloud_sql_proxy -instances=<INSTANCE_CONNECTION_NAME>=tcp:3306
```
In order to connect to the database from your local machine, enable Public IP and add your local IP address as an authorized network. This can be useful for testing and debugging.

# Resources
* https://medium.com/swlh/how-to-deploy-a-cloud-sql-db-with-a-private-ip-only-using-terraform-e184b08eca64
