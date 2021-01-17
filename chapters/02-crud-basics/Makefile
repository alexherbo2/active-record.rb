# Development environment
environment ?= development

install:
	bundle install

test:
	rspec

play:
	irb -I lib -r ./repl/init.rb

db-setup: db-drop db-create db-seed

db-create:
	sqlite3 db/$(environment).sqlite3 < db/create.sql

db-drop:
	sqlite3 db/$(environment).sqlite3 < db/drop.sql

db-seed:
	ENVIRONMENT="$(environment)" ruby db/seeds.rb

db-browse:
	sqlitebrowser db/$(environment).sqlite3
