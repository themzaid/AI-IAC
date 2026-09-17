# Hello API

A simple containerized greeting service that responds to API calls with a JSON greeting message. Built for the **DevOps Foundations** course on LinkedIn Learning.

## What It Does

```
GET /hello/World  →  {"message": "Hello World from Linkedin Learning"}
GET /health       →  {"status": "healthy"}
```

## Project Structure

```
.
├── Makefile              # Build, run, test, and deploy helpers
├── README.md
├── app/
│   ├── Dockerfile        # Multi-stage Docker build
│   ├── .dockerignore
│   ├── main.py           # Flask application
│   ├── requirements.txt  # Python dependencies
│   └── tests/
│       └── test_app.py   # Unit tests
└── terraform/
    ├── main.tf           # AWS infrastructure (VPC, ALB, ECS Fargate, ECR)
    ├── variables.tf      # Configurable inputs
    └── outputs.tf        # Deployment outputs
```

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://developer.hashicorp.com/terraform/install) (for AWS deployment)
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials (for AWS deployment)
- Python 3.12+ (only if running tests locally without Docker)

---

## Local Development

### Build the Docker Image

```bash
make build
```

### Run the Container (port 8989)

```bash
make run
```

The service starts on **http://localhost:8989**. Try it:

```bash
curl http://localhost:8989/hello/World
# {"message": "Hello World from Linkedin Learning"}
```

### Run the Smoke Tests

```bash
# Quick curl-based smoke test against the running container
make curl-test

# Full unit tests inside a Docker container
make test

# Unit tests locally (requires Python + pytest)
make test-local
```

### Stop the Container

```bash
make stop
```

### Clean Up (stop container + remove image)

```bash
make clean
```

### View Container Logs

```bash
make logs
```

---

## Deploy to AWS

The Terraform configuration provisions:

| Resource | Purpose |
|---|---|
| **VPC** | Isolated network with two public subnets |
| **ALB** | Internet-facing Application Load Balancer |
| **ECR** | Container registry for the Docker image |
| **ECS Fargate** | Serverless container hosting |
| **CloudWatch Logs** | Centralized log collection |

### Step 1 – Initialize Terraform

```bash
make terraform-init
```

### Step 2 – Preview the Plan

```bash
make terraform-plan
```

### Step 3 – Apply (deploy)

```bash
make terraform-apply
```

### Step 4 – Push Your Image to ECR

After `terraform apply`, grab the ECR URL from the output and push:

```bash
# Authenticate Docker with ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <ECR_REPOSITORY_URL>

# Tag and push
docker tag hello-api:latest <ECR_REPOSITORY_URL>:latest
docker push <ECR_REPOSITORY_URL>:latest

# Force ECS to pull the new image
aws ecs update-service \
  --cluster hello-api-cluster \
  --service hello-api-service \
  --force-new-deployment
```

### Step 5 – Test in AWS

```bash
curl http://<ALB_DNS_NAME>/hello/World
```

### Tear Down

```bash
make terraform-destroy
```

---

## Configuration

Edit `terraform/variables.tf` or pass overrides on the CLI:

| Variable | Default | Description |
|---|---|---|
| `aws_region` | `us-east-1` | AWS region |
| `app_name` | `hello-api` | Resource naming prefix |
| `container_port` | `8989` | Port the container listens on |
| `task_cpu` | `256` | Fargate CPU units |
| `task_memory` | `512` | Fargate memory (MiB) |
| `desired_count` | `1` | Number of running tasks |

```bash
# Example: deploy to eu-west-1 with 2 tasks
cd terraform
terraform apply -var="aws_region=eu-west-1" -var="desired_count=2"
```

---

## Make Targets Reference

Run `make help` to see all available targets:

| Target | Description |
|---|---|
| `make build` | Build the Docker image |
| `make run` | Build and run on port 8989 |
| `make stop` | Stop the running container |
| `make test` | Run unit tests in Docker |
| `make test-local` | Run unit tests locally |
| `make curl-test` | Smoke test the running container |
| `make logs` | Tail container logs |
| `make clean` | Stop and remove image |
| `make terraform-init` | Initialize Terraform |
| `make terraform-plan` | Preview infrastructure changes |
| `make terraform-apply` | Deploy to AWS |
| `make terraform-destroy` | Tear down AWS infrastructure |
