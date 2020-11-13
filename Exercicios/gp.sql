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
record_m	VARCHAR(10) NOT NULL,
record_e	VARCHAR(10) NOT NULL,
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

<<<<<<< HEAD
INSERT INTO prova(sexo, nome, tipo) VALUES
	(0, 'Lanï¿½amento de Dardo / Javelin Throw', 0),
	(1, 'Salto em Distï¿½ncia / Long Jump', 0),
	(1, 'Salto com Vara / Pole Vault', 0),
	(1, '400m com barreiras / 400m hurdles', 1),
	(0, '100m', 1),
	(0, 'Arremesso de Peso / Shot Put', 0),
	(1, '100m', 1),
	(1, '3000m', 1),
	(1, 'Lanï¿½amento de Disco / Discus Throw', 0),
	(0, '3000m com obstï¿½culos / 3000m steeplechase', 1),
	(0, 'Salto Triplo / Triple Jump', 0),
	(1, '400m', 1),
	(0, '800m', 1),
	(1, '800m', 1),
	(0, '200m', 1),
	(1, '200m', 1)
=======
INSERT INTO prova(sexo, nome, tipo, record_m, record_e) VALUES
	(0, 'Lançamento de Dardo / Javelin Throw', 0, '500', '400'),
	(1, 'Salto em Distância / Long Jump', 0, '700', '200'),
	(1, 'Salto com Vara / Pole Vault', 0, '958', '527'),
	(1, '400m com barreiras / 400m hurdles', 1, '00023200', '00031000'),
	(0, '100m', 1, '00045400', '00062800'),
	(0, 'Arremesso de Peso / Shot Put', 0, '70', '40'),
	(1, '100m', 1, '00002431', '00003422'),
	(1, '3000m', 1, '00144700' ,'00192500'),
	(1, 'Lançamento de Disco / Discus Throw', 0, '300', '200'),
	(0, '3000m com obstáculos / 3000m steeplechase', 1, '00175100', '00234000'),
	(0, 'Salto Triplo / Triple Jump', 0, '600', '200'),
	(1, '400m', 1, '00004303', '00005354'),
	(0, '800m', 1, '00014800', '00020100'),
	(1, '800m', 1, '00014500', '00024800'),
	(0, '200m', 1, '00003400', '00003700'),
	(1, '200m', 1, '00003700', '00004300')
>>>>>>> ebeb2afe0027ffc6158053cd581f3663d44d3688

INSERT INTO pais VALUES
	('AFG','Afeganistï¿½o'),
	('ALB','Albï¿½nia'),
	('ALG','Argï¿½lia'),
	('AND','Andorra'),
	('ANG','Angola'),
	('ANT','Antï¿½gua e Barbuda'),
	('ASA','Samoa Americana'),
	('ARG','Argentina'),
	('ARM','Armï¿½nia'),
	('ARU','Aruba'),
	('AUS','Austrï¿½lia'),
	('AUT','ï¿½ustria'),
	('AZE','Azerbaijï¿½o'),
	('BAH','Bahamas'),
	('BAN','Bangladesh'),
	('BAR','Barbados'),
	('BDI','Burundi'),
	('BEL','Bï¿½lgica'),
	('BEN','Benim'),
	('BER','Bermudas'),
	('BHU','Butï¿½o'),
	('BIH','Bï¿½snia e Herzegovina'),
	('BIZ','Belize'),
	('BLR','Bielorrï¿½ssia'),
	('BOL','Bolï¿½via'),
	('BOT','Botswana'),
	('BRA','Brasil'),
	('BRN','Bahrein'),
	('BRU','Brunei'),
	('BUL','Bulgï¿½ria'),
	('BUR','Burkina Faso'),
	('CAF','Repï¿½blica Centro-Africana'),
	('CAM','Camboja'),
	('CAN','Canadï¿½'),
	('CAY','Ilhas Cayman'),
	('CGO','Repï¿½blica do Congo'),
	('CHA','Chade'),
	('CHI','Chile'),
	('CHN','China'),
	('CIV','Costa do Marfim'),
	('CMR','Camarï¿½es'),
	('COD','Repï¿½blica Democrï¿½tica do Congo'),
	('COK','Ilhas Cook'),
	('COL','Colï¿½mbia'),
	('COM','Comores'),
	('CPV','Cabo Verde'),
	('CRC','Costa Rica'),
	('CRO','Croï¿½cia'),
	('CUB','Cuba'),
	('CYP','Chipre'),
	('CZE','Chï¿½quia'),
	('DEN','Dinamarca'),
	('DJI','Djibouti'),
	('DMA','Dominica'),
	('DOM','Repï¿½blica Dominicana'),
	('ECU','Equador'),
	('EGY','Egito'),
	('ERI','Eritreia'),
	('ESA','El Salvador'),
	('ESP','Espanha'),
	('EST','Estï¿½nia'),
	('ETH','Etiï¿½pia'),
	('FIJ','Fiji'),
	('FIN','Finlï¿½ndia'),
	('FRA','Franï¿½a'),
	('FSM','Estados Federados da Micronï¿½sia'),
	('GAB','Gabï¿½o'),
	('GAM','Gï¿½mbia'),
	('GBR','Reino Unido'),
	('GBS','Guinï¿½-Bissau'),
	('GEO','Geï¿½rgia'),
	('GEQ','Guinï¿½ Equatorial'),
	('GER','Alemanha'),
	('GHA','Gana'),
	('GRE','Grï¿½cia'),
	('GRN','Granada'),
	('GUA','Guatemala'),
	('GUI','Guinï¿½'),
	('GUM','Guam'),
	('GUY','Guiana'),
	('HAI','Haiti'),
	('HKG','Hong Kong'),
	('HON','Honduras'),
	('HUN','Hungria'),
	('INA','Indonï¿½sia'),
	('IND','ï¿½ndia'),
	('IRI','Irï¿½'),
	('IRL','Irlanda'),
	('IRQ','Iraque'),
	('ISL','Islï¿½ndia'),
	('ISR','Israel'),
	('ISV','Ilhas Virgens Americanas'),
	('ITA','Itï¿½lia'),
	('IVB','Ilhas Virgens Britï¿½nicas'),
	('JAM','Jamaica'),
	('JOR','Jordï¿½nia'),
	('JPN','Japï¿½o'),
	('KAZ','Cazaquistï¿½o'),
	('KEN','Quï¿½nia'),
	('KGZ','Quirguistï¿½o'),
	('KIR','Kiribati'),
	('KOR','Coreia do Sul'),
	('KOS','Kosovo'),
	('KSA','Arï¿½bia Saudita'),
	('KUW','Kuwait'),
	('LAO','Laos'),
	('LAT','Letï¿½nia'),
	('LBA','Lï¿½bia'),
	('LBR','Libï¿½ria'),
	('LCA','Santa Lï¿½cia'),
	('LES','Lesoto'),
	('LBN','Lï¿½bano'),
	('LIE','Liechtenstein'),
	('LTU','Lituï¿½nia'),
	('LUX','Luxemburgo'),
	('MAD','Madagï¿½scar'),
	('MAR','Marrocos'),
	('MAS','Malï¿½sia'),
	('MAW','Malawi'),
	('MDA','Moldï¿½via'),
	('MDV','Maldivas'),
	('MEX','Mï¿½xico'),
	('MGL','Mongï¿½lia'),
	('MHL','Ilhas Marshall'),
	('MKD','Macedï¿½nia do Norte'),
	('MLI','Mali'),
	('MLT','Malta'),
	('MNE','Montenegro'),
	('MON','Mï¿½naco'),
	('MOZ','Moï¿½ambique'),
	('MRI','Maurï¿½cia'),
	('MTN','Mauritï¿½nia'),
	('MYA','Mianmar'),
	('NAM','Namï¿½bia'),
	('NCA','Nicarï¿½gua'),
	('NED','Paï¿½ses Baixos'),
	('NEP','Nepal'),
	('NGR','Nigï¿½ria'),
	('NIG','Nï¿½ger'),
	('NOR','Noruega'),
	('NRU','Nauru'),
	('NZL','Nova Zelï¿½ndia'),
	('OMA','Omï¿½'),
	('PAK','Paquistï¿½o'),
	('PAN','Panamï¿½'),
	('PAR','Paraguai'),
	('PER','Peru'),
	('PHI','Filipinas'),
	('PLE','Palestina'),
	('PLW','Palau'),
	('PNG','Papua-Nova Guinï¿½'),
	('POL','Polï¿½nia'),
	('POR','Portugal'),
	('PRK','Coreia do Norte'),
	('PUR','Porto Rico'),
	('QAT','Catar'),
	('ROU','Romï¿½nia'),
	('RSA','ï¿½frica do Sul'),
	('RUS','Rï¿½ssia'),
	('RWA','Ruanda'),
	('SAM','Samoa'),
	('SEN','Senegal'),
	('SEY','Seicheles'),
	('SGP','Singapura'),
	('SKN','Sï¿½o Cristï¿½vï¿½o e Nï¿½vis'),
	('SLE','Serra Leoa'),
	('SLO','Eslovï¿½nia'),
	('SMR','San Marino'),
	('SOL','Ilhas Salomï¿½o'),
	('SOM','Somï¿½lia'),
	('SRB','Sï¿½rvia'),
	('SRI','Sri Lanka'),
	('SSD','Sudï¿½o do Sul'),
	('STP','Sï¿½o Tomï¿½ e Prï¿½ncipe'),
	('SUD','Sudï¿½o'),
	('SUI','Suï¿½ï¿½a'),
	('SUR','Suriname'),
	('SVK','Eslovï¿½quia'),
	('SWE','Suï¿½cia'),
	('SWZ','Essuatï¿½ni'),
	('SYR','Sï¿½ria'),
	('TAN','Tanzï¿½nia'),
	('TGA','Tonga'),
	('THA','Tailï¿½ndia'),
	('TJK','Tajiquistï¿½o'),
	('TKM','Turquemenistï¿½o'),
	('TLS','Timor-Leste'),
	('TOG','Togo'),
	('TPE','Taipï¿½ Chinesa (Taiwan)'),
	('TTO','Trinidad e Tobago'),
	('TUN','Tunï¿½sia'),
	('TUR','Turquia'),
	('TUV','Tuvalu'),
	('UAE','Emirados ï¿½rabes Unidos'),
	('UGA','Uganda'),
	('UKR','Ucrï¿½nia'),
	('URU','Uruguai'),
	('USA','Estados Unidos'),
	('UZB','Uzbequistï¿½o'),
	('VAN','Vanuatu'),
	('VEN','Venezuela'),
	('VIE','Vietnï¿½'),
	('VIN','Sï¿½o Vicente e Granadinas'),
	('YEM','Iï¿½men'),
	('ZAM','Zï¿½mbia'),
	('ZIM','Zimbabwe'),
	('MIX','Equipes internacionais')

INSERT INTO atleta VALUES
	('Fernanda Silveira', 0, 'BRA'),
	('Adam Johanness', 1, 'USA'),
	('Nikki Hamblin', 0, 'NZL'),
	('June Esser', 1, 'NZL'),
	('Vitor Snows', 1, 'BRA'),
	('Laurel Lance', 0, 'RUS'),	
	('Oliver Queen', 1, 'CAN'),
	('John Diggle', 1 , 'EGY'),
	('Felicity Smoak', 0, 'BRA'),
	('Curtis Holt', 1, 'POR'),
	('Rene Ramirez', 1, 'PAN'),
	('Dinah Drake', 0, 'FRA'),
	('Roy Harper', 1, 'DOM'),
	('Rory Reagan', 1, 'DEN'),
	('Sara Lance', 0, 'POL'),
	('Ray Palmer', 1, 'PNG'),
	('Mick Rory', 1, 'PLE'),
	('Nate Heywood', 1, 'PUR'),
	('Ava Sharpe', 0, 'NAM'),
	('Barry Allen', 1, 'MEX'),
	('Caitlin Snow', 0, 'LBN'),
	('Cisco Ramon', 1, 'KOR'),
	('Cynthia Reynolds', 0, 'IRI'),
	('Ralph Dibny', 1, 'JPN'),
	('Iris West', 0, 'IRL'),
	('Wally West', 1, 'CHN'),
	('Kara Danvers', 0, 'AFG'),
	('Alex Danvers', 0, 'EGY'),
	('Winn Scott', 1, 'FRA'),
	('Nia Nal', 0, 'VIE'),
	('John Johns', 1, 'ZIM'),
	('Querl Dox', 1, 'UAE'),
	('Jimmy Olsen', 1, 'THA'),
	('Nora Allen', 0, 'SRI'),
	('Mia Smoak', 0 , 'BRA'),
	('Wiliam Clayton', 1, 'NED'),
	('Connor Hawke', 1, 'LUX'),
	('Zoe Ramirez', 0, 'MAD'),
	('Maurilio Moura', 1, 'BAH'),
	('Peter Heinrich', 1, 'IRL')

-- Queries

-- Visualizar todas as provas
SELECT	id,
		nome,
		CASE WHEN (tipo = 0) 
			THEN 'Distï¿½ncia' 
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
		RAISERROR('Limite mï¿½ximo de saltos jï¿½ foi realizado pelo atleta!', 16, 1)
	END
	ELSE 
	BEGIN
		IF @contagem > 0 AND @tipo = 1
		BEGIN
			RAISERROR('O atleta jï¿½ realizou uma corrida nesta fase!', 16, 1)
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
		RAISERROR('O atleta nï¿½o foi classificado para a fase final!', 16, 1)
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
		RAISERROR('O atleta nï¿½o foi classificado para a fase final!', 16, 1)
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

-- Funï¿½ï¿½es

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