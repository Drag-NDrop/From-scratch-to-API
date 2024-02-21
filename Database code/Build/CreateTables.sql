USE Shoppinglist_app_ORM_demo;



CREATE TABLE Category (
    CategoryID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    CategoryName varchar(255) UNIQUE NOT NULL
);

CREATE TABLE UnitType(
	UnitTypeID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	MeasurementUnit varchar(50) UNIQUE NOT NULL
);

CREATE TABLE Vendor(
    VendorID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    VendorName varchar(100) UNIQUE NOT NULL,
    Storebox bit DEFAULT 0,
	Discountclub bit DEFAULT 0

);

CREATE TABLE Product(
    ProductID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Name varchar(255) NOT NULL,
    Maker varchar(255) DEFAULT 'Unknown',
	Description varchar(255) DEFAULT 'N/A',
    UnitTypeID int FOREIGN KEY REFERENCES UnitType(UnitTypeID)
);

CREATE TABLE ShoppingList(
    ShoppingListID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    ActiveForWeek int NOT NULL,
    ActiveYear int NOT NULL
);


CREATE TABLE ProductCategoryMap(
    ProductCategoryMapID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    ProductID int FOREIGN KEY REFERENCES Product(ProductID),
    CategoryID int FOREIGN KEY REFERENCES Category(CategoryID)
);

CREATE TABLE VendorProductPriceMap(
    VendorProductPriceMapID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    VendorID int FOREIGN KEY REFERENCES Vendor(VendorID),
    ProductID int FOREIGN KEY REFERENCES Product(ProductID),
	Price decimal NOT NULL,
	Date date NOT NULL,
	OfferPrice decimal DEFAULT 0,
	OnOffer bit DEFAULT 0
);


CREATE TABLE ShoppingItemLine(
    ShoppingItemLineID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	VendorProductPriceMapID int FOREIGN KEY REFERENCES VendorProductPriceMap(VendorProductPriceMapID),
    ShoppingListID int FOREIGN KEY REFERENCES ShoppingList(ShoppingListID),
    Quantity int DEFAULT 1,
	PurchaseWeek int NOT NULL,
	DateCreated date NOT NULL,
	Fulfilled bit DEFAULT 0
);

