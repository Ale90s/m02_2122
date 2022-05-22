
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


/* A PARTIR DE AQUI SOLUCIONES JOSE */
-- Tasca 2. Crea els disparadors que compti els registres de la taula prova, tant si inserim com si esborrem,
--  i crea un registre amb aquest nombre a la taula suma.
DELIMITER //
CREATE TRIGGER trgAIns_prova_compta AFTER INSERT ON prova FOR EACH ROW
BEGIN
	INSERT INTO suma (SELECT COUNT(*) FROM prova);
END //

CREATE TRIGGER trgADel_prova_compta AFTER DELETE ON prova FOR EACH ROW
BEGIN
	INSERT INTO suma (SELECT COUNT(*) FROM prova);
END //
DELIMITER ;

SELECT * FROM prova;
SELECT * FROM suma;
INSERT INTO prova (codi) VALUES (1);
SELECT * FROM prova;
SELECT * FROM suma;
INSERT INTO prova (codi) VALUES (2);
SELECT * FROM prova;
SELECT * FROM suma;

DROP TRIGGER trgAIns_prova_compta;
DROP TRIGGER trgADel_prova_compta;


-- Tasca 3. Crea un disparador que cada vegada que inserim un registre a la taula prova,
-- introdueixi el valor a la taula suma_text amb el signe + davant.
-- Així si a la taula prova tenim els valors 1, 2 i 3, a la taula suma_text hi haurà un camp de text amb valor 1+2+3.
DELIMITER //
CREATE TRIGGER trgBIns_prova_afegirsuma_text BEFORE INSERT ON prova FOR EACH ROW
BEGIN
	IF ((SELECT COUNT(*) FROM prova) = 0) THEN
		INSERT INTO suma_text VALUES (NEW.codi);
	ELSE
		UPDATE suma_text SET suma = CONCAT(suma, '+', NEW.codi);
	END IF;
END //
DELIMITER ;

DELETE FROM prova;
SELECT * FROM prova;
SELECT * FROM suma_text;
INSERT INTO prova (codi) VALUES (5);
SELECT * FROM prova;
SELECT * FROM suma_text;
INSERT INTO prova (codi) VALUES (6);
SELECT * FROM prova;
SELECT * FROM suma_text;

DROP TRIGGER trgBIns_prova_afegirsuma_text;

-- Tasca 4. Creem una taula anomenada prova_log que té tres camps (hora i data, usuari, acció). 
-- Crea un disparador que faci un registre de tots els canvis que fem a la taula prova,
-- tant sigui inserir, esborrar o modificar. Així si fem gestions a la taula prova escriuria a prova_log, per exemple:
-- 	2012/05/16 16:04:23		root@localhost		Inserció 3
-- 	2012/05/16 16:08:12		root@localhost		Eliminació 3
-- 	2012/05/16 16:09:15		carles@localhost	Canvi 4>3
CREATE TABLE prova_log(
	data TIMESTAMP,
	usuari VARCHAR(50),
	accio VARCHAR(50)
);

DELETE FROM prova;

DELIMITER //
CREATE TRIGGER trgAIns_prova_crealog AFTER INSERT ON prova FOR EACH ROW
BEGIN
	INSERT INTO prova_log VALUES (NOW(), USER(), CONCAT('Inserció ', NEW.codi));
END //

CREATE TRIGGER trgADel_prova_crealog AFTER DELETE ON prova FOR EACH ROW
BEGIN
	INSERT INTO prova_log VALUES (NOW(), USER(), CONCAT('Eliminació ', OLD.codi));
END //

CREATE TRIGGER trgAUpd_prova_crealog AFTER UPDATE ON prova FOR EACH ROW
BEGIN
	INSERT INTO prova_log VALUES (NOW(), USER(), CONCAT('Canvi ', OLD.codi, '>', NEW.codi));
END //
DELIMITER ;

SELECT * FROM prova;
SELECT * FROM prova_log;
INSERT INTO prova (codi) VALUES (1);
SELECT * FROM prova;
SELECT * FROM prova_log;
INSERT INTO prova (codi) VALUES (2);
SELECT * FROM prova;
SELECT * FROM prova_log;
DELETE FROM prova WHERE codi = 1;
SELECT * FROM prova;
SELECT * FROM prova_log;
UPDATE prova SET codi = 3 WHERE codi = 2;
SELECT * FROM prova;
SELECT * FROM prova_log;

DROP TRIGGER trgAIns_prova_crealog;
DROP TRIGGER trgADel_prova_crealog;
DROP TRIGGER trgAUpd_prova_crealog;

-- Tasca 5. Suposem que els valors introduïts a la taula prova només poden ser valors de 1 a 10.
-- Crea una taula anomenada suma_valors amb dos camps (codi i vegades) que comptarà les vegades que surt el codi a la taula prova.
-- Crea el disparador que faci el recompte per valors del 1 al 10 quan creieu oportú.
CREATE TABLE suma_valors(
	codi INT,
	vegades INT
);

DELETE FROM prova;

DELIMITER //
CREATE TRIGGER trgAIns_prova_suma_valors AFTER INSERT ON prova FOR EACH ROW
BEGIN
	IF ((SELECT vegades FROM suma_valors WHERE codi = NEW.codi) IS NULL) THEN
	-- o IF ((SELECT COUNT(*) FROM suma_valors WHERE codi=NEW.codi)=0) THEN
		INSERT INTO suma_valors VALUES (NEW.codi, 1);
	ELSE
		UPDATE suma_valors
        SET vegades = vegades + 1 WHERE codi = NEW.codi;
	END IF;
END //

CREATE TRIGGER trgAUpd_prova_suma_valors AFTER UPDATE ON prova FOR EACH ROW
BEGIN
	IF ((SELECT codi FROM prova WHERE codi = OLD.codi) IS NULL) THEN
		DELETE FROM suma_valors WHERE codi = OLD.codi;
	ELSE
		UPDATE suma_valors
        SET vegades = vegades - 1 WHERE codi = OLD.codi;
	END IF;
	IF ((SELECT vegades FROM suma_valors WHERE codi = NEW.codi) IS NULL) THEN
		INSERT INTO suma_valors VALUES (NEW.codi, 1);
	ELSE
		UPDATE suma_valors
        SET vegades = vegades + 1 WHERE codi = NEW.codi;
	END IF;
END //

CREATE TRIGGER trgADel_prova_suma_valors AFTER DELETE ON prova FOR EACH ROW
BEGIN
	IF ((SELECT codi FROM prova WHERE codi = OLD.codi) IS NULL) THEN
		DELETE FROM suma_valors WHERE codi = OLD.codi;
	ELSE
		UPDATE suma_valors
        SET vegades = vegades - 1 WHERE codi = OLD.codi;
	END IF;
END //
DELIMITER ;

SELECT * FROM prova;
SELECT * FROM suma_valors;
INSERT INTO prova (codi) VALUES (1);
INSERT INTO prova (codi) VALUES (1);
SELECT * FROM prova;
SELECT * FROM suma_valors;
INSERT INTO prova (codi) VALUES (2);
INSERT INTO prova (codi) VALUES (2);
SELECT * FROM prova;
SELECT * FROM suma_valors;
INSERT INTO prova (codi) VALUES (4);
INSERT INTO prova (codi) VALUES (5);
SELECT * FROM prova;
SELECT * FROM suma_valors;
DELETE FROM prova WHERE codi = 4;
SELECT * FROM prova;
SELECT * FROM suma_valors;
UPDATE prova SET codi = 3 WHERE codi = 2;
SELECT * FROM prova;
SELECT * FROM suma_valors;

DROP TRIGGER trgAIns_prova_suma_valors;
DROP TRIGGER trgADel_prova_suma_valors;
DROP TRIGGER trgAUpd_prova_suma_valors;


-- Tasca 6. Crea una taula prova_puntuacio amb dos camps (un camp lletra que serà A, B, C, D o E, 
-- un valor numèric anomenat puntuacio que serà un enter de 1 a 10).
-- Crea un disparador posi en una taula anomenada prova_puntuacio_seg l'últim valor de cada lletra 
-- introduït i la seva puntuació (pensa que a la taula prova_puntuació_seg sempre hi haurà 5 registres màxim que 
-- seran l'últim registre de cada lletra introduït).
CREATE TABLE prova_puntuacio(
	lletra ENUM('A','B','C','D','E'),
	puntuacio INT
);
CREATE TABLE prova_puntuacio_seg(
	lletra ENUM('A','B','C','D','E'),
	puntuacio INT
);

DELIMITER //
CREATE TRIGGER trgAIns_prova_puntuacio_ultimavalor AFTER INSERT ON prova_puntuacio FOR EACH ROW
BEGIN
	IF ((SELECT COUNT(*) FROM prova_puntuacio_seg pps WHERE pps.lletra LIKE NEW.lletra) = 0) THEN
		INSERT INTO prova_puntuacio_seg VALUES (NEW.lletra, NEW.puntuacio);
	ELSE
		UPDATE prova_puntuacio_seg pps
        SET pps.puntuacio = NEW.puntuacio WHERE lletra = NEW.lletra;
	END IF;
END //
DELIMITER ;

SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;
INSERT INTO prova_puntuacio (lletra, puntuacio) VALUES ('A', 5);
SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;
INSERT INTO prova_puntuacio (lletra, puntuacio) VALUES ('B', 6);
SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;
INSERT INTO prova_puntuacio (lletra, puntuacio) VALUES ('C', 7);
SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;
INSERT INTO prova_puntuacio (lletra, puntuacio) VALUES ('A', 8);
SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;

DROP TRIGGER trgAIns_prova_puntuacio_ultimavalor;


-- Tasca 7. Crea un disparador de manera que a la taula prova_puntuacio_seg compti les puntuacions total
-- per cada lletra (hi haurà 5 registres màxim amb la puntuació total de cadascuna).
DELIMITER //
CREATE TRIGGER trgAIns_prova_puntuacio_total AFTER INSERT ON prova_puntuacio FOR EACH ROW
BEGIN
	IF ((SELECT COUNT(*) FROM prova_puntuacio_seg pps WHERE pps.lletra LIKE NEW.lletra) =0) THEN
		INSERT INTO prova_puntuacio_seg VALUES (NEW.lletra, NEW.puntuacio);
	ELSE
		UPDATE prova_puntuacio_seg pps
        SET pps.puntuacio = pps.puntuacio + NEW.puntuacio 
		WHERE lletra = NEW.lletra;
	END IF;
END //
DELIMITER ;

DELETE from prova_puntuacio;
DELETE from prova_puntuacio_seg;

SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;
INSERT INTO prova_puntuacio (lletra, puntuacio) VALUES ('A', 5);
SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;
INSERT INTO prova_puntuacio (lletra, puntuacio) VALUES ('B', 6);
SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;
INSERT INTO prova_puntuacio (lletra, puntuacio) VALUES ('C', 7);
SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;
INSERT INTO prova_puntuacio (lletra, puntuacio) VALUES ('A', 8);
SELECT * from prova_puntuacio;
SELECT * from prova_puntuacio_seg;

DROP TRIGGER trgAIns_prova_puntuacio_total;
