output "container_id" {
  description = "ID of the Flask container"
  value       = docker_container.flask_app.id
}

output "container_name" {
  description = "Name of the Flask container"
  value       = docker_container.flask_app.name
}

output "image_name" {
  description = "Flask image name used"
  value       = docker_image.flask_app.name
}

output "image_id" {
  description = "ID of the Flask Docker image"
  value       = docker_image.flask_app.image_id
}

output "application_port" {
  description = "Port where Flask application is exposed"
  value       = var.host_port
}
