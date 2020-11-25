-- BANCO E TABELAS
CREATE DATABASE campeonatobasquete
GO
USE campeonatobasquete

CREATE TABLE times (
	id INT NOT NULL IDENTITY(4001, 1),
	nome VARCHAR(50) NOT NULL UNIQUE,
	cidade VARCHAR(80) NOT NULL
	PRIMARY KEY (id)
)

CREATE TABLE jogadores (
	id INT NOT NULL IDENTITY(900101,1),
	nome VARCHAR(60) NOT NULL UNIQUE,
	sexo CHAR(1) NULL DEFAULT('M') CHECK (sexo='M' OR sexo = 'F'),
	altura DECIMAL(7,2) NOT NULL,
	dt_nasc DATETIME NOT NULL CHECK(dt_nasc < '01/01/2000'),
	id_time INT NOT NULL
	PRIMARY KEY(id)
	FOREIGN KEY (id_time) REFERENCES times(id),
	CONSTRAINT chk_sx_alt
		CHECK ((sexo = 'M' AND altura >= 1.70) OR 
				(sexo = 'F' AND altura >= 1.60))
)

-- PROCEDURES
CREATE PROCEDURE sp_crud_times(@cod CHAR(1), @id INT, 
	@nome VARCHAR(50), @cidade VARCHAR(80), @saida VARCHAR(MAX) OUTPUT)
AS
	IF (UPPER(@cod) = 'I' OR UPPER(@cod) = 'U' OR UPPER(@cod) = 'D')
	BEGIN
		IF (UPPER(@cod) = 'I')
		BEGIN 
			INSERT INTO times (nome, cidade)
			VALUES (@nome, @cidade)

			SET @saida = 'Time inserido com sucesso!'
		END
		IF (UPPER(@cod) = 'U')
		BEGIN 
			UPDATE times
			SET nome = @nome, cidade = @cidade
			WHERE id = @id

			SET @saida = 'Time atualizado com sucesso!'
		END
		IF (UPPER(@cod) = 'D')
		BEGIN 
			DELETE times
			WHERE id = @id

			SET @saida = 'Time removido com sucesso!'
		END
	END
	ELSE
	BEGIN
		RAISERROR('Operação inválida', 16, 1)
	END

-- FUNCTIONS
CREATE FUNCTION fn_tbl_jogador_idade (@id INT)
RETURNS @tabela TABLE (
	id			INT,
	nome		VARCHAR(60),
	sexo		CHAR(1),
	altura		DECIMAL(7,2),
	dt_nasc		CHAR(10),
	idade		INT,
	id_time		INT,
	nome_time	VARCHAR(50),
	cidade		VARCHAR(80)
)
AS
BEGIN
	DECLARE @dt_nasc	DATE,
			@idade		INT
	
	INSERT INTO @tabela (id, nome, sexo, altura, dt_nasc, id_time, nome_time, cidade)
	SELECT j.id, j.nome, j.sexo, j.altura, 
		CONVERT(CHAR(10), j.dt_nasc, 103) AS dt_nasc, 
		t.id as id_time, t.nome, t.cidade FROM jogadores j
	INNER JOIN times t
	ON j.id_time = t.id
	WHERE j.id = @id

	SET @dt_nasc = (SELECT dt_nasc FROM jogadores WHERE id = @id)
	SET @idade = (SELECT DATEDIFF(DD, @dt_nasc, GETDATE()) / 365)

	UPDATE @tabela
	SET idade = @idade

	RETURN 
END

-- TESTES
DECLARE @out VARCHAR(MAX)
EXEC sp_crud_times 'I', NULL, 'Bulls', 'Anápolis', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_crud_times 'I', NULL, 'Bills', 'Tatuí', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_crud_times 'U', 4002, 'Bills', 'Boituva', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_crud_times 'I', NULL, 'Thunders', 'Avaré', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_crud_times 'D', 4003, NULL, NULL, @out OUTPUT
PRINT @out

INSERT INTO jogadores(nome, sexo, altura, dt_nasc, id_time)
VALUES 
('Fulano', 'M', 1.80, '02/04/1993', 4001)

SELECT j.id as id_jogador, j.nome, j.sexo, j.altura, 
		CONVERT(CHAR(10), j.dt_nasc, 103) AS dt_nasc, 
		j.id_time as fk_id_time, t.id as id_time, t.nome, 
		t.cidade FROM jogadores j
	INNER JOIN times t
	ON j.id_time = t.id
	WHERE j.id = 900101

SELECT j.id as id_jogador, j.nome, j.sexo, j.altura, 
		CONVERT(CHAR(10), j.dt_nasc, 103) AS dt_nasc, 
		j.id_time as fk_id_time, t.id as id_time, t.nome, 
		t.cidade FROM jogadores j
	INNER JOIN times t
	ON j.id_time = t.id

SELECT * FROM fn_tbl_jogador_idade(900101)