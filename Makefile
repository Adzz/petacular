.PHONY: start db_hidden db migrate

full_start: deps db_hidden start

db_hidden:
	docker-compose up -d postgres

db:
	docker-compose up postgres

start:
	iex -S mix phx.server

stop_db:
	docker-compose down

migrate:
	mix do ecto.migrate, ecto.dump
	MIX_ENV=test mix ecto.test.prepare
