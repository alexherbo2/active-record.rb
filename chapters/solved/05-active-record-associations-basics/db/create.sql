-- https://sqlitetutorial.net/sqlite-create-table/

-- Pokémon ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS "pokemons" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "pokemon_number" INTEGER,
  "name" TEXT
);

-- Categories ──────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS "categories" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT
);

CREATE TABLE IF NOT EXISTS "pokemon_categories" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "pokemon_id" INTEGER,
  "category_id" INTEGER,
  FOREIGN KEY ("pokemon_id")
    REFERENCES "pokemons" ("id"),
  FOREIGN KEY ("category_id")
    REFERENCES "categories" ("id")
);

-- Abilities ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS "abilities" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT
);

CREATE TABLE IF NOT EXISTS "pokemon_abilities" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "pokemon_id" INTEGER,
  "ability_id" INTEGER,
  FOREIGN KEY ("pokemon_id")
    REFERENCES "pokemons" ("id"),
  FOREIGN KEY ("ability_id")
    REFERENCES "abilities" ("id")
);

-- Types ───────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS "types" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "name" TEXT
);

CREATE TABLE IF NOT EXISTS "pokemon_types" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "pokemon_id" INTEGER,
  "type_id" INTEGER,
  FOREIGN KEY ("pokemon_id")
    REFERENCES "pokemons" ("id"),
  FOREIGN KEY ("type_id")
    REFERENCES "types" ("id")
);

-- Stats ───────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS "stats" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "hp" INTEGER,
  "attack" INTEGER,
  "defense" INTEGER,
  "special_attack" INTEGER,
  "special_defense" INTEGER,
  "speed" INTEGER,
  "pokemon_id" INTEGER,
  FOREIGN KEY ("pokemon_id")
    REFERENCES "pokemons" ("id")
);

-- Evolutions ──────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS "evolutions" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "pokemon_id" INTEGER,
  "pokemon_evolution_id" INTEGER,
  FOREIGN KEY ("pokemon_id")
    REFERENCES "pokemons" ("id"),
  FOREIGN KEY ("pokemon_evolution_id")
    REFERENCES "pokemons" ("id")
);
