--Atribuição de variável (Declarar e atribuir)
--DECLARE @var TIPO
--SET @var = valor

--Estrutura Condicional
/*
IF (teste_lógico) múltiplos testes com AND e OR
BEGIN

END
ELSE
BEGIN

END
*/

--Estrutura de Repetição
/*
WHILE (teste_logico)
BEGIN
	INCREMENTO
END
*/

--Exemplos:
DECLARE @datahora DATETIME
SET @datahora = GETDATE()
PRINT @datahora

DECLARE @datahoraconvertida CHAR(10)
SET @datahoraconvertida = CONVERT(CHAR(10),GETDATE(),103)
print @datahoraconvertida

DECLARE @valor1 INT,
		@valor2 INT,
		@res	INT,
		@frase	VARCHAR(10)
SET @valor1 = 10
SET @valor2 = 20
SET @res = @valor1 * @valor2
SET @frase = 'Resultado:'
PRINT @frase+CAST(@res AS VARCHAR(3))

CREATE DATABASE progsql
GO
USE progsql

CREATE TABLE usuario (
id			INT				NOT NULL,
nome		VARCHAR(100)	NOT NULL,
telefone	CHAR(9)			NOT NULL
PRIMARY KEY (id) )

INSERT INTO usuario VALUES
(1, 'Usuario 1', '999999999'),
(2, 'Usuario 2', '988888888')

DECLARE @id			INT,
		@nome		VARCHAR(100),
		@telefone	CHAR(9)
SET @id = (SELECT MAX(id) FROM usuario)
--SET @nome = (SELECT nome FROM usuario WHERE id = @id)
--SET @telefone = (SELECT telefone FROM usuario WHERE id = @id)
SELECT @nome = nome, @telefone = telefone
	FROM usuario WHERE id = @id
PRINT CAST(@id AS VARCHAR(3))+' | '+@nome+' | '+@telefone


CREATE TABLE produto (
id		INT				NOT NULL,
nome	VARCHAR(100)	NOT NULL,
valor	DECIMAL(7,2)	NOT NULL
PRIMARY KEY (id))

INSERT INTO produto VALUES
(1001, 'Caneta', 2.5),
(1002, 'Lápis', 1.5),
(1003, 'Borracha', 7.2)

DECLARE @valor	DECIMAL(7,2),
		@id INT
SET @id = 1003
SET @valor = (SELECT valor FROM produto WHERE id = @id)
IF (@valor > 8)
BEGIN
	UPDATE produto
	SET valor = @valor * 0.98
	WHERE id = @id
END
ELSE
BEGIN
UPDATE produto
	SET valor = @valor * 0.9
	WHERE id = @id
END
SELECT * FROM produto

DECLARE @valor INT
SET @valor = 250
IF (@valor % 2 = 0 AND @valor > 100)
BEGIN
	PRINT 'True'
END
ELSE
BEGIN
	IF (@valor % 2 = 0 AND @valor <= 100)
	BEGIN
		PRINT 'Half True'
	END
	ELSE
	BEGIN
		PRINT 'False'
	END
END

DECLARE @i		INT,
		@cont	INT,
		@mul	INT
SET @i = 4
SET @cont = 0
WHILE (@cont <= 10)
BEGIN
	SET @mul = @i * @cont
	PRINT CAST(@i AS CHAR(1))+' X '+CAST(@cont AS VARCHAR(2))+
		' = '+CAST(@mul AS VARCHAR(3))
	SET @cont = @cont + 1
END

DECLARE @id			INT,
		@nome		VARCHAR(100),
		@telefone	CHAR(9)
SET @id = 3
WHILE (@id <= 200)
BEGIN
	SET @nome = 'Usuario '+CAST(@id AS VARCHAR(3))
	IF (@id % 2 = 0)
	BEGIN
		SET @telefone = '977777777'
	END
	ELSE
	BEGIN
		SET @telefone = '966666666'
	END
	INSERT INTO usuario VALUES
	(@id, @nome, @telefone)

	SET @id = @id + 1
END

SELECT * FROM usuario