##### SQL #####
 
 -- Tasca 3. Base de dades de la Pizzeria
DROP DATABASE IF EXISTS uf2_p2_pizzeria;
CREATE DATABASE uf2_p2_pizzeria;
USE uf2_p2_pizzeria;

-- Tasca 4. Generació de taules
CREATE TABLE client (
    id_client SMALLINT AUTO_INCREMENT,
    nom VARCHAR(20) NOT NULL,
    telefon VARCHAR(9),
    adreca VARCHAR(50) NOT NULL,
    poblacio VARCHAR(20) NOT NULL DEFAULT 'Terrassa',
    PRIMARY KEY (id_client),
    CONSTRAINT uk_client_telefon UNIQUE (telefon)
)  ENGINE=INNODB;

CREATE TABLE empleat (
    id_empleat SMALLINT(3) AUTO_INCREMENT,
    nom VARCHAR(20) NOT NULL,
    cognoms VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_empleat)
)  ENGINE=INNODB;
    
CREATE TABLE comanda (
    numero SMALLINT AUTO_INCREMENT,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    domicili_local ENUM('D', 'L') NOT NULL,
    client_id SMALLINT NOT NULL,
    empleat_id SMALLINT(3) NOT NULL,
    PRIMARY KEY (numero),
    CONSTRAINT fk_comanda_client FOREIGN KEY (client_id)
        REFERENCES client (id_client),
    CONSTRAINT fk_comanda_empleat FOREIGN KEY (empleat_id)
        REFERENCES empleat (id_empleat)
)  ENGINE=INNODB , AUTO_INCREMENT=10000;

CREATE TABLE producte (
    id_producte SMALLINT AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    preu DECIMAL(4 , 2 ) NOT NULL,
    PRIMARY KEY (id_producte),
    CONSTRAINT uk_producte_nom UNIQUE (nom),
    CONSTRAINT ck_producte_preu CHECK (preu BETWEEN 0.01 AND 99.99)
)  ENGINE=INNODB;

CREATE TABLE beguda (
    id_producte SMALLINT,
    capacitat SMALLINT(3) NOT NULL,
    alcoholica ENUM('N', 'S') NOT NULL,
    PRIMARY KEY (id_producte),
    CONSTRAINT fk_beguda_producte FOREIGN KEY (id_producte)
        REFERENCES producte (id_producte),
    CONSTRAINT ck_beguda_capacitat CHECK (capacitat BETWEEN 1 AND 150)
)  ENGINE=INNODB;

CREATE TABLE pizza
	(id_producte SMALLINT,
    PRIMARY KEY (id_producte),
    CONSTRAINT fk_pizza_producte FOREIGN KEY (id_producte)
        REFERENCES producte (id_producte)
)  ENGINE=INNODB;

CREATE TABLE postre
	(id_producte SMALLINT,
    PRIMARY KEY (id_producte),
    CONSTRAINT fk_postre_producte FOREIGN KEY (id_producte)
        REFERENCES producte (id_producte)
)  ENGINE=INNODB;

CREATE TABLE ingredient (
    id_ingredient VARCHAR(3),
    nom VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_ingredient),
    CONSTRAINT uk_ingredient_nom UNIQUE (nom)
)  ENGINE=INNODB;

CREATE TABLE pizza_ingredient (
    id_producte SMALLINT,
    id_ingredient VARCHAR(3),
    PRIMARY KEY (id_producte , id_ingredient),
    CONSTRAINT fk_pizza_ingredient_pizza FOREIGN KEY (id_producte)
        REFERENCES pizza (id_producte),
    CONSTRAINT fk_pizza_ingredient_ingredient FOREIGN KEY (id_ingredient)
        REFERENCES ingredient (id_ingredient)
)  ENGINE=INNODB;

CREATE TABLE comanda_producte (
    numero SMALLINT,
    id_producte SMALLINT,
    quantitat SMALLINT(2) NOT NULL,
    PRIMARY KEY (numero , id_producte),
    CONSTRAINT fk_comanda_producte_comanda FOREIGN KEY (numero)
        REFERENCES comanda (numero),
    CONSTRAINT comanda_producte_producte FOREIGN KEY (id_producte)
        REFERENCES producte (id_producte),
    CONSTRAINT ck_comanda_producte_quantitat CHECK (quantitat BETWEEN 1 AND 99)
)  ENGINE=INNODB;

##### INSERTS #####

INSERT INTO client (nom, telefon, adreca, poblacio) VALUE ('Josep Vila', '937853354', 'C. del Pi, 23', DEFAULT);
INSERT INTO client (nom, telefon, adreca) VALUE ('Carme Garcia', '937883402', 'Plaça Nova 3');
INSERT INTO client (nom, telefon, adreca, poblacio) VALUE ('Enric Miralles', '606989866', 'Carrer Romaní 6','Matadepera');
INSERT INTO client (nom, telefon, adreca, poblacio) VALUE ('Miquel Bover', '937753222', 'Carrer Can Boada 78', DEFAULT);
INSERT INTO client (nom, telefon, adreca) VALUE ('Marta Ribas', '937862655', 'Carrer Aviació 3');
INSERT INTO client (nom, telefon, adreca) VALUE ('Guillem Jam', '937858555', 'Carrer de Dalt, 4');
INSERT INTO client (nom, telefon, adreca) VALUE ('Júlia Guillén', '626895456', 'C. Robert 8');

INSERT INTO empleat (nom, cognoms) VALUE ('Jordi', 'Casas');
INSERT INTO empleat (nom, cognoms) VALUE ('Marta', 'Pou');

INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170109204500', 'L', 1, 1);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170109205100', 'D', 2, 1);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170109212000', 'D', 3, 1);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170109213300', 'D', 4, 2);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170110210000', 'D', 5, 1);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170110213500', 'L', 6, 2);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170110215000', 'D', 1, 2);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170111203200', 'D', 2, 1);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170111211000', 'D', 7, 1);
INSERT INTO comanda (data_hora, domicili_local, client_id, empleat_id) VALUE ('20170111212400', 'D', 1, 2);

INSERT INTO producte (nom, preu) VALUE ('Ampolla Coca-Cola', 1.95);
INSERT INTO producte (nom, preu) VALUE ('Ampolla Fanta Llimona', 1.95);
INSERT INTO producte (nom, preu) VALUE ('Llauna Nestea', 1.50);
INSERT INTO producte (nom, preu) VALUE ('Llauna Cervesa Damm', 1.55);
INSERT INTO producte (nom, preu) VALUE ('Llauna Cervesa sense alcohol', 1.55);
INSERT INTO producte (nom, preu) VALUE ('Pizza Barbacoa' ,19.95);
INSERT INTO producte (nom, preu) VALUE ('Pizza Carbonara', 18.95);
INSERT INTO producte (nom, preu) VALUE ('Pizza Hawaiana', 16.95);
INSERT INTO producte (nom, preu) VALUE ('Pizza 4 estacions', 18.95);
INSERT INTO producte (nom, preu) VALUE ('Pizza Ibèrica', 21.95);
INSERT INTO producte (nom, preu) VALUE ('Pizza De la casa', 19.95);
INSERT INTO producte (nom, preu) VALUE ('Gelat Cornetto Classic', 1.00);
INSERT INTO producte (nom, preu) VALUE ('Paquet de trufes de xocolata', 2.25);
INSERT INTO producte (nom, preu) VALUE ('Gelat Magnum', 1.95);

INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUE (1, 50, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUE (2, 50, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUE (3, 33, 'N');
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUE (4, 33, 'S');
INSERT INTO beguda (id_producte, capacitat, alcoholica) VALUE (5, 33, 'N');

INSERT INTO pizza (id_producte) VALUE (6);
INSERT INTO pizza (id_producte) VALUE (7);
INSERT INTO pizza (id_producte) VALUE (8);
INSERT INTO pizza (id_producte) VALUE (9);
INSERT INTO pizza (id_producte) VALUE (10);
INSERT INTO pizza (id_producte) VALUE (11);

INSERT INTO postre (id_producte) VALUE (12);
INSERT INTO postre (id_producte) VALUE (13);
INSERT INTO postre (id_producte) VALUE (14);

INSERT INTO ingredient (id_ingredient, nom) VALUE ('MOZ', 'Mozzarella');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('TOM', 'Salsa de tomàquet');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('BAC', 'Bacon');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('POL', 'Pollastre');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('CAR', 'Carn');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('BAR', 'Salsa barbacoa');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('XAM', 'Xampinyons');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('CAB', 'Salsa carbonara');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('PIN', 'Pinya');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('PER', 'Pernil york');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('TON', 'Tonyina');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('OLI', 'Olives negres');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('NAT', 'Tomàquet natural');
INSERT INTO ingredient (id_ingredient, nom) VALUE ('IBE', 'Pernil ibèric'); 
        
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'POL');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'CAR');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (6, 'BAR');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'XAM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (7, 'CAB');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (8, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (8, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (8, 'PIN');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (8, 'PER');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'TON');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'OLI');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (9, 'XAM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (10, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (10, 'NAT');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (10, 'IBE');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'MOZ');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'TOM');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'BAC');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'PER');
INSERT INTO pizza_ingredient (id_producte, id_ingredient) VALUE (11, 'CAR');


    
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10000, 6, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10000, 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10000, 2, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10000, 12, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10001, 10, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10002, 11, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10002, 1, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10002, 4, 3);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10002, 14, 4);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10003, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10003, 8, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10003, 4, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10003, 5, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10004, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10004, 9, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10004, 1, 6);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10005, 5, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10005, 1, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10005, 12, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10005, 13, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10006, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10006, 10, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10006, 11, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10007, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10007, 1, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10007, 2, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10008, 6, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10008, 4, 2);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10008, 14, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10009, 7, 1);
INSERT INTO comanda_producte (numero, id_producte, quantitat) VALUE (10009, 9, 1);

##### UNIÓN, INTERSECCIÓN Y DIFERENCIA #####

-- Tasca 1. Mostra el nom i cognoms dels clients i treballadors.

(
	SELECT cl.nom AS Nombres
		FROM client cl)
	UNION ALL
(
	SELECT CONCAT(em.nom, " " ,em.cognoms)
		FROM empleat em);

-- Tasca 2. Mostra la quantitat de pizzes, begudes i postres tenim a la nostra carta.

(SELECT COUNT(*) AS Quantitats
	FROM pizza)
UNION ALL 
(SELECT COUNT(*)
	FROM beguda)
UNION ALL
(SELECT COUNT(*)
	FROM postre);
		

-- Tasca 3. Mostra quins preus de begudes i postres coincideixen.

(SELECT p.preu
	FROM producte p
		INNER JOIN beguda be ON be.id_producte = p.id_producte)
 INTERSECT
(SELECT p.preu
	FROM producte p
		INNER JOIN postre pos ON pos.id_producte = p.id_producte);
        
-- Tasca 4. Mostra quins preus de postres no tenim a begudes.

(SELECT p.preu
	FROM producte p
		INNER JOIN postre pos ON pos.id_producte = p.id_producte)
EXCEPT
(SELECT p.preu
	FROM producte p
		INNER JOIN beguda be ON be.id_producte = p.id_producte);