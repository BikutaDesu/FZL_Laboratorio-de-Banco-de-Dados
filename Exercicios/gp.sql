USE MASTER
DROP DATABASE gp

CREATE DATABASE gp

USE gp


-- Tabelas

CREATE TABLE pais(
coi		CHAR(3) PRIMARY KEY,
nome	VARCHAR(50) NOT NULL
)

CREATE TABLE atleta(
id		INT IDENTITY(100,1) PRIMARY KEY,
nome	VARCHAR(30) NOT NULL,
sexo	BIT NOT NULL, -- 0 = f, 1 = m
coi		CHAR(3) NOT NULL,
FOREIGN KEY (coi) REFERENCES pais(coi)
)

CREATE TABLE prova(
id			INT IDENTITY(1,1),
sexo		BIT NOT NULL, --0 = f, 1 = m
nome		VARCHAR(60) NOT NULL,
tipo		BIT NOT NULL, --0 = metros, 1 = HH:mm:ss:ddd
record_m	VARCHAR(10),
record_e	VARCHAR(10),
ouro		INT,
prata		INT,
bronze		INT
PRIMARY KEY (id, sexo)
)

CREATE TABLE score(
id		INT IDENTITY(1000,1) PRIMARY KEY,
fase	BIT NOT NULL, --0 = inicial, 1 = final
score	VARCHAR(10),
atleta	INT NOT NULL,
prova	INT NOT NULL,
sexo	BIT NOT NULL, --0 = f, 1 = m
FOREIGN KEY (atleta) REFERENCES atleta(id),
FOREIGN KEY (prova, sexo) REFERENCES prova(id, sexo)
)

-- Registros de Exemplo

INSERT INTO prova(sexo, nome, tipo) VALUES
	(0, 'Lan�amento de Dardo / Javelin Throw', 0),
	(1, 'Salto em Dist�ncia / Long Jump', 0),
	(1, 'Salto com Vara / Pole Vault', 0),
	(1, '400m com barreiras / 400m hurdles', 1),
	(0, '100m', 1),
	(0, 'Arremesso de Peso / Shot Put', 0),
	(1, '100m', 1),
	(1, '3000m', 1),
	(1, 'Lan�amento de Disco / Discus Throw', 0),
	(0, '3000m com obst�culos / 3000m steeplechase', 1),
	(0, 'Salto Triplo / Triple Jump', 0),
	(1, '400m', 1),
	(0, '800m', 1),
	(1, '800m', 1),
	(0, '200m', 1),
	(1, '200m', 1)

INSERT INTO pais VALUES
	('AFG','Afeganist�o'),
	('ALB','Alb�nia'),
	('ALG','Arg�lia'),
	('AND','Andorra'),
	('ANG','Angola'),
	('ANT','Ant�gua e Barbuda'),
	('ASA','Samoa Americana'),
	('ARG','Argentina'),
	('ARM','Arm�nia'),
	('ARU','Aruba'),
	('AUS','Austr�lia'),
	('AUT','�ustria'),
	('AZE','Azerbaij�o'),
	('BAH','Bahamas'),
	('BAN','Bangladesh'),
	('BAR','Barbados'),
	('BDI','Burundi'),
	('BEL','B�lgica'),
	('BEN','Benim'),
	('BER','Bermudas'),
	('BHU','But�o'),
	('BIH','B�snia e Herzegovina'),
	('BIZ','Belize'),
	('BLR','Bielorr�ssia'),
	('BOL','Bol�via'),
	('BOT','Botswana'),
	('BRA','Brasil'),
	('BRN','Bahrein'),
	('BRU','Brunei'),
	('BUL','Bulg�ria'),
	('BUR','Burkina Faso'),
	('CAF','Rep�blica Centro-Africana'),
	('CAM','Camboja'),
	('CAN','Canad�'),
	('CAY','Ilhas Cayman'),
	('CGO','Rep�blica do Congo'),
	('CHA','Chade'),
	('CHI','Chile'),
	('CHN','China'),
	('CIV','Costa do Marfim'),
	('CMR','Camar�es'),
	('COD','Rep�blica Democr�tica do Congo'),
	('COK','Ilhas Cook'),
	('COL','Col�mbia'),
	('COM','Comores'),
	('CPV','Cabo Verde'),
	('CRC','Costa Rica'),
	('CRO','Cro�cia'),
	('CUB','Cuba'),
	('CYP','Chipre'),
	('CZE','Ch�quia'),
	('DEN','Dinamarca'),
	('DJI','Djibouti'),
	('DMA','Dominica'),
	('DOM','Rep�blica Dominicana'),
	('ECU','Equador'),
	('EGY','Egito'),
	('ERI','Eritreia'),
	('ESA','El Salvador'),
	('ESP','Espanha'),
	('EST','Est�nia'),
	('ETH','Eti�pia'),
	('FIJ','Fiji'),
	('FIN','Finl�ndia'),
	('FRA','Fran�a'),
	('FSM','Estados Federados da Micron�sia'),
	('GAB','Gab�o'),
	('GAM','G�mbia'),
	('GBR','Reino Unido'),
	('GBS','Guin�-Bissau'),
	('GEO','Ge�rgia'),
	('GEQ','Guin� Equatorial'),
	('GER','Alemanha'),
	('GHA','Gana'),
	('GRE','Gr�cia'),
	('GRN','Granada'),
	('GUA','Guatemala'),
	('GUI','Guin�'),
	('GUM','Guam'),
	('GUY','Guiana'),
	('HAI','Haiti'),
	('HKG','Hong Kong'),
	('HON','Honduras'),
	('HUN','Hungria'),
	('INA','Indon�sia'),
	('IND','�ndia'),
	('IRI','Ir�'),
	('IRL','Irlanda'),
	('IRQ','Iraque'),
	('ISL','Isl�ndia'),
	('ISR','Israel'),
	('ISV','Ilhas Virgens Americanas'),
	('ITA','It�lia'),
	('IVB','Ilhas Virgens Brit�nicas'),
	('JAM','Jamaica'),
	('JOR','Jord�nia'),
	('JPN','Jap�o'),
	('KAZ','Cazaquist�o'),
	('KEN','Qu�nia'),
	('KGZ','Quirguist�o'),
	('KIR','Kiribati'),
	('KOR','Coreia do Sul'),
	('KOS','Kosovo'),
	('KSA','Ar�bia Saudita'),
	('KUW','Kuwait'),
	('LAO','Laos'),
	('LAT','Let�nia'),
	('LBA','L�bia'),
	('LBR','Lib�ria'),
	('LCA','Santa L�cia'),
	('LES','Lesoto'),
	('LBN','L�bano'),
	('LIE','Liechtenstein'),
	('LTU','Litu�nia'),
	('LUX','Luxemburgo'),
	('MAD','Madag�scar'),
	('MAR','Marrocos'),
	('MAS','Mal�sia'),
	('MAW','Malawi'),
	('MDA','Mold�via'),
	('MDV','Maldivas'),
	('MEX','M�xico'),
	('MGL','Mong�lia'),
	('MHL','Ilhas Marshall'),
	('MKD','Maced�nia do Norte'),
	('MLI','Mali'),
	('MLT','Malta'),
	('MNE','Montenegro'),
	('MON','M�naco'),
	('MOZ','Mo�ambique'),
	('MRI','Maur�cia'),
	('MTN','Maurit�nia'),
	('MYA','Mianmar'),
	('NAM','Nam�bia'),
	('NCA','Nicar�gua'),
	('NED','Pa�ses Baixos'),
	('NEP','Nepal'),
	('NGR','Nig�ria'),
	('NIG','N�ger'),
	('NOR','Noruega'),
	('NRU','Nauru'),
	('NZL','Nova Zel�ndia'),
	('OMA','Om�'),
	('PAK','Paquist�o'),
	('PAN','Panam�'),
	('PAR','Paraguai'),
	('PER','Peru'),
	('PHI','Filipinas'),
	('PLE','Palestina'),
	('PLW','Palau'),
	('PNG','Papua-Nova Guin�'),
	('POL','Pol�nia'),
	('POR','Portugal'),
	('PRK','Coreia do Norte'),
	('PUR','Porto Rico'),
	('QAT','Catar'),
	('ROU','Rom�nia'),
	('RSA','�frica do Sul'),
	('RUS','R�ssia'),
	('RWA','Ruanda'),
	('SAM','Samoa'),
	('SEN','Senegal'),
	('SEY','Seicheles'),
	('SGP','Singapura'),
	('SKN','S�o Crist�v�o e N�vis'),
	('SLE','Serra Leoa'),
	('SLO','Eslov�nia'),
	('SMR','San Marino'),
	('SOL','Ilhas Salom�o'),
	('SOM','Som�lia'),
	('SRB','S�rvia'),
	('SRI','Sri Lanka'),
	('SSD','Sud�o do Sul'),
	('STP','S�o Tom� e Pr�ncipe'),
	('SUD','Sud�o'),
	('SUI','Su��a'),
	('SUR','Suriname'),
	('SVK','Eslov�quia'),
	('SWE','Su�cia'),
	('SWZ','Essuat�ni'),
	('SYR','S�ria'),
	('TAN','Tanz�nia'),
	('TGA','Tonga'),
	('THA','Tail�ndia'),
	('TJK','Tajiquist�o'),
	('TKM','Turquemenist�o'),
	('TLS','Timor-Leste'),
	('TOG','Togo'),
	('TPE','Taip� Chinesa (Taiwan)'),
	('TTO','Trinidad e Tobago'),
	('TUN','Tun�sia'),
	('TUR','Turquia'),
	('TUV','Tuvalu'),
	('UAE','Emirados �rabes Unidos'),
	('UGA','Uganda'),
	('UKR','Ucr�nia'),
	('URU','Uruguai'),
	('USA','Estados Unidos'),
	('UZB','Uzbequist�o'),
	('VAN','Vanuatu'),
	('VEN','Venezuela'),
	('VIE','Vietn�'),
	('VIN','S�o Vicente e Granadinas'),
	('YEM','I�men'),
	('ZAM','Z�mbia'),
	('ZIM','Zimbabwe'),
	('MIX','Equipes internacionais')

INSERT INTO atleta VALUES
	('Fernanda Silveira', 0, 'BRA'),
	('Adam Johanness', 1, 'USA'),
	('Nikki Hamblin', 0, 'NZL'),
	('June Esser', 1, 'NZL'),
	('Victor Snows', 1, 'BRA')	

-- Queries

-- Visualizar todas as provas
SELECT	id,
		nome,
		CASE WHEN (tipo = 0) 
			THEN 'Dist�ncia' 
			ELSE 'Tempo'
			END AS tipo,
		CASE WHEN (sexo = 0) 
			THEN 'Feminino' 
			ELSE 'Masculino'
			END AS sexo
FROM	prova

-- Final de ciclo

-- Insert Procedures

CREATE TRIGGER t_inserir_atleta ON atleta FOR INSERT
AS
BEGIN
	DECLARE @coi CHAR(3)
	SET @coi = (SELECT coi FROM inserted)
	IF @coi NOT IN (SELECT coi FROM pais) 
	BEGIN 
		RAISERROR('COI invalido ou nao-cadastrado', 16, 1) 
		ROLLBACK TRANSACTION
	END
END
GO

CREATE PROCEDURE inserir_score (@fase BIT, @score VARCHAR(10), @atleta INT, @prova INT, @sexo BIT)
AS
BEGIN
	DECLARE @contagem INT, @tipo BIT
	SET @contagem = dbo.f_contar_baterias (@fase, @atleta, @prova)
	SET @tipo =(SELECT tipo FROM prova WHERE id = @prova)

	IF @contagem > 5 AND @tipo = 0
	BEGIN
		RAISERROR('Limite m�ximo de saltos j� foi realizado pelo atleta!', 16, 1)
	END
	ELSE 
	BEGIN
		IF @contagem > 0 AND @tipo = 1
		BEGIN
			RAISERROR('O atleta j� realizou uma corrida nesta fase!', 16, 1)
		END
		ELSE 
		BEGIN
			INSERT INTO score VALUES (@fase, @score, @atleta, @prova, @sexo)
		END
	END
END

CREATE TRIGGER t_inserir_score_before ON score FOR INSERT
AS
BEGIN
	DECLARE @prova INT, @fase BIT, @tipo BIT, @atleta INT, @provas_totais INT, @sexo BIT
	SET @prova = (SELECT prova  FROM inserted)
	SET @fase = (SELECT fase FROM inserted)
	SET @tipo = (SELECT tipo FROM prova WHERE id = @prova)
	SET @atleta = (SELECT atleta FROM inserted)
	SET @provas_totais = dbo.f_contar_baterias (@fase, @atleta, @prova)
	SET @sexo = (SELECT sexo FROM inserted)


	IF @fase = 1 AND @tipo = 0 AND @atleta NOT IN (SELECT atleta_id FROM dbo.f_melhores(0, @prova))
	BEGIN
		RAISERROR('O atleta n�o foi classificado para a fase final!', 16, 1)
		ROLLBACK TRANSACTION
	END
	IF @provas_totais < 6 AND @tipo = 0 AND @fase = 1
	BEGIN
		DECLARE @contador INT
		SET @contador = 6 - @provas_totais
		WHILE  @contador > 1
		BEGIN 
			EXEC inserir_score 0, NULL, @atleta, @prova, @sexo 
			SET @contador = @contador -1
		END
	END

	IF @fase = 1 AND @tipo = 1 AND @atleta NOT IN (SELECT atleta_id FROM dbo.f_melhores(0, @prova))
	BEGIN
		RAISERROR('O atleta n�o foi classificado para a fase final!', 16, 1)
		ROLLBACK TRANSACTION
	END
END
GO

CREATE TRIGGER t_inserir_score_after ON score AFTER INSERT
AS
BEGIN
	DECLARE @prova INT, @tipo BIT, @score VARCHAR(10), @id INT
	SET @prova = (SELECT prova  FROM inserted)
	SET @tipo = (SELECT tipo FROM prova WHERE id = @prova)
	SET @score = (SELECT score FROM inserted)
	SET @id = (SELECT id FROM inserted)

	IF @tipo = 0 AND @score IS NULL
	BEGIN
		UPDATE score SET score = 'FAULT' WHERE  id = @id
	END
	ELSE 
	BEGIN
		IF @tipo = 1 AND @score IS NULL
		BEGIN
			UPDATE score SET score = 'DNF' WHERE  id = @id
		END
	END
END
GO

-- Fun��es

CREATE FUNCTION f_contar_baterias (@fase BIT, @atleta INT, @prova INT)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(score) FROM score WHERE prova = @prova AND atleta = @atleta AND fase = @fase)
END
GO

CREATE FUNCTION f_melhores (@fase BIT, @prova INT)
RETURNS @melhores TABLE (
prova VARCHAR(60),
atleta_id INT,
atleta VARCHAR(30),
score VARCHAR(10),
pais VARCHAR(50)
)
AS
BEGIN
	DECLARE @quantidade INT
	SET @quantidade = 8
	IF @fase = 1
	BEGIN
		SET @quantidade = 3
	END

    INSERT INTO @melhores
        SELECT TOP (@quantidade) p.nome,
		a.id,
       a.nome,
       MAX(s.score) AS score,
       pa.nome
    FROM    prova p
    INNER JOIN score s
    ON s.prova = p.id
    INNER JOIN atleta a
    ON a.id = s.atleta
    INNER JOIN pais pa
    ON pa.coi = a.coi
    WHERE   s.prova = @prova AND
            s.fase = @fase AND
            s.score != 'FAULT' AND
            s.score != 'DNF'
    GROUP BY a.id, p.nome, a.nome, pa.nome
    ORDER BY score ASC

	RETURN
END
GO

-- DISCARD LATER 

SELECT * FROM atleta 
SELECT * FROM prova

EXEC inserir_score 1, 200, 102, 17, 0
EXEC inserir_score 1, 200, 100, 17, 0
EXEC inserir_score 0, 200, 100, 17, 0
EXEC inserir_score 0, 200, 100, 17, 0
EXEC inserir_score 0, 200, 100, 17, 0


SELECT * FROM f_melhores(0, 17)

select * from score

SELECT	* FROM	score