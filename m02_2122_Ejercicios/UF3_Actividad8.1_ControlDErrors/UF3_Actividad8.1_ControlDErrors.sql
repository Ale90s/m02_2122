-- Tasca 1. Crea un procediment que donat un nombre que representa l’any, genera una taula com la de comandes, 
-- però amb el nom comandes_ANY (on ANY és el nombre que ens han passat com a paràmetre) si aquesta taula no existeix.

DELIMITER //
CREATE OR REPLACE PROCEDURE nomByAny(IN año INT)
BEGIN

DECLARE tasca1 
	HANDLER FOR 1146
    CREATE TABLE CONCAT(comandes_, año) (
		numero SMALLINT AUTO_INCREMENT,
		data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		domicili_local ENUM('D', 'L') NOT NULL,
		client_id SMALLINT NOT NULL,
		empleat_id SMALLINT(3) NOT NULL,
		PRIMARY KEY (numero),
    ) ENGINE = INNODB;

SELECT 1 
	FROM CONCAT(comandes_, año);

END //
DELIMITER ;

SET @var = "comandes_";

SET @var = @var + "a";
SELECT @var;

SELECT 1 
	FROM CONCAT(comandes_, año);

SELECT * FROM comanda;

/* SOLUCION JOSE */
DELIMITER //
CREATE OR REPLACE PROCEDURE taulaComandesAny(IN pAny INT(4))
BEGIN
	DECLARE EXIT HANDLER FOR 1050 BEGIN END;
	SET @sqldata = CONCAT('CREATE TABLE comanda_', pAny,
						  '(numero smallint(6) NOT NULL,
							data_hora timestamp NOT NULL,
							domicili_local enum(\'D\', \'L\') NOT NULL,
							client_id smallint(6) NOT NULL,
							empleat_id smallint(3) NOT NULL,
							PRIMARY KEY (numero)
						    ) ENGINE=InnoDB');

	PREPARE stmt_sql FROM @sqldata;
	EXECUTE stmt_sql;
	DEALLOCATE PREPARE stmt_sql;
END //
DELIMITER ;

CALL taulaComandesAny(2017);

-- Tasca 2. Crea un procediment que copiï les comandes en una taula anomenada comandes_ANY 
-- ( on ANY corresponen l’any de la data d’un paràmetre d’entrada), només copiarem totes aquelles comandes que corresponen a aquest ANY.
-- Si la taula no existeix, fes que es generi a partir del procediment de la Tasca 1. 
-- Alhora, sí aquella data és de l’any actual, avisa a l’usuari que l’any està en curs
-- i no es pot copiar la informació amb un paràmetre de sortida.

/* SOLUCION JOSE */
DELIMITER //
CREATE OR REPLACE PROCEDURE copyComandesByDate(OUT pError VARCHAR(100), pData DATE)
BEGIN
	DECLARE sqldata VARCHAR(1000);
	DECLARE CONTINUE HANDLER FOR 1146 
    BEGIN
		CALL taulaComandesAny(YEAR(pData));
        
        SET @sqldata := sqldata;  
        PREPARE stmt_sql FROM @sqldata;
	END;

    IF (YEAR(pData) = YEAR(CURDATE())) THEN
		SET pError = 'L\'any està en curs i no es pot copiar la informació';
    ELSE
		SET pError = '';
		SET sqldata = CONCAT('INSERT INTO comanda_', YEAR(pData),
								' (numero, data_hora, domicili_local, client_id, empleat_id) 
								SELECT numero, data_hora, domicili_local, client_id, empleat_id
                                FROM comanda		
								WHERE YEAR(data_hora) = ', YEAR(pData));
        SET @sqldata := sqldata;                        
		PREPARE stmt_sql FROM @sqldata;
		EXECUTE stmt_sql;
		DEALLOCATE PREPARE stmt_sql;
	END IF;
END //
DELIMITER ;

CALL copyComandesByDate(@missatge, '2017-03-10');
SELECT @missatge;

-- Tasca 3. Crea un procediment anomenat getTotalComandesCopiaByAny que donat un nombre que correspon a un any, 
-- ens mostri el nombre de comandes que s'han fet en aquest any. Per tant, per comptar aquestes comandes s’ha d’usar
--  la taula corresponent a comandes_ANY (gestionada anteriorment).
-- Tingues en compte que si no s'ha realitzat cap còpia de comandes ha de mostrar 0.

/* SOLUCION JOSE */
DELIMITER //
CREATE OR REPLACE PROCEDURE getTotalComandesCopiaByAny(IN pAny INT)
BEGIN
	DECLARE EXIT HANDLER FOR 1146 SELECT 0 AS comandes;
	SET @sqldata = CONCAT('SELECT COUNT(*) AS comanda FROM comandes_', pAny, ';');
	PREPARE stmt_sql FROM @sqldata;
	EXECUTE stmt_sql;
	DEALLOCATE PREPARE stmt_sql;
END //
DELIMITER ;

CALL getTotalComandesCopiaByAny(2017);
