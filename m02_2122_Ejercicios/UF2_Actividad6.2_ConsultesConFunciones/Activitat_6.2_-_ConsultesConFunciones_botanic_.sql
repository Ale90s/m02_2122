-- Tasca 3. Base de dades del Botànic (Automatización para crear la database nueva)
DROP DATABASE IF EXISTS botanic;
CREATE DATABASE IF NOT EXISTS botanic;
USE botanic;

-- Tasca 4. Generació de taules

CREATE TABLE firma_comercial (
	id_firma_comercial	VARCHAR(15),
    PRIMARY KEY (id_firma_comercial)
) ENGINE = INNODB;

CREATE TABLE adob (
	id_adob VARCHAR(20),
    id_firma_comercial VARCHAR(15) NOT NULL,
    tipus ENUM('AI', 'LLD') NOT NULL,  #AI = ACCIO IMMEDIATA // LLD = LLARGA DURACIO
    PRIMARY KEY (id_adob),
    CONSTRAINT fk_adob_firma_comercial FOREIGN KEY (id_firma_comercial)
		REFERENCES firma_comercial (id_firma_comercial)
) ENGINE = INNODB;

CREATE TABLE estacio (
	id_estacio VARCHAR(9), # Hivern, Primavera, Estiu, Tardor
    PRIMARY KEY (id_estacio),
    CONSTRAINT ck_estacio_id_estacio CHECK (id_estacio IN ('Hivern', 'Primavera', 'Estiu', 'Tardor'))
) ENGINE = INNODB;

CREATE TABLE planta (
	id_planta VARCHAR(20),
    nom_popular VARCHAR(20) NOT NULL,
    id_estacio VARCHAR(9), # Hivern, Primavera, Estiu, Tardor
    tipus_planta ENUM('E', 'I') NOT NULL, #E = EXTERIOR, I = INTERIOR
    PRIMARY KEY (id_planta),
    CONSTRAINT fk_planta_estacio FOREIGN KEY (id_estacio)
		REFERENCES estacio (id_estacio)
) ENGINE = INNODB;

CREATE TABLE planta_interior (
	id_planta VARCHAR(20),
    ubicacio VARCHAR(20) NOT NULL,
    temperatura SMALLINT(2) NOT NULL,
    PRIMARY KEY (id_planta),
    CONSTRAINT fk_planta_interior_id_planta FOREIGN KEY (id_planta)
		REFERENCES planta (id_planta)
) ENGINE = INNODB;

CREATE TABLE planta_exterior (
	id_planta VARCHAR(20),
    tipus ENUM ('P', 'T') NOT NULL, #P = Vida llarg o permanent o T = planta de temporada
    PRIMARY KEY (id_planta),
    CONSTRAINT fk_planta_exterior_id_planta FOREIGN KEY (id_planta)
		REFERENCES planta (id_planta)
) ENGINE = INNODB;

CREATE TABLE adob_estacio_planta (
	id_planta VARCHAR(20),
    id_estacio VARCHAR(9),
    id_adob VARCHAR(20),
    quantitat SMALLINT NOT NULL,
    PRIMARY KEY (id_planta, id_estacio, id_adob),
    CONSTRAINT fk_adob_estacio_planta_id_planta FOREIGN KEY (id_planta)
		REFERENCES planta (id_planta),
	CONSTRAINT fk_adob_estacio_planta_id_estacio FOREIGN KEY (id_estacio)
		REFERENCES estacio (id_estacio),
	CONSTRAINT fk_adob_estacio_planta_id_adob FOREIGN KEY (id_adob)
		REFERENCES adob (id_adob),
    CONSTRAINT ck_adob_estacio_planta_quantitat CHECK (quantitat >= 20 AND quantitat <= 100)
) ENGINE = INNODB;

-- Tasca 5. Insert

INSERT INTO firma_comercial VALUES ('Tirsadob');
INSERT INTO firma_comercial VALUES ('Prisadob');
INSERT INTO firma_comercial VALUES ('Cirsadob');
INSERT INTO firma_comercial VALUES ('Uocadob');
INSERT INTO firma_comercial VALUES ('Intadob');

INSERT INTO adob (id_adob, id_firma_comercial, tipus) 
	VALUES ('Vitaplant', 'Tirsadob', 'AI');
INSERT INTO adob (id_adob, id_firma_comercial, tipus) 
	VALUES ('Creixplant', 'Prisadob', 'AI');
INSERT INTO adob (id_adob, id_firma_comercial, tipus) 
	VALUES ('Casadob', 'Tirsadob', 'AI');
INSERT INTO adob (id_adob, id_firma_comercial, tipus)
	VALUES ('Superplant', 'Cirsadob', 'LLD');
INSERT INTO adob (id_adob, id_firma_comercial, tipus)
	VALUES ('Plantavit', 'Uocadob', 'LLD');
INSERT INTO adob (id_adob, id_firma_comercial, tipus)
	VALUES ('Nutreplant', 'Cirsadob', 'LLD');
INSERT INTO adob (id_adob, id_firma_comercial, tipus)
	VALUES ('Plantadob', 'Prisadob', 'LLD');
INSERT INTO adob (id_adob, id_firma_comercial, tipus)
	VALUES ('Sanexplant', 'Uocadob', 'LLD');
INSERT INTO adob (id_adob, id_firma_comercial, tipus)
	VALUES ('Casaplant', 'Intadob', 'AI');
INSERT INTO adob (id_adob, id_firma_comercial, tipus)
	VALUES ('Superdob', 'Intadob', 'LLD');
    
INSERT INTO estacio (id_estacio) VALUES ('Hivern');
INSERT INTO estacio (id_estacio) VALUES ('Primavera');
INSERT INTO estacio (id_estacio) VALUES ('Estiu');
INSERT INTO estacio (id_estacio) VALUES ('Tardor');

INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Geranium', 'Gerani', 'Primavera', 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Begonia rex', 'Begònia', 'Estiu', 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Chrysanthemum', 'Crisantem', 'Estiu', 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Euphorbia', 'Poinsetia', 'Hivern', 'I');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Hedera', 'Heura', NULL, 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Codiaeum', 'Croton', NULL, 'I');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Camellia', 'Camèllia', 'Primavera', 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Cyclamen', 'Ciclamen', 'Hivern', 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Rosa', 'Roser', 'Primavera', 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Polystichum', 'Falguera', NULL, 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Tulipa', 'Tulipa', 'Primavera', 'E');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Philodendron', 'Potus', NULL, 'I');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Chlorophytum', 'Cintes', NULL, 'I');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Ficus', 'Ficus Benjamina', NULL, 'I');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Yuca', 'Yuca', NULL, 'I');
INSERT INTO planta (id_planta, nom_popular, id_estacio, tipus_planta)
	VALUES ('Cactus', 'Cactus', NULL, 'E');
    
INSERT INTO planta_interior (id_planta, ubicacio, temperatura)
	VALUES ('Euphorbia', 'Llum indirecta', 18);
INSERT INTO planta_interior (id_planta, ubicacio, temperatura)
	VALUES ('Codiaeum', 'No corrents', 17);
INSERT INTO planta_interior (id_planta, ubicacio, temperatura)
	VALUES ('Philodendron', 'Llum directa', 15);
INSERT INTO planta_interior (id_planta, ubicacio, temperatura)
	VALUES ('Ficus', 'Llum indirecta', 19);
INSERT INTO planta_interior (id_planta, ubicacio, temperatura)
	VALUES ('Yuca', 'Llum directa', 15);
    
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Geranium', 'P');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Begonia rex', 'P');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Chrysanthemum', 'T');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Hedera', 'P');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Camellia', 'P');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Cyclamen', 'P');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Rosa', 'P');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Polystichum', 'P');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Tulipa', 'T');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Chlorophytum', 'P');
INSERT INTO planta_exterior (id_planta, tipus)
	VALUES ('Cactus', 'P');
    
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Geranium', 'Primavera', 'Casadob', 30);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Geranium', 'Hivern', 'Vitaplant', 20);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Geranium', 'Estiu', 'Sanexplant', 20);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Camellia', 'Hivern', 'Plantavit', 50);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Camellia', 'Primavera', 'Casadob', 75);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Cyclamen', 'Tardor', 'Casadob', 30);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Begonia rex', 'Estiu', 'Casadob', 25);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Chrysanthemum', 'Primavera', 'Superplant', 45);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Begonia rex', 'Primavera', 'Nutreplant', 50);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Codiaeum', 'Estiu', 'Casadob', 60);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Rosa', 'Primavera', 'Casadob', 30);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Rosa', 'Primavera', 'Creixplant', 50);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Polystichum', 'Primavera', 'Casadob', 40);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Polystichum', 'Tardor', 'Plantadob', 20);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Tulipa', 'Hivern', 'Casadob', 40);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Philodendron', 'Primavera', 'Casadob', 40);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Chlorophytum', 'Tardor', 'Casadob', 30);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Chlorophytum', 'Hivern', 'Superplant', 40);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Euphorbia', 'Hivern', 'Casadob', 50);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Euphorbia', 'Hivern', 'Sanexplant', 40);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Hedera', 'Primavera', 'Casadob', 45);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Codiaeum', 'Primavera', 'Casadob', 50);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Ficus', 'Primavera', 'Casadob', 50);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Yuca', 'Estiu', 'Superdob', 30);
INSERT INTO adob_estacio_planta (id_planta, id_estacio, id_adob, quantitat)
	VALUES ('Cactus', 'Estiu', 'Superdob', 40);
    
-- Tasca 6. Modificacions a les taules

ALTER TABLE planta_interior 
	ADD altura ENUM('T', 'A') NOT NULL DEFAULT 'T'; -- A = "Aire" y T = "Tierra"

ALTER TABLE firma_comercial
	ADD direccio VARCHAR(30),	
	ADD codi_postal VARCHAR(5),
    ADD correu_electronic VARCHAR(50),
    ADD CONSTRAINT ck_firma_comercial_correu_electronic
		CHECK (correu_electronic LIKE '%@%' AND correu_electronic LIKE '%.%');
        
-- Tasca 7. Update

UPDATE planta_interior SET altura = 'A' WHERE id_planta = 'Codiaeum';

UPDATE adob_estacio_planta SET quantitat = 30
	WHERE id_planta = 'Geranium' AND id_estacio = 'Hivern' AND id_adob = 'Vitaplant';
UPDATE adob_estacio_planta SET quantitat = 30
	WHERE id_planta = 'Begonia rex' AND id_estacio = 'Estiu' AND id_adob = 'Casadob';
UPDATE adob_estacio_planta SET quantitat = 30
	WHERE id_planta = 'Chrysanthemum' AND id_estacio = 'Primavera' AND id_adob = 'Superplant';
UPDATE adob_estacio_planta SET quantitat = 50
	WHERE id_planta = 'Begonia rex' AND id_estacio = 'Primavera' AND id_adob = 'Nutreplant';
UPDATE adob_estacio_planta SET quantitat = 50
	WHERE id_planta = 'Codiaeum' AND id_estacio = 'Estiu' AND id_adob = 'Casadob';
UPDATE adob_estacio_planta SET quantitat = 35
	WHERE id_planta = 'Rosa' AND id_estacio = 'Primavera' AND id_adob = 'Casadob';
UPDATE adob_estacio_planta SET quantitat = 45
	WHERE id_planta = 'Philodendron' AND id_estacio = 'Primavera' AND id_adob = 'Casadob';

-- Tasca 8. Delete


DELETE FROM adob_estacio_planta WHERE id_adob = 'Superdob' OR id_adob = 'Casaplant';
DELETE FROM adob WHERE id_firma_comercial = 'Intadob';
DELETE FROM firma_comercial WHERE id_firma_comercial = 'Intadob';

/*
AQUI SE DEBE BORRAR DE HIJO A PADRE, EL PRINCIPAL ES FIRMA_COMERCIAL, Y ÉL SE REFERENCIA A ADOB,
POR ÚLTIMO SE REFERENCIA EN ADOB_ESTACIO_PLANTA, POR LO QUE CON AYUDA DE SELECTS TENEMOS QUE BUSCAR
DONDE SE REFERENCIA PARA BORRAR LAS ENTRADAS DESDE EL TECHO A LOS CIMIENTOS
*/

-- ACTIVIDAD 6.2 - CONSULTES AMB FUNCIONS.

-- Tasca 1. Mostra la quantitat total d'adob que podem fer servir.

SELECT SUM(quantitat) AS "Quantitat total d'adob"
	FROM adob_estacio_planta;

-- Tasca 2. Mostra la mitjana d'adob Casadob amb que s'han adobat les plantes.

SELECT AVG(quantitat) AS "Mitjana d'adob Casadob"
	FROM adob_estacio_planta
    WHERE id_adob = 'Casadob';
    
-- Tasca 3. Mostra la mitjana de temperatura a la que han d'estar les plantes d'interior.

SELECT AVG(temperatura) AS "Mitjana de temperatura plantes d'interior"
	FROM planta_interior;
    
-- Tasca 4. Mostra la quantitat mínima i màxima d'adob que s'utilitza alguna vegada (en una sola consulta).

SELECT min(quantitat) AS "Quantitat mínima", max(quantitat) AS "Quantitat màxima"
	FROM adob_estacio_planta;

-- Tasca 5. Mostra la temperatura màxima a la que pot estar una planta d'interior.

SELECT max(temperatura) AS "Temperatura màxima"
	FROM planta_interior;

-- Tasca 6. Mostra la quantitat total d'adob que utilitza la planta Euphorbia.

SELECT sum(quantitat)
	FROM adob_estacio_planta
    WHERE id_planta = 'Euphorbia';
    
-- Tasca 12. Concatena dos columnes de la taula adobs amb una separació opcional.

SELECT CONCAT(id_adob,"            ", tipus) AS "Nom d'adob i tipus"
	FROM adob;

-- Tasca 13. Mostra un nombre determinat de caràcters començant per l'esquerra d’un o varis camps de la taula adobs.

SELECT LEFT(CONCAT(id_adob," ", tipus), 11)
	FROM adob;

-- Tasca 14. Mostra un nombre determinat de caràcters començant per la dreta d’un o varis camps de la taula adobs.

SELECT RIGHT(id_firma_comercial, 5)
	FROM adob;

-- Tasca 15. Mostra el número de caràcters del nom de l'adob per a cada un dels registres de la taula adobs.

SELECT LENGTH(id_adob)
	FROM adob;

-- Tasca 16. Mostra el número de caràcters del nom de l'adob i el nom de l’adob, per a cada un dels registres de la taula adobs amb longitud de càracters menors a 10.

SELECT LENGTH(id_adob), id_adob
	FROM adob
    where LENGTH(id_adob) < 10;

-- Tasca 17. Mostra en mínuscules el nom de les firmes comecials de la taula adobs. Ara fés que no es repetexin.

SELECT DISTINCT LOWER(id_firma_comercial)
	FROM adob;

-- Tasca 18. Mostra en nom de l'adob, alhora en majúscules i també en majúscules els 4 primers caràcters.

SELECT UPPER(id_adob), LEFT(UPPER(id_adob), 4)
	FROM adob;

-- Tasca 19. Mostra la quantitat total d'adob, la quantitat total si el subministre d'adob s'incremente en 10 per a cada dosi, i  la quantitat total d'adob + 10.

SELECT SUM(quantitat), SUM(quantitat + 10), (SUM(quantitat))+10
	FROM adob_estacio_planta;

-- Tasca 20. Mostra la quantitat d'adob, i crea columnes amb la quantitat si li restem 100, multipliquem 10, dividim per 10 i fem la divisió entera (DIV) per 20.

SELECT SUM(quantitat) - 100, SUM(quantitat) * 10, SUM(quantitat) / 10, SUM(quantitat) DIV 20
	FROM adob_estacio_planta;

-- Tasca 21. Mostra el valor absolut de la quantitat d'adob, i crea columnes amb la quantitat si li restem 100, i el valor absolut si restem 100 a la quantitat.

SELECT ABS(quantitat) -100, ABS(quantitat - 100)
	FROM adob_estacio_planta;

-- Tasca 22. Mostra la quantitat d'adob dividit entre 7, i mostra la divisió redondejada, redondejada cap adalt i cap abaix.



-- Tasca 23. Mostra la quantitat d'adob, el seu mòdul a 2, elevat a 2, i 2 elevat a la quantitat. Alhora l'arrel de la quantitat i l'arrel redondejadats a 4 decimals.



-- Tasca 24. Mostra la data actual, l'hora actual, el timestamp actual.



-- Tasca 25. Mostra la data '2012-01-31 20:01:38', en funció d'aquesta data mostra alhora: el dia, el dia de mes, el dia de la setmana, el mes, l'últim dia del mes, el dia de l'any, l'any.



-- Tasca 26. Mostra la data actual, en funció d'aquesta data mostra alhora: el dia, el dia de mes , el dia de la setmana, el mes, el dia de l'any, l'any.



-- Tasca 27. Mostra l'hora '2012-07-31 20:01:38', en funció d'aquesta hora mostra alhora: el minut, el segon.



-- Tasca 28. Mostra l'hora actual, en funció d'aquesta hora mostra alhora: el minut, el segon.
