USE uf2_p2_pizzeria;

-- Tasca1. 
/*
Afegeix una columna nova la taula clients que s’anomenti num_comandes. 
Aquest nou camp contindrà la quantitat de comandes diferents que ha realitzat aquell client.

Crea un procediment emmagatzemat que, sense rebre cap paràmetre, 
ompli la columna num_comandes amb el nombre de comandes que ha fet cada client.
*/

ALTER TABLE client
	ADD num_comandes SMALLINT;

DELIMITER //
CREATE OR REPLACE PROCEDURE numComandes()
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE var_nComandas INT;
DECLARE var_id_cliente INT;
DECLARE nComandas CURSOR FOR 
	SELECT COUNT(*), cl.id_client
	FROM client cl
		INNER JOIN comanda co ON co.client_id = cl.id_client
	GROUP BY cl.id_client;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;

OPEN nComandas;

bucle: LOOP
FETCH FROM nComandas INTO var_nComandas, var_id_cliente;

IF done THEN
	LEAVE bucle;
END IF;

UPDATE client 
		SET num_comandes = var_nComandas
	WHERE id_client = var_id_cliente;
    
END LOOP;

CLOSE nComandas;

END //
DELIMITER ;

SELECT *
	FROM client;

CALL numComandes();
    
-- Tasca 2. 
/*
Afegeix una columna nova a la taula empleats que s’anomeni total_facturacio. 
Contindrà la facturació total que ha fet aquell empleat, excloent-hi l'IVA. 
Per a aquesta activitat, suposarem que tots els preus dels productes són amb IVA inclòs.
Crea un procediment emmagatzemat que, rebent per paràmetre un enter que representa el % d'IVA (per exemple, 10), 
ompli la columna de quantitat de facturació total de l'empleat sense comptar l'IVA.
*/

ALTER TABLE empleat
	ADD total_facturacio INT;

DELIMITER //
CREATE OR REPLACE PROCEDURE facturacioTotal(IN iva INT)
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE var_id_empleado INT;
DECLARE var_facComandas INT;
DECLARE facClientes CURSOR FOR
SELECT co.empleat_id, SUM(cp.quantitat * p.preu)
	FROM comanda co
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
        INNER JOIN producte p ON p.id_producte = cp.id_producte
	GROUP BY co.empleat_id;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;

OPEN facClientes;

bucle:LOOP
FETCH FROM facClientes INTO var_id_empleado, var_facComandas;

IF done THEN
	LEAVE bucle;
END IF;

UPDATE empleat
	SET total_facturacio = var_facComandas - (var_facComandas * (iva / 100))
    WHERE id_empleat = var_id_empleado;

END LOOP;

CLOSE facClientes;

END //
DELIMITER ;

CALL facturacioTotal(10);

SELECT *
	FROM empleat;
    


-- Tasca 3.
/*
Crea un procediment anomenat duplicaProductesByTipus. El procediment rebrà per paràmetre el tipus de
productes a duplicar (‘B’ per a les begudes, ‘D’ pels postres i ‘P’ per a les pizzes).
El procediment duplicarà a la taula o taules corresponents tots els productes d'aquell tipus, 
afegint al final del nom del producte s'hi afegirà el text "(còpia)". Per exemple, si estem duplicant 
les begudes i tenim una 'Ampolla Coca-Cola' es crearà un nou producte anomenat 'Ampolla Coca-Cola (còpia)’.
*/
