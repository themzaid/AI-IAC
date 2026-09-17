# ---------------------------------------------------------------
# Hello API – Makefile
# ---------------------------------------------------------------

APP_NAME   := hello-api
IMAGE_TAG  := latest
PORT       := 8989

.PHONY: help build run stop test logs clean terraform-init terraform-plan terraform-apply terraform-destroy

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# --------------- Docker ---------------

build: ## Build the Docker image
	docker build -t $(APP_NAME):$(IMAGE_TAG) ./app

run: build ## Build and run the container locally on port 8989
	docker run --rm -d \
		--name $(APP_NAME) \
		-p $(PORT):$(PORT) \
		$(APP_NAME):$(IMAGE_TAG)
	@echo ""
	@echo "✅  $(APP_NAME) is running at http://localhost:$(PORT)"
	@echo "    Try: curl http://localhost:$(PORT)/hello/World"
	@echo ""

stop: ## Stop the running container
	docker stop $(APP_NAME) 2>/dev/null || true

test: ## Run unit tests inside a container
	docker build -t $(APP_NAME)-test:$(IMAGE_TAG) -f ./app/Dockerfile.test ./app
	docker run --rm $(APP_NAME)-test:$(IMAGE_TAG)

test-local: ## Run unit tests locally (requires Python venv)
	cd app && python -m pytest tests -v

curl-test: ## Quick smoke test against the running container
	@echo "--- Health Check ---"
	@curl -s http://localhost:$(PORT)/health | python3 -m json.tool
	@echo ""
	@echo "--- Hello World ---"
	@curl -s http://localhost:$(PORT)/hello/World | python3 -m json.tool
	@echo ""
	@echo "--- Hello Zaid ---"
	@curl -s http://localhost:$(PORT)/hello/Zaid | python3 -m json.tool

logs: ## Tail container logs
	docker logs -f $(APP_NAME)

clean: stop ## Stop container and remove the image
	docker rmi $(APP_NAME):$(IMAGE_TAG) 2>/dev/null || true

# --------------- Terraform ---------------

terraform-init: ## Initialize Terraform
	cd terraform && terraform init

terraform-plan: ## Preview infrastructure changes
	cd terraform && terraform plan

terraform-apply: ## Deploy infrastructure to AWS
	cd terraform && terraform apply

terraform-destroy: ## Tear down all AWS infrastructure
	cd terraform && terraform destroy
