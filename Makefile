
store.tar.enc:
	@echo Ensure logged into travis with: travis login --org
	travis whoami
	cp -p  ~/.common/config/cmems/cmems_secret.py .
	tar cpf store.tar cmems_secret.py
	rm cmems_secret.py
	travis encrypt-file store.tar
	rm store.tar

.PHONY: store.tar.enc

