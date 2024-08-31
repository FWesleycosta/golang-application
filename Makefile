swagger:
	swag init -g cmd/main.go

run:
	go run cmd/main.go

docker:
	docker compose up -d

down:
	docker compose down

delete:
	rm -rf postgres-data

sonar:
	sonar-scanner

build:
	go build -o bin/golang-application cmd/main.go
