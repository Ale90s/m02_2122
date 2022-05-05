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
	IF(opcio = "apte") THEN
		RETURN "A";
	ELSEIF(opcio = "no apte") THEN
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



-- Tasca 3. 
/*
Crea una funció anomenada getTornByHora que segons l'hora que li introduïm ens digui torn de 'matí' 
(si és una hora entre les 8 i les 15) o torn de 'tarda' (si és una hora entre les 16 i les 22). 
En cas que no sigui cap d'aquest que escrigui un guió '-'.
*/



-- Tasca 4. Crea una funció anomenada getNomComplet de manera que retorni el nom i els cognoms concatenats 
-- en el mateix camp.



-- Tasca 5. Crea una funció anomenada getConversioDolars, 
-- de manera que retorni el valor en Dòlars d'un import en Euros, on 1€ = 1,08 $.



-- Tasca 6. Crea una funció anomenada getValorAbsolut de manera que sumi dos valors enters en valor absolut.
