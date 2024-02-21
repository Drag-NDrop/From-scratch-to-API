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
-- Description:	Create a row in ShoppingItemLine table
-- =============================================
CREATE PROCEDURE Create_ShoppingItemLine 
	-- Add the parameters for the stored procedure here
	@VendorProductPriceMapID int, 
	@ShoppingListID int,
	@Quantity int,
	@PurchaseWeek int,
	@Fulfilled bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	--SELECT @VendorProductPriceMapID, @ShoppingListID

	INSERT INTO ShoppingItemLine(VendorProductPriceMapID, ShoppingListID, Quantity, PurchaseWeek, DateCreated, Fulfilled)
	VALUES(
		@VendorProductPriceMapID, 
		@ShoppingListID, 
		@Quantity, 
		@PurchaseWeek, 
		GetDate(), 
		@Fulfilled
	);



END
GO
