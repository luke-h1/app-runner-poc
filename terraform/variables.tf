variable "docker_image_tag" {
  type        = string
  description = "The tag of the docker image to deploy"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "app-runner-poc"
}

variable "env" {
  type        = string
  description = "The environment to deploy to"
  default     = "staging"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
}

# variable "zone_id" {
#   description = "The zone ID to associate the domain with"
#   type        = string
# }

# variable "private_key" {
#   description = "Cloudflare private key to import"
#   type        = string
# }

# variable "certificate_body" {
#   description = "Cloudflare certificate body to import"
#   type        = string
# }

# variable "certificate_chain" {
#   description = "Cloudflare chain to import"
#   type        = string
# }