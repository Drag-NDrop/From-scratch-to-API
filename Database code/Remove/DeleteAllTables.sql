USE Shoppinglist_app_ORM_demo;

-- Disable Constraints at DB level

EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'

-- Drop tables
DROP TABLE Category;
DROP TABLE Product;
DROP TABLE ProductCategoryMap;
DROP TABLE ShoppingItemLine;
DROP TABLE ShoppingList;
DROP TABLE UnitType;
DROP TABLE Vendor;
DROP TABLE VendorProductPriceMap;

--To Enable constraints at DB level

EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'