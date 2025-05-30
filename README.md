# hello-ecs
Repository with the terraform configuration for creating an Amazon ECS cluster and deploy a service that runs a nodejs web server rendering a basic hello world web page.

## 🔧 Prerequisites

- **terraform** v1.12+
- **terragrunt** v0.80+
- **aws-cli** configured with proper credentials

## ⚙️ Usage

### 🚀 Deploy the dev environment
```bash
# Show what changes will terraform make
terragrunt run-all plan -working-dir=infra/live/dev

# Deploy all infrastructure in dev environment
terragrunt run-all apply -working-dir=infra/live/dev
```

### 💥 Destroy infrastructure
```bash
# Destroy all (be careful!)
terragrunt run-all destroy -working-dir=infra/live/dev
```

### Access the hello world web page
- Get the url of the load balancer to access the hello world web application.
```bash
terragrunt output alb_dns_name --all -working-dir=infra/live/dev/us-east-1/ecs -non-interactive
```
