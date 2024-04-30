CERT_PATH := ./demoCA
VOLUMES_PATH := ./volumes

cert:
	cd demoCA
	touch $(CERT_PATH)/index.txt $(CERT_PATH)/serial
	echo 1000 > $(CERT_PATH)/serial
	openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -keyout $(CERT_PATH)/ca.key -out $(CERT_PATH)/ca.crt -subj "/CN=www.modelCA.com/O=Model CA LTD./C=CN/ST=NJ/L=SEU" -passout pass:dees
	openssl req -newkey rsa:2048 -sha256 -keyout $(CERT_PATH)/vpn.key -out $(CERT_PATH)/vpn.csr -subj "/CN=vpnlabserver.com/O=Model CA LTD./C=CN/ST=NJ/L=SEU" -passout pass:dees
	openssl ca -config myCA_openssl.cnf -policy policy_anything -md sha256 -days 3650 -in $(CERT_PATH)/vpn.csr -out $(CERT_PATH)/vpn.crt -batch -cert $(CERT_PATH)/ca.crt -keyfile $(CERT_PATH)/ca.key
	cp $(CERT_PATH)/vpn.crt $(VOLUMES_PATH)/server-certs/
	cp $(CERT_PATH)/vpn.key $(VOLUMES_PATH)/server-certs/
	cp $(CERT_PATH)/ca.crt $(VOLUMES_PATH)/client-certs/
	openssl x509 -in $(CERT_PATH)/ca.crt -noout -subject_hash
	ln -s $(CERT_PATH)/ca.crt eaa14a05.0
	mv eaa14a05.0 $(VOLUMES_PATH)/client-certs/

up:
	docker compose up -d
	docker ps

down:
	docker compose down

clean:
	rm $(VOLUMES_PATH)/client-certs/**
	rm $(VOLUMES_PATH)/server-certs/**
	rm $(CERT_PATH)/**

