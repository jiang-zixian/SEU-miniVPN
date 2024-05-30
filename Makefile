CERT_PATH := ./demoCA
VOLUMES_PATH := ./volumes
DOCKER_NAME ?= mycontainer

cert:
	cd demoCA
	mkdir ./demoCA/certs ./demoCA/crl ./demoCA/newcerts
	touch ./demoCA/index.txt ./demoCA/serial
	echo 1000 > ./demoCA/serial
	cd ..
	cp /usr/lib/ssl/openssl.cnf myCA_openssl.cnf
	openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -keyout ca.key -out ca.crt -subj "/CN=www.modelCA.com/O=Model CA LTD./C=CN/ST=NJ/L=SEU" -passout pass:dees
	openssl req -newkey rsa:2048 -sha256 -keyout vpn.key -out vpn.csr -subj "/CN=vpnlabserver.com/O=Model CA LTD./C=CN/ST=NJ/L=SEU" -passout pass:dees
	openssl ca -config myCA_openssl.cnf -policy policy_anything -md sha256 -days 3650 -in vpn.csr -out vpn.crt -batch -cert ca.crt -keyfile ca.key
	mv ./vpn.crt ./volumes/server-certs/
	mv ./vpn.key ./volumes/server-certs/
	cp ./ca.crt ./volumes/client-certs/
	cd volumes/client-certs/
	openssl x509 -in ./volumes/client-certs/ca.crt -noout -subject_hash
	ln -s ca.crt ./volumes/client-certs/112bc731.0

up:
	docker compose up -d
	docker ps

down:
	docker compose down

clean:
	rm $(VOLUMES_PATH)/client-certs/**
	rm $(VOLUMES_PATH)/server-certs/**
	rm -r $(CERT_PATH)/**
	rm myCA_openssl.cnf
	rm ./vpn*
	rm ./ca*

exec:
	docker exec -it $(DOCKER_NAME) bash


