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

INSERT INTO pais VALUES
	('AFG','Afeganistão'),
	('ALB','Albânia'),
	('ALG','Argélia'),
	('AND','Andorra'),
	('ANG','Angola'),
	('ANT','Antígua e Barbuda'),
	('ASA','Samoa Americana'),
	('ARG','Argentina'),
	('ARM','Armênia'),
	('ARU','Aruba'),
	('AUS','Austrália'),
	('AUT','Áustria'),
	('AZE','Azerbaijão'),
	('BAH','Bahamas'),
	('BAN','Bangladesh'),
	('BAR','Barbados'),
	('BDI','Burundi'),
	('BEL','Bélgica'),
	('BEN','Benim'),
	('BER','Bermudas'),
	('BHU','Butão'),
	('BIH','Bósnia e Herzegovina'),
	('BIZ','Belize'),
	('BLR','Bielorrússia'),
	('BOL','Bolívia'),
	('BOT','Botswana'),
	('BRA','Brasil'),
	('BRN','Bahrein'),
	('BRU','Brunei'),
	('BUL','Bulgária'),
	('BUR','Burkina Faso'),
	('CAF','República Centro-Africana'),
	('CAM','Camboja'),
	('CAN','Canadá'),
	('CAY','Ilhas Cayman'),
	('CGO','República do Congo'),
	('CHA','Chade'),
	('CHI','Chile'),
	('CHN','China'),
	('CIV','Costa do Marfim'),
	('CMR','Camarões'),
	('COD','República Democrática do Congo'),
	('COK','Ilhas Cook'),
	('COL','Colômbia'),
	('COM','Comores'),
	('CPV','Cabo Verde'),
	('CRC','Costa Rica'),
	('CRO','Croácia'),
	('CUB','Cuba'),
	('CYP','Chipre'),
	('CZE','Chéquia'),
	('DEN','Dinamarca'),
	('DJI','Djibouti'),
	('DMA','Dominica'),
	('DOM','República Dominicana'),
	('ECU','Equador'),
	('EGY','Egito'),
	('ERI','Eritreia'),
	('ESA','El Salvador'),
	('ESP','Espanha'),
	('EST','Estónia'),
	('ETH','Etiópia'),
	('FIJ','Fiji'),
	('FIN','Finlândia'),
	('FRA','França'),
	('FSM','Estados Federados da Micronésia'),
	('GAB','Gabão'),
	('GAM','Gâmbia'),
	('GBR','Reino Unido'),
	('GBS','Guiné-Bissau'),
	('GEO','Geórgia'),
	('GEQ','Guiné Equatorial'),
	('GER','Alemanha'),
	('GHA','Gana'),
	('GRE','Grécia'),
	('GRN','Granada'),
	('GUA','Guatemala'),
	('GUI','Guiné'),
	('GUM','Guam'),
	('GUY','Guiana'),
	('HAI','Haiti'),
	('HKG','Hong Kong'),
	('HON','Honduras'),
	('HUN','Hungria'),
	('INA','Indonésia'),
	('IND','Índia'),
	('IRI','Irã'),
	('IRL','Irlanda'),
	('IRQ','Iraque'),
	('ISL','Islândia'),
	('ISR','Israel'),
	('ISV','Ilhas Virgens Americanas'),
	('ITA','Itália'),
	('IVB','Ilhas Virgens Britânicas'),
	('JAM','Jamaica'),
	('JOR','Jordânia'),
	('JPN','Japão'),
	('KAZ','Cazaquistão'),
	('KEN','Quênia'),
	('KGZ','Quirguistão'),
	('KIR','Kiribati'),
	('KOR','Coreia do Sul'),
	('KOS','Kosovo'),
	('KSA','Arábia Saudita'),
	('KUW','Kuwait'),
	('LAO','Laos'),
	('LAT','Letônia'),
	('LBA','Líbia'),
	('LBR','Libéria'),
	('LCA','Santa Lúcia'),
	('LES','Lesoto'),
	('LBN','Líbano'),
	('LIE','Liechtenstein'),
	('LTU','Lituânia'),
	('LUX','Luxemburgo'),
	('MAD','Madagáscar'),
	('MAR','Marrocos'),
	('MAS','Malásia'),
	('MAW','Malawi'),
	('MDA','Moldávia'),
	('MDV','Maldivas'),
	('MEX','México'),
	('MGL','Mongólia'),
	('MHL','Ilhas Marshall'),
	('MKD','Macedônia do Norte'),
	('MLI','Mali'),
	('MLT','Malta'),
	('MNE','Montenegro'),
	('MON','Mónaco'),
	('MOZ','Moçambique'),
	('MRI','Maurícia'),
	('MTN','Mauritânia'),
	('MYA','Mianmar'),
	('NAM','Namíbia'),
	('NCA','Nicarágua'),
	('NED','Países Baixos'),
	('NEP','Nepal'),
	('NGR','Nigéria'),
	('NIG','Níger'),
	('NOR','Noruega'),
	('NRU','Nauru'),
	('NZL','Nova Zelândia'),
	('OMA','Omã'),
	('PAK','Paquistão'),
	('PAN','Panamá'),
	('PAR','Paraguai'),
	('PER','Peru'),
	('PHI','Filipinas'),
	('PLE','Palestina'),
	('PLW','Palau'),
	('PNG','Papua-Nova Guiné'),
	('POL','Polónia'),
	('POR','Portugal'),
	('PRK','Coreia do Norte'),
	('PUR','Porto Rico'),
	('QAT','Catar'),
	('ROU','Roménia'),
	('RSA','África do Sul'),
	('RUS','Rússia'),
	('RWA','Ruanda'),
	('SAM','Samoa'),
	('SEN','Senegal'),
	('SEY','Seicheles'),
	('SGP','Singapura'),
	('SKN','São Cristóvão e Névis'),
	('SLE','Serra Leoa'),
	('SLO','Eslovênia'),
	('SMR','San Marino'),
	('SOL','Ilhas Salomão'),
	('SOM','Somália'),
	('SRB','Sérvia'),
	('SRI','Sri Lanka'),
	('SSD','Sudão do Sul'),
	('STP','São Tomé e Príncipe'),
	('SUD','Sudão'),
	('SUI','Suíça'),
	('SUR','Suriname'),
	('SVK','Eslováquia'),
	('SWE','Suécia'),
	('SWZ','Essuatíni'),
	('SYR','Síria'),
	('TAN','Tanzânia'),
	('TGA','Tonga'),
	('THA','Tailândia'),
	('TJK','Tajiquistão'),
	('TKM','Turquemenistão'),
	('TLS','Timor-Leste'),
	('TOG','Togo'),
	('TPE','Taipé Chinesa (Taiwan)'),
	('TTO','Trinidad e Tobago'),
	('TUN','Tunísia'),
	('TUR','Turquia'),
	('TUV','Tuvalu'),
	('UAE','Emirados Árabes Unidos'),
	('UGA','Uganda'),
	('UKR','Ucrânia'),
	('URU','Uruguai'),
	('USA','Estados Unidos'),
	('UZB','Uzbequistão'),
	('VAN','Vanuatu'),
	('VEN','Venezuela'),
	('VIE','Vietnã'),
	('VIN','São Vicente e Granadinas'),
	('YEM','Iêmen'),
	('ZAM','Zâmbia'),
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
			THEN 'Distância' 
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
		RAISERROR('Limite máximo de saltos já foi realizado pelo atleta!', 16, 1)
	END
	ELSE 
	BEGIN
		IF @contagem > 0 AND @tipo = 1
		BEGIN
			RAISERROR('O atleta já realizou uma corrida nesta fase!', 16, 1)
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
		RAISERROR('O atleta não foi classificado para a fase final!', 16, 1)
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
		RAISERROR('O atleta não foi classificado para a fase final!', 16, 1)
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

-- Funções

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

DELETE FROM score
SELECT * FROM atleta 
SELECT * FROM prova

EXEC inserir_score 1, 200, 104, 4, 1
EXEC inserir_score 0, 100, 101, 2, 1
EXEC inserir_score 0, 100, 103, 3, 1
EXEC inserir_score 0, 100, 101, 9, 1
EXEC inserir_score 0, 120, 103, 2, 1


SELECT * FROM f_melhores(0, 1)

SELECT	* FROM	score