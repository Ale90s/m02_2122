DELIMITER //
CREATE OR REPLACE PROCEDURE generaSorteigs(IN nSorteos INT, IN fecha DATE,IN nombreSorteo VARCHAR(30),
IN premiosAREpartir INT, IN importeMinimo INT)
BEGIN

	SET @error = "Todo correcto";


	IF (nSorteos > 0 AND importeMinimo > 0)
	THEN
		SELECT 1;
	ELSE
		SET @error = "Tiene que haber más de un sorteo y el importe mínimo de compra es 1€";
	END IF;


END //
DELIMITER ;

CALL generaSorteigs(1, '19700808', 1, 1, 1);
SELECT @error;

SELECT *
	FROM sorteig;
SELECT *
	FROM sorteig_comanda;

INSERT INTO sorteig (nom, data, premis)
	VALUES ("Test", '19700808', 2);

INSERT INTO sorteig_comanda (id_sorteig, numero)
	VALUES (18,10002);

DELETE FROM sorteig;

DELETE FROM sorteig_comanda
	WHERE numero = 10002;






SELECT numero, SUM(p.preu * cp.quantitat) AS test
	FROM comanda_producte cp
		INNER JOIN producte p ON p.id_producte = cp.id_producte
    GROUP BY numero
    HAVING test > 50;








select FLOOR(RAND() * (10 - 5 + 1) + 5);

SET @a = 10;
SET @b = 5;

SELECT FLOOR(RAND() * (@a - @b + 1) + @b);