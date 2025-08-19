output "network_id" {
  description = "ID of the created Docker network"
  value       = docker_network.app_network.id
}

output "network_name" {
  description = "Name of the created Docker network"
  value       = docker_network.app_network.name
}

output "network_driver" {
  description = "Driver of the created Docker network"
  value       = docker_network.app_network.driver
}
