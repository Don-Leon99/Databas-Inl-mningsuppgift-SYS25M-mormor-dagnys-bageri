PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS RecipeIngredients(
    recipe_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    quantity_kg REAL NOT NULL CHECK (quantity_kg > 0),

    PRIMARY KEY (recipe_id, ingredient_id),
    
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id)
);