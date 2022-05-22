USE uf2_p2_pizzeria;

-- Tasca 1. Crea una funció que realitzi la funcionalitat de la Tasca 1 de M02 UF2 Activitat 9.1 - Consultes niades.
-- Mostra els ingredients de les pizzes de la darrera comanda que s'ha demanat.

DELIMITER //
CREATE OR REPLACE FUNCTION muestraIngredientes()
RETURNS INT
BEGIN

RETURN (SELECT MAX(numero) FROM comanda);

END //
DELIMITER ;

SELECT DISTINCT ing.nom
	FROM ingredient AS ing
    INNER JOIN pizza_ingredient pizing ON pizing.id_ingredient = ing.id_ingredient
    INNER JOIN pizza piz ON piz.id_producte = pizing.id_producte
    INNER JOIN producte pr ON pr.id_producte = piz.id_producte
    INNER JOIN comanda_producte copr ON copr.id_producte = pr.id_producte
    WHERE copr.numero = muestraIngredientes();

-- Tasca 2. Crea una funció que realitzi la funcionalitat de la Tasca 10 de M02 UF2 Activitat 9.1 - Consultes niades.
-- De la comanda que s'ha demanat a l'hora més tard, mostra les pizzes que ha demanat.

DELIMITER //
CREATE OR REPLACE FUNCTION horaMasTarde()
RETURNS TIME
BEGIN
	RETURN (SELECT MAX(TIME(co.data_hora)) FROM comanda co);
END //
DELIMITER ;

SELECT DISTINCT pr.nom
FROM comanda co 
	INNER JOIN comanda_producte copr ON co.numero = copr.numero
	INNER JOIN producte pr ON copr.id_producte = pr.id_producte
	INNER JOIN pizza piz ON pr.id_producte = piz.id_producte
WHERE TIME(co.data_hora) = horaMasTarde();
                            


-- Tasca 3. Crea una funció que realitzi la funcionalitat de la Tasca 11 de M02 UF2 Activitat 9.1 - Consultes niades.
-- Mostra els ingredients de les pizzes que s'han demanat més vegades en una comanda.

DELIMITER //
CREATE OR REPLACE FUNCTION ingPizzesMasPedidas()
RETURNS INT
BEGIN

	RETURN (SELECT MAX(copr.quantitat)
						FROM comanda_producte copr
							INNER JOIN producte pr ON copr.id_producte = pr.id_producte
							INNER JOIN pizza piz ON pr.id_producte = piz.id_producte);

END //
DELIMITER ;
                            
SELECT DISTINCT ing.nom
FROM ingredient ing
	INNER JOIN pizza_ingredient pizing  ON ing.id_ingredient = pizing.id_ingredient
    INNER JOIN pizza piz ON pizing.id_producte = piz.id_producte
    INNER JOIN producte pr ON piz.id_producte = pr.id_producte
	INNER JOIN comanda_producte copr ON pr.id_producte = copr.id_producte
WHERE copr.quantitat = (ingPizzesMasPedidas());


-- Tasca 4. Mostra a partir d'una consulta tipus SELECT a la taula productes, si un producte es pizza, beguda o postre.

DELIMITER //
CREATE OR REPLACE FUNCTION tipoProducto(ident_producto INT)
RETURNS VARCHAR(50)
BEGIN

IF(SELECT 1 FROM pizza WHERE id_producte = ident_producto) THEN

RETURN "Es una pizza";

ELSEIF(SELECT 1 FROM beguda WHERE id_producte = ident_producto) THEN

RETURN "Es una bebida";

ELSEIF(SELECT 1 FROM postre WHERE id_producte = ident_producto) THEN

RETURN "Es un postre";

ELSE 

RETURN "No se ha encontrado el producto";

END IF;
END //
DELIMITER ;

SELECT tipoProducto(4);
SELECT tipoProducto(10);
SELECT tipoProducto(100);
SELECT tipoProducto(13);

/* A PARTIR DE AQUI SOLUCIONES JOSE */
-- Tasca 5. Crea una funció que realitzi la funcionalitat de la Tasca 3 de M02 UF2 Activitat 9.2 - Consultes niades III.
DELIMITER // 
CREATE OR REPLACE FUNCTION getImportTotalComanda(pNumero SMALLINT(6)) 
RETURNS DECIMAL(6,2)
BEGIN 
	RETURN (SELECT SUM(p.preu * cp.quantitat)
			FROM comanda_producte cp
				INNER JOIN producte p ON p.id_producte = cp.id_producte
			WHERE cp.numero = pNumero); 
END // 
DELIMITER ; 

SELECT co.numero, getImportTotalComanda(co.numero)
FROM comanda co
ORDER BY co.numero;


-- Tasca 6. Crea una funció que realitzi la funcionalitat de la Tasca 5 de M02 UF2 Activitat 9.2 - Consultes niades III.
DELIMITER // 
CREATE OR REPLACE FUNCTION getQuantitatProductesComanda(pNumero SMALLINT(6)) 
RETURNS INT
BEGIN 
	RETURN (SELECT SUM(cp.quantitat)
			FROM comanda_producte cp
			WHERE cp.numero = pNumero); 
END // 
DELIMITER ; 

SELECT co.numero, getQuantitatProductesComanda(co.numero) AS NumProductesComanda
FROM comanda co;
