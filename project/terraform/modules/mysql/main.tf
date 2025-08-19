# Pull MySQL image
resource "docker_image" "mysql" {
  name         = var.mysql_image
  keep_locally = false
}

# Create MySQL container
resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = var.container_name
  
  # Environment variables for MySQL configuration
  env = [
    "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}",
    "MYSQL_DATABASE=${var.mysql_database}",
    "MYSQL_USER=${var.mysql_user}",
    "MYSQL_PASSWORD=${var.mysql_password}",
    "MYSQL_ROOT_HOST=%"
  ]
  
  # Restart policy
  restart = "unless-stopped"
  
  # Network configuration
  networks_advanced {
    name = var.network_id
  }
  
  # Volume for persistent data
  volumes {
    volume_name    = docker_volume.mysql_data.name
    container_path = "/var/lib/mysql"
  }
  
  # Health check
  healthcheck {
    test         = ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${var.mysql_root_password}"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }
  
  labels {
    label = "project"
    value = "flask-mysql-terraform"
  }
  
  labels {
    label = "service"
    value = "database"
  }
}

# Docker volume for MySQL data persistence
resource "docker_volume" "mysql_data" {
  name = "${var.container_name}-data"
  
  labels {
    label = "project"
    value = "flask-mysql-terraform"
  }
}
