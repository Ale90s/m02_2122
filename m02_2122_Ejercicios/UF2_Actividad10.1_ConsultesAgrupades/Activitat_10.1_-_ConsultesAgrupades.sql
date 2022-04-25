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

##### CONSULTES AGRUPADES #####

-- Tasca 1. Mostra les vegades que utilitzem cada ingredient.

SELECT 	id_ingredient, COUNT(*) AS SumaIngredientes
	FROM pizza_ingredient
    GROUP BY id_ingredient;

-- Tasca 2. Mostra els ingredients que utilitzem més de 2 vegades.
    
SELECT ing.nom, COUNT(*) AS veces
	FROM pizza_ingredient pizing
		INNER JOIN ingredient ing ON ing.id_ingredient = pizing.id_ingredient
    GROUP BY ing.nom
    HAVING veces > 2;

-- Tasca 3. Mostra el numero de comanda y el preu total de cada comanda.

SELECT cp.numero, SUM(cp.quantitat * p.preu) AS PreuTotal
	FROM comanda_producte cp
		INNER JOIN producte p ON p.id_producte = cp.id_producte
    GROUP BY cp.numero
    ORDER BY cp.numero;

-- Tasca 4. Mostra quants productes hi ha a cada comanda.

SELECT cp.numero, SUM(quantitat) AS sumaProductos
	FROM producte p
		INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte
    GROUP BY cp.numero
    ORDER BY cp.numero;

-- Tasca 5. Mostra els clients que han facturat més de 50€.

SELECT cl.nom, SUM(cp.quantitat * p.preu) AS preuTotal
	FROM comanda co
		INNER JOIN client cl ON cl.id_client = co.client_id
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
		INNER JOIN producte p ON p.id_producte = cp.id_producte
	GROUP BY cl.nom
    HAVING preuTotal > 50;

-- Tasca 6. Mostra quant ha facturat cada empleat.

SELECT CONCAT(e.nom, " ", e.cognoms) AS nombreEmpleado, SUM(cp.quantitat * p.preu) AS sumaTotal
	FROM empleat e
		INNER JOIN comanda co ON co.empleat_id = e.id_empleat
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
		INNER JOIN producte p ON p.id_producte = cp.id_producte
    GROUP BY nombreEmpleado;
    
-- Tasca 7. Mostra els empleats que han facturat més de 200€.

SELECT CONCAT(e.nom, " ", e.cognoms) AS nombreEmpleado, SUM(cp.quantitat * p.preu) AS sumaTotal
	FROM empleat e
		INNER JOIN comanda co ON co.empleat_id = e.id_empleat
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
		INNER JOIN producte p ON p.id_producte = cp.id_producte
    GROUP BY nombreEmpleado
    HAVING sumaTotal > 200;

-- Tasca 8. Mostra la quantitat de postres que han demanat cadascun dels clients Josep Vila i Guillem Jam.

SELECT cl.nom, SUM(cp.quantitat) AS totalPostre
	FROM client cl
		INNER JOIN comanda co ON co.client_id = cl.id_client
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
		INNER JOIN producte p ON p.id_producte = cp.id_producte
		INNER JOIN postre pos ON pos.id_producte = p.id_producte
    WHERE cl.nom IN ("Josep Vila", "Guillem Jam")
	GROUP BY cl.nom;

-- Tasca 9. Mostra les comandes amb un import superior a 40€ en pizzes, ordenat per l’import de mayor a menor i per numero de comanda.

SELECT cp.numero, SUM(p.preu * cp.quantitat) AS preuPizzas
	FROM comanda_producte cp
    INNER JOIN producte p ON p.id_producte = cp.id_producte
    INNER JOIN pizza piz ON piz.id_producte = p.id_producte
    GROUP BY cp.numero
    HAVING preuPizzas > 40;

-- Tasca 10. Mostra els clients que han demanat més de 2 vegades la mateixa pizza. Mostra-ho ordenat per les vegades de més gran a més petit i per ordre alfabètic del client.

SELECT c.nom
	FROM client c
		INNER JOIN comanda co ON co.client_id = c.id_client
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
		INNER JOIN producte p ON p.id_producte = cp.id_producte
		INNER JOIN pizza piz ON piz.id_producte = p.id_producte
    GROUP BY c.nom, p.nom
    HAVING sum(cp.quantitat) > 2;

-- Tasca 11. De les comandes que han demanat postres, mostra l'import total de la comanda.

SELECT cp.numero, 
	(SELECT SUM(copr.quantitat * pr.preu)
		FROM comanda_producte copr
				INNER JOIN producte pr ON pr.id_producte = copr.id_producte
		WHERE cp.numero = copr.numero) AS comandasConPostre
	FROM comanda_producte cp
		INNER JOIN producte p ON p.id_producte = cp.id_producte
		INNER JOIN postre pos ON pos.id_producte = p.id_producte
    GROUP BY cp.numero;

-- Tasca 12. Mostra el preu mitjà dels productes de cada comanda ordenat del preu més baix al més alt.

SELECT cp.numero, AVG(p.preu) AS preuMitja
	FROM comanda_producte cp
		INNER JOIN producte p ON p.id_producte = cp.id_producte
	GROUP BY cp.numero
    ORDER BY preuMitja;

-- Tasca 13. Mostra l'import total que hem facturat segons si han demanat les comandes per servir a domicili o al local.

SELECT co.domicili_local, SUM(cp.quantitat * p.preu) AS totalDemandado
	FROM comanda co
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
		INNER JOIN producte p ON p.id_producte = cp.id_producte
	GROUP BY co.domicili_local;

-- Tasca 14. Mostra el client i el preu de la pizza més cara que ha demanat cada client de Terrassa. Ordena-ho pel preu de la pizza de més gran a més petit.

SELECT 	cl.nom, MAX(p.preu)
	FROM client cl
		INNER JOIN comanda co ON co.client_id = cl.id_client
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
		INNER JOIN producte p ON p.id_producte = cp.id_producte
        INNER JOIN pizza piz ON piz.id_producte = p.id_producte
	WHERE cl.poblacio = 'Terrassa'
	GROUP BY cl.nom;

-- Tasca 15. Mostra el nom del client i el número comanda de les que tenen 5 o més productes.

SELECT 	cl.nom, co.numero
	FROM client cl
		INNER JOIN comanda co ON co.client_id = cl.id_client
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
    GROUP BY co.numero
		HAVING COUNT(cp.id_producte) >= 5
    ORDER BY co.numero;

-- Tasca 16. Mostra la facturació total de cada dia.

SELECT DATE(co.data_hora), SUM(cp.quantitat * p.preu)
	FROM comanda_producte cp
		INNER JOIN producte p ON p.id_producte = cp.id_producte
        INNER JOIN comanda co ON co.numero = cp.numero
	GROUP BY DATE(co.data_hora);

-- Tasca 17. Mostra la facturació total de cada setmana.

SELECT YEAR(co.data_hora) AS año, WEEKOFYEAR(co.data_hora) AS semanaDelAño, SUM(cp.quantitat * p.preu) AS facturacionTotal
	FROM comanda_producte cp
		INNER JOIN producte p ON p.id_producte = cp.id_producte
        INNER JOIN comanda co ON co.numero = cp.numero
	GROUP BY WEEKOFYEAR(co.data_hora) AND YEAR(co.data_hora);

-- Tasca 18. Dels client que han demanat alguna vegada Pizza Barbacoa, 
-- mostra quants comandes ha demanat. Ordena-ho per les comandes, de més a menys.

SELECT cl.nom, COUNT(com.numero) AS numeroComandas
	FROM client cl
		INNER JOIN comanda com ON com.client_id = cl.id_client
        INNER JOIN comanda_producte cp ON cp.numero = com.numero
        INNER JOIN producte p ON p.id_producte = cp.id_producte
        INNER JOIN pizza piz ON piz.id_producte = p.id_producte
	WHERE p.nom = "Pizza Barbacoa"
    GROUP BY cl.nom
    ORDER BY numeroComandas DESC;
    
-- Tasca 19. Mostra quantes comandes hem servit a cada població.

SELECT cl.poblacio, COUNT(*)
	FROM client cl
    INNER JOIN comanda com ON com.client_id = cl.id_client
    GROUP BY cl.poblacio
    ORDER BY cl.poblacio;
