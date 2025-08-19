# Docker Network Module
module "network" {
  source = "./modules/network"
  
  network_name = var.network_name
}

# MySQL Database Module
module "mysql" {
  source = "./modules/mysql"
  
  network_id            = module.network.network_id
  container_name        = var.mysql_container_name
  mysql_image          = var.mysql_image
  mysql_root_password  = var.mysql_root_password
  mysql_database       = var.mysql_database
  mysql_user           = var.mysql_user
  mysql_password       = var.mysql_password
  
  depends_on = [module.network]
}

# Flask Application Module
module "flask" {
  source = "./modules/flask"
  
  network_id           = module.network.network_id
  container_name       = var.flask_container_name
  image_name          = var.flask_image_name
  host_port           = var.flask_host_port
  container_port      = var.flask_container_port
  app_path            = var.flask_app_path
  
  # Database connection environment variables
  db_host     = var.mysql_container_name
  db_user     = var.mysql_user
  db_password = var.mysql_password
  db_name     = var.mysql_database
  
  depends_on = [module.network, module.mysql]
}
