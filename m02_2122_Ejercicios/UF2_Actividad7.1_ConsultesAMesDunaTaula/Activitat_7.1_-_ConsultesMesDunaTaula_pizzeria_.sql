-- Tasca 3. Base de dades de la Pizzeria

DROP DATABASE IF EXISTS pizzeria;
CREATE DATABASE pizzeria;
USE pizzeria;

-- Tasca 4. Generació de taules

CREATE TABLE client (
id_client	SMALLINT AUTO_INCREMENT,
nom_client	VARCHAR (30) NOT NULL,
telefon		VARCHAR(9),
adreca		VARCHAR(50) NOT NULL,
poblacio	VARCHAR(30) NOT NULL DEFAULT 'Terrassa',
PRIMARY KEY (id_client),
CONSTRAINT uk_client_telefon UNIQUE (telefon)
) ENGINE=INNODB;

CREATE TABLE empleat (
id_empleat	SMALLINT(3) AUTO_INCREMENT,
nom			VARCHAR(30) NOT NULL,
cognoms		VARCHAR(50) NOT NULL,
PRIMARY KEY (id_empleat)
) ENGINE=INNODB;

CREATE TABLE comanda (
numero	INT AUTO_INCREMENT,
data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
domicili_local	ENUM('D', 'L') NOT NULL,
id_client	SMALLINT NOT NULL,
id_empleat	SMALLINT(3) NOT NULL,
PRIMARY KEY (numero),
CONSTRAINT fk_comanda_client FOREIGN KEY (id_client)
	REFERENCES `client` (id_client),
CONSTRAINT fk_comanda_empleat FOREIGN KEY (id_empleat)
	REFERENCES empleat (id_empleat)
) ENGINE=INNODB, AUTO_INCREMENT=10000;

CREATE TABLE producte (
id_producte	SMALLINT AUTO_INCREMENT,
nom VARCHAR(50) NOT NULL,
preu DECIMAL (4, 2) NOT NULL,
PRIMARY KEY (id_producte),
CONSTRAINT uk_producte_nom UNIQUE (nom),
CONSTRAINT ck_producte_preu CHECK (preu BETWEEN 0.01 AND 99.99)
) ENGINE=INNODB;

CREATE TABLE beguda (
id_producte SMALLINT,
capacitat SMALLINT(3) NOT NULL,
alcoholica ENUM('N', 'S') NOT NULL,
PRIMARY KEY (id_producte),
CONSTRAINT fk_beguda_producte FOREIGN KEY (id_producte)
	REFERENCES producte (id_producte),
CONSTRAINT ck_beguda_capacitat CHECK (capacitat BETWEEN 1 AND 150)
) ENGINE=INNODB;

CREATE TABLE pizza (
id_producte SMALLINT,
PRIMARY KEY (id_producte),
CONSTRAINT fk_pizza_producte FOREIGN KEY (id_producte)
	REFERENCES producte (id_producte)
) ENGINE=INNODB;

CREATE TABLE postre (
id_producte SMALLINT,
PRIMARY KEY (id_producte),
CONSTRAINT fk_postre_producte FOREIGN KEY (id_producte)
	REFERENCES producte (id_producte)
) ENGINE=INNODB;

CREATE TABLE ingredient (
id_ingredient 	VARCHAR(3),
nom				VARCHAR(20) NOT NULL,
PRIMARY KEY (id_ingredient),
CONSTRAINT uk_ingredient_nom UNIQUE (nom)
) ENGINE=INNODB;

CREATE TABLE pizza_ingredient(
id_producte 	SMALLINT,
id_ingredient VARCHAR(3),
PRIMARY KEY (id_producte, id_ingredient),
CONSTRAINT fk_pizza_ingredient_pizza FOREIGN KEY (id_producte)
	REFERENCES pizza (id_producte),
CONSTRAINT fk_pizza_ingredient_ingredient FOREIGN KEY (id_ingredient)
	REFERENCES ingredient (id_ingredient)
) ENGINE=INNODB;

CREATE TABLE comanda_producte(
numero INT,
id_producte SMALLINT,
quantitat SMALLINT(2) NOT NULL,
PRIMARY KEY (numero, id_producte),
CONSTRAINT fk_comanda_producte_comanda FOREIGN KEY (numero)
	REFERENCES comanda (numero),
CONSTRAINT fk_comanda_producte_producte FOREIGN KEY (id_producte)
	REFERENCES producte (id_producte),
CONSTRAINT ck_comanda_producte_quantitat CHECK (quantitat BETWEEN 1 AND 99)
) ENGINE=INNODB;

-- Tasca 5. Insert

-- PRODUCTOS
INSERT INTO producte (id_producte, nom, preu)
	VALUES (1, 'Ampolla Coca-Cola', 1.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (2, 'Ampolla Fanta Llimona', 1.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (3, 'Llauna Nestea', 1.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (4, 'Llauna Cervesa Damm', 1.55);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (5, 'Llauna Cervesa sense alcohol', 1.55);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (6, 'Pizza Barbacoa', 19.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (7, 'Pizza Carbonara', 18.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (8, 'Pizza Hawaiana', 16.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (9, 'Pizza 4 estacions', 18.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (10, 'Pizza Ibèrica', 21.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (11, 'Pizza de la casa', 19.95);
INSERT INTO producte (id_producte, nom, preu)
	VALUES (12, 'Gelat Cornetto Classic', 1.00);
    INSERT INTO producte (id_producte, nom, preu)
	VALUES (13, 'Paquet de trudes de xocolata', 2.25);
    INSERT INTO producte (id_producte, nom, preu)
	VALUES (14, 'Gelat Magnum', 1.95);
    
-- BEBIDAS
INSERT INTO beguda (id_producte, capacitat, alcoholica)
	VALUES (1, 50, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica)
	VALUES (2, 50, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica)
	VALUES (3, 33, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica)
	VALUES (4, 33, 'S');
INSERT INTO beguda (id_producte, capacitat, alcoholica)
	VALUES (5, 33, 'N');

-- ID'S PIZZAS
INSERT INTO pizza (id_producte) VALUES (6);
INSERT INTO pizza (id_producte) VALUES (7);
INSERT INTO pizza (id_producte) VALUES (8);
INSERT INTO pizza (id_producte) VALUES (9);
INSERT INTO pizza (id_producte) VALUES (10);
INSERT INTO pizza (id_producte) VALUES (11);

-- INGREDIENTES PIZZAS
INSERT INTO ingredient (id_ingredient, nom) VALUES ('MOZ', 'Mozzarella');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('TOM', 'salsa de tomàquet');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('BAC', 'bacon');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('POL', 'pollastre');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('CAR', 'carn');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('BAR', 'salsa barbacoa');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('XAM', 'xampinyons');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('CAB', 'salsa carbonara');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('PIN', 'pinya');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('PER', 'pernil york');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('TON', 'tonyina');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('OLI', 'olives negres');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('NAT', 'tomàquet natural');
INSERT INTO ingredient (id_ingredient, nom) VALUES ('IBE', 'pernil ibèric');

-- INGREDIENTES PIZZA BARBACOA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'POL');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'CAR');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'BAR');
-- INGREDIENTES PIZZA CARBONARA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'XAM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'CAB');
-- INGREDIENTES PIZZA HAWAIANA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (8, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (8, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (8, 'PIN');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (8, 'PER');
-- INGREDIENTES PIZZA 4 ESTACIONS
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'PER');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'TON');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'OLI');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'XAM');
-- INGREDIENTS PIZZA IBÈRICA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (10, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (10, 'NAT');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (10, 'IBE');
-- INGREDIENTS PIZZA DE LA CASA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'PER');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'CAR');

-- ID'S POSTRES
INSERT INTO postre (id_producte) VALUES (12);
INSERT INTO postre (id_producte) VALUES (13);
INSERT INTO postre (id_producte) VALUES (14);

-- CLIENTES
INSERT INTO client (id_client, nom_client, telefon, adreca, poblacio) VALUES (1, 'Josep Vila', '937853354', 'C. del Pi 23', 'Terrassa');
INSERT INTO client (id_client, nom_client, telefon, adreca, poblacio) VALUES (2, 'Carme Garcia', '937883402', 'Plaça Nova 3', 'Terrassa');
INSERT INTO client (id_client, nom_client, telefon, adreca, poblacio) VALUES (3, 'Enric Miralles', '606989866', 'Carrer Romaní 6', 'Matadepera');
INSERT INTO client (id_client, nom_client, telefon, adreca, poblacio) VALUES (4, 'Miquel Bover', '937753222', 'Carrer Can Boada 78', 'Terrassa');
INSERT INTO client (id_client, nom_client, telefon, adreca, poblacio) VALUES (5, 'Marta Ribas', '937862655', 'Carrer Aviació 3', 'Terrassa');
INSERT INTO client (id_client, nom_client, telefon, adreca, poblacio) VALUES (6, 'Guillen Jam', '937858555', 'Carrer del Dalt 4', 'Terrassa');
INSERT INTO client (id_client, nom_client, telefon, adreca, poblacio) VALUES (7, 'Júlia Guillén', '626895456', 'C. Robert 8', 'Terrassa');

-- EMPLEADOS
INSERT INTO empleat (id_empleat, nom, cognoms) VALUES (1, 'Jordi', 'Casas');
INSERT INTO empleat (id_empleat, nom, cognoms) VALUES (2, 'Marta', 'Pou');

-- COMANDA

INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10000, '20170109204500', 'L', 1, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10001, '20170109205100', 'D', 2, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10002, '20170109212000', 'D', 3, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10003, '20170109213300', 'D', 4, 2);
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10004, '20170110210000', 'D', 5, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10005, '20170110213500', 'L', 6, 2);
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10006, '20170110215000', 'D', 1, 2);
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10007, '20170111203200', 'D', 2, 1);
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10008, '20170111211000', 'D', 7, 1);
    INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10009, '20170111212400', 'D', 1, 2);

-- PRODUCTOS QUE CONTIENE CADA COMANDA

INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10000, 6, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10000, 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10000, 2, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10000, 12, 2);
    
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10001, 10, 1);
    
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10002, 11, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10002, 3, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10002, 4, 3);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10002, 14, 4);
    
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10003, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10003, 8, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10003, 4, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10003, 5, 2);

INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10004, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10004, 9, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10004, 1, 6);
    
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10005, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10005, 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10005, 12, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10005, 13, 1);
    
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10006, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10006, 10, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10006, 11, 2);
    
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10007, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10007, 1, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10007, 2, 1);
    
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10008, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10008, 4, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10008, 14, 1);
    
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10009, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10009, 9, 1);
    
-- Tasca 7.1 - Consultes a més d'una taula 1

-- 7.1. Mostra el nom del client de la comanda 10002.

SELECT cl.id_client
	FROM client cl INNER JOIN comanda c ON cl.id_client = c.id_client
    WHERE c.numero = '10002';
    
-- 7.2. Mostra el nom del empleat que ha venut la comanda 10000.

SELECT em.nom, em.cognoms
	FROM empleat em INNER JOIN comanda co ON em.id_empleat = co.id_empleat
    WHERE co.numero = '10000';
    
-- 7.3. Mostra el número de comanda i si eren a recollir en el local o repartiment domicili les comandes que ha demanat en Josep Vila.

SELECT co.numero, co.domicili_local
	FROM comanda co INNER JOIN client cl ON co.id_client = cl.id_client
    WHERE cl.nom_client = 'Josep Vila';

-- 7.4. Mostra el el número de comanda i el nom del clients que han demanat comandes al local.

SELECT co.numero, cl.nom_client
	FROM comanda co 
    INNER JOIN client cl ON co.id_client = cl.id_client
    WHERE co.domicili_local = 'L';

-- 7.5. Mostra el nom dels empleats han servit comandes a la Carme Garcia.

SELECT DISTINCT em.nom, em.cognoms, cl.nom_client
	FROM empleat em
	INNER JOIN comanda co ON em.id_empleat = co.id_empleat
    INNER JOIN client cl ON co.id_client = cl.id_client
    WHERE cl.nom_client = 'Carme Garcia';

-- 7.6. Mostra la data i hora que ha fet comandes l'empleada Marta Pou.

SELECT co.data_hora
	FROM comanda co
	INNER JOIN empleat em ON co.id_empleat = em.id_empleat
	WHERE em.nom LIKE 'Marta' AND em.cognoms LIKE 'Pou';

-- 7.7. Mostra quantes comandes han demanat per servir a domicili.

SELECT COUNT(domicili_local) AS "Nº comandes a domicili"
	FROM comanda
    WHERE domicili_local = 'D';

-- 7.8. Mostra els números de comanda que han demanat pizza 4 estacions.

SELECT copr.numero
	FROM comanda_producte copr
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    WHERE pr.nom = 'Pizza 4 estacions';

-- 7.9. Mostra quantes Coca-colas hem venut.

SELECT SUM(copr.quantitat) AS "Coca-colas vendidas"
	FROM comanda_producte copr	
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
	WHERE pr.nom LIKE '%Coca-Cola';

-- 7.10. Mostra els ingredients que té la pizza barbacoa.

SELECT ing.nom 'Nombre ingredientes'
	FROM ingredient ing
    INNER JOIN pizza_ingredient pizing ON ing.id_ingredient = pizing.id_ingredient
    INNER JOIN pizza piz ON piz.id_producte = pizing.id_producte
    INNER JOIN producte pr ON pr.id_producte = piz.id_producte
    WHERE pr.nom = 'Pizza barbacoa';
    
    

-- 7.11. Mostra les begudes i el preu d'aquestes.

SELECT pr.nom, pr.preu
	FROM producte pr
	INNER JOIN beguda be ON be.id_producte = pr.id_producte;

-- 7.12. Mostra el nom de les pizzes que tenen pinya

SELECT pr.nom
	FROM producte pr
    INNER JOIN pizza piz ON piz.id_producte = pr.id_producte
	INNER JOIN pizza_ingredient pizing ON pizing.id_producte = piz.id_producte
	INNER JOIN ingredient ing ON ing.id_ingredient = pizing.id_ingredient
	WHERE ing.nom = 'pinya' AND pr.nom LIKE ('PIZZA%');

-- 7.13. Mostra la quantitat d’ingredients que té la pizza 4 estacions.

SELECT COUNT(pizing.id_ingredient) AS "Ingredients pizza 4 estacions"
	FROM pizza_ingredient pizing
    INNER JOIN pizza piz ON piz.id_producte = pizing.id_producte
	INNER JOIN producte pr ON pr.id_producte = piz.id_producte
    WHERE pr.nom = 'Pizza 4 estacions';

-- 7.14. Mostra quantes begudes no alcohòliques hi ha a la carta.

SELECT pr.nom
	FROM producte pr
	INNER JOIN beguda be ON be.id_producte = pr.id_producte
	WHERE be.alcoholica = 'N';

-- 7.15. Mostra el preu total de la comanda 10005.

SELECT SUM(copr.quantitat * pr.preu)
	FROM comanda_producte copr
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    WHERE copr.numero = 10005;
    
-- 7.16. Mostra quantes pizzes hem servit a fora de Terrassa

SELECT SUM(copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    INNER JOIN pizza piz ON pr.id_producte = piz.id_producte
    INNER JOIN comanda co ON copr.numero = co.numero
    INNER JOIN client cl ON co.id_client = cl.id_client  
    WHERE piz.id_producte IN (6, 7, 8, 9, 10, 11) AND cl.poblacio <> 'Terrassa';
	

-- 7.17. Mostra la quantitat de pizzes que té la nostra carta.

SELECT COUNT(pr.id_producte) AS "Pizzas que hay en carta"
	FROM producte pr
    INNER JOIN pizza piz ON pr.id_producte = piz.id_producte
    WHERE piz.id_producte = pr.id_producte;

-- 7.18. Mostra el nom de les postres dels nostres productes que ha demanat la Júlia Guillén.

SELECT pr.nom
	FROM producte pr
    INNER JOIN postre post ON pr.id_producte = post.id_producte
	INNER JOIN comanda_producte copr ON pr.id_producte = copr.id_producte
    INNER JOIN comanda co ON copr.numero = co.numero
    INNER JOIN client cl ON co.id_client = cl.id_client
	WHERE cl.nom_client = 'Júlia Guillén';

-- 7.19. Mostra el nom del client han demanat almenys 4 unitats d’una mateixa beguda a una comanda.

SELECT cl.nom_client
	FROM client cl
    INNER JOIN comanda co ON cl.id_client = co.id_client
    INNER JOIN comanda_producte copr ON co.numero = copr.numero
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    INNER JOIN beguda be ON pr.id_producte = be.id_producte
    WHERE be.id_producte = pr.id_producte AND copr.quantitat >= 4;

-- 7.20. Mostra en quantes pizzes hi ha bacon.

SELECT COUNT(pizing.id_producte)
	FROM pizza_ingredient pizing
    INNER JOIN ingredient ing ON pizing.id_ingredient = ing.id_ingredient
    WHERE nom = 'bacon';

-- 7.21. Mostra la quantitat de Coca-cola que hem venut.

SELECT SUM(quantitat)
	FROM comanda_producte copr
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    WHERE pr.nom = 'Ampolla Coca-Cola';


-- 7.22. Mostra el nom del client que ha demanat pizza barbacoa al local.

SELECT cl.nom_client
	FROM client cl
    INNER JOIN comanda co ON cl.id_client = co.id_client
    INNER JOIN comanda_producte copr ON co.numero = copr.numero
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    WHERE co.domicili_local = 'L' AND pr.nom = 'Pizza barbacoa';

-- 7.23. Mostra el nom de les pizzes que s’han demanat una quantitat de 2 o més en una comanda.

SELECT pr.nom
	FROM producte pr
    INNER JOIN comanda_producte copr ON pr.id_producte = copr.id_producte
	INNER JOIN pizza piz ON pr.id_producte = piz.id_producte
	WHERE piz.id_producte = pr.id_producte AND quantitat >= 2;

-- 7.24. Mostra els números de comanda en que s’ha demanat begades alcohòliques.

SELECT co.numero
	FROM comanda co
    INNER JOIN comanda_producte copr ON co.numero = copr.numero
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    INNER JOIN beguda be ON pr.id_producte = be.id_producte
    WHERE be.alcoholica = 'S';

-- 7.25. Mostra la quantitat de comandes que han demanat pizzes Barbacoa concatenat el resultat amb la paraula "comanda/es" i renombra la columna amb el nom comandes_barbacoa.

SELECT CONCAT(CAST(COUNT(copr.numero) AS CHAR), ' comanda/es') AS comandes_barbacoa
	FROM comanda_producte copr
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    WHERE pr.nom LIKE ('%barbacoa');

-- 7.26. Mostra en minúscula el nom dels ingredients que tenen les pizzes de la comanda 10002 i renombra la columna com a ingredients_comanda_10002.

SELECT LOWER(ing.nom) AS 'ingredients_comanda_10002'
	FROM ingredient ing
    INNER JOIN pizza_ingredient pizing ON ing.id_ingredient = pizing.id_ingredient
	INNER JOIN pizza piz ON pizing.id_producte = piz.id_producte
    INNER JOIN producte pr ON piz.id_producte = pr.id_producte
    INNER JOIN comanda_producte copr ON pr.id_producte = copr.id_producte
    WHERE copr.numero = 10002;

-- 7.27. Mostra el les tres primeres lletres del nom dels clients que han demanat begudes alguna vegada i renombra la columna com abreviatura_clients.

SELECT DISTINCT LEFT(cl.nom_client, 3) AS 'abreviatura_clients'
	FROM client cl
    INNER JOIN comanda co ON cl.id_client = co.id_client
    INNER JOIN comanda_producte copr ON co.numero = copr.numero
    INNER JOIN producte pr ON copr.id_producte = pr.id_producte
    INNER JOIN beguda be ON pr.id_producte = be.id_producte
    WHERE pr.id_producte = be.id_producte;
    
    
/* 7.28. Mostra el número de comanda, el nom del client i una columna amb la unió del número de la comanda amb el nombre de lletres del nom del client
		 separats amb un "-", de les comandes realitzades els dilluns. Exemple: comanda 1001 del client pepe, dona com a resultat 1001-4. Finalment renombra
		 el número de la comanda a comanda, el nom del client a client, i la columna calculada com a comanda_codi. */

SELECT co.numero AS "Comanda", cl.nom_client AS "Client", CONCAT(co.numero, "-", co.id_client) AS "Comanda_codi"
	FROM comanda co
    INNER JOIN client cl ON cl.id_client = co.id_client;

-- 7.29. Mostra el nombre total de Pizzes que hem venut en cap de setmana.

SELECT copr.quantitat
	FROM comanda_producte copr
    INNER JOIN comanda co ON co.numero = copr.numero
    INNER JOIN producte pr ON pr.id_producte = copr.id_producte
    INNER JOIN pizza piz ON piz.id_producte = pr.id_producte
    WHERE WEEKDAY(co.data_hora) IN (5, 6); 
    # No sale ningún resultado porque no se vendió ninguna pizza en fin de semana

-- 7.30. Mostra el valor total de la comanda 10005, a més, un camp amb la part entera i l'altre amb els cèntims d'Euro del valor total.


SELECT SUM(pr.preu * copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN producte pr ON pr.id_producte = copr.id_producte
    WHERE copr.numero = 10005;
    
-- 7.31. Mostra el nombre total de pizzes que s’han demanat a partir de les 21:30 inclosa.

SELECT SUM(copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN comanda co ON co.numero = copr.numero
    INNER JOIN producte pr ON pr.id_producte = copr.id_producte
    INNER JOIN pizza piz ON piz.id_producte = pr.id_producte
    WHERE TIME (co.data_hora) >= '21:30:00';

-- 7.32. Mostra el nombre de begudes no alcohòliques que s’han venut els dies 9/1/17 i 10/1/17.
 
SELECT SUM(copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN comanda co ON co.numero = copr.numero
	INNER JOIN producte pr ON pr.id_producte = copr.id_producte
	INNER JOIN beguda be ON be.id_producte = pr.id_producte
    WHERE DATE(co.data_hora) IN ('2017/01/09', '2017/01/10') AND alcoholica = 'N';
    
-- 7.33. Mostra en majúscules el nom del empleats que han venut postres.

SELECT DISTINCT UPPER(em.nom)
	FROM empleat em
    INNER JOIN comanda co ON co.id_empleat = em.id_empleat
	INNER JOIN comanda_producte copr ON copr.numero = co.numero
    INNER JOIN producte pr ON pr.id_producte = copr.id_producte
    INNER JOIN postre pos ON pos.id_producte = pr.id_producte
    WHERE pos.id_producte = pr.id_producte;

-- 7.34. Mostra quines comandes han demanat pizzes que tenen d'ingredient Pernil york.

SELECT copr.numero
	FROM comanda_producte copr
    INNER JOIN pizza_ingredient pizing ON pizing.id_producte = copr.id_producte
    INNER JOIN ingredient ing ON pizing.id_ingredient = ing.id_ingredient
    WHERE ing.nom = 'Pernil york';

-- 7.35. Mostra el preu mitjà de les pizzes.

SELECT AVG(pr.preu)
	FROM producte pr
    INNER JOIN pizza piz ON piz.id_producte = pr.id_producte;

-- 7.36. Mostra l'import total que hem venut en begudes.

SELECT SUM(copr.quantitat * be.id_producte)
	FROM comanda_producte copr
	INNER JOIN beguda be ON be.id_producte = copr.id_producte;

-- 7.37. Mostra el total de pizzes que s'han servit al local.

SELECT COUNT(copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN pizza piz ON piz.id_producte = copr.id_producte
    INNER JOIN comanda co ON co.numero = copr.numero
    WHERE domicili_local = 'L';

-- 7.38. Mostra el total de pizzes que ha servit a domicili.

SELECT COUNT(copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN pizza piz ON piz.id_producte = copr.id_producte
    INNER JOIN comanda co ON co.numero = copr.numero
    WHERE domicili_local = 'D';

-- 7.39. Mostra les pizzes que s'han demanat la setmana del 9/1/17.

SELECT DISTINCT pr.nom
	FROM producte pr
	INNER JOIN pizza piz ON piz.id_producte = pr.id_producte
    INNER JOIN comanda_producte copr ON copr.id_producte = pr.id_producte
    INNER JOIN comanda co ON co.numero = copr.numero
    WHERE WEEKOFYEAR(co.data_hora) = WEEKOFYEAR('2017/01/09');

-- 7.40. Mostra les pizzes que ha venut el Jordi Casas als clients de Terrassa.

SELECT pr.nom	
	FROM producte pr
	INNER JOIN pizza piz ON piz.id_producte = pr.id_producte
	INNER JOIN comanda_producte copr ON copr.id_producte = pr.id_producte
    INNER JOIN comanda co ON co.numero = copr.numero
    INNER JOIN empleat em ON em.id_empleat = co.id_empleat
    INNER JOIN client cl ON cl.id_client = co.id_client
    WHERE (em.nom = 'Jordi' AND em.cognoms = 'Casas') AND cl.poblacio = 'Terrassa';
