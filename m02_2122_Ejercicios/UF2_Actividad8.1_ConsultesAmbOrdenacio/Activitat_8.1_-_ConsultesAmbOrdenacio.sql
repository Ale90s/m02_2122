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
    
-- Tasca 8.1 - Consultes amb ordenació

-- 1. Mostra el nom del client, adreça i població ordenats per població.

SELECT nom_client, adreca, poblacio
	FROM client
    ORDER BY poblacio;

-- 2. Mostra les dades dels empleats ordenats per cognom i nom.

SELECT id_empleat, nom, cognoms
	FROM empleat
    ORDER BY cognoms, nom;

-- 3. Mostra el nom i preu dels productes, ordenats de mayor a menor en preu.

SELECT nom, preu
	FROM producte
    ORDER BY preu DESC;

-- 4. Mostra les begudes i el preu d'aquestes, ordenats de mayor a menor preu i despres pel nom.

SELECT pr.nom, pr.preu
	FROM producte pr
    INNER JOIN beguda be ON pr.id_producte = be.id_producte
    ORDER BY pr.nom DESC, pr.nom;

-- 5. Mostra el nom de les pizzes i el nom dels seus ingredients segons l'ordre desc per les pizzes i asc pels ingredients.

SELECT pr.nom, ing.nom
	FROM producte pr
	INNER JOIN pizza piz ON piz.id_producte = pr.id_producte
	INNER JOIN pizza_ingredient pizing ON piz.id_producte = pizing.id_producte
	INNER JOIN ingredient ing ON ing.id_ingredient = pizing.id_ingredient
    ORDER BY pr.nom DESC, ing.nom;

-- 6. Mostra el nom dels ingredients de la pizza ibèrica ordenats descendement.

SELECT ing.nom
	FROM ingredient ing	
    INNER JOIN pizza_ingredient pizing ON pizing.id_ingredient = ing.id_ingredient
	INNER JOIN pizza piz ON piz.id_producte = pizing.id_producte
	INNER JOIN producte pr ON pr.id_producte = piz.id_producte
    WHERE pr.nom LIKE ('%ibèrica')
    ORDER BY ing.nom DESC;

-- 7. Mostra el nom de les pizzes que tenen Pinya o Mozzarella , ordenades pel nom de la pizza descendenment.

SELECT pr.nom
	FROM producte pr
	INNER JOIN pizza piz ON piz.id_producte = pr.id_producte
    INNER JOIN pizza_ingredient pizing ON pizing.id_producte = piz.id_producte
    INNER JOIN ingredient ing ON ing.id_ingredient = pizing.id_ingredient
	WHERE ing.nom ='Pinya' OR ing.nom = 'Mozzarella'
    ORDER BY pr.nom DESC;

-- 8. Mostra el nom de les postres i preu dels nostres productes que ha demanat en Guillem Jam, ordenats per preu.

SELECT p.id_producte, pr.preu
	FROM postre p
    INNER JOIN producte pr ON pr.id_producte = p.id_producte
    INNER JOIN comanda_producte copr ON copr.id_producte = pr.id_producte
    INNER JOIN comanda co ON co.numero = copr.numero
    INNER JOIN client cl ON cl.id_client = co.id_client
	WHERE cl.nom_client = 'Guillen Jam'
    ORDER BY pr.preu;

-- 9. Mostra en ordre descendent el nom dels clients que ha demanat productes Damm a domicili.

SELECT cl.nom_client
	FROM client cl
    INNER JOIN comanda co ON co.id_client = cl.id_client
    INNER JOIN comanda_producte copr ON copr.numero = co.numero
    INNER JOIN producte pr ON pr.id_producte = copr.id_producte
    INNER JOIN beguda be ON be.id_producte = pr.id_producte
    WHERE pr.nom LIKE '%Damm%' AND co.domicili_local = 'D'
    ORDER BY cl.nom_client DESC;
    
-- 10. Mostra el nom del client desc i el número de comanda asc, per les comandes amb begudes.

SELECT DISTINCT cl.nom_client, co.numero
	FROM client cl
    INNER JOIN comanda co ON co.id_client = cl.id_client
    INNER JOIN comanda_producte copr ON copr.numero = co.numero
    INNER JOIN producte pr ON pr.id_producte = copr.id_producte
    INNER JOIN beguda be ON be.id_producte = pr.id_producte
    ORDER BY cl.nom_client DESC, co.numero;

-- 11. Mostra les begudes que s'han venut entre les 21 i les 21:30 hores ordenades alfabèticament de manera invers.

SELECT pr.nom
	FROM producte pr
    INNER JOIN postre p ON p.id_producte = pr.id_producte
    INNER JOIN comanda_producte copr ON copr.id_producte = pr.id_producte
    INNER JOIN comanda co ON co.numero = copr.numero
    WHERE TIME(co.data_hora) BETWEEN '21:00:00' AND '21:30:00'
    ORDER BY pr.nom DESC;
