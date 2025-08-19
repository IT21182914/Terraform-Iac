# Network Configuration
variable "network_name" {
  description = "Name of the Docker network"
  type        = string
  default     = "flask-mysql-network"
}

# MySQL Configuration
variable "mysql_root_password" {
  description = "Root password for MySQL"
  type        = string
  default     = "rootpassword123"
  sensitive   = true
}

variable "mysql_database" {
  description = "Name of the MySQL database"
  type        = string
  default     = "flask_db"
}

variable "mysql_user" {
  description = "MySQL user for Flask application"
  type        = string
  default     = "flask_user"
}

variable "mysql_password" {
  description = "Password for MySQL user"
  type        = string
  default     = "flask_password"
  sensitive   = true
}

variable "mysql_container_name" {
  description = "Name of the MySQL container"
  type        = string
  default     = "mysql-container"
}

variable "mysql_image" {
  description = "MySQL Docker image"
  type        = string
  default     = "mysql:8.0"
}

# Flask Configuration
variable "flask_container_name" {
  description = "Name of the Flask container"
  type        = string
  default     = "flask-app-container"
}

variable "flask_image_name" {
  description = "Name for the Flask Docker image"
  type        = string
  default     = "flask-mysql-app"
}

variable "flask_host_port" {
  description = "Host port to expose Flask application"
  type        = number
  default     = 5000
}

variable "flask_container_port" {
  description = "Container port for Flask application"
  type        = number
  default     = 5000
}

variable "flask_app_path" {
  description = "Path to Flask application code"
  type        = string
  default     = "../flask_app"
}
