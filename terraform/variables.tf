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