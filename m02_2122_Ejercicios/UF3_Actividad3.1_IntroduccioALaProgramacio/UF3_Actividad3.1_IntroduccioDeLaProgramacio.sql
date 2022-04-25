-- Tasca 1. Mostra quantes comandes es van fer l'11/01/2017. Fes servir una variable.

SET @tasca1Ex = '2017-01-11';

SELECT COUNT(numero) AS numComandas
	FROM comanda
    WHERE DATE(data_hora) = @tasca1Ex;

-- Tasca 2. Mostra el nom del clients i un contador del registre alhora que es mostren 
-- els valores de la consulta ordenats per nom.

SET @var = 0;
-- COMO HACER AUTO_INCREMENT DE LA VARIABLE CON LA CONDICION DE QUE SE ORDENE POR NOMBRE????
SELECT cl.nom, @var := @var + 1 numero
		FROM client cl, (SELECT @var := 0) AS var1
		ORDER BY cl.nom ASC;

-- Tasca 3. Enmagatzema la quantitat en euros que ha facturat l'empleat amb major facturació. 
-- Mostra posteriorment la dada enmagazemada a la variable amb el valor resultant.

SELECT SUM(cp.quantitat * p.preu) AS preuTotal INTO @maxFacturado
	FROM empleat e
		INNER JOIN comanda co ON co.empleat_id = e.id_empleat
		INNER JOIN comanda_producte cp ON cp.numero = co.numero
        INNER JOIN producte p ON p.id_producte = cp.id_producte
	GROUP BY e.nom, e.cognoms
    ORDER BY preuTotal DESC
    LIMIT 1;
    
SELECT @maxFacturado;

-- Tasca 4. A partir d'una variable que contingu el valor d'increment de preus 1%, 
-- aplica l'increment de preus a tots els postres.

SET @incremento = 0.01;

SELECT p.nom, (p.preu + (p.preu * @incremento)) AS preuAmbIva
	FROM producte p
		INNER JOIN postre pos ON pos.id_producte = p.id_producte;

-- Tasca 5. Localitza el client que més ha comprat (valor total de les seves comandes). 
-- Enmagatzema el nom del client i el preu total de totes les seves comandes, 
-- posteriorment mostra les dades enmagazemades de les variables.
    
SELECT SUM(p.preu * cp.quantitat) AS comandaTotal INTO @sumaComanda
	FROM client c
		INNER JOIN comanda co ON co.client_id = c.id_client
        INNER JOIN comanda_producte cp ON cp.numero = co.numero
        INNER JOIN producte p ON p.id_producte = cp.id_producte
	GROUP BY c.id_client
    ORDER BY comandaTotal DESC
    LIMIT 1;
        
SELECT @sumaComanda;
SELECT @nomCliente;

-- Tasca 6. Cerca que busqui totes les pizzes que tinguin com a ingredient BAC. 
-- Fes servir una variable per l'ingredient.

SET @barbacoa = 'BAC';

SELECT p.nom 
	FROM pizza piz
		INNER JOIN producte p ON p.id_producte = piz.id_producte
		INNER JOIN pizza_ingredient pizing ON pizing.id_producte = piz.id_producte
        INNER JOIN ingredient ing ON ing.id_ingredient = pizing.id_ingredient
	WHERE ing.id_ingredient = @barbacoa
    GROUP BY p.nom;

-- Tasca 7. Fent l'ús de variables, modifica el preu del producte 3 a 1.65 €.

SET @newPrice = 1.65;

UPDATE producte
	SET preu = @newprice
    WHERE id_producte = 3;

SELECT p.nom, p.preu
	FROM producte p
    WHERE id_producte = 3;
