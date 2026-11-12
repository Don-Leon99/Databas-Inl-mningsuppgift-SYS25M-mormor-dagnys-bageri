PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Recipes (
    recipe_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL UNIQUE,
    instructions TEXT NOT NULL,

    FOREIGN KEY (product_id) REFERENCES Products (product_id)
);