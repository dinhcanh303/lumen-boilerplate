
docker: docker-stop docker-start

docker-start:
	docker-compose up --build -d
docker-stop:
	docker-compose down
docker-exec:
	docker exec -it mcs_lumen /bin/sh