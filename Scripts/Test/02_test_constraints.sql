PRAGMA foreign_keys = ON;

-- Kontroll: ska returnera 1 (foreign keys är påslagna)
PRAGMA foreign_keys;

-- ===== FOREIGN KEY =====

-- 1. Råvara med leverantör som inte finns
-- Förväntat: FOREIGN KEY constraint failed
-- PRAGMA foreign_keys = ON;
INSERT INTO Ingredients (article_number, name, price_per_kg, stock_kg, reorder_level_kg, supplier_id)
VALUES ('XX-999', 'Choklad', 150.00, 10, 5, 99);

-- 2. Recept för produkt som inte finns
-- Förväntat: FOREIGN KEY constraint failed
-- PRAGMA foreign_keys = ON;
INSERT INTO Recipes (product_id, instructions)
VALUES (99, 'Recept utan produkt');

-- 3. Råvara i recept som inte finns i Ingredients
-- Förväntat: FOREIGN KEY constraint failed
-- PRAGMA foreign_keys = ON;
INSERT INTO RecipeIngredients (recipe_id, ingredient_id, quantity_kg)
VALUES (1, 99, 0.5);

-- 4. Inköpsrad på ett inköp som inte finns
-- Förväntat: FOREIGN KEY constraint failed
-- PRAGMA foreign_keys = ON;
INSERT INTO PurchaseLines (purchase_id, ingredient_id, quantity_kg, price_per_kg)
VALUES (99, 1, 10, 9.50);

-- 5. Ta bort leverantör som har råvaror kopplade
-- Förväntat: FOREIGN KEY constraint failed
-- PRAGMA foreign_keys = ON;
DELETE FROM Suppliers WHERE supplier_id = 1;

-- ===== PRIMARY KEY / UNIQUE =====

-- 6. Samma råvara två gånger i samma recept
-- Förväntat: UNIQUE constraint failed: RecipeIngredients.recipe_id, RecipeIngredients.ingredient_id
-- PRAGMA foreign_keys = ON;
INSERT INTO RecipeIngredients (recipe_id, ingredient_id, quantity_kg)
VALUES (1, 1, 0.5);

-- 7. Andra recept för samma produkt
-- Förväntat: UNIQUE constraint failed: Recipes.product_id
-- PRAGMA foreign_keys = ON;
INSERT INTO Recipes (product_id, instructions)
VALUES (1, 'Ett till kanelbullerecept');

-- 8. Dubblett av artikelnummer
-- Förväntat: UNIQUE constraint failed: Ingredients.article_number
-- PRAGMA foreign_keys = ON;
INSERT INTO Ingredients (article_number, name, price_per_kg, stock_kg, reorder_level_kg, supplier_id)
VALUES ('KB-001', 'Dinkelmjöl', 15.00, 10, 5, 1);

-- ===== CHECK =====

-- 9. Negativt pris
-- Förväntat: CHECK constraint failed
-- PRAGMA foreign_keys = ON;
INSERT INTO Ingredients (article_number, name, price_per_kg, stock_kg, reorder_level_kg, supplier_id)
VALUES ('XX-100', 'Havregryn', -5.00, 10, 5, 1);

-- 10. Mängd 0 i recept
-- Förväntat: CHECK constraint failed
-- PRAGMA foreign_keys = ON;
INSERT INTO RecipeIngredients (recipe_id, ingredient_id, quantity_kg)
VALUES (3, 2, 0);

-- ===== NOT NULL =====

-- 11. Leverantör utan namn
-- Förväntat: NOT NULL constraint failed: Suppliers.name
-- PRAGMA foreign_keys = ON;
INSERT INTO Suppliers (address, phone_number, email, contact_person)
VALUES ('Okänd väg 1', '040-000000', 'test@test.se', 'Anna Test');