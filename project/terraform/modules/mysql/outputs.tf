output "container_id" {
  description = "ID of the MySQL container"
  value       = docker_container.mysql.id
}

output "container_name" {
  description = "Name of the MySQL container"
  value       = docker_container.mysql.name
}

output "image_name" {
  description = "MySQL image name used"
  value       = docker_image.mysql.name
}

output "volume_name" {
  description = "Name of the MySQL data volume"
  value       = docker_volume.mysql_data.name
}
