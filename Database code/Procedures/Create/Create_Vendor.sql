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
-- Create date: 20-06-2023
-- Description:	Creates a vendor in the Vendor table
-- =============================================
CREATE PROCEDURE Create_Vendor 
	-- Add the parameters for the stored procedure here
	@VendorName varchar(100),
	@Storebox bit = 0, 
	@Discountclub bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- SELECT @Storebox, @Discountclub
	INSERT INTO Vendor(VendorName, Storebox, Discountclub) VALUES(@VendorName, @Storebox, @Discountclub)
END
GO
