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
-- Description:	Create a UNIQUE unit type for measuring units, in the UnitType table
-- =============================================
CREATE PROCEDURE Create_UnitType 
	-- Add the parameters for the stored procedure here
	@UnitType varchar(255) 
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO UnitType(MeasurementUnit)
	VALUES(@UnitType);
END
GO