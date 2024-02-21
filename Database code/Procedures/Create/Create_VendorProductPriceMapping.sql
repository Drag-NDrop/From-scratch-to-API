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
-- Description:	Creates a Vendor-Product-Price mapping
-- =============================================
CREATE PROCEDURE Create_VendorProductPriceMap 
	-- Add the parameters for the stored procedure here
	@VendorID int, 
	@ProductID int,
	@Price decimal,
	@OnOffer bit,
	@OfferPrice decimal
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Konvertér datoen til et læsbart "fordansket" format.
	--DECLARE @CurrentDate date = CONVERT(VARCHAR(30), GETDATE(), 103);
	
    -- Insert statements for procedure here
	--SELECT @VendorID, @ProductID

	INSERT INTO VendorProductPriceMap(VendorID, ProductID, Price, Date, OnOffer, OfferPrice)
	VALUES(
	@VendorID, 
	@ProductID,
	@Price,
	getdate(),
	@OnOffer,
	@OfferPrice
	);

END
GO
