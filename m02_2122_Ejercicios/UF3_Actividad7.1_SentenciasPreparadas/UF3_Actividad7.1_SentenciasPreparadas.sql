-- Tasca 1. Nou procediment tasca 1 Actividad 5.2. Procediments amb paràmetres.

DELIMITER //
CREATE OR REPLACE PROCEDURE incrementPreu(in increment DECIMAL(5,3))
BEGIN
	
    -- DECLARE incrementDecimal DECIMAL(5,3);
    -- SET incrementDecimal = increment; POR QUÉ NO FUNCIONA CON ESTE TIPO DE VARIABLES?
    SET @tasca1 = increment;
    
	PREPARE tasca1 
	FROM 'UPDATE producte p
			SET preu = preu + TRUNCATE((preu * @tasca1), 2)';
    
    EXECUTE tasca1;

	DEALLOCATE PREPARE tasca1;
	
END //
DELIMITER ;

CALL incrementPreu(0.015);

-- Tasca 2. Nou procediment tasca 7 Actividad 5.2. Procediments amb paràmetres.

DELIMITER //
CREATE OR REPLACE PROCEDURE tasca2(IN pNumero SMALLINT(6), OUT pQuantitatProductes SMALLINT)
BEGIN
	
    SET @numero = pNumero;
    
	PREPARE tasca2 
		FROM 'SELECT COUNT(*) INTO @salida
				FROM comanda_producte cp 
				WHERE cp.numero = @numero;';            
                
	EXECUTE tasca2;
    
    SET pQuantitatProductes = @salida;
    
    DEALLOCATE PREPARE tasca2;
    
END //
DELIMITER ;

CALL tasca2(@numeroTasca2, @cantidad);

SELECT @salida;

-- Tasca 3. Nou procediment tasca 4 Actividad 6.1. Programació amb IF.

DELIMITER //
CREATE OR REPLACE PROCEDURE tasca3(IN pNom VARCHAR(20), IN pCognoms VARCHAR(40))
BEGIN
	
    SET @nombre = pNom;
    SET @apellidos = pCognoms;
    
    PREPARE tasca3 
		FROM 
        'IF (@nombre IS NOT NULL AND @apellidos IS NOT NULL) THEN -- Cerca per nom i cognoms
			SELECT *
			FROM empleat
			WHERE nom LIKE @nombre AND cognoms LIKE @apellidos;
		ELSEIF (@nombre IS NULL AND @apellidos IS NOT NULL) THEN -- Cerca per cognoms
			SELECT *
			FROM empleat
			WHERE cognoms LIKE @apellidos;
		ELSEIF (@nombre IS NOT NULL AND @apellidos IS NULL) THEN -- Cerca per nom
			SELECT *
			FROM empleat
			WHERE nom LIKE @nombre;
		ELSE  -- Cerca tots
			SELECT *
			FROM empleat;
		END IF;';
        
	EXECUTE tasca3;
    
    DEALLOCATE PREPARE tasca3;

END //
DELIMITER ;

CALL tasca3(NULL, NULL);
CALL tasca3(NULL, "Casas");
CALL tasca3("Marta", NULL);

-- Tasca 4. Nou procediment tasca 9 Actividad 6.1. Programació amb IF.


DELIMITER //
CREATE OR REPLACE PROCEDURE tasca4(IN pId_reunio SMALLINT, IN pOpcio ENUM('W', 'D', 'M', 'Y'))
BEGIN

	SET @opcion = pOpcio;
    SET @id = pId_reunio;
	
    PREPARE tasca4 
		FROM 
        'IF (@opcion = ''W'') THEN
			UPDATE reunio
			SET data = ADDDATE(data,  INTERVAL 1 WEEK)
			WHERE id_reunio = @id;
		ELSEIF (@opcion = ''D'') THEN
			UPDATE reunio 
			SET data = ADDDATE(data,  INTERVAL 1 DAY)
			WHERE id_reunio = @id;
		ELSEIF (@opcion = ''M'') THEN
			UPDATE reunio 
			SET data = ADDDATE(data,  INTERVAL 1 MONTH)
			WHERE id_reunio = @id;
		ELSEIF (@opcion = ''Y'') THEN
			UPDATE reunio 
			SET data = ADDDATE(data,  INTERVAL 1 YEAR)
			WHERE id_reunio = @id;
		END IF;';
    
    EXECUTE tasca4;
    
    DEALLOCATE PREPARE tasca4;
	
END //
DELIMITER ;

SELECT *
FROM reunio;
CALL tasca4(5, 'D');
CALL tasca4(6, 'W');
CALL tasca4(7, 'M');
CALL tasca4(8, 'Y');


-- Tasca 5. Nou procediment tasca 5 Actividad 6.2. Programació amb CASE.


-- Tasca 5. Retorna per paràmetre la quantitat d'ingredients que té un producte en concret a partir del seu identificador. Els productes que no són pizzes en si mateixos són un únic ingredient.
-- DROP PROCEDURE getQuantitatIngredientsByProducte;
DELIMITER //
CREATE OR REPLACE PROCEDURE getQuantitatIngredientsByProducte(IN pId_producte SMALLINT(6), OUT pQuantitat SMALLINT)
BEGIN
	
    SET @sortida = 0;
    SET @id = pId_producte;
    
    PREPARE tasca5
		FROM 
		'IF (@id IS NOT NULL) THEN
			SELECT count(*) INTO @sortida
			FROM producte p
				LEFT JOIN postre po ON p.id_producte = po.id_producte
				LEFT JOIN beguda be ON p.id_producte = be.id_producte
				LEFT JOIN pizza pz ON p.id_producte = pz.id_producte
				LEFT JOIN pizza_ingredient pi ON pz.id_producte = pi.id_producte
			WHERE p.id_producte = @id
			GROUP BY p.id_producte;
		END IF;';
	
    EXECUTE tasca5;
    
    SET pQuantitat = @sortida;
    
    DEALLOCATE PREPARE tasca5;
    
END //
DELIMITER ;

CALL getQuantitatIngredientsByProducte(1, @quantitat);
SELECT CONCAT(@quantitat, ' ingredient/es');
CALL getQuantitatIngredientsByProducte(2, @quantitat);
SELECT CONCAT(@quantitat, ' ingredient/es');
CALL getQuantitatIngredientsByProducte(8, @quantitat);
SELECT CONCAT(@quantitat, ' ingredient/es');
CALL getQuantitatIngredientsByProducte(NULL, @quantitat);
SELECT CONCAT(@quantitat, ' ingredient/es');
