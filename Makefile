init:
	terraform -chdir=terraform init

lint:
	terraform fmt -check -diff terraform

validate:
	terraform -chdir=terraform validate

apply:
	terraform -chdir=terraform apply

deploy:
	ansible-playbook -v -i ansible/hosts ansible/playbook.yml
