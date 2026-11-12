# ER-diagram – Mormor Dagnys bageri

erDiagram
    Suppliers ||--o{ Ingredients : supplies
    Suppliers ||--o{ Purchases : receives
    Products ||--|| Recipes : has
    Recipes ||--|{ RecipeIngredients : contains
    Ingredients ||--o{ RecipeIngredients : used_in
    Purchases ||--|{ PurchaseLines : contains
    Ingredients ||--o{ PurchaseLines : bought_as

    Suppliers {
        INTEGER supplier_id PK
        TEXT name
        TEXT address
        TEXT phone_number
        TEXT email
        TEXT contact_person
    }
    Ingredients {
        INTEGER ingredient_id PK
        TEXT article_number UK
        TEXT name
        REAL price_per_kg
        REAL stock_kg
        REAL reorder_level_kg
        INTEGER supplier_id FK
    }
    Products {
        INTEGER product_id PK
        TEXT name
        TEXT category
    }
    Recipes {
        INTEGER recipe_id PK
        INTEGER product_id FK, UK
        TEXT instructions
    }
    RecipeIngredients {
        INTEGER recipe_id PK, FK
        INTEGER ingredient_id PK, FK
        REAL quantity_kg
    }
    Purchases {
        INTEGER purchase_id PK
        INTEGER supplier_id FK
        TEXT purchase_date
    }
    PurchaseLines {
        INTEGER purchase_id PK, FK
        INTEGER ingredient_id PK, FK
        REAL quantity_kg
        REAL price_per_kg
    }