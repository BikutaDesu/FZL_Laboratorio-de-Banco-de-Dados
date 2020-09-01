--Potência em SQL SERVER
SELECT POWER(3,4)

CREATE PROCEDURE sp_power(@vlr1 INT, @vlr2 INT, @res INT OUTPUT)
AS
	SET @res = POWER(@vlr1, @vlr2)

CREATE PROCEDURE sp_calc(@vlr1 INT, @vlr2 INT, @text VARCHAR(100))
AS
	DECLARE @res INT
	EXEC sp_power @vlr1, @vlr2, @res OUTPUT
	PRINT @text + ': ' + CAST(@res AS VARCHAR(5))

EXEC sp_calc 3,4,'Resultado é'