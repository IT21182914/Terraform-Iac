output "network_name" {
  description = "Name of the created Docker network"
  value       = module.network.network_name
}

output "network_id" {
  description = "ID of the created Docker network"
  value       = module.network.network_id
}

output "mysql_container_name" {
  description = "Name of the MySQL container"
  value       = module.mysql.container_name
}

output "mysql_container_id" {
  description = "ID of the MySQL container"
  value       = module.mysql.container_id
}

output "flask_container_name" {
  description = "Name of the Flask container"
  value       = module.flask.container_name
}

output "flask_container_id" {
  description = "ID of the Flask container"
  value       = module.flask.container_id
}

output "flask_image_name" {
  description = "Name of the built Flask Docker image"
  value       = module.flask.image_name
}

output "application_url" {
  description = "URL to access the Flask application"
  value       = "http://localhost:${var.flask_host_port}"
}

output "health_check_url" {
  description = "URL for health check endpoint"
  value       = "http://localhost:${var.flask_host_port}/health"
}

output "connection_info" {
  description = "Database connection information"
  value = {
    host     = var.mysql_container_name
    database = var.mysql_database
    user     = var.mysql_user
  }
  sensitive = false
}
