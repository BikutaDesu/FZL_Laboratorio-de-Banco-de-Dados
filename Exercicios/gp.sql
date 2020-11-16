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
score	VARCHAR(8),
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
		RAISERROR('Limite máximo de partidas já foi realizado pelo atleta!', 16, 1)
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
/**DROP TRIGGER t_inserir_atleta
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
GO**/

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
	 EXEC inserir_score @fase, '697', 100, 1, 0
	 EXEC inserir_score @fase, '00433242', 100, 5, 0
	 EXEC inserir_score @fase, '772', 100, 6, 0
	 EXEC inserir_score @fase, '00432100', 100, 10, 0
	 EXEC inserir_score @fase, '717', 100, 11, 0
	 EXEC inserir_score @fase, '203', 101, 2, 1
	 EXEC inserir_score @fase, '763', 101, 3, 1
	 EXEC inserir_score @fase, '00140310', 101, 4, 1
	 EXEC inserir_score @fase, '925', 102, 1, 0
	 EXEC inserir_score @fase, '00340321', 102, 5, 0
	 EXEC inserir_score @fase, '997', 102, 6, 0
	 EXEC inserir_score @fase, '658', 103, 2, 1
	 EXEC inserir_score @fase, '749', 103, 3, 1
	 EXEC inserir_score @fase, '00114003', 103, 4, 1
	 EXEC inserir_score @fase, '00302041', 103, 7, 1
	 EXEC inserir_score @fase, '00024421', 103, 8, 1
	 EXEC inserir_score @fase, '776', 103, 9, 1
	 EXEC inserir_score @fase, '960', 104, 2, 1
	 EXEC inserir_score @fase, '670', 104, 3, 1
	 EXEC inserir_score @fase, '00134132', 104, 4, 1
	 EXEC inserir_score @fase, '00422133', 104, 7, 1
	 EXEC inserir_score @fase, '00214031', 104, 8, 1
	 EXEC inserir_score @fase, '704', 104, 9, 1
	 EXEC inserir_score @fase, '00404431', 104, 12, 1
	 EXEC inserir_score @fase, '00444013', 104, 14, 1
	 EXEC inserir_score @fase, '994', 105, 1, 0
	 EXEC inserir_score @fase, '00202313', 105, 5, 0
	 EXEC inserir_score @fase, '140', 105, 6, 0
	 EXEC inserir_score @fase, '843', 106, 2, 1
	 EXEC inserir_score @fase, '484', 106, 3, 1
	 EXEC inserir_score @fase, '00343310', 106, 4, 1
	 EXEC inserir_score @fase, '00030034', 106, 7, 1
	 EXEC inserir_score @fase, '00424100', 106, 8, 1
	 EXEC inserir_score @fase, '292', 106, 9, 1
	 EXEC inserir_score @fase, '369', 107, 2, 1
	 EXEC inserir_score @fase, '804', 107, 3, 1
	 EXEC inserir_score @fase, '00223334', 107, 4, 1
	 EXEC inserir_score @fase, '00132201', 107, 7, 1
	 EXEC inserir_score @fase, '00300010', 107, 8, 1
	 EXEC inserir_score @fase, '502', 107, 9, 1
	 EXEC inserir_score @fase, '00004131', 107, 12, 1
	 EXEC inserir_score @fase, '00200043', 107, 14, 1
	 EXEC inserir_score @fase, '785', 108, 1, 0
	 EXEC inserir_score @fase, '00242041', 108, 5, 0
	 EXEC inserir_score @fase, '61', 108, 6, 0
	 EXEC inserir_score @fase, '694', 109, 2, 1
	 EXEC inserir_score @fase, '828', 109, 3, 1
	 EXEC inserir_score @fase, '00333403', 109, 4, 1
	 EXEC inserir_score @fase, '00434101', 109, 7, 1
	 EXEC inserir_score @fase, '213', 110, 2, 1
	 EXEC inserir_score @fase, '217', 110, 3, 1
	 EXEC inserir_score @fase, '00243134', 110, 4, 1
	 EXEC inserir_score @fase, '00402124', 110, 7, 1
	 EXEC inserir_score @fase, '00441230', 110, 8, 1
	 EXEC inserir_score @fase, '295', 110, 9, 1
	 EXEC inserir_score @fase, '645', 111, 1, 0
	 EXEC inserir_score @fase, '00311230', 111, 5, 0
	 EXEC inserir_score @fase, '417', 111, 6, 0
	 EXEC inserir_score @fase, '00101222', 111, 10, 0
	 EXEC inserir_score @fase, '757', 111, 11, 0
	 EXEC inserir_score @fase, '00212112', 111, 13, 0
	 EXEC inserir_score @fase, '00330414', 111, 15, 0
	 EXEC inserir_score @fase, '244', 112, 2, 1
	 EXEC inserir_score @fase, '732', 112, 3, 1
	 EXEC inserir_score @fase, '744', 113, 2, 1
	 EXEC inserir_score @fase, '741', 113, 3, 1
	 EXEC inserir_score @fase, '00334403', 113, 4, 1
	 EXEC inserir_score @fase, '00111231', 113, 7, 1
	 EXEC inserir_score @fase, '996', 114, 1, 0
	 EXEC inserir_score @fase, '00203030', 114, 5, 0
	 EXEC inserir_score @fase, '599', 114, 6, 0
	 EXEC inserir_score @fase, '00341223', 114, 10, 0
	 EXEC inserir_score @fase, '857', 114, 11, 0
	 EXEC inserir_score @fase, '00133411', 114, 13, 0
	 EXEC inserir_score @fase, '108', 115, 2, 1
	 EXEC inserir_score @fase, '414', 115, 3, 1
	 EXEC inserir_score @fase, '00430331', 115, 4, 1
	 EXEC inserir_score @fase, '00102321', 115, 7, 1
	 EXEC inserir_score @fase, '00303044', 115, 8, 1
	 EXEC inserir_score @fase, '627', 115, 9, 1
	 EXEC inserir_score @fase, '00220233', 115, 12, 1
	 EXEC inserir_score @fase, '654', 116, 2, 1
	 EXEC inserir_score @fase, '458', 116, 3, 1
	 EXEC inserir_score @fase, '00432213', 116, 4, 1
	 EXEC inserir_score @fase, '00122331', 116, 7, 1
	 EXEC inserir_score @fase, '00102414', 116, 8, 1
	 EXEC inserir_score @fase, '610', 116, 9, 1
	 EXEC inserir_score @fase, '00304231', 116, 12, 1
	 EXEC inserir_score @fase, '426', 117, 2, 1
	 EXEC inserir_score @fase, '350', 117, 3, 1
	 EXEC inserir_score @fase, '00402002', 117, 4, 1
	 EXEC inserir_score @fase, '00113221', 117, 7, 1
	 EXEC inserir_score @fase, '00243404', 117, 8, 1
	 EXEC inserir_score @fase, '673', 117, 9, 1
	 EXEC inserir_score @fase, '268', 118, 1, 0
	 EXEC inserir_score @fase, '00234404', 118, 5, 0
	 EXEC inserir_score @fase, '424', 118, 6, 0
	 EXEC inserir_score @fase, '299', 119, 2, 1
	 EXEC inserir_score @fase, '416', 119, 3, 1
	 EXEC inserir_score @fase, '00444340', 119, 4, 1
	 EXEC inserir_score @fase, '00033443', 119, 7, 1
	 EXEC inserir_score @fase, '00323421', 119, 8, 1
	 EXEC inserir_score @fase, '968', 119, 9, 1
	 EXEC inserir_score @fase, '250', 120, 1, 0
	 EXEC inserir_score @fase, '00120410', 120, 5, 0
	 EXEC inserir_score @fase, '839', 120, 6, 0
	 EXEC inserir_score @fase, '00122411', 120, 10, 0
	 EXEC inserir_score @fase, '816', 120, 11, 0
	 EXEC inserir_score @fase, '745', 121, 2, 1
	 EXEC inserir_score @fase, '582', 121, 3, 1
	 EXEC inserir_score @fase, '00240440', 121, 4, 1
	 EXEC inserir_score @fase, '00122303', 121, 7, 1
	 EXEC inserir_score @fase, '00134042', 121, 8, 1
	 EXEC inserir_score @fase, '366', 121, 9, 1
	 EXEC inserir_score @fase, '424', 122, 1, 0
	 EXEC inserir_score @fase, '290', 123, 2, 1
	 EXEC inserir_score @fase, '155', 123, 3, 1
	 EXEC inserir_score @fase, '00312211', 123, 4, 1
	 EXEC inserir_score @fase, '00314201', 123, 7, 1
	 EXEC inserir_score @fase, '00242033', 123, 8, 1
	 EXEC inserir_score @fase, '511', 123, 9, 1
	 EXEC inserir_score @fase, '00321243', 123, 12, 1
	 EXEC inserir_score @fase, '603', 124, 1, 0
	 EXEC inserir_score @fase, '00021444', 124, 5, 0
	 EXEC inserir_score @fase, '585', 124, 6, 0
	 EXEC inserir_score @fase, '572', 125, 2, 1
	 EXEC inserir_score @fase, '945', 125, 3, 1
	 EXEC inserir_score @fase, '00342244', 125, 4, 1
	 EXEC inserir_score @fase, '00203443', 125, 7, 1
	 EXEC inserir_score @fase, '00012133', 125, 8, 1
	 EXEC inserir_score @fase, '238', 125, 9, 1
	 EXEC inserir_score @fase, '00441201', 125, 12, 1
	 EXEC inserir_score @fase, '00320333', 125, 14, 1
	 EXEC inserir_score @fase, '567', 126, 1, 0
	 EXEC inserir_score @fase, '400', 127, 1, 0
	 EXEC inserir_score @fase, '00314323', 127, 5, 0
	 EXEC inserir_score @fase, '998', 127, 6, 0
	 EXEC inserir_score @fase, '720', 128, 2, 1
	 EXEC inserir_score @fase, '786', 128, 3, 1
	 EXEC inserir_score @fase, '00442043', 128, 4, 1
	 EXEC inserir_score @fase, '00113022', 128, 7, 1
	 EXEC inserir_score @fase, '00120000', 128, 8, 1
	 EXEC inserir_score @fase, '157', 128, 9, 1
	 EXEC inserir_score @fase, '00010130', 128, 12, 1
	 EXEC inserir_score @fase, '27', 129, 1, 0
	 EXEC inserir_score @fase, '587', 130, 2, 1
	 EXEC inserir_score @fase, '321', 130, 3, 1
	 EXEC inserir_score @fase, '00013232', 130, 4, 1
	 EXEC inserir_score @fase, '195', 131, 2, 1
	 EXEC inserir_score @fase, '975', 131, 3, 1
	 EXEC inserir_score @fase, '00324042', 131, 4, 1
	 EXEC inserir_score @fase, '00121033', 131, 7, 1
	 EXEC inserir_score @fase, '00223004', 131, 8, 1
	 EXEC inserir_score @fase, '913', 132, 2, 1
	 EXEC inserir_score @fase, '623', 132, 3, 1
	 EXEC inserir_score @fase, '00244032', 132, 4, 1
	 EXEC inserir_score @fase, '00211210', 132, 7, 1
	 EXEC inserir_score @fase, '00441144', 132, 8, 1
	 EXEC inserir_score @fase, '866', 132, 9, 1
	 EXEC inserir_score @fase, '582', 133, 1, 0
	 EXEC inserir_score @fase, '00341344', 133, 5, 0
	 EXEC inserir_score @fase, '797', 133, 6, 0
	 EXEC inserir_score @fase, '00212241', 133, 10, 0
	 EXEC inserir_score @fase, '423', 133, 11, 0
	 EXEC inserir_score @fase, '882', 134, 1, 0
	 EXEC inserir_score @fase, '00322204', 134, 5, 0
	 EXEC inserir_score @fase, '571', 134, 6, 0
	 EXEC inserir_score @fase, '00320341', 134, 10, 0
	 EXEC inserir_score @fase, '139', 134, 11, 0
	 EXEC inserir_score @fase, '00223242', 134, 13, 0
	 EXEC inserir_score @fase, '00314422', 134, 15, 0
	 EXEC inserir_score @fase, '606', 135, 2, 1
	 EXEC inserir_score @fase, '549', 135, 3, 1
	 EXEC inserir_score @fase, '882', 137, 1, 0
	 EXEC inserir_score @fase, '00320432', 137, 5, 0
	 EXEC inserir_score @fase, '234', 137, 6, 0
	 EXEC inserir_score @fase, '852', 138, 2, 1
	 EXEC inserir_score @fase, '433', 138, 3, 1
	 EXEC inserir_score @fase, '00214243', 138, 4, 1
	 EXEC inserir_score @fase, '00001042', 138, 7, 1
	 EXEC inserir_score @fase, '00330042', 138, 8, 1
	 EXEC inserir_score @fase, '708', 138, 9, 1
	 EXEC inserir_score @fase, '00021300', 138, 12, 1
	 EXEC inserir_score @fase, '00331124', 138, 14, 1
	 EXEC inserir_score @fase, '562', 139, 2, 1

END
GO

--DROP PROCEDURE popular_score_final
CREATE PROCEDURE popular_score_final (@fase INT)
AS
BEGIN
	DECLARE	@score VARCHAR(8),
			@atleta INT,
			@prova INT,
			@sexo BIT

	SET @prova = 1
	
	WHILE (@prova <= 16)
	BEGIN
		DECLARE cur CURSOR FOR	SELECT	m.atleta_id,
										a.sexo
								FROM	f_melhores(@fase -1,  @prova) m, atleta a
								WHERE	m.atleta_id = a.id
		OPEN cur
		FETCH NEXT FROM cur into @atleta, @sexo
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @tipo BIT
			SET @tipo = (SELECT tipo FROM prova WHERE id = @prova)

			IF (@tipo > 0 )
			BEGIN
				DECLARE @counter INT
				SET @counter = 3
				SET @score = '00'

				WHILE (@counter > 0)
				BEGIN
					SET @score = @score + (SELECT FLOOR(RAND()*(5-0)+0))
					SET @score = @score + (SELECT FLOOR(RAND()*(9-0)+0))
					SET @counter = @counter - 1
				END
				EXEC inserir_score @fase, @score, @atleta, @prova, @sexo
				FETCH NEXT FROM cur into @atleta, @sexo
			END
			ELSE 
			BEGIN
				DECLARE @quantidade INT
				SET @quantidade = (SELECT FLOOR(RAND()*(6-1)+1))

				WHILE (@quantidade > 0)
				BEGIN
					SET @score = (SELECT FLOOR(RAND()*(1000-15)+15))
					EXEC inserir_score @fase, @score, @atleta, @prova, @sexo
					FETCH NEXT FROM cur into @atleta, @sexo
					SET @quantidade = @quantidade -1
				END
			END
			
		END

		CLOSE cur
		DEALLOCATE cur
	SET @prova = @prova + 1
	END
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


EXEC popular_score 0
EXEC popular_score_final 1

SELECT * FROM score WHERE fase = 1
DELETE FROM score WHERE fase = 1

SELECT atleta_id FROM f_melhores(1, 2)
