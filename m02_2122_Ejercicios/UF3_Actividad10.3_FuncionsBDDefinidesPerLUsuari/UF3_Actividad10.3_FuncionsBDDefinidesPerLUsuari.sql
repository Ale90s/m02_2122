USE uf2_p2_pizzeria;

-- Tasca 1. Crea una funció que realitzi la funcionalitat de la Tasca 1 de M02 UF2 Activitat 9.1 - Consultes niades.

/*
-- Tasca 1. Mostra els ingredients de les pizzes de la darrera comanda que s'ha demanat.

SELECT DISTINCT ing.nom
	FROM ingredient AS ing
    INNER JOIN pizza_ingredient pizing ON pizing.id_ingredient = ing.id_ingredient
    INNER JOIN pizza piz ON piz.id_producte = pizing.id_producte
    INNER JOIN producte pr ON pr.id_producte = piz.id_producte
    INNER JOIN comanda_producte copr ON copr.id_producte = pr.id_producte
    WHERE copr.numero = (SELECT MAX(numero) FROM comanda_producte);
*/

-- Tasca 2. Crea una funció que realitzi la funcionalitat de la Tasca 10 de M02 UF2 Activitat 9.1 - Consultes niades.

/*
-- Tasca 10. De la comanda que s'ha demanat a l'hora més tard, mostra les pizzes que ha demanat.

SELECT DISTINCT pr.nom
FROM comanda co 
	INNER JOIN comanda_producte copr ON co.numero = copr.numero
	INNER JOIN producte pr ON copr.id_producte = pr.id_producte
	INNER JOIN pizza piz ON pr.id_producte = piz.id_producte
WHERE TIME(co.data_hora) = (SELECT MAX(TIME(co.data_hora))
							FROM comanda co);
*/

-- Tasca 3. Crea una funció que realitzi la funcionalitat de la Tasca 11 de M02 UF2 Activitat 9.1 - Consultes niades.

/*
SELECT DISTINCT ing.nom
FROM ingredient ing
	INNER JOIN pizza_ingredient pizing  ON ing.id_ingredient = pizing.id_ingredient
    INNER JOIN pizza piz ON pizing.id_producte = piz.id_producte
    INNER JOIN producte pr ON piz.id_producte = pr.id_producte
	INNER JOIN comanda_producte copr ON pr.id_producte = copr.id_producte
WHERE copr.quantitat = (SELECT MAX(quantitat)
						FROM comanda_producte copr
							INNER JOIN producte pr ON copr.id_producte = pr.id_producte
							INNER JOIN pizza piz ON pr.id_producte = piz.id_producte);
*/

-- Tasca 4. Mostra a partir d'una consulta tipus SELECT a la taula productes, si un producte es pizza, beguda o postre.

