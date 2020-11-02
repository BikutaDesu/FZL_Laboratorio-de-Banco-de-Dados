/*
CURSORES

DECLARE cursor CURSOR FOR SELECT col1, col2 FROM tabela WHERE condicao
OPEN cursor
FETCH NEXT FROM cursor INTO @var1, @var2

WHILE @@FETCH_STATUS = 0
BEGIN
	Programação

	FETCH NEXT FROM cursor INTO @var1, @var2
END

CLOSE cursor
DEALLOCATE cursor
*/

CREATE DATABASE aulacursor
GO
USE aulacursor

CREATE TABLE cliente (
id		CHAR(15)		NOT NULL,
nome	VARCHAR(100)	NOT NULL,
saldo	DECIMAL(7,2)	NOT NULL)

INSERT INTO cliente VALUES
('5k3by2uz75o','Cliente 1',551),
('p9tzythdgma','Cliente 2',1719),
('m5a6efnak69','Cliente 3',1033),
('kz5odohh8c5','Cliente 4',1660),
('0lwrnhkp64u','Cliente 5',601),
('whayjzkxe6s','Cliente 6',1744),
('n50jwh259q4','Cliente 7',1895),
('ch3ctqm5if5','Cliente 8',372),
('cobl5bialbl','Cliente 9',807),
('8vi83hu3i2j','Cliente 10',1962),
('dfot5m2ubgn','Cliente 11',1059),
('uzhx65a3y9l','Cliente 12',634),
('ipvppwtd6pr','Cliente 13',1460),
('7z2gjrulsle','Cliente 14',543),
('878xc85z2zz','Cliente 15',1813)

SELECT * FROM cliente

--CRIAR UDF com CURSOR
CREATE FUNCTION fn_cursor(@valor DECIMAL(7,2))
RETURNS @tabela TABLE (
id		CHAR(10),
nome	VARCHAR(100),
saldo	DECIMAL(7,2)
)
AS
BEGIN
	DECLARE @id	CHAR(10),
		@nome	VARCHAR(100),
		@saldo	DECIMAL(7,2)
	DECLARE c CURSOR FOR SELECT id, nome, saldo FROM cliente WHERE saldo < @valor
	OPEN c
	FETCH NEXT FROM c INTO @id, @nome, @saldo

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@saldo < 1000.00)
		BEGIN
			INSERT INTO @tabela VALUES (@id, @nome, @saldo)
		END

		FETCH NEXT FROM c INTO @id, @nome, @saldo
	END
	CLOSE c
	DEALLOCATE c

	RETURN
END

SELECT * FROM fn_cursor(1100.00)

SELECT id, nome, saldo FROM cliente WHERE saldo < 1100.00