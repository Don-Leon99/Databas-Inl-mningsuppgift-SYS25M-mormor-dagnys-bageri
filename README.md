# Mormor Dagnys bageri – Databas

Inlämningsuppgift i Databasteknik. Projektet innehåller en normaliserad SQLite-databas som hanterar Mormor Dagnys bageris leverantörer, råvaror, recept, inköp och lagersaldo.

## Innehåll

Databasen gör det möjligt att:

- hantera leverantörer med namn, adress, kontaktperson, telefonnummer och e-post
- se vilka råvaror som köps från respektive leverantör (artikelnummer, namn, pris per kg)
- koppla varje produkt till ett recept med de råvaror som behövs
- registrera inköp och följa lagersaldot, så att bageriet vet när en ny beställning behövs

## Projektstruktur

```
mormor-dagnys-bageri/
├── Database/
│   └── bageri.db                          # Genereras av skripten
├── Design/
│   ├── er-diagram.png                     # Visualiserad databasdesign
│   ├── er-diagram.md                      # Mermaid-källkod för diagrammet
│   └── normalization.md                   # Normalisering och designbeslut
├── Scripts/
│   ├── drop_tables.sql                    # Tar bort alla tabeller
│   ├── Create/
│   │   ├── 00_create_suppliers.sql
│   │   ├── 01_create_products.sql
│   │   ├── 02_create_ingredients.sql
│   │   ├── 03_create_recipes.sql
│   │   ├── 04_create_purchases.sql
│   │   ├── 05_create_recipe_ingredients.sql
│   │   └── 06_create_purchase_lines.sql
│   └── Test/
│       ├── 00_insert_testdata.sql         # Testdata för alla tabeller
│       ├── 01_test_queries.sql            # Frågor som testar relationerna
│       └── 02_test_constraints.sql        # Ogiltig data som ska avvisas
└── README.md
```

## Tabeller

| Tabell | Beskrivning | Nycklar |
|---|---|---|
| `Suppliers` | Leverantörer | PK `supplier_id` |
| `Products` | Bageriets produkter | PK `product_id` |
| `Ingredients` | Råvaror, pris, lagersaldo och beställningsnivå | PK `ingredient_id`, FK `supplier_id`, UNIQUE `article_number` |
| `Recipes` | Ett recept per produkt | PK `recipe_id`, FK + UNIQUE `product_id` |
| `RecipeIngredients` | Kopplar råvaror till recept med mängd | PK (`recipe_id`, `ingredient_id`), båda FK |
| `Purchases` | Inköp från en leverantör | PK `purchase_id`, FK `supplier_id` |
| `PurchaseLines` | Råvaror, mängd och pris per inköp | PK (`purchase_id`, `ingredient_id`), båda FK |

Se `Design/er-diagram.png` för relationerna och `Design/normalization.md` för hur designen uppfyller 1NF–3NF.

## Antaganden

- Varje råvara köps från **en** leverantör.
- Varje produkt har **ett** recept.
- En råvara kan bara förekomma **en gång** per recept (säkras av den sammansatta primärnyckeln i `RecipeIngredients`).
- Mängder och priser anges i kg.
- Priset i `PurchaseLines` är priset vid inköpstillfället, så historiken bevaras även om priset i `Ingredients` ändras.
- Inköpets totalsumma lagras inte utan beräknas från `PurchaseLines`.

## Constraints

- **PRIMARY KEY** på alla tabeller, sammansatt i kopplingstabellerna
- **FOREIGN KEY** på alla relationer, vilket stoppar data som pekar på rader som inte finns
- **UNIQUE** på `article_number` och `Recipes.product_id`
- **CHECK** som förhindrar negativa priser, lagersaldon och mängder
- **NOT NULL** på obligatoriska fält

> **Obs:** SQLite har foreign keys avstängda som standard. Varje skript börjar därför med `PRAGMA foreign_keys = ON;`.

## Köra projektet

Skripten måste köras i ordning, eftersom tabeller med foreign keys kräver att tabellerna de refererar till redan finns.

### Med terminalen (sqlite3)

Kör från projektets rotmapp:

```bash
sqlite3 Database/bageri.db < Scripts/drop_tables.sql

sqlite3 Database/bageri.db < Scripts/Create/00_create_suppliers.sql
sqlite3 Database/bageri.db < Scripts/Create/01_create_products.sql
sqlite3 Database/bageri.db < Scripts/Create/02_create_ingredients.sql
sqlite3 Database/bageri.db < Scripts/Create/03_create_recipes.sql
sqlite3 Database/bageri.db < Scripts/Create/04_create_purchases.sql
sqlite3 Database/bageri.db < Scripts/Create/05_create_recipe_ingredients.sql
sqlite3 Database/bageri.db < Scripts/Create/06_create_purchase_lines.sql

sqlite3 Database/bageri.db < Scripts/Test/00_insert_testdata.sql
sqlite3 Database/bageri.db < Scripts/Test/01_test_queries.sql
```

### Med VS Code (tillägget SQLite)

1. Öppna kommandopaletten (`Ctrl + Shift + P`) och välj **SQLite: Use Database** → `Database/bageri.db`.
2. Öppna skripten i ordningen ovan och kör dem med **SQLite: Run Query** (`Ctrl + Shift + Q`).
3. Resultatet syns i SQLite-panelen och tabellerna under **SQLite Explorer**.

## Tester

### Testfrågor (`01_test_queries.sql`)

| # | Fråga | Förväntat resultat |
|---|---|---|
| 1 | Recept med råvaror och mängder | 22 rader |
| 2 | Produkter och deras leverantörer | 11 rader |
| 3 | Råvaror per leverantör | 12 rader |
| 4 | Råvaror som behöver beställas | 4 rader: Smör, Vispgrädde, Kanel, Jäst |
| 5 | Inköpshistorik med totalsumma | 4 inköp |
| 6 | Råvarukostnad per recept | 4 rader |

### Constraint-tester (`02_test_constraints.sql`)

Varje test försöker lägga in ogiltig data och **ska ge ett fel**. Kör ett test i taget, tillsammans med raden `PRAGMA foreign_keys = ON;`, eftersom SQLite avbryter vid första felet.

Testerna visar att databasen stoppar:

- råvaror, recept och inköpsrader som pekar på rader som inte finns (FOREIGN KEY)
- borttagning av en leverantör som har råvaror kopplade (FOREIGN KEY)
- samma råvara två gånger i ett recept, ett andra recept för samma produkt och dubbla artikelnummer (PRIMARY KEY / UNIQUE)
- negativa priser och mängden 0 (CHECK)
- leverantörer utan namn (NOT NULL)

Om ett test lyckas har ogiltig data hamnat i databasen. Bygg då om den från början med `drop_tables.sql`.
