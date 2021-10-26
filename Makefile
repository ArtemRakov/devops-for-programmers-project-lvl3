install:
	ansible-galaxy role install -r ansible/requirements.yml
	ansible-galaxy collection install -r ansible/requirements.yml

setup-infra:
	ansible-playbook -v --vault-password-file vault-password ansible/infra.yml

provision:
	ansible-playbook -v -i ansible/hosts --vault-password-file vault-password ansible/playbook.yml

deploy:
	ansible-playbook -i ansible/hosts -v --vault-password-file vault-password --tags deploy ansible/playbook.yml

touch-vault-password-file:
	touch vault-password

encrypt-vault:
	ansible-vault encrypt $(FILE) --vault-password-file vault-password

decrypt-vault:
	ansible-vault decrypt $(FILE) --vault-password-file vault-password

view-vault:
	ansible-vault view $(FILE) --vault-password-file vault-password

edit-vault:
	ansible-vault edit $(FILE) --vault-password-file vault-password

create-vault:
	ansible-vault create $(FILE) --vault-password-file vault-password
