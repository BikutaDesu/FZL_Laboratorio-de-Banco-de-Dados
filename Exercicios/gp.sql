USE MASTER
DROP DATABASE gp

CREATE DATABASE gp

USE gp

-- Tables

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



-- Insert Procedures
--DROP PROCEDURE t_inserir_score
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
GO

-- Insert Triggers
--DROP TRIGGER t_inserir_atleta
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

--DROP TRIGGER t_inserir_score_before
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

--DROP TRIGGER t_inserir_score_after
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

-- Functions
--DROP FUNCTION f_contar_baterias
CREATE FUNCTION f_contar_baterias (@fase BIT, @atleta INT, @prova INT)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(score) FROM score WHERE prova = @prova AND atleta = @atleta AND fase = @fase)
END
GO

--DROP FUNCTION f_melhores
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

-- Registries/populating

--DELETE FROM prova
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
GO

--DELETE FROM pais
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
GO

--DELETE FROM atleta
INSERT INTO dbo.atleta(nome, sexo, coi) VALUES
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
GO

--DROP PROCEDURE popular_score
CREATE PROCEDURE popular_score (@fase INT)
AS
BEGIN
	 EXEC inserir_score @fase, '749', 107, 1, 0
	 EXEC inserir_score @fase, '00043442', 107, 5, 0
	 EXEC inserir_score @fase, '490', 107, 6, 0
	 EXEC inserir_score @fase, '00412142', 107, 10, 0
	 EXEC inserir_score @fase, '33', 107, 11, 0
	 EXEC inserir_score @fase, '00112134', 107, 13, 0
	 EXEC inserir_score @fase, '00221203', 107, 15, 0
	 EXEC inserir_score @fase, '121', 108, 2, 1
	 EXEC inserir_score @fase, '603', 108, 3, 1
	 EXEC inserir_score @fase, '00202134', 108, 4, 1
	 EXEC inserir_score @fase, '00442130', 108, 7, 1
	 EXEC inserir_score @fase, '00134312', 108, 8, 1
	 EXEC inserir_score @fase, '139', 108, 9, 1
	 EXEC inserir_score @fase, '00402411', 108, 12, 1
	 EXEC inserir_score @fase, '00342103', 108, 14, 1
	 EXEC inserir_score @fase, '00304020', 108, 16, 1
	 EXEC inserir_score @fase, '481', 109, 1, 0
	 EXEC inserir_score @fase, '00002110', 109, 5, 0
	 EXEC inserir_score @fase, '493', 109, 6, 0
	 EXEC inserir_score @fase, '00102342', 109, 10, 0
	 EXEC inserir_score @fase, '480', 109, 11, 0
	 EXEC inserir_score @fase, '00000404', 109, 13, 0
	 EXEC inserir_score @fase, '00324022', 109, 15, 0
	 EXEC inserir_score @fase, '152', 110, 2, 1
	 EXEC inserir_score @fase, '128', 110, 3, 1
	 EXEC inserir_score @fase, '00030214', 110, 4, 1
	 EXEC inserir_score @fase, '00422042', 110, 7, 1
	 EXEC inserir_score @fase, '00304313', 110, 8, 1
	 EXEC inserir_score @fase, '186', 110, 9, 1
	 EXEC inserir_score @fase, '00321413', 110, 12, 1
	 EXEC inserir_score @fase, '00424144', 110, 14, 1
	 EXEC inserir_score @fase, '00424004', 110, 16, 1
	 EXEC inserir_score @fase, '883', 111, 2, 1
	 EXEC inserir_score @fase, '358', 111, 3, 1
	 EXEC inserir_score @fase, '00231341', 111, 4, 1
	 EXEC inserir_score @fase, '00432141', 111, 7, 1
	 EXEC inserir_score @fase, '00210213', 111, 8, 1
	 EXEC inserir_score @fase, '581', 111, 9, 1
	 EXEC inserir_score @fase, '00241032', 111, 12, 1
	 EXEC inserir_score @fase, '00331442', 111, 14, 1
	 EXEC inserir_score @fase, '00402132', 111, 16, 1
	 EXEC inserir_score @fase, '691', 112, 1, 0
	 EXEC inserir_score @fase, '00343230', 112, 5, 0
	 EXEC inserir_score @fase, '762', 112, 6, 0
	 EXEC inserir_score @fase, '00202422', 112, 10, 0
	 EXEC inserir_score @fase, '201', 112, 11, 0
	 EXEC inserir_score @fase, '00330004', 112, 13, 0
	 EXEC inserir_score @fase, '00300102', 112, 15, 0
	 EXEC inserir_score @fase, '820', 113, 2, 1
	 EXEC inserir_score @fase, '991', 113, 3, 1
	 EXEC inserir_score @fase, '00032444', 113, 4, 1
	 EXEC inserir_score @fase, '00310224', 113, 7, 1
	 EXEC inserir_score @fase, '00002134', 113, 8, 1
	 EXEC inserir_score @fase, '591', 113, 9, 1
	 EXEC inserir_score @fase, '00031324', 113, 12, 1
	 EXEC inserir_score @fase, '00310121', 113, 14, 1
	 EXEC inserir_score @fase, '00212302', 113, 16, 1
	 EXEC inserir_score @fase, '429', 114, 2, 1
	 EXEC inserir_score @fase, '382', 114, 3, 1
	 EXEC inserir_score @fase, '00223223', 114, 4, 1
	 EXEC inserir_score @fase, '00234310', 114, 7, 1
	 EXEC inserir_score @fase, '00141342', 114, 8, 1
	 EXEC inserir_score @fase, '457', 114, 9, 1
	 EXEC inserir_score @fase, '00200134', 114, 12, 1
	 EXEC inserir_score @fase, '00431041', 114, 14, 1
	 EXEC inserir_score @fase, '00033202', 114, 16, 1
	 EXEC inserir_score @fase, '408', 115, 1, 0
	 EXEC inserir_score @fase, '00432342', 115, 5, 0
	 EXEC inserir_score @fase, '967', 115, 6, 0
	 EXEC inserir_score @fase, '00014114', 115, 10, 0
	 EXEC inserir_score @fase, '116', 115, 11, 0
	 EXEC inserir_score @fase, '00233004', 115, 13, 0
	 EXEC inserir_score @fase, '00331434', 115, 15, 0
	 EXEC inserir_score @fase, '108', 116, 2, 1
	 EXEC inserir_score @fase, '598', 116, 3, 1
	 EXEC inserir_score @fase, '00402444', 116, 4, 1
	 EXEC inserir_score @fase, '00144342', 116, 7, 1
	 EXEC inserir_score @fase, '00201422', 116, 8, 1
	 EXEC inserir_score @fase, '656', 116, 9, 1
	 EXEC inserir_score @fase, '00230202', 116, 12, 1
	 EXEC inserir_score @fase, '00210432', 116, 14, 1
	 EXEC inserir_score @fase, '00314124', 116, 16, 1
	 EXEC inserir_score @fase, '654', 117, 2, 1
	 EXEC inserir_score @fase, '631', 117, 3, 1
	 EXEC inserir_score @fase, '00431322', 117, 4, 1
	 EXEC inserir_score @fase, '00413234', 117, 7, 1
	 EXEC inserir_score @fase, '00410430', 117, 8, 1
	 EXEC inserir_score @fase, '736', 117, 9, 1
	 EXEC inserir_score @fase, '00112434', 117, 12, 1
	 EXEC inserir_score @fase, '00322432', 117, 14, 1
	 EXEC inserir_score @fase, '00223311', 117, 16, 1
	 EXEC inserir_score @fase, '195', 118, 1, 0
	 EXEC inserir_score @fase, '00121301', 118, 5, 0
	 EXEC inserir_score @fase, '627', 118, 6, 0
	 EXEC inserir_score @fase, '00132022', 118, 10, 0
	 EXEC inserir_score @fase, '600', 118, 11, 0
	 EXEC inserir_score @fase, '00141123', 118, 13, 0
	 EXEC inserir_score @fase, '00104002', 118, 15, 0
	 EXEC inserir_score @fase, '538', 119, 2, 1
	 EXEC inserir_score @fase, '581', 119, 3, 1
	 EXEC inserir_score @fase, '00213434', 119, 4, 1
	 EXEC inserir_score @fase, '00424340', 119, 7, 1
	 EXEC inserir_score @fase, '00421302', 119, 8, 1
	 EXEC inserir_score @fase, '861', 119, 9, 1
	 EXEC inserir_score @fase, '00421142', 119, 12, 1
	 EXEC inserir_score @fase, '00331102', 119, 14, 1
	 EXEC inserir_score @fase, '00111140', 119, 16, 1
	 EXEC inserir_score @fase, '45', 120, 2, 1
	 EXEC inserir_score @fase, '122', 120, 3, 1
	 EXEC inserir_score @fase, '00314301', 120, 4, 1
	 EXEC inserir_score @fase, '00204100', 120, 7, 1
	 EXEC inserir_score @fase, '00131004', 120, 8, 1
	 EXEC inserir_score @fase, '232', 120, 9, 1
	 EXEC inserir_score @fase, '00114342', 120, 12, 1
	 EXEC inserir_score @fase, '00104030', 120, 14, 1
	 EXEC inserir_score @fase, '00121223', 120, 16, 1
	 EXEC inserir_score @fase, '831', 121, 1, 0
	 EXEC inserir_score @fase, '00142403', 121, 5, 0
	 EXEC inserir_score @fase, '528', 121, 6, 0
	 EXEC inserir_score @fase, '00212424', 121, 10, 0
	 EXEC inserir_score @fase, '373', 121, 11, 0
	 EXEC inserir_score @fase, '00032210', 121, 13, 0
	 EXEC inserir_score @fase, '00430432', 121, 15, 0
	 EXEC inserir_score @fase, '753', 122, 2, 1
	 EXEC inserir_score @fase, '840', 122, 3, 1
	 EXEC inserir_score @fase, '00003340', 122, 4, 1
	 EXEC inserir_score @fase, '00434330', 122, 7, 1
	 EXEC inserir_score @fase, '00314302', 122, 8, 1
	 EXEC inserir_score @fase, '422', 122, 9, 1
	 EXEC inserir_score @fase, '00403411', 122, 12, 1
	 EXEC inserir_score @fase, '00043111', 122, 14, 1
	 EXEC inserir_score @fase, '00102301', 122, 16, 1
	 EXEC inserir_score @fase, '471', 123, 2, 1
	 EXEC inserir_score @fase, '540', 123, 3, 1
	 EXEC inserir_score @fase, '00001132', 123, 4, 1
	 EXEC inserir_score @fase, '00142023', 123, 7, 1
	 EXEC inserir_score @fase, '00244402', 123, 8, 1
	 EXEC inserir_score @fase, '16', 123, 9, 1
	 EXEC inserir_score @fase, '00101400', 123, 12, 1
	 EXEC inserir_score @fase, '00404412', 123, 14, 1
	 EXEC inserir_score @fase, '00101141', 123, 16, 1
	 EXEC inserir_score @fase, '344', 124, 2, 1
	 EXEC inserir_score @fase, '922', 124, 3, 1
	 EXEC inserir_score @fase, '00104212', 124, 4, 1
	 EXEC inserir_score @fase, '00000134', 124, 7, 1
	 EXEC inserir_score @fase, '00122414', 124, 8, 1
	 EXEC inserir_score @fase, '674', 124, 9, 1
	 EXEC inserir_score @fase, '00434213', 124, 12, 1
	 EXEC inserir_score @fase, '00042400', 124, 14, 1
	 EXEC inserir_score @fase, '00020141', 124, 16, 1
	 EXEC inserir_score @fase, '527', 125, 1, 0
	 EXEC inserir_score @fase, '00414411', 125, 5, 0
	 EXEC inserir_score @fase, '779', 125, 6, 0
	 EXEC inserir_score @fase, '00340120', 125, 10, 0
	 EXEC inserir_score @fase, '998', 125, 11, 0
	 EXEC inserir_score @fase, '00403340', 125, 13, 0
	 EXEC inserir_score @fase, '00142334', 125, 15, 0
	 EXEC inserir_score @fase, '205', 126, 2, 1
	 EXEC inserir_score @fase, '901', 126, 3, 1
	 EXEC inserir_score @fase, '00021440', 126, 4, 1
	 EXEC inserir_score @fase, '00201241', 126, 7, 1
	 EXEC inserir_score @fase, '00243320', 126, 8, 1
	 EXEC inserir_score @fase, '729', 126, 9, 1
	 EXEC inserir_score @fase, '00014320', 126, 12, 1
	 EXEC inserir_score @fase, '00321034', 126, 14, 1
	 EXEC inserir_score @fase, '00104123', 126, 16, 1
	 EXEC inserir_score @fase, '544', 127, 1, 0
	 EXEC inserir_score @fase, '00002040', 127, 5, 0
	 EXEC inserir_score @fase, '817', 127, 6, 0
	 EXEC inserir_score @fase, '00203012', 127, 10, 0
	 EXEC inserir_score @fase, '582', 127, 11, 0
	 EXEC inserir_score @fase, '00204341', 127, 13, 0
	 EXEC inserir_score @fase, '00143013', 127, 15, 0
	 EXEC inserir_score @fase, '484', 128, 2, 1
	 EXEC inserir_score @fase, '850', 128, 3, 1
	 EXEC inserir_score @fase, '00410214', 128, 4, 1
	 EXEC inserir_score @fase, '00142331', 128, 7, 1
	 EXEC inserir_score @fase, '00222044', 128, 8, 1
	 EXEC inserir_score @fase, '326', 128, 9, 1
	 EXEC inserir_score @fase, '00123224', 128, 12, 1
	 EXEC inserir_score @fase, '00013341', 128, 14, 1
	 EXEC inserir_score @fase, '00211033', 128, 16, 1
	 EXEC inserir_score @fase, '564', 129, 1, 0
	 EXEC inserir_score @fase, '00323034', 129, 5, 0
	 EXEC inserir_score @fase, '66', 129, 6, 0
	 EXEC inserir_score @fase, '00311140', 129, 10, 0
	 EXEC inserir_score @fase, '458', 129, 11, 0
	 EXEC inserir_score @fase, '00033120', 129, 13, 0
	 EXEC inserir_score @fase, '00034441', 129, 15, 0
	 EXEC inserir_score @fase, '308', 130, 2, 1
	 EXEC inserir_score @fase, '827', 130, 3, 1
	 EXEC inserir_score @fase, '00041112', 130, 4, 1
	 EXEC inserir_score @fase, '00113010', 130, 7, 1
	 EXEC inserir_score @fase, '00403211', 130, 8, 1
	 EXEC inserir_score @fase, '265', 130, 9, 1
	 EXEC inserir_score @fase, '00320432', 130, 12, 1
	 EXEC inserir_score @fase, '00434434', 130, 14, 1
	 EXEC inserir_score @fase, '00311012', 130, 16, 1
	 EXEC inserir_score @fase, '171', 131, 1, 0
	 EXEC inserir_score @fase, '00020113', 131, 5, 0
	 EXEC inserir_score @fase, '435', 131, 6, 0
	 EXEC inserir_score @fase, '00130411', 131, 10, 0
	 EXEC inserir_score @fase, '841', 131, 11, 0
	 EXEC inserir_score @fase, '00132101', 131, 13, 0
	 EXEC inserir_score @fase, '00103324', 131, 15, 0
	 EXEC inserir_score @fase, '451', 132, 2, 1
	 EXEC inserir_score @fase, '511', 132, 3, 1
	 EXEC inserir_score @fase, '00342314', 132, 4, 1
	 EXEC inserir_score @fase, '00001202', 132, 7, 1
	 EXEC inserir_score @fase, '00012231', 132, 8, 1
	 EXEC inserir_score @fase, '848', 132, 9, 1
	 EXEC inserir_score @fase, '00423211', 132, 12, 1
	 EXEC inserir_score @fase, '00222222', 132, 14, 1
	 EXEC inserir_score @fase, '00433010', 132, 16, 1
	 EXEC inserir_score @fase, '742', 133, 1, 0
	 EXEC inserir_score @fase, '00141321', 133, 5, 0
	 EXEC inserir_score @fase, '711', 133, 6, 0
	 EXEC inserir_score @fase, '00111020', 133, 10, 0
	 EXEC inserir_score @fase, '486', 133, 11, 0
	 EXEC inserir_score @fase, '00314313', 133, 13, 0
	 EXEC inserir_score @fase, '00023230', 133, 15, 0
	 EXEC inserir_score @fase, '909', 134, 1, 0
	 EXEC inserir_score @fase, '00122344', 134, 5, 0
	 EXEC inserir_score @fase, '543', 134, 6, 0
	 EXEC inserir_score @fase, '00240221', 134, 10, 0
	 EXEC inserir_score @fase, '285', 134, 11, 0
	 EXEC inserir_score @fase, '00304321', 134, 13, 0
	 EXEC inserir_score @fase, '00420312', 134, 15, 0
	 EXEC inserir_score @fase, '108', 135, 2, 1
	 EXEC inserir_score @fase, '419', 135, 3, 1
	 EXEC inserir_score @fase, '00443304', 135, 4, 1
	 EXEC inserir_score @fase, '00140002', 135, 7, 1
	 EXEC inserir_score @fase, '00424204', 135, 8, 1
	 EXEC inserir_score @fase, '42', 135, 9, 1
	 EXEC inserir_score @fase, '00322344', 135, 12, 1
	 EXEC inserir_score @fase, '00024003', 135, 14, 1
	 EXEC inserir_score @fase, '00314030', 135, 16, 1
	 EXEC inserir_score @fase, '240', 136, 1, 0
	 EXEC inserir_score @fase, '00344034', 136, 5, 0
	 EXEC inserir_score @fase, '504', 136, 6, 0
	 EXEC inserir_score @fase, '00103342', 136, 10, 0
	 EXEC inserir_score @fase, '21', 136, 11, 0
	 EXEC inserir_score @fase, '00013331', 136, 13, 0
	 EXEC inserir_score @fase, '00144432', 136, 15, 0
	 EXEC inserir_score @fase, '923', 137, 2, 1
	 EXEC inserir_score @fase, '609', 137, 3, 1
	 EXEC inserir_score @fase, '00014312', 137, 4, 1
	 EXEC inserir_score @fase, '00133241', 137, 7, 1
	 EXEC inserir_score @fase, '00241242', 137, 8, 1
	 EXEC inserir_score @fase, '49', 137, 9, 1
	 EXEC inserir_score @fase, '00134031', 137, 12, 1
	 EXEC inserir_score @fase, '00321244', 137, 14, 1
	 EXEC inserir_score @fase, '00242000', 137, 16, 1
	 EXEC inserir_score @fase, '162', 138, 2, 1
	 EXEC inserir_score @fase, '512', 138, 3, 1
	 EXEC inserir_score @fase, '00423222', 138, 4, 1
	 EXEC inserir_score @fase, '00130331', 138, 7, 1
	 EXEC inserir_score @fase, '00433241', 138, 8, 1
	 EXEC inserir_score @fase, '682', 138, 9, 1
	 EXEC inserir_score @fase, '00422210', 138, 12, 1
	 EXEC inserir_score @fase, '00430234', 138, 14, 1
	 EXEC inserir_score @fase, '00140331', 138, 16, 1
	 EXEC inserir_score @fase, '525', 139, 2, 1
	 EXEC inserir_score @fase, '433', 139, 3, 1
	 EXEC inserir_score @fase, '00211234', 139, 4, 1
	 EXEC inserir_score @fase, '00442322', 139, 7, 1
	 EXEC inserir_score @fase, '00221002', 139, 8, 1
	 EXEC inserir_score @fase, '77', 139, 9, 1
	 EXEC inserir_score @fase, '00031303', 139, 12, 1
	 EXEC inserir_score @fase, '00020021', 139, 14, 1
	 EXEC inserir_score @fase, '00033210', 139, 16, 1
	 EXEC inserir_score @fase, '595', 140, 1, 0
	 EXEC inserir_score @fase, '00020012', 140, 5, 0
	 EXEC inserir_score @fase, '803', 140, 6, 0
	 EXEC inserir_score @fase, '00434024', 140, 10, 0
	 EXEC inserir_score @fase, '133', 140, 11, 0
	 EXEC inserir_score @fase, '00202422', 140, 13, 0
	 EXEC inserir_score @fase, '00411333', 140, 15, 0
	 EXEC inserir_score @fase, '471', 141, 1, 0
	 EXEC inserir_score @fase, '00241302', 141, 5, 0
	 EXEC inserir_score @fase, '98', 141, 6, 0
	 EXEC inserir_score @fase, '00410324', 141, 10, 0
	 EXEC inserir_score @fase, '337', 141, 11, 0
	 EXEC inserir_score @fase, '00331004', 141, 13, 0
	 EXEC inserir_score @fase, '00322210', 141, 15, 0
	 EXEC inserir_score @fase, '493', 142, 2, 1
	 EXEC inserir_score @fase, '454', 142, 3, 1
	 EXEC inserir_score @fase, '00020130', 142, 4, 1
	 EXEC inserir_score @fase, '00102300', 142, 7, 1
	 EXEC inserir_score @fase, '00240301', 142, 8, 1
	 EXEC inserir_score @fase, '525', 142, 9, 1
	 EXEC inserir_score @fase, '00123010', 142, 12, 1
	 EXEC inserir_score @fase, '00000420', 142, 14, 1
	 EXEC inserir_score @fase, '00330321', 142, 16, 1
	 EXEC inserir_score @fase, '976', 143, 2, 1
	 EXEC inserir_score @fase, '582', 143, 3, 1
	 EXEC inserir_score @fase, '00134014', 143, 4, 1
	 EXEC inserir_score @fase, '00410132', 143, 7, 1
	 EXEC inserir_score @fase, '00401021', 143, 8, 1
	 EXEC inserir_score @fase, '361', 143, 9, 1
	 EXEC inserir_score @fase, '00320114', 143, 12, 1
	 EXEC inserir_score @fase, '00432013', 143, 14, 1
	 EXEC inserir_score @fase, '00022114', 143, 16, 1
	 EXEC inserir_score @fase, '190', 144, 1, 0
	 EXEC inserir_score @fase, '00021344', 144, 5, 0
	 EXEC inserir_score @fase, '553', 144, 6, 0
	 EXEC inserir_score @fase, '00302134', 144, 10, 0
	 EXEC inserir_score @fase, '741', 144, 11, 0
	 EXEC inserir_score @fase, '00430444', 144, 13, 0
	 EXEC inserir_score @fase, '00104131', 144, 15, 0
	 EXEC inserir_score @fase, '945', 145, 2, 1
	 EXEC inserir_score @fase, '605', 145, 3, 1
	 EXEC inserir_score @fase, '00133100', 145, 4, 1
	 EXEC inserir_score @fase, '00331341', 145, 7, 1
	 EXEC inserir_score @fase, '00303243', 145, 8, 1
	 EXEC inserir_score @fase, '926', 145, 9, 1
	 EXEC inserir_score @fase, '00300332', 145, 12, 1
	 EXEC inserir_score @fase, '00123042', 145, 14, 1
	 EXEC inserir_score @fase, '00231313', 145, 16, 1
	 EXEC inserir_score @fase, '41', 146, 2, 1
	 EXEC inserir_score @fase, '299', 146, 3, 1
	 EXEC inserir_score @fase, '00120041', 146, 4, 1
	 EXEC inserir_score @fase, '00001000', 146, 7, 1
	 EXEC inserir_score @fase, '00314414', 146, 8, 1
	 EXEC inserir_score @fase, '474', 146, 9, 1
	 EXEC inserir_score @fase, '00401403', 146, 12, 1
	 EXEC inserir_score @fase, '00314234', 146, 14, 1
	 EXEC inserir_score @fase, '00013434', 146, 16, 1
END
GO

--DROP PROCEDURE popular_score_final
CREATE PROCEDURE popular_score_final (@fase INT)
AS
BEGIN
END
GO

-- DISCARD LATER 

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

EXEC popular_score 1

SELECT	* FROM prova
DELETE FROM
