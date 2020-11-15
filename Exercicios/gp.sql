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


-- Visualizar todos os atletas
SELECT	*
FROM	atleta

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


-- Registros/População

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
GO

DROP PROCEDURE popular_score
CREATE PROCEDURE popular_score (@fase INT)
AS
BEGIN
	 EXEC inserir_score @fase, '286', 100, 1, 0
	 EXEC inserir_score @fase, '00021243', 100, 5, 0
	 EXEC inserir_score @fase, '50', 100, 6, 0
	 EXEC inserir_score @fase, '00440301', 100, 10, 0
	 EXEC inserir_score @fase, '427', 100, 11, 0
	 EXEC inserir_score @fase, '00300224', 100, 13, 0
	 EXEC inserir_score @fase, '00224301', 100, 15, 0
	 EXEC inserir_score @fase, '534', 101, 2, 1
	 EXEC inserir_score @fase, '489', 101, 3, 1
	 EXEC inserir_score @fase, '00021141', 101, 4, 1
	 EXEC inserir_score @fase, '00414113', 101, 7, 1
	 EXEC inserir_score @fase, '00401034', 101, 8, 1
	 EXEC inserir_score @fase, '49', 101, 9, 1
	 EXEC inserir_score @fase, '00342410', 101, 12, 1
	 EXEC inserir_score @fase, '00104120', 101, 14, 1
	 EXEC inserir_score @fase, '00233244', 101, 16, 1
	 EXEC inserir_score @fase, '179', 102, 1, 0
	 EXEC inserir_score @fase, '00432010', 102, 5, 0
	 EXEC inserir_score @fase, '646', 102, 6, 0
	 EXEC inserir_score @fase, '00404221', 102, 10, 0
	 EXEC inserir_score @fase, '136', 102, 11, 0
	 EXEC inserir_score @fase, '00234311', 102, 13, 0
	 EXEC inserir_score @fase, '00112211', 102, 15, 0
	 EXEC inserir_score @fase, '452', 103, 2, 1
	 EXEC inserir_score @fase, '43', 103, 3, 1
	 EXEC inserir_score @fase, '00102403', 103, 4, 1
	 EXEC inserir_score @fase, '00034012', 103, 7, 1
	 EXEC inserir_score @fase, '00042404', 103, 8, 1
	 EXEC inserir_score @fase, '231', 103, 9, 1
	 EXEC inserir_score @fase, '00300400', 103, 12, 1
	 EXEC inserir_score @fase, '00021124', 103, 14, 1
	 EXEC inserir_score @fase, '00141433', 103, 16, 1
	 EXEC inserir_score @fase, '985', 104, 2, 1
	 EXEC inserir_score @fase, '90', 104, 3, 1
	 EXEC inserir_score @fase, '00431124', 104, 4, 1
	 EXEC inserir_score @fase, '00412142', 104, 7, 1
	 EXEC inserir_score @fase, '00032042', 104, 8, 1
	 EXEC inserir_score @fase, '899', 104, 9, 1
	 EXEC inserir_score @fase, '00022232', 104, 12, 1
	 EXEC inserir_score @fase, '00102013', 104, 14, 1
	 EXEC inserir_score @fase, '00114114', 104, 16, 1
	 EXEC inserir_score @fase, '402', 105, 1, 0
	 EXEC inserir_score @fase, '00432211', 105, 5, 0
	 EXEC inserir_score @fase, '515', 105, 6, 0
	 EXEC inserir_score @fase, '00132341', 105, 10, 0
	 EXEC inserir_score @fase, '988', 105, 11, 0
	 EXEC inserir_score @fase, '00024044', 105, 13, 0
	 EXEC inserir_score @fase, '00022012', 105, 15, 0
	 EXEC inserir_score @fase, '754', 106, 2, 1
	 EXEC inserir_score @fase, '215', 106, 3, 1
	 EXEC inserir_score @fase, '00230300', 106, 4, 1
	 EXEC inserir_score @fase, '00341100', 106, 7, 1
	 EXEC inserir_score @fase, '00121114', 106, 8, 1
	 EXEC inserir_score @fase, '57', 106, 9, 1
	 EXEC inserir_score @fase, '00313441', 106, 12, 1
	 EXEC inserir_score @fase, '00210401', 106, 14, 1
	 EXEC inserir_score @fase, '00310323', 106, 16, 1
	 EXEC inserir_score @fase, '941', 107, 2, 1
	 EXEC inserir_score @fase, '88', 107, 3, 1
	 EXEC inserir_score @fase, '00434124', 107, 4, 1
	 EXEC inserir_score @fase, '00331112', 107, 7, 1
	 EXEC inserir_score @fase, '00120220', 107, 8, 1
	 EXEC inserir_score @fase, '562', 107, 9, 1
	 EXEC inserir_score @fase, '00003232', 107, 12, 1
	 EXEC inserir_score @fase, '00301302', 107, 14, 1
	 EXEC inserir_score @fase, '00411042', 107, 16, 1
	 EXEC inserir_score @fase, '120', 108, 1, 0
	 EXEC inserir_score @fase, '00333023', 108, 5, 0
	 EXEC inserir_score @fase, '409', 108, 6, 0
	 EXEC inserir_score @fase, '00032324', 108, 10, 0
	 EXEC inserir_score @fase, '48', 108, 11, 0
	 EXEC inserir_score @fase, '00001431', 108, 13, 0
	 EXEC inserir_score @fase, '00142042', 108, 15, 0
	 EXEC inserir_score @fase, '474', 109, 2, 1
	 EXEC inserir_score @fase, '964', 109, 3, 1
	 EXEC inserir_score @fase, '00114113', 109, 4, 1
	 EXEC inserir_score @fase, '00223024', 109, 7, 1
	 EXEC inserir_score @fase, '00241434', 109, 8, 1
	 EXEC inserir_score @fase, '827', 109, 9, 1
	 EXEC inserir_score @fase, '00404224', 109, 12, 1
	 EXEC inserir_score @fase, '00143103', 109, 14, 1
	 EXEC inserir_score @fase, '00220004', 109, 16, 1
	 EXEC inserir_score @fase, '175', 110, 2, 1
	 EXEC inserir_score @fase, '393', 110, 3, 1
	 EXEC inserir_score @fase, '00324104', 110, 4, 1
	 EXEC inserir_score @fase, '00313343', 110, 7, 1
	 EXEC inserir_score @fase, '00320321', 110, 8, 1
	 EXEC inserir_score @fase, '164', 110, 9, 1
	 EXEC inserir_score @fase, '00013023', 110, 12, 1
	 EXEC inserir_score @fase, '00333122', 110, 14, 1
	 EXEC inserir_score @fase, '00202014', 110, 16, 1
	 EXEC inserir_score @fase, '512', 111, 1, 0
	 EXEC inserir_score @fase, '00043434', 111, 5, 0
	 EXEC inserir_score @fase, '86', 111, 6, 0
	 EXEC inserir_score @fase, '00000400', 111, 10, 0
	 EXEC inserir_score @fase, '980', 111, 11, 0
	 EXEC inserir_score @fase, '00441023', 111, 13, 0
	 EXEC inserir_score @fase, '00032333', 111, 15, 0
	 EXEC inserir_score @fase, '984', 112, 2, 1
	 EXEC inserir_score @fase, '197', 112, 3, 1
	 EXEC inserir_score @fase, '00300223', 112, 4, 1
	 EXEC inserir_score @fase, '00040131', 112, 7, 1
	 EXEC inserir_score @fase, '00314143', 112, 8, 1
	 EXEC inserir_score @fase, '393', 112, 9, 1
	 EXEC inserir_score @fase, '00433404', 112, 12, 1
	 EXEC inserir_score @fase, '00302232', 112, 14, 1
	 EXEC inserir_score @fase, '00333414', 112, 16, 1
	 EXEC inserir_score @fase, '318', 113, 2, 1
	 EXEC inserir_score @fase, '271', 113, 3, 1
	 EXEC inserir_score @fase, '00021233', 113, 4, 1
	 EXEC inserir_score @fase, '00104000', 113, 7, 1
	 EXEC inserir_score @fase, '00104420', 113, 8, 1
	 EXEC inserir_score @fase, '899', 113, 9, 1
	 EXEC inserir_score @fase, '00324412', 113, 12, 1
	 EXEC inserir_score @fase, '00242332', 113, 14, 1
	 EXEC inserir_score @fase, '00242011', 113, 16, 1
	 EXEC inserir_score @fase, '694', 114, 1, 0
	 EXEC inserir_score @fase, '00442310', 114, 5, 0
	 EXEC inserir_score @fase, '257', 114, 6, 0
	 EXEC inserir_score @fase, '00434044', 114, 10, 0
	 EXEC inserir_score @fase, '980', 114, 11, 0
	 EXEC inserir_score @fase, '00231414', 114, 13, 0
	 EXEC inserir_score @fase, '00410112', 114, 15, 0
	 EXEC inserir_score @fase, '915', 115, 2, 1
	 EXEC inserir_score @fase, '679', 115, 3, 1
	 EXEC inserir_score @fase, '00320224', 115, 4, 1
	 EXEC inserir_score @fase, '00022324', 115, 7, 1
	 EXEC inserir_score @fase, '00401423', 115, 8, 1
	 EXEC inserir_score @fase, '388', 115, 9, 1
	 EXEC inserir_score @fase, '00331323', 115, 12, 1
	 EXEC inserir_score @fase, '00310413', 115, 14, 1
	 EXEC inserir_score @fase, '00030114', 115, 16, 1
	 EXEC inserir_score @fase, '903', 116, 2, 1
	 EXEC inserir_score @fase, '649', 116, 3, 1
	 EXEC inserir_score @fase, '00042434', 116, 4, 1
	 EXEC inserir_score @fase, '00421123', 116, 7, 1
	 EXEC inserir_score @fase, '00430032', 116, 8, 1
	 EXEC inserir_score @fase, '48', 116, 9, 1
	 EXEC inserir_score @fase, '00313342', 116, 12, 1
	 EXEC inserir_score @fase, '00400040', 116, 14, 1
	 EXEC inserir_score @fase, '00141143', 116, 16, 1
	 EXEC inserir_score @fase, '67', 117, 2, 1
	 EXEC inserir_score @fase, '46', 117, 3, 1
	 EXEC inserir_score @fase, '00323031', 117, 4, 1
	 EXEC inserir_score @fase, '00311101', 117, 7, 1
	 EXEC inserir_score @fase, '00042033', 117, 8, 1
	 EXEC inserir_score @fase, '774', 117, 9, 1
	 EXEC inserir_score @fase, '00242120', 117, 12, 1
	 EXEC inserir_score @fase, '00204431', 117, 14, 1
	 EXEC inserir_score @fase, '00103040', 117, 16, 1
	 EXEC inserir_score @fase, '925', 118, 1, 0
	 EXEC inserir_score @fase, '00122340', 118, 5, 0
	 EXEC inserir_score @fase, '854', 118, 6, 0
	 EXEC inserir_score @fase, '00411222', 118, 10, 0
	 EXEC inserir_score @fase, '363', 118, 11, 0
	 EXEC inserir_score @fase, '00323001', 118, 13, 0
	 EXEC inserir_score @fase, '00202302', 118, 15, 0
	 EXEC inserir_score @fase, '520', 119, 2, 1
	 EXEC inserir_score @fase, '380', 119, 3, 1
	 EXEC inserir_score @fase, '00140334', 119, 4, 1
	 EXEC inserir_score @fase, '00234423', 119, 7, 1
	 EXEC inserir_score @fase, '00444024', 119, 8, 1
	 EXEC inserir_score @fase, '635', 119, 9, 1
	 EXEC inserir_score @fase, '00230311', 119, 12, 1
	 EXEC inserir_score @fase, '00301333', 119, 14, 1
	 EXEC inserir_score @fase, '00000112', 119, 16, 1
	 EXEC inserir_score @fase, '837', 120, 1, 0
	 EXEC inserir_score @fase, '00134431', 120, 5, 0
	 EXEC inserir_score @fase, '373', 120, 6, 0
	 EXEC inserir_score @fase, '00323030', 120, 10, 0
	 EXEC inserir_score @fase, '629', 120, 11, 0
	 EXEC inserir_score @fase, '00010123', 120, 13, 0
	 EXEC inserir_score @fase, '00112014', 120, 15, 0
	 EXEC inserir_score @fase, '399', 121, 2, 1
	 EXEC inserir_score @fase, '343', 121, 3, 1
	 EXEC inserir_score @fase, '00010122', 121, 4, 1
	 EXEC inserir_score @fase, '00403220', 121, 7, 1
	 EXEC inserir_score @fase, '00243233', 121, 8, 1
	 EXEC inserir_score @fase, '674', 121, 9, 1
	 EXEC inserir_score @fase, '00242332', 121, 12, 1
	 EXEC inserir_score @fase, '00444034', 121, 14, 1
	 EXEC inserir_score @fase, '00042413', 121, 16, 1
	 EXEC inserir_score @fase, '876', 122, 1, 0
	 EXEC inserir_score @fase, '00332033', 122, 5, 0
	 EXEC inserir_score @fase, '788', 122, 6, 0
	 EXEC inserir_score @fase, '00241141', 122, 10, 0
	 EXEC inserir_score @fase, '130', 122, 11, 0
	 EXEC inserir_score @fase, '00004034', 122, 13, 0
	 EXEC inserir_score @fase, '00022140', 122, 15, 0
	 EXEC inserir_score @fase, '344', 123, 2, 1
	 EXEC inserir_score @fase, '266', 123, 3, 1
	 EXEC inserir_score @fase, '00101410', 123, 4, 1
	 EXEC inserir_score @fase, '00444113', 123, 7, 1
	 EXEC inserir_score @fase, '00331013', 123, 8, 1
	 EXEC inserir_score @fase, '491', 123, 9, 1
	 EXEC inserir_score @fase, '00042424', 123, 12, 1
	 EXEC inserir_score @fase, '00101343', 123, 14, 1
	 EXEC inserir_score @fase, '00414040', 123, 16, 1
	 EXEC inserir_score @fase, '566', 124, 1, 0
	 EXEC inserir_score @fase, '00332023', 124, 5, 0
	 EXEC inserir_score @fase, '431', 124, 6, 0
	 EXEC inserir_score @fase, '00022002', 124, 10, 0
	 EXEC inserir_score @fase, '242', 124, 11, 0
	 EXEC inserir_score @fase, '00410321', 124, 13, 0
	 EXEC inserir_score @fase, '00303043', 124, 15, 0
	 EXEC inserir_score @fase, '494', 125, 2, 1
	 EXEC inserir_score @fase, '699', 125, 3, 1
	 EXEC inserir_score @fase, '00312433', 125, 4, 1
	 EXEC inserir_score @fase, '00302100', 125, 7, 1
	 EXEC inserir_score @fase, '00342111', 125, 8, 1
	 EXEC inserir_score @fase, '110', 125, 9, 1
	 EXEC inserir_score @fase, '00213042', 125, 12, 1
	 EXEC inserir_score @fase, '00032224', 125, 14, 1
	 EXEC inserir_score @fase, '00034004', 125, 16, 1
	 EXEC inserir_score @fase, '422', 126, 1, 0
	 EXEC inserir_score @fase, '00401413', 126, 5, 0
	 EXEC inserir_score @fase, '407', 126, 6, 0
	 EXEC inserir_score @fase, '00421320', 126, 10, 0
	 EXEC inserir_score @fase, '62', 126, 11, 0
	 EXEC inserir_score @fase, '00311123', 126, 13, 0
	 EXEC inserir_score @fase, '00223204', 126, 15, 0
	 EXEC inserir_score @fase, '654', 127, 1, 0
	 EXEC inserir_score @fase, '00202213', 127, 5, 0
	 EXEC inserir_score @fase, '80', 127, 6, 0
	 EXEC inserir_score @fase, '00222434', 127, 10, 0
	 EXEC inserir_score @fase, '659', 127, 11, 0
	 EXEC inserir_score @fase, '00014023', 127, 13, 0
	 EXEC inserir_score @fase, '00023000', 127, 15, 0
	 EXEC inserir_score @fase, '408', 128, 2, 1
	 EXEC inserir_score @fase, '992', 128, 3, 1
	 EXEC inserir_score @fase, '00410221', 128, 4, 1
	 EXEC inserir_score @fase, '00221310', 128, 7, 1
	 EXEC inserir_score @fase, '00334440', 128, 8, 1
	 EXEC inserir_score @fase, '196', 128, 9, 1
	 EXEC inserir_score @fase, '00014230', 128, 12, 1
	 EXEC inserir_score @fase, '00304114', 128, 14, 1
	 EXEC inserir_score @fase, '00333040', 128, 16, 1
	 EXEC inserir_score @fase, '832', 129, 1, 0
	 EXEC inserir_score @fase, '00404223', 129, 5, 0
	 EXEC inserir_score @fase, '902', 129, 6, 0
	 EXEC inserir_score @fase, '00342323', 129, 10, 0
	 EXEC inserir_score @fase, '762', 129, 11, 0
	 EXEC inserir_score @fase, '00311431', 129, 13, 0
	 EXEC inserir_score @fase, '00203023', 129, 15, 0
	 EXEC inserir_score @fase, '312', 130, 2, 1
	 EXEC inserir_score @fase, '364', 130, 3, 1
	 EXEC inserir_score @fase, '00221211', 130, 4, 1
	 EXEC inserir_score @fase, '00004400', 130, 7, 1
	 EXEC inserir_score @fase, '00134311', 130, 8, 1
	 EXEC inserir_score @fase, '418', 130, 9, 1
	 EXEC inserir_score @fase, '00010333', 130, 12, 1
	 EXEC inserir_score @fase, '00104024', 130, 14, 1
	 EXEC inserir_score @fase, '00444441', 130, 16, 1
	 EXEC inserir_score @fase, '760', 131, 2, 1
	 EXEC inserir_score @fase, '906', 131, 3, 1
	 EXEC inserir_score @fase, '00333241', 131, 4, 1
	 EXEC inserir_score @fase, '00332001', 131, 7, 1
	 EXEC inserir_score @fase, '00234010', 131, 8, 1
	 EXEC inserir_score @fase, '518', 131, 9, 1
	 EXEC inserir_score @fase, '00001221', 131, 12, 1
	 EXEC inserir_score @fase, '00244224', 131, 14, 1
	 EXEC inserir_score @fase, '00404133', 131, 16, 1
	 EXEC inserir_score @fase, '893', 132, 2, 1
	 EXEC inserir_score @fase, '728', 132, 3, 1
	 EXEC inserir_score @fase, '00112410', 132, 4, 1
	 EXEC inserir_score @fase, '00301313', 132, 7, 1
	 EXEC inserir_score @fase, '00444331', 132, 8, 1
	 EXEC inserir_score @fase, '401', 132, 9, 1
	 EXEC inserir_score @fase, '00010400', 132, 12, 1
	 EXEC inserir_score @fase, '00424300', 132, 14, 1
	 EXEC inserir_score @fase, '00000224', 132, 16, 1
	 EXEC inserir_score @fase, '526', 133, 1, 0
	 EXEC inserir_score @fase, '00334322', 133, 5, 0
	 EXEC inserir_score @fase, '709', 133, 6, 0
	 EXEC inserir_score @fase, '00111112', 133, 10, 0
	 EXEC inserir_score @fase, '933', 133, 11, 0
	 EXEC inserir_score @fase, '00323112', 133, 13, 0
	 EXEC inserir_score @fase, '00004213', 133, 15, 0
	 EXEC inserir_score @fase, '125', 134, 1, 0
	 EXEC inserir_score @fase, '00324040', 134, 5, 0
	 EXEC inserir_score @fase, '980', 134, 6, 0
	 EXEC inserir_score @fase, '00142122', 134, 10, 0
	 EXEC inserir_score @fase, '744', 134, 11, 0
	 EXEC inserir_score @fase, '00231310', 134, 13, 0
	 EXEC inserir_score @fase, '00424101', 134, 15, 0
	 EXEC inserir_score @fase, '522', 135, 2, 1
	 EXEC inserir_score @fase, '958', 135, 3, 1
	 EXEC inserir_score @fase, '00404141', 135, 4, 1
	 EXEC inserir_score @fase, '00111341', 135, 7, 1
	 EXEC inserir_score @fase, '00014100', 135, 8, 1
	 EXEC inserir_score @fase, '971', 135, 9, 1
	 EXEC inserir_score @fase, '00110210', 135, 12, 1
	 EXEC inserir_score @fase, '00203433', 135, 14, 1
	 EXEC inserir_score @fase, '00431430', 135, 16, 1
	 EXEC inserir_score @fase, '912', 136, 2, 1
	 EXEC inserir_score @fase, '885', 136, 3, 1
	 EXEC inserir_score @fase, '00024343', 136, 4, 1
	 EXEC inserir_score @fase, '00304212', 136, 7, 1
	 EXEC inserir_score @fase, '00404014', 136, 8, 1
	 EXEC inserir_score @fase, '635', 136, 9, 1
	 EXEC inserir_score @fase, '00431103', 136, 12, 1
	 EXEC inserir_score @fase, '00122321', 136, 14, 1
	 EXEC inserir_score @fase, '00041100', 136, 16, 1
	 EXEC inserir_score @fase, '748', 137, 1, 0
	 EXEC inserir_score @fase, '00300420', 137, 5, 0
	 EXEC inserir_score @fase, '487', 137, 6, 0
	 EXEC inserir_score @fase, '00240124', 137, 10, 0
	 EXEC inserir_score @fase, '269', 137, 11, 0
	 EXEC inserir_score @fase, '00214114', 137, 13, 0
	 EXEC inserir_score @fase, '00122211', 137, 15, 0
	 EXEC inserir_score @fase, '539', 138, 2, 1
	 EXEC inserir_score @fase, '337', 138, 3, 1
	 EXEC inserir_score @fase, '00411401', 138, 4, 1
	 EXEC inserir_score @fase, '00300102', 138, 7, 1
	 EXEC inserir_score @fase, '00313131', 138, 8, 1
	 EXEC inserir_score @fase, '69', 138, 9, 1
	 EXEC inserir_score @fase, '00043234', 138, 12, 1
	 EXEC inserir_score @fase, '00323410', 138, 14, 1
	 EXEC inserir_score @fase, '00333442', 138, 16, 1
	 EXEC inserir_score @fase, '590', 139, 2, 1
	 EXEC inserir_score @fase, '696', 139, 3, 1
	 EXEC inserir_score @fase, '00001442', 139, 4, 1
	 EXEC inserir_score @fase, '00123000', 139, 7, 1
	 EXEC inserir_score @fase, '00204004', 139, 8, 1
	 EXEC inserir_score @fase, '633', 139, 9, 1
	 EXEC inserir_score @fase, '00201442', 139, 12, 1
	 EXEC inserir_score @fase, '00314341', 139, 14, 1
	 EXEC inserir_score @fase, '00431031', 139, 16, 1
END
GO

CREATE PROCEDURE popular_score_final (@fase INT)
AS
BEGIN
END
GO

-- DISCARD LATER 

EXEC popular_score 0



SELECT	* FROM	score
DELETE FROM score

SELECT * FROM f_melhores(0, 1)