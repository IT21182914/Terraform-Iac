variable "network_id" {
  description = "ID of the Docker network"
  type        = string
}

variable "container_name" {
  description = "Name of the MySQL container"
  type        = string
}

variable "mysql_image" {
  description = "MySQL Docker image"
  type        = string
  default     = "mysql:8.0"
}

variable "mysql_root_password" {
  description = "Root password for MySQL"
  type        = string
  sensitive   = true
}

variable "mysql_database" {
  description = "Name of the MySQL database to create"
  type        = string
}

variable "mysql_user" {
  description = "MySQL user to create"
  type        = string
}

variable "mysql_password" {
  description = "Password for MySQL user"
  type        = string
  sensitive   = true
}
