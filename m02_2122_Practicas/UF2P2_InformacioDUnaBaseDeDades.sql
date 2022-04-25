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
INSERT INTO ingredient (id_ingredient, nom) VALUES (1, 'Mozzarella');
INSERT INTO ingredient (id_ingredient, nom) VALUES (2, 'salsa de tomàquet');
INSERT INTO ingredient (id_ingredient, nom) VALUES (3, 'bacon');
INSERT INTO ingredient (id_ingredient, nom) VALUES (4, 'pollastre');
INSERT INTO ingredient (id_ingredient, nom) VALUES (5, 'carn');
INSERT INTO ingredient (id_ingredient, nom) VALUES (6, 'salsa barbacoa');
INSERT INTO ingredient (id_ingredient, nom) VALUES (7, 'xampinyons');
INSERT INTO ingredient (id_ingredient, nom) VALUES (8, 'salsa carbonara');
INSERT INTO ingredient (id_ingredient, nom) VALUES (9, 'pinya');
INSERT INTO ingredient (id_ingredient, nom) VALUES (10, 'pernil york');
INSERT INTO ingredient (id_ingredient, nom) VALUES (11, 'tonyina');
INSERT INTO ingredient (id_ingredient, nom) VALUES (12, 'olives negres');
INSERT INTO ingredient (id_ingredient, nom) VALUES (13, 'tomàquet natural');
INSERT INTO ingredient (id_ingredient, nom) VALUES (14, 'pernil ibèric');

-- INGREDIENTES PIZZA BARBACOA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 1);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 2);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 3);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 4);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 5);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (6, 6);
-- INGREDIENTES PIZZA CARBONARA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 1);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 2);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 3);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 7);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (7, 8);
-- INGREDIENTES PIZZA HAWAIANA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (8, 1);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (8, 2);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (8, 9);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (8, 10);
-- INGREDIENTES PIZZA 4 ESTACIONS
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9, 1);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9, 2);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9, 10);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9, 11);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9, 12);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (9, 7);
-- INGREDIENTS PIZZA IBÈRICA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (10, 1);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (10, 13);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (10, 14);
-- INGREDIENTS PIZZA DE LA CASA
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11, 1);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11, 2);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11, 3);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11, 10);
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUES (11, 5);

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
	VALUES (10000, '20170109204500', 'L', '1', '1');
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10001, '20170109205100', 'D', '2', '1');
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10002, '20170109212000', 'D', '3', '1');
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10003, '20170109213300', 'D', '4', '2');
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10004, '20170110210000', 'D', '5', '1');
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10005, '20170110213500', 'L', '6', '2');
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10006, '20170110215000', 'D', '1', '2');
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10007, '20170111203200', 'D', '2', '1');
INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10008, '20170111211000', 'D', '7', '1');
    INSERT INTO comanda (numero, data_hora, domicili_local, id_client, id_empleat) 
	VALUES (10009, '20170111212400', 'D', '1', '2');

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
	VALUES (10003, 7, 4);
INSERT INTO comanda_producte (numero, id_producte, quantitat)
	VALUES (10003, 8, 4);
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
    
-- Tasca 6. Select

-- 6.1. Mostra el nom, telèfon i adreça dels clients de Terrassa.

SELECT nom_client, telefon, adreca
	FROM client
    WHERE poblacio='Terrassa';

-- 6.2. Mostra el nom, telèfon i adreça dels clients que no viuen a Terrassa.

SELECT nom_client, telefon, adreca
	FROM client
	WHERE poblacio!='Terrassa';

-- 6.3. Mostra el nom dels clients que el seu telèfon comenci per '93785'.

SELECT nom_client
	FROM client
    WHERE telefon LIKE '93785%';

-- 6.4. Mostra el nom i cognoms dels empleats amb una ‘a’ en el seu nom o cognom.

SELECT nom, cognoms
	FROM empleat
    WHERE nom LIKE '%a%' OR cognoms LIKE '%a%';

-- 6.5. Mostra el número i la data-hora  de les comandes han demanat per recollir al local.

SELECT numero, data_hora
	FROM comanda
    WHERE domicili_local='L';

-- 6.6. Mostra el número de les comandes han demanat per servir a domicili al client Josep Vila.

SELECT numero
	FROM comanda
    WHERE id_client=1 AND domicili_local='D';

-- 6.7. Mostra el nom i preu dels productes que tinguin un preu superior a 17 €.

SELECT id_producte, preu
	FROM producte
    WHERE preu > 17;

-- 6.8. Mostra els ingredients que el seu nom comenci per 'Pernil'.

SELECT id_ingredient, nom
	FROM ingredient
	WHERE nom LIKE 'pernil%';
    
-- 6.9. Mostra les pizzes que tinguin algun d'aquests ingredients: Xampinyons, Salsa carbonara, Pinya.

SELECT id_producte
	FROM pizza_ingredient
    WHERE id_ingredient IN (6,7,9);

-- 6.10. Mostra les comandes que s'ha demanat algun producte amb una quantitat entre 3 i 4.

SELECT numero
	FROM comanda_producte
    WHERE quantitat BETWEEN 3 AND 4;
