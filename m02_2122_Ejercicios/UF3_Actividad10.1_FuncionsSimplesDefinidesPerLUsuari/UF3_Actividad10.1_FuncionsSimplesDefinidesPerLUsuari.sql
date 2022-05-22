USE uf2_p2_pizzeria;

-- Tasca 1. 
/*
Volem crear una funció anomenada getDescripcioQualificacio, on ha partir d’un parametre tipus string variable,
sí s’envia amb valor 'apte' retorni una 'A', en cas de 'no apte' retorni 'NA', per totes les altres posibles 
opcions retornarà 'NS/NC'.
*/

DELIMITER //
CREATE OR REPLACE FUNCTION getDescripcioQualificacio (opcio VARCHAR(15))
RETURNS VARCHAR(5)
	IF (opcio = "apte") THEN
		RETURN "A";
	ELSEIF (opcio = "no apte") THEN
		RETURN "NA";
	ELSE
		RETURN "NS/NC";
	END IF;
END //
DELIMITER ;

SELECT getDescripcioQualificacio("Opcio no valida");
SELECT getDescripcioQualificacio("apte");
SELECT getDescripcioQualificacio("no apte");

DROP FUNCTION getDescripcioQualificacio;

-- Tasca 2. Crea una funció anomenada getApteByNota que retorni el valor 'apte' 
-- si escrivim una nota que és superior a 5, i 'no apte' en cas contrari.

DELIMITER //
CREATE OR REPLACE FUNCTION getApteByNota (nota INT)
RETURNS VARCHAR(10)
	IF (nota > 5) THEN
		RETURN "apte";
	ELSE
		RETURN "no apte";
	END IF;
END //
DELIMITER ;

SELECT getApteByNota(7);
SELECT getApteByNota(5);

-- Tasca 3. 
/*
Crea una funció anomenada getTornByHora que segons l'hora que li introduïm ens digui torn de 'matí' 
(si és una hora entre les 8 i les 15) o torn de 'tarda' (si és una hora entre les 16 i les 22). 
En cas que no sigui cap d'aquest que escrigui un guió '-'.
*/

DELIMITER //
CREATE OR REPLACE FUNCTION getTornByHora (hora INT)
RETURNS VARCHAR(5)

	IF (hora >= 8 AND hora <= 15) THEN
		RETURN "matí";
	ELSEIF (hora >= 16 AND hora <= 22) THEN
		RETURN "tarda";
	ELSE 
		RETURN "-";
	END IF;
    
END //
DELIMITER ;

SELECT getTornByHora(5);
SELECT getTornByHora(10);
SELECT getTornByHora(20);

-- Tasca 4. Crea una funció anomenada getNomComplet de manera que retorni el nom i els cognoms concatenats 
-- en el mateix camp.

DELIMITER //
CREATE OR REPLACE FUNCTION getNomComplet (nombre VARCHAR(15), apellidos VARCHAR(50))
RETURNS VARCHAR(65)

	IF (nombre IS NULL OR apellidos IS NULL) THEN
		RETURN "La persona debe tener nombre y apellido";
	ELSE
		RETURN CONCAT(nombre, " ", apellidos);
	END IF;
    
END //
DELIMITER ;

SELECT getNomComplet ("Pepe", "Rodriguez Sanchez");
SELECT getNomComplet (NULL, "Rodriguez Sanchez");

-- Tasca 5. Crea una funció anomenada getConversioDolars, 
-- de manera que retorni el valor en Dòlars d'un import en Euros, on 1€ = 1,08 $.

DELIMITER //
CREATE OR REPLACE FUNCTION getConversioDolars (importEnEuros DECIMAL(5, 2))
RETURNS DECIMAL(5, 2)

    RETURN (importEnEuros * 1.08);

END //
DELIMITER ;

SELECT getConversioDolars (50);
SELECT getConversioDolars (134);
SELECT getConversioDolars (1);

-- Tasca 6. Crea una funció anomenada getValorAbsolut de manera que sumi dos valors enters en valor absolut.

DELIMITER //
CREATE OR REPLACE FUNCTION getValorAbsolut (n1 INT, n2 INT)
RETURNS INT

	RETURN (n1 + n2);

END //
DELIMITER ;

SELECT getValorAbsolut(2, 3);
SELECT getValorAbsolut(1324, 44);
SELECT getValorAbsolut(953, 78);


/* A PARTIR DE AQUI SOLUCIONES DE JOSE */
-- Tasca 7. Crea una funció anomenada getImportAmbIva de manera que calculi el preu amb IVA,
-- d'un import què nosaltres li donem sense IVA. 
DELIMITER //
CREATE FUNCTION getImportAmbIva(pImport DECIMAL(6,2))
RETURNS DECIMAL(6,2)
BEGIN
	RETURN pImport * 1.21;
	-- o 
    -- RETURN pImport + ((pImport * 21)/100);
END //
DELIMITER ;

SELECT getImportAmbIva(100.23);

-- Tasca 8. Crea una funció anomenada getEdat de manera que calculi l'edat d'un individu. 
-- La data de naixement la donarem en 3 paràmetres: dia, mes i any. 
DELIMITER //
CREATE FUNCTION getEdat(pDia SMALLINT, pMes SMALLINT, pAny SMALLINT)
RETURNS SMALLINT
BEGIN
	DECLARE vData DATE;
    
	SET vData = CONCAT(pAny,'/', pMes,'/', pDia);
	RETURN TIMESTAMPDIFF(YEAR, vData, NOW());
END //
DELIMITER ;

SELECT getEdat(9,4,1993), getEdat(11,5,1993);

-- Tasca 9. Crea una funció anomenada getDataEsByUs que, donada una data en format AAAA/MM/DD, ens la retorni un varchar en format DD/MM/AAAA.
DELIMITER // 
CREATE FUNCTION getDataEsByUs(pData DATE)
RETURNS VARCHAR(10) 
BEGIN 
	RETURN CONCAT(DAY(pData), '/', MONTH(pData), '/', YEAR(pData)); 
	-- o
    -- RETURN DATE_FORMAT(par_data,'%d/%m/%Y');
END // 
DELIMITER ; 

SELECT getDataEsByUs('2020/05/25');

-- Tasca 10. Crea una funció anomenada getDataUsByES que, donada una data tipus varchar en format DD/MM/AAAA, ens la retorni en format AAAA/MM/DD.
DELIMITER // 
CREATE OR REPLACE FUNCTION getDataUsByES(pData VARCHAR(10))
RETURNS DATE 
BEGIN 
	RETURN CONCAT(SUBSTRING(pData, 7, 4), '/', SUBSTRING(pData, 4, 2), '/', SUBSTRING(pData, 1, 2));
	-- o
    -- RETURN STR_TO_DATE(pData, '%d/%m/%Y'); 
END // 
DELIMITER ; 

SELECT getDataUsByES('25/05/2020'); 

-- Tasca 11. Crea una funció anomenada diffDates de manera que donat dues dates i un paràmetre (d, m o a), 
-- ens retorni la diferència de dies, mesos o anys, segons el paràmetre que s'hagi escollit (d dies, m mesos o a anys).
-- Versió 1
DELIMITER // 
CREATE OR REPLACE FUNCTION diffDates(pData1 DATE, pData2 DATE, pFrequencia VARCHAR(1)) 
RETURNS INT 
BEGIN 
	CASE pFrequencia 
	WHEN 'd' THEN 
		RETURN TIMESTAMPDIFF(DAY, pData1, pData2);
	WHEN 'm' THEN 
		RETURN TIMESTAMPDIFF(MONTH, pData1, pData2);
	WHEN 'a' THEN 
		RETURN TIMESTAMPDIFF(YEAR, pData1, pData2);
	END CASE;
END //
DELIMITER ;
/* o
DELIMITER // 
CREATE OR REPLACE FUNCTION diffDates(pData1 DATE, pData2 DATE, pFrequencia VARCHAR(1)) 
RETURNS INT 
BEGIN 
	DECLARE vData DATE DEFAULT pData1;
	DECLARE vReturn INT DEFAULT 0;
	CASE pFrequencia 
	WHEN 'd' THEN 
	   RETURN DATEDIFF(pData2, pData1); 
	WHEN 'm' THEN 
		WHILE (vData < pData2) DO
			SET vData := DATE_ADD(vData, INTERVAL 1 MONTH);
			SET vReturn := vReturn + 1;
		END WHILE;
		RETURN var_return;
	WHEN 'a' THEN 
		WHILE (vData < pData2) DO
			SET vData := DATE_ADD(vData, INTERVAL 1 YEAR);
			SET vReturn := vReturn + 1;
		END WHILE;
		RETURN vReturn;
	END CASE; 
END // 
DELIMITER ; 
*/
SELECT diffDates('2012/05/12', '2012/06/25', 'd'); 


-- Tasca 12. Crea una funció anomenada getDataLlengua de manera que donada una data,
-- ens retorni la data en text especificant el dia de la setmana.
-- Per exemple si indiquem '2012/05/14', retornarà 'dilluns catorze de maig del dos mil dotze'. 
-- Per limitar-ho l'any serà del 2011 al 2020.
DELIMITER // 
CREATE OR REPLACE FUNCTION getDataLlengua(pData DATE) 
RETURNS VARCHAR(70) 
BEGIN 

	DECLARE vDiaSetmana VARCHAR(9); 
	DECLARE vDiaMes VARCHAR(15); 
	DECLARE vMes VARCHAR(11); 
	DECLARE vAny VARCHAR(20); 

	CASE DAYOFWEEK(pData) 
		WHEN '1' THEN SET vDiaSetmana := 'diumenge'; 
		WHEN '2' THEN SET vDiaSetmana := 'dilluns'; 
		WHEN '3' THEN SET vDiaSetmana := 'dimarts'; 
		WHEN '4' THEN SET vDiaSetmana := 'dimecres'; 
		WHEN '5' THEN SET vDiaSetmana := 'dijous'; 
		WHEN '6' THEN SET vDiaSetmana := 'divendres'; 
		WHEN '7' THEN SET vDiaSetmana := 'dissabte'; 
	END CASE; 
	CASE DAYOFMONTH(pData) 
		WHEN '1' THEN SET vDiaMes :='u'; 
		WHEN '2' THEN SET vDiaMes :='dos'; 
		WHEN '3' THEN SET vDiaMes :='tres'; 
		WHEN '4' THEN SET vDiaMes :='quatre'; 
		WHEN '5' THEN SET vDiaMes :='cinc'; 
		WHEN '6' THEN SET vDiaMes :='sis'; 
		WHEN '7' THEN SET vDiaMes :='set'; 
		WHEN '8' THEN SET vDiaMes :='vuit'; 
		WHEN '9' THEN SET vDiaMes :='nou'; 
		WHEN '10' THEN SET vDiaMes :='deu'; 
		WHEN '11' THEN SET vDiaMes :='onze'; 
		WHEN '12' THEN SET vDiaMes :='dotze'; 
		WHEN '13' THEN SET vDiaMes :='tretze'; 
		WHEN '14' THEN SET vDiaMes :='catorze'; 
		WHEN '15' THEN SET vDiaMes :='quinze'; 
		WHEN '16' THEN SET vDiaMes :='setze'; 
		WHEN '17' THEN SET vDiaMes :='disset'; 
		WHEN '18' THEN SET vDiaMes :='divuit'; 
		WHEN '19' THEN SET vDiaMes :='dinou'; 
		WHEN '20' THEN SET vDiaMes :='vint'; 
		WHEN '21' THEN SET vDiaMes :='vint-i-u'; 
		WHEN '22' THEN SET vDiaMes :='vint-i-dos'; 
		WHEN '23' THEN SET vDiaMes :='vint-i-tres'; 
		WHEN '24' THEN SET vDiaMes :='vint-i-quatre'; 
		WHEN '25' THEN SET vDiaMes :='vint-i-cinc'; 
		WHEN '26' THEN SET vDiaMes :='vint-i-sis'; 
		WHEN '27' THEN SET vDiaMes :='vint-i-set'; 
		WHEN '28' THEN SET vDiaMes :='vint-i-vuit'; 
		WHEN '29' THEN SET vDiaMes :='vint-i-nou'; 
		WHEN '30' THEN SET vDiaMes :='trenta'; 
		WHEN '31' THEN SET vDiaMes :='trenta-u'; 
	END CASE; 
	CASE MONTH(pData) 
		WHEN '1' THEN SET vMes :='de gener'; 
		WHEN '2' THEN SET vMes :='de febrer'; 
		WHEN '3' THEN SET vMes :='de març'; 
		WHEN '4' THEN SET vMes :='d\'abril'; 
		WHEN '5' THEN SET vMes :='de maig'; 
		WHEN '6' THEN SET vMes :='de juny'; 
		WHEN '7' THEN SET vMes :='de juliol'; 
		WHEN '8' THEN SET vMes :='d\'agost'; 
		WHEN '9' THEN SET vMes :='de setembre'; 
		WHEN '10' THEN SET vMes :='d\'octubre'; 
		WHEN '11' THEN SET vMes :='de novembre'; 
		WHEN '12' THEN SET vMes :='de desembre'; 
	END CASE; 
	CASE YEAR(pData) 
		WHEN '2011' THEN SET vAny :='dos mil onze'; 
		WHEN '2012' THEN SET vAny :='dos mil dotze'; 
		WHEN '2013' THEN SET vAny :='dos mil tretze'; 
		WHEN '2014' THEN SET vAny :='dos mil catorze'; 
		WHEN '2015' THEN SET vAny :='dos mil quinze'; 
        WHEN '2016' THEN SET vAny :='dos mil setze'; 
        WHEN '2017' THEN SET vAny :='dos mil disset'; 
        WHEN '2018' THEN SET vAny :='dos mil divuit'; 
        WHEN '2019' THEN SET vAny :='dos mil dinou'; 
        WHEN '2020' THEN SET vAny :='dos mil vint'; 
        WHEN '2021' THEN SET vAny :='dos mil vint-i-u'; 
        WHEN '2022' THEN SET vAny :='dos mil vint-i-dos';         
	END CASE; 
    
	RETURN CONCAT(vDiaSetmana,', ', vDiaMes,' ', vMes,' de ', vAny); 
END // 
DELIMITER ;

SELECT getDataLlengua('2020/04/14'); 

-- Tasca 13. Crea una funció anomenada getAMDByDate que donada una data un paràmetre d'una lletra ('A','M' o 'D'),
-- ens retorni l'any, el mes o el dia de la data respectivament. Si el paràmetre no és cap d'aquestes lletres ha de retornar un 0.
DELIMITER //
CREATE OR REPLACE FUNCTION getAMDByDate(pData DATE, pLletra ENUM('A','M','D'))
RETURNS INT(4)
BEGIN 
	IF (pLletra = 'A') THEN
		RETURN YEAR(pData);
	ELSEIF(pLletra = 'M') THEN
		RETURN MONTH(pData);
	ELSEIF(pLletra = 'D') THEN
		RETURN DAY(pData);
	ELSE
		RETURN 0;
	END IF;
END//
DELIMITER ;

SELECT getAMDByDate('2017/05/10', 'M');
