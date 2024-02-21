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
-- Create date: 22-06-2023
-- Description:	Updates the OfferPrice of a VendorProductPrice row
-- =============================================
CREATE PROCEDURE Update_OfferPriceByVendorProductPriceMapID
	-- Add the parameters for the stored procedure here
	@VendorProductPriceID int,
	@OfferPrice decimal,
	@OnOffer bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE VendorProductPriceMap
	SET OfferPrice = @OfferPrice
	WHERE VendorProductPriceMapID = @VendorProductPriceID;

	IF @OnOffer = 1
		UPDATE VendorProductPriceMap
		SET OnOffer = @OnOffer
		WHERE VendorProductPriceMapID = @VendorProductPriceID;
	ELSE 
       	UPDATE VendorProductPriceMap
		SET OnOffer = 0
		WHERE VendorProductPriceMapID = @VendorProductPriceID;
END
GO
