# Build Flask Docker image
resource "docker_image" "flask_app" {
  name = var.image_name
  
  build {
    context    = var.app_path
    dockerfile = "Dockerfile"
    tag        = ["${var.image_name}:latest"]
  }
  
  triggers = {
    dir_sha1 = sha1(join("", [
      for f in fileset(var.app_path, "**") :
      filesha1("${var.app_path}/${f}")
    ]))
  }
  
  keep_locally = false
}

# Create Flask container
resource "docker_container" "flask_app" {
  image = docker_image.flask_app.image_id
  name  = var.container_name
  
  # Port mapping
  ports {
    internal = var.container_port
    external = var.host_port
  }
  
  # Environment variables for database connection
  env = [
    "DB_HOST=${var.db_host}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
    "FLASK_ENV=production"
  ]
  
  # Restart policy
  restart = "unless-stopped"
  
  # Network configuration
  networks_advanced {
    name = var.network_id
  }
  
  # Health check
  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:${var.container_port}/health"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "40s"
  }
  
  labels {
    label = "project"
    value = "flask-mysql-terraform"
  }
  
  labels {
    label = "service"
    value = "web-application"
  }
  
  # Ensure container starts after a delay to allow MySQL to be ready
  command = [
    "sh", "-c", 
    "sleep 10 && python app.py"
  ]
}
