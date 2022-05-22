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
    
/* A PARTIR DE AQUI SOLUCIONES JOSE */
-- Tasca 3. Volem crear una funció anomenada getMinEnters que realitzi les funcions de MIN per valors enters.

DELIMITER //
CREATE OR REPLACE AGGREGATE FUNCTION getMinEnters(n INT) RETURNS INT
BEGIN
	DECLARE minimo INT DEFAULT 2147483647;
	DECLARE CONTINUE HANDLER FOR NOT FOUND RETURN minimo;
	LOOP
		FETCH GROUP NEXT ROW;
        IF minimo > n THEN
			SET minimo = n;
		END IF;
	END LOOP;
END //
DELIMITER ;

SELECT getMinEnters(numero)
	FROM comanda;

-- Tasca 4. Volem crear una funció anomenada getMaxEnters que realitzi les funcions de MAX per valors enters.
DELIMITER //
CREATE OR REPLACE AGGREGATE FUNCTION getMaxEnters(pEnter INT) RETURNS INT
BEGIN
	DECLARE vMax INT;
    DECLARE vCount INT DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR NOT FOUND RETURN vMax;

	LOOP
		FETCH GROUP NEXT ROW;
        IF vCount = 0 THEN
			SET vMax = pEnter;
            SET vCount = vCount + 1;
        END iF;
        IF pEnter > vMax THEN
			SET vMax = pEnter;
		END IF;
	END LOOP;
END //
DELIMITER ;

SELECT getMaxEnters(valor)
FROM 
	(SELECT 1 AS valor
	  UNION 
	  SELECT 2
	  UNION 
	  SELECT 3
	) tValors;
    
SELECT getMaxEnters(valor)
FROM 
	(SELECT 1 AS valor
	  UNION 
	  SELECT 5
	  UNION 
	  SELECT 3
	) tValors;
    
-- Tasca 5. Volem crear una funció anomenada getAvgEnters que realitzi les funcions de AVG per valors enters.
DELIMITER //
CREATE OR REPLACE AGGREGATE FUNCTION getAvgEnters(pEnter INT) RETURNS DOUBLE
BEGIN
	DECLARE vAvg INT DEFAULT 0;
    DECLARE vCount INT DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
		IF vCount > 0 THEN
			RETURN vAvg / vCount;
		ELSE
			RETURN 0;
		END IF;
	END;

	LOOP
		FETCH GROUP NEXT ROW;
		SET vCount = vCount + 1;
		SET vAvg = vAvg + pEnter;
	END LOOP;
END //
DELIMITER ;

SELECT getAvgEnters(valor)
FROM 
	(SELECT 1 AS valor
	  UNION 
	  SELECT 2
	  UNION 
	  SELECT 3
	) tValors;
    
SELECT getAvgEnters(valor)
FROM 
	(SELECT 1 AS valor
	  UNION 
	  SELECT 7
	  UNION 
	  SELECT 3
	) tValors;
