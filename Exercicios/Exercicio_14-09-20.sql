/*Exercício
Dada a database abaixo, criar uma procedure que receba idProduto, nome,
valor e tipo(e para entrada e s para saída) e determine se vai para a tabela 
de compras (entrada) ou de vendas (saída). Não há necessidade de usar 
Try..Catch
*/
USE master
CREATE DATABASE ex_14_07
GO
USE ex_14_07

CREATE TABLE produto(
idProduto INT NOT NULL,
nome VARCHAR(100),
valor DECIMAL(7,2),
tipo CHAR(1) DEFAULT('e')
PRIMARY KEY (idProduto))

CREATE TABLE compra(
codigo INT NOT NULL IDENTITY,
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)

PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))

CREATE TABLE venda(
codigo INT NOT NULL IDENTITY ,
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)

PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))

CREATE PROCEDURE sp_inserirProduto (@idProduto INT, @nome VARCHAR(100), @valor DECIMAL(7,2), @qtd INT, @tipo CHAR(1))
AS
    DECLARE @tabela         VARCHAR(10),
            @queryProduto   VARCHAR(MAX),
            @queryTipo      VARCHAR(MAX)
    IF @tipo = 'e'
    BEGIN
        SET @tabela = 'compra'
    END
    ELSE
    BEGIN
        IF @tipo = 's'
        BEGIN
            SET @tabela = 'venda'
        END
        ELSE
        BEGIN
            RAISERROR ('Erro de processamento', 16, 1)
        END
    END

    SET @queryProduto   = 'INSERT INTO produto VALUES (' + CAST(@idProduto AS VARCHAR(5)) + ','''  + @nome + ''','
                              + CAST(@valor AS VARCHAR(7)) + ',''' + @tipo + ''')'
    SET @queryTipo      = 'INSERT INTO ' + @tabela + ' VALUES ('
                              + CAST(@idProduto AS VARCHAR(5)) + ',' + CAST(@qtd AS VARCHAR(5)) + ','
                              + CAST((@qtd * @valor) AS VARCHAR(7)) + ')'
    print @queryProduto
    print @queryTipo

GO

EXEC sp_inserirProduto 1,'Doce',18.99,2,'s'
