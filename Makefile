build:
	docker build -t cats-main .

run:
	docker run -p 80:80 --name cats-main-container cats-main

stop:
	docker stop cats-main-container || true
	docker rm cats-main-container || true

restart: stop run