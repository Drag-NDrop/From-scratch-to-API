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
-- Description:	Read products by VendorID
-- =============================================
CREATE PROCEDURE Read_ProductsByVendorID 
	-- Add the parameters for the stored procedure here
	@VendorID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT	Product.ProductID, 
		Product.Name AS ProductName, 
		Maker, Description, 
		Product.UnitTypeID, 
		(SELECT VendorName 
		FROM Vendor WHERE
		VendorProductPriceMap.VendorID = Vendor.VendorID)
		AS Vendor,
		VendorProductPriceMap.Price AS Price
	FROM Product
	RIGHT Join VendorProductPriceMap
	ON VendorProductPriceMap.ProductID = Product.ProductID
	WHERE VendorProductPriceMap.VendorID = @VendorID
END
GO

