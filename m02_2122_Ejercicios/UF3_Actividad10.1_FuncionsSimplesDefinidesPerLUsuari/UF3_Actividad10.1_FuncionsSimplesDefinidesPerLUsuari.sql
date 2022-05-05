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
