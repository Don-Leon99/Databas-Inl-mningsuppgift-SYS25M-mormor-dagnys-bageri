PRAGMA foreign_keys = ON;

-- Suppliers
INSERT INTO Suppliers (supplier_id, name, address, phone_number, email, contact_person) VALUES
(1, 'Kvarnbolaget Skåne', 'Kvarngatan 4, 211 15 Malmö', '040-123456', 'order@kvarnbolaget.se', 'Lena Persson'),
(2, 'Mejerigården', 'Mjölkvägen 12, 222 22 Lund', '046-654321', 'info@mejerigarden.se', 'Erik Nilsson'),
(3, 'Söta Skåne AB', 'Sockervägen 7, 261 31 Landskrona', '0418-778899', 'kundtjanst@sotaskane.se', 'Maria Holm');

-- Ingredients (några har stock_kg under reorder_level_kg)
INSERT INTO Ingredients (ingredient_id, article_number, name, price_per_kg, stock_kg, reorder_level_kg, supplier_id) VALUES
(1,  'KB-001', 'Vetemjöl',    9.50,   40,  25, 1),
(2,  'MG-010', 'Smör',        89.00,  3,   5,  2),
(3,  'KB-002', 'Rågmjöl',     12.00,  30,  20, 1),
(4,  'MG-011', 'Mjölk',       14.00,  20,  10, 2),
(5,  'MG-012', 'Vispgrädde',  45.00,  4,   6,  2),
(6,  'MG-013', 'Ägg',         38.00,  12,  8,  2),
(7,  'SS-100', 'Strösocker',  13.50,  50,  20, 3),
(8,  'SS-101', 'Kanel',       220.00, 0.5, 1,  3),
(9,  'SS-102', 'Kardemumma',  450.00, 1.5, 1,  3),
(10, 'SS-103', 'Jäst',        60.00,  2,   2,  3),
(11, 'SS-104', 'Marsipan',    120.00, 5,   3,  3),
(12, 'SS-105', 'Sirap',       30.00,  8,   5,  3);

-- Products
INSERT INTO Products (product_id, name, category) VALUES
(1, 'Kanelbulle',      'Bullar'),
(2, 'Kardemummabulle', 'Bullar'),
(3, 'Rågbröd',         'Bröd'),
(4, 'Prinsesstårta',   'Konditori');

-- Recipes (ett per produkt)
INSERT INTO Recipes (recipe_id, product_id, instructions) VALUES
(1, 1, 'Knåda degen, jäs 30 min, fyll med kanelsmör, rulla, skär och grädda 225°C i 8 min.'),
(2, 2, 'Knåda degen, jäs 30 min, fyll med kardemummasmör, forma knutar och grädda 225°C i 8 min.'),
(3, 3, 'Blanda mjöl och sirap, knåda, jäs 60 min och grädda 200°C i 40 min.'),
(4, 4, 'Grädda sockerkaksbotten, varva med vaniljkräm och grädde, täck med marsipan.');

-- RecipeIngredients (mängd per sats)
INSERT INTO RecipeIngredients (recipe_id, ingredient_id, quantity_kg) VALUES
(1, 1, 1.0), (1, 2, 0.2), (1, 4, 0.4), (1, 7, 0.15), (1, 8, 0.02), (1, 10, 0.05),
(2, 1, 1.0), (2, 2, 0.2), (2, 4, 0.4), (2, 7, 0.15), (2, 9, 0.015), (2, 10, 0.05),
(3, 3, 0.8), (3, 1, 0.2), (3, 10, 0.03), (3, 12, 0.1),
(4, 1, 0.2), (4, 6, 0.3), (4, 7, 0.25), (4, 5, 0.6), (4, 11, 0.3), (4, 4, 0.3);

-- Purchases
INSERT INTO Purchases (purchase_id, supplier_id, purchase_date) VALUES
(1, 1, '2026-10-01'),
(2, 2, '2026-10-05'),
(3, 3, '2026-10-08'),
(4, 1, '2026-11-02');

-- PurchaseLines (priset vid köptillfället kan skilja sig från dagens pris)
INSERT INTO PurchaseLines (purchase_id, ingredient_id, quantity_kg, price_per_kg) VALUES
(1, 1, 50, 9.00),  (1, 3, 30, 11.50),
(2, 2, 10, 85.00), (2, 4, 20, 14.00), (2, 5, 8, 45.00),
(3, 7, 25, 13.50), (3, 8, 1, 210.00), (3, 10, 3, 60.00),
(4, 1, 25, 9.50);