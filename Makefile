cert:
	cd demoCA
	touch ./demoCA/index.txt ./demoCA/serial
	echo 1000 > ./demoCA/serial
	openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -keyout ./demoCA/ca.key -out ./demoCA/ca.crt -subj "/CN=www.modelCA.com/O=Model CA LTD./C=CN/ST=NJ/L=SEU" -passout pass:dees
	openssl req -newkey rsa:2048 -sha256 -keyout ./demoCA/vpn.key -out ./demoCA/vpn.csr -subj "/CN=vpnlabserver.com/O=Model CA LTD./C=CN/ST=NJ/L=SEU" -passout pass:dees
	openssl ca -config myCA_openssl.cnf -policy policy_anything -md sha256 -days 3650 -in ./demoCA/vpn.csr -out ./demoCA/vpn.crt -batch -cert ./demoCA/ca.crt -keyfile ./demoCA/ca.key
	cp ./demoCA/vpn.crt ./volumes/server-certs/
	cp ./demoCA/vpn.key ./volumes/server-certs/
	cp ./demoCA/ca.crt ./volumes/client-certs/
	openssl x509 -in ./demoCA/ca.crt -noout -subject_hash
	ln -s ./demoCA/ca.crt eaa14a05.0
	mv eaa14a05.0 ./volumes/client-certs/

up:
	docker compose up -d
	docker ps

down:
	docker compose down

clean:
	rm ./volumes/client-certs/**
	rm ./volumes/server-certs/**
	rm ./demoCA/**

