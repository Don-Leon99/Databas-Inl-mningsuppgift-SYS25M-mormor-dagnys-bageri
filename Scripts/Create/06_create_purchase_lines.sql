PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS PurchaseLines(
    purchase_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    quantity_kg REAL NOT NULL CHECK (quantity_kg > 0),
    price_per_kg REAL NOT NULL CHECK (price_per_kg > 0),

    PRIMARY KEY (purchase_id, ingredient_id),

    FOREIGN KEY (purchase_id) REFERENCES Purchases(purchase_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id)
);