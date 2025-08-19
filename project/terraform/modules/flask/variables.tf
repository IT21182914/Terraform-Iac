variable "network_id" {
  description = "ID of the Docker network"
  type        = string
}

variable "container_name" {
  description = "Name of the Flask container"
  type        = string
}

variable "image_name" {
  description = "Name for the Flask Docker image"
  type        = string
}

variable "host_port" {
  description = "Host port to expose Flask application"
  type        = number
}

variable "container_port" {
  description = "Container port for Flask application"
  type        = number
}

variable "app_path" {
  description = "Path to Flask application code"
  type        = string
}

variable "db_host" {
  description = "Database host (container name)"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
}
