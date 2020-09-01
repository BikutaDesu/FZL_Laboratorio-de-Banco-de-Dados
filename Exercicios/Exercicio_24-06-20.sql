-- Fazer um algoritmo que, dado 1 número, mostre se é múltiplo de 2,3,5 ou nenhum deles
DECLARE @numero INT, @i INT
SET @numero = 7
SET @i = 0

IF (@numero % 2 = 0)
BEGIN
    PRINT CAST(@numero AS VARCHAR(MAX)) + N' é multiplo de 2'
    SET @i = @i + 1
END

IF (@numero % 3 = 0)
BEGIN
    PRINT CAST(@numero AS VARCHAR(MAX)) + N' é multiplo de 3'
    SET @i = @i + 1
END

IF (@numero % 5 = 0)
BEGIN
    PRINT CAST(@numero AS VARCHAR(MAX)) + N' é multiplo de 5'
    SET @i = @i + 1
END

IF (@i = 0)
BEGIN
    PRINT CAST(@numero AS VARCHAR(MAX)) + N' não é multiplo de 2,3 e nem 5'
END


-- Fazer um algoritmo que, dados 3 números, mostre o maior e o menor
DECLARE @numero1    INT,
        @numero2    INT,
        @numero3    INT,
        @maior      INT,
        @menor      INT
SET @numero1 = 5
SET @numero2 = 2
SET @numero3 = 10

IF (@numero1 > @numero2)
BEGIN
    SET @maior = @numero1
    SET @menor = @numero2
END
ELSE
BEGIN
    SET @maior = @numero2
    SET @menor = @numero1
END

IF (@numero3 > @maior)
BEGIN
    SET @maior = @numero3
END
ELSE
BEGIN
    IF (@numero3 < @menor)
    BEGIN
        SET @menor = @numero3
    END
END

PRINT N'O maior número é: ' + CAST(@maior AS VARCHAR(MAX)) + ' e o menor: ' + CAST(@menor AS VARCHAR(MAX))


-- Fazer um algoritmo que calcule os 15 primeiros termos da série de Fibonacci
--  e a soma dos 15 primeiros termos
DECLARE @anterior   INT,
        @proximo    INT,
        @aux        INT,
        @i          INT,
        @serie      VARCHAR(MAX)
SET @anterior = 0
SET @proximo = 1
SET @i = 1
SET @serie = CONCAT(@serie, CAST(@anterior AS CHAR(1)), ', ' + CAST(@proximo AS CHAR(1)))
WHILE (@i < 15)
BEGIN
    SET @aux = @anterior
    SET @anterior = @proximo
    SET @proximo = @proximo + @aux
    SET @serie = CONCAT(@serie, ', ' + CAST(@proximo AS VARCHAR(MAX)))
    SET @i = @i + 1
END
SET @serie = CONCAT(@serie, '.')
PRINT @serie


-- Fazer um algoritmo que separa uma frase, imprimindo todas as letras em maiúsculo e,
--  depois imprimindo todas em minúsculo
DECLARE @frase              VARCHAR(100),
        @fraseMaiuscula     VARCHAR(100),
        @fraseMinuscula     VARCHAR(100),
        @i                  INT

SET @i = 1
SET @frase = 'Meu Deus, que fome!'

WHILE(@i <= LEN(@frase))
BEGIN
	SET @fraseMaiuscula = CONCAT(@fraseMaiuscula, UPPER(SUBSTRING(@frase, @i, 1)) + ' ')
	SET @i = @i + 1
END
PRINT @fraseMaiuscula
SET @i = 1
WHILE(@i <= LEN(@frase))
BEGIN
	SET @fraseMinuscula = CONCAT(@fraseMinuscula, LOWER(SUBSTRING(@frase, @i, 1)) + ' ')
	SET @i = @i + 1
END
PRINT @fraseMinuscula


-- Fazer um algoritmo que verifica, dada uma palavra, se é, ou não, palíndromo
DECLARE @frase  VARCHAR(100),
		@bool   BIT,
		@i      INT

SET @i = 1
SET @bool = 1
SET @frase = 'Saippuakivikauppias' -- Por incrível que pareça, essa palavra tem significado, é "vendedor de soda cáustica" em finlandês

WHILE(@i <= FLOOR(LEN(@frase)/2))
BEGIN
	IF (LOWER(SUBSTRING(@frase, @i, 1)) != LOWER(SUBSTRING(@frase, LEN(@frase) - (@i - 1), 1)))
	BEGIN
		SET	@bool = 0
	END
	SET @i = @i + 1
END

IF (@bool = 0)
BEGIN
	PRINT N'Não é palíndromo'
END
ELSE
BEGIN
	PRINT 'É palíndromo'
END


-- Fazer um algoritmo que, dado um CPF diga se é válido
DECLARE @cpf                        CHAR(11),
        @i                          INT,
        @j                          INT,
        @digitoCpf                  INT,
        @resultado                  INT,
        @digitoEsperado             VARCHAR(2),
        @contadorDigitosIguais      INT
SET @cpf = '22233366638'
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
        PRINT 'CPF Valido!'
    END
    ELSE
        BEGIN
           PRINT 'CPF Invalido!'
        END
END
ELSE
BEGIN
    PRINT 'CPF Invalido'
END

