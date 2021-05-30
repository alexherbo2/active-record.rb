# CRUD – Basics

###### [Previous chapter](../01-mapping-between-models-and-database-tables) | [Next chapter](../03-testing-with-rspec)

> CRUD is an acronym for the four verbs we use to operate on data: **C**reate, **R**ead, **U**pdate and **D**elete.
> [Active Record] automatically creates methods to allow an application to read and manipulate data stored within its tables.

See [CRUD: Reading and writing data] for a complete reference.

[Active Record]: https://guides.rubyonrails.org/active_record_basics.html
[CRUD: Reading and writing data]: https://guides.rubyonrails.org/active_record_basics.html#crud-reading-and-writing-data

## Installation

Install [sqlite3] for Ruby:

``` sh
make install
```

[sqlite3]: https://github.com/sparklemotion/sqlite3-ruby

## Database file

A database in [SQLite] is a single disk file.

[SQLite]: https://sqlite.org

By convention, we will locate it in `db/development.sqlite3` and `db/test.sqlite3` when running [specs][`spec/models/pokemon_spec.rb`].

[`spec/models/pokemon_spec.rb`]: spec/models/pokemon_spec.rb

To initialize the table structure, we have [`db/create.sql`] and [`db/drop.sql`] statements.

[`db/create.sql`]: db/create.sql
[`db/drop.sql`]: db/drop.sql

Create command example:

``` sh
sqlite3 db/development.sqlite3 < db/create.sql
```

Drop command example:

``` sh
sqlite3 db/development.sqlite3 < db/drop.sql
```

Simply run `make db-create` and `make db-drop` from the [`Makefile`] to set up or tear down the tables.

[`Makefile`]: Makefile

While it is not related to code, it will help to see the picture of a good organization.

---

See [SQLite – Create table] and [SQLite – Drop table] for a complete reference.

[SQLite – Create table]: https://sqlitetutorial.net/sqlite-create-table/
[SQLite – Drop table]: https://sqlitetutorial.net/sqlite-drop-table/

## Connecting to the database

``` ruby
DB = SQLite3::Database.new('db/development.sqlite3')
```

## Retrieving data from the database

Everything is a list.
Rows and columns.

Giving the following `pokemons` table with `id`, `index` and `name`:

``` yaml
- [1, 1, "Bulbasaur"]
- [2, 2, "Ivysaur"]
- [3, 3, "Venusaur"]
```

If you ask to get all Pokémon:

``` json
[
  [1, 1, "Bulbasaur"],
  [2, 2, "Ivysaur"],
  [3, 3, "Venusaur"]
]
```

If you ask to get the Pokémon count:

``` json
[
  [3]
]
```

I won’t give you the answer, but think SQL works like [King Crimson] in this case. 😂

[King Crimson]: https://jojo.fandom.com/wiki/King_Crimson

## Retrieving data as Ruby objects

Welcome to Ruby!

By default, [sqlite3] gem returns a list with array-like objects.

``` ruby
rows = DB.execute <<~SQL
  SELECT * FROM "pokemons"
SQL
```

Output example:

``` json
[
  [1, 1, "Bulbasaur"],
  [2, 2, "Ivysaur"],
  [3, 3, "Venusaur"]
]
```

You can turn them into hash-like structures with:

``` ruby
DB.results_as_hash = true
```

And get instead:

``` json
[
  { "id": 1, "index": 1, "name": "Bulbasaur" },
  { "id": 2, "index": 2, "name": "Ivysaur" },
  { "id": 3, "index": 3, "name": "Venusaur" }
]
```

I said array-like (and hash-like :p), because the rows are special objects:

``` ruby
DB.execute("select * from pokemons").first.class # SQLite3::ResultSet::ArrayWithTypesAndFields
DB.execute("select * from pokemons").first.types # ["INTEGER", "INTEGER", "TEXT"]
DB.execute("select * from pokemons").first.fields # ["id", "index", "name"]
```

**ProTip!** SQL keywords can be lowercase and identifiers unquoted if they are not reserved keywords.

The [SQLite – Keywords] document can be useful, if you question on a keyword or the quoting.

[SQLite – Keywords]: https://sqlite.org/lang_keywords.html

---

See [`SQLite3::ResultSet::ArrayWithTypesAndFields`] and [`SQLite3::ResultSet::HashWithTypesAndFields`] for a complete reference.

[`SQLite3::ResultSet::ArrayWithTypesAndFields`]: https://rubydoc.info/gems/sqlite3/SQLite3/ResultSet/ArrayWithTypesAndFields
[`SQLite3::ResultSet::HashWithTypesAndFields`]: https://rubydoc.info/gems/sqlite3/SQLite3/ResultSet/HashWithTypesAndFields

## Understanding SQL and the magic around the SQLite gem

``` ruby
DB.results_as_hash = false
DB.execute("select count(id) from pokemons") # [[151]]
```

``` ruby
DB.results_as_hash = false
DB.execute("select name from pokemons") # [["Bulbasaur"], ["Ivysaur"], ["Venusaur"], ...]
DB.execute("select name, count(id) from pokemons") # [["Bulbasaur", 151]] 🤯
```

``` ruby
DB.results_as_hash = false
DB.execute("select count(id) from pokemons") # [[151]]
DB.execute("select count(id) from pokemons")[0] # [151]
DB.execute("select count(id) from pokemons")[0][0] # 151
```

``` ruby
DB.results_as_hash = true
DB.execute("select count(id) from pokemons") # [{ "count(id)": 151 }]
DB.execute("select COUNT(id) from pokemons") # [{ "COUNT(id)": 151 }] 🤔
DB.execute("select count(id) from pokemons")[0] # { "count(id)": 151 }
DB.execute("select count(id) from pokemons")[0][0] # 151 🤯
```

[It][Josuke Teaches Shigechi A Painful Lesson In Sharing] was my first impression when I realized my `count` method worked with `DB.results_as_hash` set to `true`.

[Josuke Teaches Shigechi A Painful Lesson In Sharing]: https://youtu.be/83H3ThRrni4?t=57

## Inserting data

``` ruby
statement = DB.prepare <<~SQL
  INSERT INTO "pokemons" ("index", "name")
  VALUES (:index, :name)
SQL

statement.execute(index: 152, name: 'Chikorita')
```

**ProTip!** Use `?` placeholders or named parameters.

You can get the ID of the last inserted record with:

``` ruby
id = DB.last_insert_row_id
```

## Updating data

``` ruby
statement = DB.prepare <<~SQL
  UPDATE "pokemons"
  SET "index" = :index, "name" = :name
  WHERE "id" = :id
SQL

statement.execute(id: 152, index: 152, name: 'Chika')
```

## Deleting data

``` ruby
statement = DB.prepare <<~SQL
  DELETE FROM "pokemons"
  WHERE "id" = ?
SQL

statement.execute(152)
```

## Seeding data

Simply run `make db-seed` to seed data or `make db-setup` to create the database and seed, from the [`Makefile`].

[`Makefile`]: Makefile

See [`db/seeds.rb`] for more details.

[`db/seeds.rb`]: db/seeds.rb

## Try it yourself

Inspect the database with [SQLite Browser] and play with the REPL.

[SQLite Browser]: https://sqlitebrowser.org

**Setup**

``` sh
make db-setup
```

**Browser**

``` sh
make db-browse
```

**Playground**

``` sh
make play
```

**ProTip!** Open and edit [`repl/init.rb`] to initialize code before entering interactive mode.

[`repl/init.rb`]: repl/init.rb

See [SQLite3/Ruby] and [its documentation][SQLite3/Ruby – Documentation] for the possible methods.

[SQLite3/Ruby]: https://github.com/sparklemotion/sqlite3-ruby
[SQLite3/Ruby – Documentation]: https://rubydoc.info/gems/sqlite3

## Challenge

Implement the CRUD for a `Pokemon` model, as described in the [CRUD: Reading and writing data] document.

**Example**

``` ruby
pikachu = Pokemon.new do |pokemon|
  pokemon.index = 25
  pokemon.name = 'Pikachu'
end

pikachu.id
# ⇒ nil (The Pokémon is not persisted yet)

pikachu.save
# Persist the record

pikachu.id
# ⇒ 1 (Expected result, the database has inserted a row, store the ID in memory)

pikachu.name = 'Pika'
pikachu.save
# Update the record in the database
```

Run the specs with `make test` to ensure your code works as expected.

### Quick start

Open [`app/models/pokemon.rb`], [`spec/models/pokemon_spec.rb`] and [`data/pokemon.json`].

[`app/models/pokemon.rb`]: app/models/pokemon.rb
[`spec/models/pokemon_spec.rb`]: spec/models/pokemon_spec.rb
[`data/pokemon.json`]: data/pokemon.json

## Solution

[Download solution].

[Download solution]: ../solved/02-crud-basics
