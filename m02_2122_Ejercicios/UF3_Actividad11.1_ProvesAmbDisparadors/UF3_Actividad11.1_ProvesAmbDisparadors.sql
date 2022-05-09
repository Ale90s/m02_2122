
DROP DATABASE IF EXISTS proves_disparadors;
CREATE DATABASE IF NOT EXISTS proves_disparadors;
USE proves_disparadors;

CREATE TABLE prova (codi INT);
CREATE TABLE suma (suma INT);
CREATE TABLE suma_text (suma VARCHAR(200));

-- Tasca 1. Crea un disparador que quan fem una inserció a la taula prova, 
-- deixi només l'últim registre introduït a la taula suma.

INSERT INTO suma (suma) VALUES (LAST_INSERT_ID(500));
INSERT INTO suma (suma) VALUES (LAST_INSERT_ID(96));
INSERT INTO suma (suma) VALUES (LAST_INSERT_ID(31));
INSERT INTO suma (suma) VALUES (LAST_INSERT_ID(123));

DELIMITER //
CREATE OR REPLACE TRIGGER triggProva AFTER INSERT ON prova FOR EACH ROW
BEGIN
	DELETE FROM suma;
    INSERT INTO suma VALUES (NEW.codi);
END //
DELIMITER ;

INSERT INTO prova (codi) VALUES (10);

SELECT * 
	FROM suma;

-- Tasca 2. Crea els disparadors que compti els registres de la taula prova, 
-- tant si inserim com si esborrem,  i crea un registre amb aquest nombre a la taula suma.

SELECT COUNT(*)
	FROM prova;

-- Tasca 3. Crea un disparador que cada vegada que inserim un registre a la taula prova, 
-- introdueixi el valor a la taula suma_text amb el signe + davant. 
-- Així si a la taula prova tenim els valors 1, 2 i 3, a la taula suma_text hi haurà un 
-- camp de text amb valor 1+2+3.



-- Tasca 4. Creem una taula anomenada prova_log que té tres camps (hora i data, usuari, acció). 
-- Crea un disparador que faci un registre de tots els canvis que fem a la taula prova, 
-- tant sigui inserir, esborrar o modificar. Així si fem gestions a la taula prova escriuria a 
-- prova_log, per exemple:
