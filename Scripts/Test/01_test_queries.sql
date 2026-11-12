PRAGMA foreign_keys = ON;

-- 1. Recept med dess råvaror och mängder
SELECT p.name AS product, i.name AS ingredient, ri.quantity_kg
FROM Recipes r
JOIN Products p           ON p.product_id = r.product_id
JOIN RecipeIngredients ri ON ri.recipe_id = r.recipe_id
JOIN Ingredients i        ON i.ingredient_id = ri.ingredient_id
ORDER BY p.name, i.name;

-- 2. Produkter och deras leverantörer (via recept och råvaror)
SELECT DISTINCT p.name AS product, s.name AS supplier
FROM Products p
JOIN Recipes r            ON r.product_id = p.product_id
JOIN RecipeIngredients ri ON ri.recipe_id = r.recipe_id
JOIN Ingredients i        ON i.ingredient_id = ri.ingredient_id
JOIN Suppliers s          ON s.supplier_id = i.supplier_id
ORDER BY p.name, s.name;

-- 3. Råvaror per leverantör
SELECT s.name AS supplier, i.article_number, i.name AS ingredient, i.price_per_kg
FROM Suppliers s
JOIN Ingredients i ON i.supplier_id = s.supplier_id
ORDER BY s.name, i.name;

-- 4. Råvaror som behöver beställas (lager på eller under beställningsnivå)
SELECT i.name AS ingredient, i.stock_kg, i.reorder_level_kg,
       s.name AS supplier, s.contact_person, s.phone_number
FROM Ingredients i
JOIN Suppliers s ON s.supplier_id = i.supplier_id
WHERE i.stock_kg <= i.reorder_level_kg
ORDER BY s.name;

-- 5. Inköpshistorik med totalsumma per inköp
SELECT pu.purchase_id, pu.purchase_date, s.name AS supplier,
       SUM(pl.quantity_kg * pl.price_per_kg) AS total_amount
FROM Purchases pu
JOIN Suppliers s      ON s.supplier_id = pu.supplier_id
JOIN PurchaseLines pl ON pl.purchase_id = pu.purchase_id
GROUP BY pu.purchase_id
ORDER BY pu.purchase_date;

-- 6. Kostnad för råvaror per recept (en sats)
SELECT p.name AS product,
       ROUND(SUM(ri.quantity_kg * i.price_per_kg), 2) AS cost_per_batch
FROM Products p
JOIN Recipes r            ON r.product_id = p.product_id
JOIN RecipeIngredients ri ON ri.recipe_id = r.recipe_id
JOIN Ingredients i        ON i.ingredient_id = ri.ingredient_id
GROUP BY p.product_id
ORDER BY cost_per_batch DESC;