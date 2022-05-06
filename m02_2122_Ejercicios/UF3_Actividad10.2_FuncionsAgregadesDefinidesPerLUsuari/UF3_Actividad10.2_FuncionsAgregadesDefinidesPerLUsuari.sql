USE uf2_p2_pizzeria;

-- Tasca 1. Volem crear una funció anomenada getSumaEnters qeu realitzi les funcions de SUM per valors enters.

DELIMITER //
CREATE OR REPLACE AGGREGATE FUNCTION getSumaEnters(n INT) RETURNS INT
BEGIN
	DECLARE suma INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND RETURN suma;
		LOOP
			FETCH GROUP NEXT ROW;
            IF N THEN
				SET suma = suma + n;
			END IF;
		END LOOP;
END //
DELIMITER ;

DROP FUNCTION getSumaEnters;

SELECT getSumaEnters(111);

SELECT getSumaEnters(id_producte)
	FROM producte;
    
SELECT getSumaEnters(quantitat)
	FROM comanda_producte;

-- Tasca 2. Volem crear una funció anomenada getRestaEnters que realitzi les funcions de SUM pero restan els valors enters.

DELIMITER //
CREATE OR REPLACE AGGREGATE FUNCTION getRestaEnters(n INT) RETURNS INT
BEGIN
	DECLARE resta INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND RETURN resta;
		LOOP
			FETCH GROUP NEXT ROW;
            IF n THEN
				SET resta = resta - n;
			END IF;
        END LOOP;
END //
DELIMITER ;

DROP FUNCTION getRestaEnters;

SELECT getRestaEnters(preu)
	FROM producte
    ORDER BY preu DESC;
    

-- Tasca 3. Volem crear una funció anomenada getMinEnters que realitzi les funcions de MIN per valors enters.

