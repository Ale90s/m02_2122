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

##### CONSULTES NIADES 3 #####

-- Tasca 1. Mostra la quantitat de pizzes, begudes i postres tenim a la nostra carta.

SELECT (SELECT COUNT(p.nom)
		FROM producte p
		INNER JOIN pizza piz ON piz.id_producte = p.id_producte) AS cantPizzas,
        (SELECT COUNT(pr.nom)
        FROM producte pr
        INNER JOIN beguda be ON be.id_producte = pr.id_producte) AS cantBebida;
        
-- Tasca 2. Mostra la quantitat de pizzes, begudes i postres que hem venut.

SELECT (SELECT SUM(copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN producte p ON p.id_producte = copr.id_producte
    INNER JOIN pizza piz ON piz.id_producte = p.id_producte) AS numPizzas,
    (SELECT SUM(copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN producte p ON p.id_producte = copr.id_producte
    INNER JOIN beguda be ON be.id_producte = p.id_producte) AS numBebidas,
    (SELECT SUM(copr.quantitat)
	FROM comanda_producte copr
    INNER JOIN producte p ON p.id_producte = copr.id_producte
    INNER JOIN postre pos ON pos.id_producte = p.id_producte) AS numPostres;

-- Tasca 3. Mostra el numero de comanda y el preu total de cada comanda.

SELECT DISTINCT copr.numero, (SELECT SUM(p.preu * cp.quantitat)
					FROM producte p
					INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte
                    WHERE cp.numero = copr.numero) AS precioComanda
FROM comanda_producte AS copr
ORDER BY copr.numero;
### 	EJEMPLO CON GROUP BY	###
SELECT copr.numero, SUM(p.preu * copr.quantitat) AS precio_total
	FROM comanda_producte copr
    INNER JOIN producte p ON copr.id_producte = p.id_producte
    GROUP BY copr.numero
    ORDER BY copr.numero;

-- Tasca 4. De les comandes que han demanat postres, mostra l'import total de la comanda.

SELECT DISTINCT cp.numero, (SELECT SUM(copr.quantitat * pr.preu)
								FROM comanda_producte copr
                                INNER JOIN producte pr ON pr.id_producte = copr.id_producte
                                WHERE cp.numero = copr.numero
							) AS sumaTotal
	FROM comanda_producte cp
    INNER JOIN producte p ON p.id_producte = cp.id_producte
    INNER JOIN postre pos ON pos.id_producte = p.id_producte
    ORDER BY cp.numero;

-- Tasca 5. Mostra quants productes hi ha a cada comanda.

SELECT DISTINCT cp.numero, 
	(SELECT COUNT(pr.id_producte)
		FROM producte pr
			INNER JOIN comanda_producte copr ON copr.id_producte = pr.id_producte
		WHERE cp.numero = copr.numero) AS productesTotal
	FROM comanda_producte cp
    ORDER BY cp.numero;

-- Tasca 6. Dels clients que han demanat alguna vegades comandes al local,
-- mostra el número i la data  de totes les comandes que han fet aquests clients.

SELECT c.nom, com.numero, DATE(com.data_hora) AS fecha
	FROM client c
    INNER JOIN comanda com ON com.client_id = c.id_client
    WHERE c.nom IN (SELECT cl.nom
					FROM client cl
						INNER JOIN comanda co ON co.client_id = cl.id_client
					WHERE co.domicili_local = 'L'
					ORDER BY co.numero);

-- Tasca 7. Mostra quants ingredients té cada pizza.

SELECT DISTINCT p.nom,
	(SELECT COUNT(*)
		FROM pizza_ingredient pzg
        INNER JOIN pizza pz ON pz.id_producte = pzg.id_producte
        WHERE pz.id_producte = piz.id_producte
        ) AS numIng
	FROM producte p
    INNER JOIN pizza piz ON piz.id_producte = p.id_producte
    ORDER BY p.nom;

-- Tasca 8. Mostra quantes pizzes barbacoa que ha demanat cada client.

SELECT id_client, nom,
		(
        SELECT IFNULL(SUM(copr.quantitat), 0)
			FROM comanda co
				INNER JOIN comanda_producte copr ON copr.numero = co.numero
				INNER JOIN producte p ON p.id_producte = copr.id_producte
				INNER JOIN pizza piz ON piz.id_producte = p.id_producte
			WHERE p.nom = "Pizza Barbacoa" AND client_id = cl.id_client
        ) AS pizzasBarbacoas
	FROM client AS cl;

-- Tasca 9. Dels clients que han demanat la pizza al local, mostra quants productes diferents han demanat.

SELECT DISTINCT p.nom
	FROM producte p
    INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte
    INNER JOIN comanda co ON co.numero = cp.numero
    INNER JOIN client c ON c.id_client = co.client_id
    WHERE c.id_client IN (SELECT cl.id_client
							FROM client cl
								INNER JOIN comanda com ON com.client_id = cl.id_client
							WHERE com.domicili_local = 'L')
ORDER BY p.nom;

-- Tasca 10. Mostra la quantitat de begudes i de pizzes de la comanda 10005.

SELECT co.numero, 
	(SELECT IFNULL(SUM(cp.quantitat), 0)
    FROM comanda_producte cp
		INNER JOIN beguda be ON be.id_producte = cp.id_producte
    WHERE co.numero = cp.numero) AS sumaBebidas,
	(SELECT IFNULL(SUM(cp2.quantitat), 0)
    FROM comanda_producte cp2
		INNER JOIN pizza piz ON piz.id_producte = cp2.id_producte
	WHERE co.numero = cp2.numero) AS sumaPizzas
FROM comanda co
WHERE co.numero = 10005;

-- Tasca 11. Mostra els clients que han facturat més de 50€.

### 	MAS EFICIENTE	###
SELECT nom, facturacio
FROM (SELECT nom,
	(SELECT SUM(copr.quantitat * pr.preu) AS facturacio
	FROM comanda com
		INNER JOIN comanda_producte copr ON copr.numero = com.numero
		INNER JOIN producte pr ON pr.id_producte = copr.id_producte
        WHERE com.client_id = cl.id_client) AS facturacio
	FROM client cl) AS tablaDinamica # El hecho de ponerle el nombre tablaDinamica lo hace "persona" #
    WHERE facturacio > 50;
### 	MENOS EFICIENTE		###
SELECT DISTINCT cl.nom,
	(SELECT SUM(copr.quantitat * pr.preu)
	FROM client c
		INNER JOIN comanda com ON com.client_id = c.id_client
		INNER JOIN comanda_producte copr ON copr.numero = com.numero
		INNER JOIN producte pr ON pr.id_producte = copr.id_producte
	WHERE cl.id_client = c.id_client) AS facturaTotal
FROM client cl
    WHERE (SELECT SUM(copr.quantitat * pr.preu)
			FROM client c
				INNER JOIN comanda com ON com.client_id = c.id_client
				INNER JOIN comanda_producte copr ON copr.numero = com.numero
				INNER JOIN producte pr ON pr.id_producte = copr.id_producte
           WHERE cl.id_client = c.id_client) > 50;

-- Tasca 12. Mostra les vegades que utilitzem cada ingredient.

SELECT ing.nom,
				(SELECT COUNT(ingr.nom)
					FROM ingredient ingr
						INNER JOIN pizza_ingredient pizing2 ON pizing2.id_ingredient = ingr.id_ingredient
						INNER JOIN pizza piz2 ON piz2.id_producte = pizing2.id_producte
						INNER JOIN producte p2 ON p2.id_producte = piz2.id_producte
						INNER JOIN comanda_producte cp2 ON cp2.id_producte = p2.id_producte
					WHERE ingr.nom = ing.nom) AS totalIng
	FROM ingredient ing
    ORDER BY ing.nom;

####	UTILIZANDO GROUP BY		####
SELECT ing.nom, COUNT(ing.nom) AS totalIng
	FROM ingredient ing
		INNER JOIN pizza_ingredient pizing ON pizing.id_ingredient = ing.id_ingredient
        INNER JOIN pizza piz ON piz.id_producte = pizing.id_producte
        INNER JOIN producte p ON p.id_producte = piz.id_producte
        INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte
    GROUP BY ing.nom
    ORDER BY ing.nom;

-- Tasca 13. Mostra les vegades totals que hem utilitzat cada ingredient 
-- (tingueu en compte que si hem demanat dues pizzes, hem de comptar els ingredients dues vegades).

SELECT ingr.nom,
		(SELECT SUM(cp.quantitat)
		FROM ingredient ing
			INNER JOIN pizza_ingredient pizing ON pizing.id_ingredient = ing.id_ingredient
			INNER JOIN pizza piz ON piz.id_producte = pizing.id_producte
			INNER JOIN producte p ON p.id_producte = piz.id_producte
			INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte
            WHERE ingr.id_ingredient = ing.id_ingredient) AS totalIngredientes
	FROM ingredient ingr
	ORDER BY ingr.nom;

-- Tasca 14. Mostra l'import que hem facturat de cada beguda

SELECT p.nom,
		(SELECT SUM(cp.quantitat * pr.preu)
			FROM comanda_producte cp
				INNER JOIN producte pr ON pr.id_producte = cp.id_producte
                INNER JOIN beguda be ON be.id_producte = pr.id_producte
                WHERE p.id_producte = pr.id_producte) AS totalBebidas
	FROM producte p
	INNER JOIN beguda be ON be.id_producte = p.id_producte
    ORDER BY p.nom;
