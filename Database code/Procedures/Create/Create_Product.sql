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
-- Description:	Create a product in the Product table
-- =============================================
CREATE PROCEDURE Create_Product 
	-- Add the parameters for the stored procedure here
	@Name varchar(255) = 'Unknown', 
	@Maker varchar(255) = 'Unknown',
	@Description varchar(255) = 'Unknown',
	@UnitTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- SELECT @Name, @Maker
	INSERT INTO Product(Name, Maker, Description, UnitTypeID) VALUES(@Name, @Maker, @Description, @UnitTypeID)
END
GO
