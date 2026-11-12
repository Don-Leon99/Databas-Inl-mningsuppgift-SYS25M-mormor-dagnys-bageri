PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Purchases(
    purchase_id INTEGER PRIMARY KEY,
    supplier_id INTEGER NOT NULL,
    purchase_date TEXT NOT NULL DEFAULT (date('now')),

    FOREIGN KEY (supplier_id) REFERENCES Suppliers (supplier_id)
);