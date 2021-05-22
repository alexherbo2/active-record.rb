# Development environment
environment ?= development

build:
	gem build active-record.gemspec

install: build
	gem install active-record-0.1.0.gem

uninstall:
	gem uninstall active-record

clean:
	rm -Rf Gemfile.lock active-record-*.*.*.gem

test:
	rspec

play:
	irb -I lib -r ./repl/init.rb

db-setup: db-drop db-create db-seed

db-create:
	sqlite3 db/$(environment).sqlite3 < db/create.sql

db-drop:
	sqlite3 db/$(environment).sqlite3 < db/drop.sql

db-prepare:
	ruby db/prepare.rb

db-seed:
	ENVIRONMENT="$(environment)" ruby db/seeds.rb

db-browse:
	sqlitebrowser db/$(environment).sqlite3
