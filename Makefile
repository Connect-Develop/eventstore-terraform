.PHONY: all plan apply destroy 

all: plan apply

plan:
	terraform plan --var-file terraform.tfvars -out terraform-apply.tfplan

apply:
	terraform apply --var-file terraform.tfvars

destroy:
	terraform plan --destroy --var-file terraform.tfvars --out terraform-destroy.tfplan
	terraform apply terraform-destroy.tfplan
