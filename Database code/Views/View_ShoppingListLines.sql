USE [Shoppinglist_app_ORM_demo]
GO

/****** Object:  View [dbo].[View_ShoppingListLines]    Script Date: 27-06-2023 20:05:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_ShoppingListLines]
AS
SELECT        dbo.Category.Category, dbo.Product.Name, dbo.Product.Maker, dbo.Product.Description, dbo.UnitType.MeasurementUnit, dbo.ShoppingItemLine.Quantity, dbo.ShoppingItemLine.Fulfilled, dbo.VendorProductPriceMap.Price, 
                         dbo.VendorProductPriceMap.OfferPrice, dbo.VendorProductPriceMap.OnOffer, dbo.Vendor.VendorName, dbo.Vendor.Storebox, dbo.Vendor.Discountclub, dbo.ShoppingList.ActiveForWeek, 
						 dbo.ShoppingList.ActiveYear, dbo.ShoppingList.ShoppingListID, dbo.Vendor.VendorID, dbo.Product.ProductID, dbo.product.UnitTypeID, dbo.Category.CategoryID,dbo.ShoppingItemLine.ShoppingItemLineID
FROM            dbo.UnitType INNER JOIN
                         dbo.Category INNER JOIN
                         dbo.ProductCategoryMap ON dbo.Category.CategoryID = dbo.ProductCategoryMap.CategoryID INNER JOIN
                         dbo.Product ON dbo.ProductCategoryMap.ProductID = dbo.Product.ProductID ON dbo.UnitType.UnitTypeID = dbo.Product.UnitTypeID INNER JOIN
                         dbo.VendorProductPriceMap ON dbo.Product.ProductID = dbo.VendorProductPriceMap.ProductID INNER JOIN
                         dbo.ShoppingList INNER JOIN
                         dbo.ShoppingItemLine ON dbo.ShoppingList.ShoppingListID = dbo.ShoppingItemLine.ShoppingListID ON dbo.VendorProductPriceMap.VendorProductPriceMapID = dbo.ShoppingItemLine.VendorProductPriceMapID INNER JOIN
                         dbo.Vendor ON dbo.VendorProductPriceMap.VendorID = dbo.Vendor.VendorID
GO
