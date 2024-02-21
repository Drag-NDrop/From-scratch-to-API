-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Martin Sandgaard
-- Create date: 21-06-2023
-- Description:	Gets all shoppinglist lines for a given ShoppingListID
-- =============================================
CREATE PROCEDURE Read_ShoppingListLinesByShoppingListID 
	-- Add the parameters for the stored procedure here
	@ShoppingListID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT
ShoppingItemLine.ShoppingListID,
Quantity,
MeasurementUnit,
Product.Name,
Price,
VendorName,
OnOffer,
OfferPrice,
ActiveForWeek,
ActiveYear


FROM ShoppingItemLine 
RIGHT JOIN VendorProductPriceMap
ON ShoppingItemLine.VendorProductPriceMapID = VendorProductPriceMap.VendorProductPriceMapID
RIGHT JOIN Vendor
ON VendorProductPriceMap.VendorID = Vendor.VendorID
RIGHT JOIN Product
ON Product.ProductID = VendorProductPriceMap.ProductID
RIGHT JOIN UnitType
ON Product.UnitTypeID = UnitType.UnitTypeID
RIGHT JOIN ShoppingList
ON ShoppingList.ShoppingListID = ShoppingItemLine.ShoppingListID

WHERE ShoppingItemLine.ShoppingListID = @ShoppingListID




END
GO
