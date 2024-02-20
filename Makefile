POSTGRESQL_URL='postgres://postgres:postgres@localhost:5444/sqlc?sslmode=disable'
DB_MIGRATIONS_PATH=schema/schema/

database: ## Runs local postgres container with kds_test database
	@docker stop sqlc-demo 2> /dev/null || true
	@docker rm sqlc-demo 2> /dev/null || true
	@docker run --name sqlc-demo -e POSTGRES_DB=sqlc -e POSTGRES_PASSWORD=postgres -d -p 5444:5432 postgres:latest

dataload:
	@psql ${POSTGRESQL_URL} -f ./testdata/data.sql

fulldb: database dbup dataload

logs: ## Follow docker postgres logs
	@docker logs -f sqlc-demo

generate_migration: ## make generate_migration name="create_some_table"
	migrate create -seq -ext sql -digits 3 -dir ${DB_MIGRATIONS_PATH} $(name) -verbose

dbup:
ifdef n
	migrate -database ${POSTGRESQL_URL} -path ${DB_MIGRATIONS_PATH} -verbose up $(n)
else
	migrate -database ${POSTGRESQL_URL} -path ${DB_MIGRATIONS_PATH} -verbose up
endif

dbdown:
ifdef n
	migrate -database ${POSTGRESQL_URL} -path ${DB_MIGRATIONS_PATH} -verbose down $(n)
else
	migrate -database ${POSTGRESQL_URL} -path ${DB_MIGRATIONS_PATH} -verbose down
endif


generatedb: ## Generates db model and queries based on ./schema  sqlc generate -f ./schema/sqlc.yaml
	docker run --rm -v .:/src -w /src sqlc/sqlc:1.25.0 generate -f ./schema/sqlc.yaml

deps: clean  ## Install dependencies for Go
	@go mod download

tidy: ## Go deps (go mod tidy)
	@go mod tidy

clean: ## Cleanup the deps folder (node_modules)
	@rm -rf node_modules/

run: ## Run the application
	@go run main.go
