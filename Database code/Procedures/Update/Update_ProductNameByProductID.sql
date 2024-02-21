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
-- Description:	Updates a Name using ProductID
-- =============================================
CREATE PROCEDURE Update_ProductNameByProductID 
	-- Add the parameters for the stored procedure here
	@ProductID int,
	@NewName varchar(255) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	UPDATE Product
	SET Name = @NewName
	WHERE ProductID = @ProductID;


END
GO
