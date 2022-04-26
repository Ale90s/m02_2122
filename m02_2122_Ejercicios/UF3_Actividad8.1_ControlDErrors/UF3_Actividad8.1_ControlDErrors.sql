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

-- Tasca 2. Crea un procediment que copiï les comandes en una taula anomenada comandes_ANY 
-- ( on ANY corresponen l’any de la data d’un paràmetre d’entrada), només copiarem totes aquelles comandes que corresponen 
-- a aquest ANY. Si la taula no existeix, fes que es generi a partir del procediment de la Tasca 1. Alhora, sí aquella data 
-- és de l’any actual, avisa a l’usuari que l’any està en curs i no es pot copiar la informació amb un paràmetre de sortida.



-- Tasca 3. Crea un procediment anomenat getTotalComandesCopiaByAny que donat un nombre que correspon a un any, 
-- ens mostri el nombre de comandes que s'han fet en aquest any. Per tant, per comptar aquestes comandes s’ha d’usar la 
-- taula corresponent a comandes_ANY (gestionada anteriorment). Tingues en compte que si no s'ha realitzat cap còpia de 
-- comandes ha de mostrar 0.

