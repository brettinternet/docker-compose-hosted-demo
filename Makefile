.PHONY: start setup terraform

start:
	@docker-compose --compatibility up

setup: .env tunnel/.terraform.lock.hcl terraform

terraform:
	@terraform -chdir=tunnel plan
	@terraform -chdir=tunnel apply

.env:
	@cp .env.example .env
	@echo "Configure options in .env"

tunnel/.terraform.lock.hcl:
	@terraform -chdir=tunnel init
