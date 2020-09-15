CREATE DATABASE querydinamica
GO
USE querydinamica

CREATE TABLE camiseta(
idProduto INT NOT NULL,
tipo VARCHAR(100),
cor VARCHAR(50),
tamanho VARCHAR(3)
PRIMARY KEY(idProduto))

CREATE TABLE tenis(
idProduto INT NOT NULL,
tipo VARCHAR(100),
cor VARCHAR(50),
tamanho INT
PRIMARY KEY(idProduto))

SELECT * FROM tenis
SELECT * FROM camiseta

--Criar uma SP única que decida se é tênis ou camiseta e fazer o insert

CREATE ALTER PROCEDURE sp_insereproduto(@id INT, @tipo VARCHAR(100),
							@cor VARCHAR(50), @tamanho VARCHAR(3))
AS
	DECLARE @tam		INT,
			@tabela		VARCHAR(10),
			@query		VARCHAR(MAX),
			@erro		VARCHAR(MAX)

	SET @tabela = 'tenis'

	BEGIN TRY
		SET @tam = CAST(@tamanho AS INT)
	END TRY
	BEGIN CATCH
		SET @tabela = 'camiseta'
	END CATCH

	SET @query = 'INSERT INTO '+@tabela+' VALUES('+CAST(@id AS VARCHAR(5))+
		','''+@tipo+''','''+@cor+''','''+@tamanho+''')'
	PRINT @query
	BEGIN TRY
		EXEC (@query)
		--INSERT INTO tabela VALUES (@var1, @var2)
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('Chave primária duplicada', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Erro de processamento', 16, 1)
		END
	END CATCH

EXEC sp_insereproduto 1001,'Regata','branca','P'
EXEC sp_insereproduto 10001,'Chuteira','preta','42'


/* Query Dinâmica - Query montada em uma variável e o SQL executa o conteúdo
da variável
	INSERT INTO @tabela VALUES (@id, @tipo, @cor, @tamanho)
Escape SQL Server = '
Executar query dentro de uma variável = EXEC (@var)