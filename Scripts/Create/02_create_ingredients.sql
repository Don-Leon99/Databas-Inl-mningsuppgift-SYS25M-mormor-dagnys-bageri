PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Ingredients(
    ingredient_id INTEGER PRIMARY KEY,
    article_number TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    price_per_kg REAL NOT NULL CHECK (price_per_kg > 0),
    stock_kg REAL NOT NULL DEFAULT 0 CHECK (stock_kg >= 0),
    reorder_level_kg REAL NOT NULL CHECK (reorder_level_kg >= 0),
    supplier_id INTEGER NOT NULL,

    FOREIGN KEY (supplier_id) REFERENCES Suppliers (supplier_id)
);