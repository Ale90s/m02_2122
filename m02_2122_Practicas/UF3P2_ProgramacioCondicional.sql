/*
A REMARCAR QUE YO SUMO LAS DIFERENTES COMANDAS PARA LLEGAR AL IMPORTE MÍNIMO 
e.g: La suma de las diferentes comandas de Josep Vila superan los 50 euros por lo que va a entrar en el sorteo
*/

USE uf2_p2_pizzeria;

DELIMITER //
CREATE OR REPLACE PROCEDURE generaSorteigs(IN numSorteos INT, IN fecha DATE,IN nombreSorteo VARCHAR(30),
IN premiosAREpartir INT, IN importeMinimo INT, OUT estado TEXT)
BEGIN

	SET estado = "Los sorteos se han repartido satisfactoriamente.";


	IF (numSorteos > 0 AND importeMinimo > 0)
	THEN
        
        SET @iteraciones = 0;
        
		REPEAT
            INSERT INTO sorteig (nom, data, premis) VALUES (nombreSorteo, fecha, premiosARepartir);

			INSERT INTO sorteig_comanda(id_sorteig, numero) 
			SELECT LAST_INSERT_ID(), co.numero
				FROM comanda AS co 
					INNER JOIN client cl ON cl.id_client = co.client_id
					INNER JOIN comanda_producte AS copr ON co.numero = copr.numero             
					INNER JOIN producte AS pr ON copr.id_producte = pr.id_producte         
				GROUP BY cl.id_client      
				HAVING  SUM(copr.quantitat * pr.preu) > importeMinimo         
				ORDER BY RAND()         
				LIMIT premiosARepartir;
			
            SET fecha = fecha + INTERVAL '1' DAY;
			SET @iteraciones = @iteraciones + 1;
		UNTIL (@iteraciones = numSorteos)
		END REPEAT;
        
        IF ((SELECT COUNT(*)
				FROM sorteig_comanda
				WHERE id_sorteig = LAST_INSERT_ID()) < premiosARepartir)
		THEN
			SET estado = "Los premios del sorteo se han repartido satisfactoriamente pero sobran premios.";
		END IF;
        
	ELSE
		SET estado = "Tiene que haber más de un sorteo y el importe mínimo de compra es 1€.";
	END IF;


END //
DELIMITER ;

CALL generaSorteigs(3, '19700830',"VALE DESCUENTO" , 3, 50, @estado);
SELECT @estado;

CALL generaSorteigs(0, '19700830',"POSTRE GRATIS" , 3, 50, @estado);
SELECT @estado;

CALL generaSorteigs(1, '19700830',"VIAJE A VAVAYI" , 20, 10, @estado);
SELECT @estado;

SELECT *
	FROM sorteig;
SELECT *
	FROM sorteig_comanda;
