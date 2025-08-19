# Flask MySQL Docker Terraform Infrastructure

This project demonstrates Infrastructure as Code using Terraform to deploy a Python Flask web application with a MySQL database using Docker containers.

## Project Structure

```
project/
├── flask_app/                     # Flask application code
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app.py
├── terraform/                     # Terraform configuration
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── modules/
│       ├── network/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── mysql/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── flask/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
└── README.md
```

## Architecture Overview

The infrastructure consists of:

1. **Docker Network**: An isolated bridge network for container communication
2. **MySQL Container**: MySQL 8.0 database server with persistent volume
3. **Flask Container**: Python Flask web application connected to MySQL

### Key Features

- **Modular Terraform Design**: Separate modules for network, database, and application
- **Container Isolation**: All containers run on an isolated Docker network
- **Data Persistence**: MySQL data is stored in a Docker volume
- **Health Checks**: Both containers have health check configurations
- **Environment Variables**: Database connection configured via environment variables
- **Port Forwarding**: Flask app accessible on localhost:5000

## Prerequisites

Before running this project, ensure you have:

1. **Docker Desktop** installed and running
2. **Terraform** >= 1.0 installed
3. **Windows PowerShell** or Command Prompt
4. **Git** (optional, for version control)

### Installation Links:
- [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
- [Terraform](https://www.terraform.io/downloads.html)

## Quick Start Guide

### Step 1: Clone or Download the Project
```powershell
# If using git
git clone <repository-url>
cd "Terraform Iac/project"

# Or simply navigate to the project directory
cd "d:\WSO2\Terraform Iac\project"
```

### Step 2: Verify Docker is Running
```powershell
docker --version
docker ps
```

### Step 3: Navigate to Terraform Directory
```powershell
cd terraform
```

### Step 4: Initialize Terraform
```powershell
terraform init
```

This command will:
- Download the Docker provider
- Initialize the backend
- Set up the working directory

### Step 5: Plan the Deployment
```powershell
terraform plan
```

This will show you what resources Terraform will create:
- Docker network
- MySQL container with volume
- Flask application container
- Docker images

### Step 6: Apply the Configuration
```powershell
terraform apply
```

When prompted, type `yes` to confirm the deployment.

The deployment process will:
1. Create an isolated Docker network
2. Pull and start MySQL 8.0 container
3. Build the Flask application Docker image
4. Start the Flask container
5. Configure networking between containers

### Step 7: Verify Deployment
After successful deployment, you should see output similar to:
```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

application_url = "http://localhost:5000"
health_check_url = "http://localhost:5000/health"
flask_container_name = "flask-app-container"
mysql_container_name = "mysql-container"
network_name = "flask-mysql-network"
```

## Testing the Application

### 1. Check Application Health
```powershell
# Using curl (if available)
curl http://localhost:5000/health

# Or open in browser
start http://localhost:5000/health
```

### 2. Access the Web Application
Open your web browser and navigate to: http://localhost:5000

The application provides:
- A simple web interface to add users
- Display existing users from the database
- RESTful API endpoints for user management

### 3. Test API Endpoints

**Get all users:**
```powershell
curl http://localhost:5000/api/users
```

**Add a new user:**
```powershell
curl -X POST http://localhost:5000/api/users ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"Test User\",\"email\":\"test@example.com\"}"
```

### 4. Verify Container Status
```powershell
# Check running containers
docker ps

# Check container logs
docker logs flask-app-container
docker logs mysql-container

# Check network
docker network ls
docker network inspect flask-mysql-network
```

## Configuration Options

You can customize the deployment by modifying variables in `terraform/variables.tf` or by passing variables during apply:

```powershell
# Custom MySQL passwords
terraform apply -var="mysql_root_password=mynewpassword" -var="mysql_password=userpassword"

# Different port mapping
terraform apply -var="flask_host_port=8080"

# Custom container names
terraform apply -var="flask_container_name=my-flask-app" -var="mysql_container_name=my-mysql-db"
```

## Troubleshooting

### Common Issues and Solutions

1. **Docker not running:**
   ```
   Error: Cannot connect to the Docker daemon
   ```
   Solution: Start Docker Desktop and wait for it to be ready.

2. **Port already in use:**
   ```
   Error: Port 5000 is already allocated
   ```
   Solution: Change the port in variables.tf or stop the service using port 5000.

3. **Flask app can't connect to MySQL:**
   - Check if both containers are running: `docker ps`
   - Check logs: `docker logs flask-app-container`
   - Verify network: `docker network inspect flask-mysql-network`

4. **Permission issues on Windows:**
   - Run PowerShell as Administrator
   - Ensure Docker Desktop has proper permissions

### Viewing Logs
```powershell
# Flask application logs
docker logs flask-app-container -f

# MySQL logs
docker logs mysql-container -f

# Terraform debug logs
$env:TF_LOG="DEBUG"
terraform apply
```

## Cleanup

To destroy all resources and clean up:

```powershell
# Destroy Terraform-managed resources
terraform destroy

# Remove dangling images (optional)
docker image prune -f

# Remove volumes (optional - will delete database data)
docker volume prune -f
```

## Project Components

### Flask Application (`flask_app/app.py`)
- Web interface for user management
- RESTful API endpoints
- MySQL database integration
- Health check endpoint
- Automatic database initialization

### Docker Configuration
- **Dockerfile**: Multi-stage build with Python 3.11
- **requirements.txt**: Python dependencies
- **Health checks**: Container health monitoring

### Terraform Modules
- **Network Module**: Creates isolated Docker network
- **MySQL Module**: Manages MySQL container and volume
- **Flask Module**: Builds and deploys Flask application

## Security Considerations

- MySQL passwords are marked as sensitive in Terraform
- Flask container runs as non-root user
- Network isolation between containers and host
- Health checks for container monitoring

## Next Steps

To extend this project, you could:

1. Add HTTPS/TLS configuration
2. Implement database migrations
3. Add monitoring and logging
4. Set up CI/CD pipeline
5. Deploy to cloud platforms (AWS, Azure, GCP)
6. Add load balancing for multiple Flask instances
7. Implement backup strategies for MySQL data

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Terraform and Docker documentation
3. Check container logs for specific error messages
4. Verify all prerequisites are installed and running
