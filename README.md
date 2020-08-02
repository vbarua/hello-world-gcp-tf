## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.29 |
| google | ~> 3.32.0 |
| google-beta | ~> 3.32.0 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.32.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| container\_healthcheck | Path for container healthcheck | `string` | n/a | yes |
| container\_name | Container name to deploy | `string` | n/a | yes |
| container\_port | Port exposed by the image for requests | `number` | `8080` | no |
| container\_registry\_region | The GCR region for the container registry | `string` | `"us"` | no |
| container\_tag | Container tag to deploy | `string` | n/a | yes |
| cos\_image\_name | Pinned ContainerOS image to use instead of latest | `string` | `"cos-stable-77-12371-89-0"` | no |
| http\_server\_tag | Tag for allowing http traffic | `string` | `"http-server"` | no |
| mig\_instance\_count | The number of instances to place in the managed instance group | `string` | `"2"` | no |
| mig\_service\_account | Service account to attach to the managed instance group | <pre>object({<br>    email  = string,<br>    scopes = list(string)<br>  })</pre> | <pre>{<br>  "email": "",<br>  "scopes": [<br>    "cloud-platform"<br>  ]<br>}</pre> | no |
| name\_prefix | Project prefix string for resources | `string` | `"hello-world"` | no |
| network | The GCP network | `string` | n/a | yes |
| project\_id | Project in which to create resources | `string` | n/a | yes |
| region | Region in which to create resources | `string` | `"us-west1"` | no |
| subnetwork | The GCP subnetwork | `string` | n/a | yes |
| zone | Zone in which to create resources | `string` | `"us-west1-b"` | no |

## Outputs

No output.
