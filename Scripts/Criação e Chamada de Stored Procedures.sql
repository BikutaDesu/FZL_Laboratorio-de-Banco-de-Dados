CREATE DATABASE procedimento
GO
USE procedimento

CREATE TABLE pessoa(
codigo		INT		NOT NULL IDENTITY PRIMARY KEY,
nome		VARCHAR(100),
telefone	VARCHAR(15))

CREATE TABLE produto(
codigo	INT NOT NULL IDENTITY PRIMARY KEY,
nome	VARCHAR(100),
valor	DECIMAL(7,2))

CREATE TABLE venda(
codigo_venda	INT NOT NULL PRIMARY KEY,
codigo_pessoa	INT NOT NULL,
codigo_produto	INT NOT NULL,
qtd		INT NOT NULL,
valor_un	DECIMAL(7,2),
valor_total	DECIMAL(7,2)
FOREIGN KEY (codigo_pessoa) REFERENCES pessoa(codigo),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)

INSERT INTO produto VALUES
('Chocolate', 2.5),
('Café', 3.5),
('Pasta de Dente', 5.5)

CREATE PROCEDURE  sp_pessoa (@operacao CHAR(1),
    @codigo INT, @nome VARCHAR(100),
    @telefone VARCHAR(15),
    @saida VARCHAR(MAX) OUTPUT )
AS
    IF(UPPER(@operacao) = 'I')
    BEGIN
       INSERT INTO pessoa VALUES (@nome, @telefone)
       SET @saida = 'Inserido com sucesso!'
    END
    ELSE
    BEGIN
        IF(UPPER(@operacao) = 'U')
        BEGIN
            UPDATE pessoa SET nome = @nome, telefone = @telefone
            WHERE codigo = @codigo
            SET @saida = 'Atualizado com sucesso!'
        END
        ELSE
        BEGIN
            IF(UPPER(@operacao) = 'U')
            BEGIN
                DELETE pessoa
                WHERE codigo = @codigo
                SET @saida = 'Excluido com sucesso!'
            END
            ELSE
            BEGIN
                RAISERROR ('Operação Inválida', 16, 1)
            END
        END
    END

SELECT * FROM pessoa

DECLARE @out VARCHAR(MAX)
EXEC sp_pessoa 'I', NULL, 'Fulano', '11999996666', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_pessoa 'U', 1, 'Fulano de Tal', '11999996666', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_pessoa 'J', 1, 'Fulano de Tal', '11999996666', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_pessoa 'D', 1, NULL, NULL, @out OUTPUT
PRINT @out


CREATE PROCEDURE sp_inserevenda(@codigo_venda INT,
	@codigo_pessoa INT, @codigo_produto INT, @qtd INT)
AS
	DECLARE @valor_un		DECIMAL(7,2),
			@valor_total	DECIMAL(7,2),
			@cont_pessoa	INT,
			@cont_produto	INT
	SET @cont_pessoa = (SELECT COUNT(*) FROM pessoa
						WHERE codigo = @codigo_pessoa)
	SET @cont_produto = (SELECT COUNT(*) FROM produto
						WHERE codigo = @codigo_produto)
	IF (@cont_pessoa = 0)
	BEGIN
		RAISERROR('Código de pessoa inválido', 16, 1)
	END
	IF (@cont_produto = 0)
	BEGIN
		RAISERROR('Código de produto inválido', 16, 1)
	END
	IF (@cont_pessoa = 1 AND @cont_produto = 1)
	BEGIN
		SELECT @valor_un = valor FROM produto
			WHERE codigo = @codigo_produto
		SET @valor_total = @valor_un * @qtd
		INSERT INTO venda VALUES
		(@codigo_venda, @codigo_pessoa, @codigo_produto, @qtd,
			@valor_un, @valor_total)
	END

SELECT * FROM venda

EXEC sp_inserevenda 1,2,5,4
