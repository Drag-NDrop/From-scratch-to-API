CREATE TABLE Product(
    ProductID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Name varchar(255) NOT NULL,
    Maker varchar(255) DEFAULT 'Unknown',
	Description varchar(255) DEFAULT 'N/A',
    UnitTypeID int FOREIGN KEY REFERENCES UnitType(UnitTypeID)
);


USE [Shoppinglist_app_ORM_demo];

INSERT INTO Shoppinglist_app_ORM_demo.dbo.Product(Name,Maker,Description, UnitTypeID) 
VALUES
('Lune frikadeller','Slagteren i Føtex',"Pakke med 3",1)
('Økologisk Letmælk','Arla', "",2)
