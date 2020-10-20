--  Criar um database, fazer uma tabela cadastro (cpf, nome, rua, numero e cep)com uma procedure que só permitirá a
--      inserção dos dados se o CPF for válido, caso contrário retornar uma mensagem de erro
DROP DATABASE IF EXISTS ex_31_06
CREATE DATABASE ex_31_06
GO
USE ex_31_06

CREATE TABLE pessoa(
cpf		    CHAR(11)        NOT NULL,
nome		VARCHAR(100),
rua	        VARCHAR(100),
numero      VARCHAR(8),
cep         CHAR(8),
PRIMARY KEY (cpf))

CREATE PROCEDURE sp_verificarCpf(@cpf CHAR(11), @res INT OUTPUT)
AS
    DECLARE @i                      INT,
        @j                          INT,
        @digitoCpf                  INT,
        @resultado                  INT,
        @digitoEsperado             VARCHAR(2),
        @contadorDigitosIguais      INT
    SET @contadorDigitosIguais = 1
    SET @i = 0
    SET @digitoEsperado = ''
    SET @digitoCpf = SUBSTRING(@cpf,1,1)

    WHILE (@contadorDigitosIguais < 11)
    BEGIN
        IF (@digitoCpf = SUBSTRING(@cpf,@contadorDigitosIguais+1,1))
        BEGIN
            SET @digitoCpf = SUBSTRING(@cpf,@contadorDigitosIguais+1,1)
            SET @contadorDigitosIguais = @contadorDigitosIguais + 1
        END
        ELSE
            BREAK
    END
    IF(@contadorDigitosIguais < 11)
    BEGIN
        WHILE (@i < 2)
        BEGIN
            SET @j = 0
            SET @resultado = 0
            WHILE (@j < (9 + @i))
            BEGIN
                SET @digitoCpf = CAST(SUBSTRING(@cpf,@j+1,1) AS INT)
                SET @resultado = @resultado + (@digitoCpf * ((10 + @i)-@j))
                SET @j = @j + 1
            END
            IF ((@resultado % 11) < 2)
            BEGIN
                SET @digitoEsperado = CONCAT(@digitoEsperado, '0')
            END
            ELSE
            BEGIN
               SET @digitoEsperado = CONCAT(@digitoEsperado, CAST(11 - (@resultado % 11) AS CHAR(1)))
            END
            SET @i = @i + 1
        END
        IF (@digitoEsperado = SUBSTRING(@cpf,10,2))
        BEGIN
            SET @res = 0
        END
        ELSE
            BEGIN
                SET @res = 1
            END
    END
    ELSE
    BEGIN
        SET @res = 1
    END
GO;

CREATE PROCEDURE sp_inserir(@cpf CHAR(11),
    @nome VARCHAR(100),
    @rua VARCHAR(100),
    @numero VARCHAR(8),
    @cep CHAR(8),
    @res VARCHAR(MAX) OUTPUT)
AS
    DECLARE @cpfStatus INT
    EXEC sp_verificarCpf @cpf, @cpfStatus OUTPUT
    IF (@cpfStatus = 0)
    BEGIN
        INSERT INTO pessoa VALUES (@cpf, @nome, @rua, @numero, @cep)
        SET @res = @nome + ' inserido com sucesso!'
    END
    ELSE
    BEGIN
        RAISERROR('CPF inválido', 16, 1)
    END
GO;

DECLARE @out VARCHAR(MAX)
EXEC sp_inserir '22233366638',
                'Victor Neves',
                'Rua alguma coisa',
                '220',
                '08690075',
                @out OUTPUT
PRINT @out


--  Criar uma nova database e resolver o exercicio Aula_03a_-_Exercicio_Stored_Procedures.txt do site do professor.
/*Exercício
Criar uma database chamada academia, com 3 tabelas como seguem:

Aluno
|Codigo_aluno|Nome|

Atividade
|Codigo|Descrição|IMC|

Atividade
codigo      descricao                           imc
----------- ----------------------------------- --------
1           Corrida + Step                       18.5
2           Biceps + Costas + Pernas             24.9
3           Esteira + Biceps + Costas + Pernas   29.9
4           Bicicleta + Biceps + Costas + Pernas 34.9
5           Esteira + Bicicleta                  39.9

Atividadesaluno
|Codigo_aluno|Altura|Peso|IMC|Atividade|

IMC = Peso (Kg) / Altura² (M)
*/

CREATE DATABASE academia
USE academia

CREATE TABLE aluno (
    codigo_aluno    INT NOT NULL IDENTITY ,
    nome            VARCHAR(100),
    PRIMARY KEY (codigo_aluno)
)

CREATE TABLE atividade (
    codigo INT NOT NULL IDENTITY,
    descricao   VARCHAR(100),
    imc         DECIMAL(5,2),
    PRIMARY KEY (codigo)
)

INSERT INTO atividade VALUES
('Corrida + Step',1.5),
('Biceps + Costas + Pernas', 24.9),
('Esteira + Biceps + Costas + Pernas', 29.9),
('Bicicleta + Biceps + Costas + Pernas', 34.9),
('Esteira + Bicicleta', 39.9)

CREATE TABLE atividadesAluno(
    codigo_aluno    INT             NOT NULL,
    altura          DECIMAL(3,2)    NOT NULL,
    peso            DECIMAL(7,2)    NOT NULL,
    imc             DECIMAL(7,2)    NOT NULL,
    atividade       INT             NOT NULL,
    PRIMARY KEY (codigo_aluno, atividade),
    FOREIGN KEY (codigo_aluno) REFERENCES aluno(codigo_aluno),
    FOREIGN KEY (atividade) REFERENCES atividade(codigo)
)

/*
Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
* Caso o IMC seja maior que 40, utilizar o código 5.
*/
CREATE PROCEDURE sp_buscarAtividade(@imc decimal(7,2),
    @codigo_atividade INT OUT)
AS
    IF (@imc <= 40)
    BEGIN
        SET @codigo_atividade = (SELECT codigo FROM atividade WHERE imc = (
        SELECT MAX(imc) FROM atividade WHERE @imc >= imc))
    END
    ELSE
    BEGIN
        SET @codigo_atividade = 5
    END
GO;
DECLARE @out INT
EXEC sp_buscarAtividade 30.9, @out OUTPUT
PRINT @out

/*
Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:
 - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um
 novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas
 regras estabelecidas acima.
 - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se
 verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e
 as atividades pelas regras estabelecidas acima.
*/
CREATE PROCEDURE sp_alunoatividades(@cod_aluno INT,
    @nome VARCHAR(100),
    @altura DECIMAL(3,2),
    @peso DECIMAL(5,2),
    @res VARCHAR(MAX) OUTPUT)
AS
DECLARE @imc DECIMAL(3,1)
DECLARE @codigo_atividade INT
SET @imc = @peso / POWER(@altura,2)

EXEC sp_buscarAtividade @imc, @codigo_atividade OUTPUT

IF(@cod_aluno = 0)
BEGIN
	INSERT INTO aluno VALUES
	(@nome)

	SET @cod_aluno =  SCOPE_IDENTITY()

	INSERT INTO atividadesaluno VALUES
	(@cod_aluno, @altura, @peso, @imc, @codigo_atividade)

	SET @res = 'Aluno cadastrado com sucesso!'
END
ELSE
BEGIN
	UPDATE atividadesaluno
	SET altura = @altura, peso = @peso, imc = @imc, atividade = @codigo_atividade
	WHERE codigo_aluno = @cod_aluno

	SET @res = 'Aluno atualizado com sucesso!'
END
GO;

DECLARE @out VARCHAR(MAX)
EXEC sp_alunoatividades 0, 'Victor Neves', 1.75 , 55, @out OUTPUT
PRINT @out

SELECT al.nome, atA.altura, ata.peso, atA.imc, at.descricao AS 'Atividade_sugerida' FROM aluno al
INNER JOIN atividadesAluno atA
ON al.codigo_aluno = atA.codigo_aluno
INNER JOIN atividade at
On at.codigo = atA.atividade