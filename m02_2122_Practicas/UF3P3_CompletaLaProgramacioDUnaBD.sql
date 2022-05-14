-- Tasca 1.
/*
Crea una funció que donada una data i una lletra (que pot ser P o U), ens digui si escollim ‘P’, 
la primera comanda del primer dia del mes de la data o la que més a prop està d’aquest primer dia del mes; en el cas de ‘U’ ens digui quina és la comanda de l'últim dia del mes o la que més a prop estigui. 
Per exemple, a partir de la data 04/04/2020 i la lletra ‘P’, buscarem la comanda del dia 01/04/2020, si no hi ha, doncs, cerquem o el dia anterior o posterior al dia 1, i així fins que trobem una comanda. 
En el cas que hi hagi més d’una, retornem només una d’aquestes.
*/

DELIMITER //
CREATE OR REPLACE FUNCTION TascaUn(fecha DATE, tipo ENUM('P', 'U'))
RETURNS INT
BEGIN

	DECLARE fechaAnterior, fechaPosterior DATE;
    
    IF (SELECT 1 FROM comanda WHERE DATE(data_hora) = fecha LIMIT 1) THEN
		RETURN 
			(SELECT numero
				FROM comanda
					WHERE DATE(data_hora) = fecha
				LIMIT 1);
    END IF;
    
	CASE tipo
		WHEN 'P' THEN
			SET fechaAnterior = (LAST_DAY(fecha) + INTERVAL 1 DAY) - INTERVAL 1 MONTH;
            SET fechaPosterior = fechaAnterior;
		WHEN 'U' THEN
			SET fechaPosterior = LAST_DAY(fecha);
            SET fechaAnterior = fechaPosterior;
    END CASE;
    
    REPEAT
		
		SET fechaPosterior = fechaPosterior + INTERVAL 1 DAY;  
		SET fechaAnterior = fechaAnterior - INTERVAL 1 DAY;
        
	UNTIL ((SELECT 1 FROM comanda WHERE DATE(data_hora) = fechaAnterior LIMIT 1) OR
				(SELECT 1 FROM comanda WHERE DATE(data_hora) = fechaAnterior LIMIT 1))		
	END REPEAT;
    
    IF (SELECT 1 FROM comanda WHERE DATE(data_hora) = fechaAnterior LIMIT 1) THEN
	RETURN
		(SELECT numero
				FROM comanda
					WHERE DATE(data_hora) = fechaAnterior
				LIMIT 1);
    ELSE
    RETURN
		(SELECT numero
				FROM comanda
					WHERE DATE(data_hora) = fechaPosterior
				LIMIT 1);
    END IF;

END //
DELIMITER ;

SELECT TascaUn(@fecha, 'P');
SELECT TascaUn(@fecha, 'U');
SET @fecha = DATE(20170103);

-- Tasca 2. 
/*
Crea un procediment per què donat dos nombres, generi un nombre aleatori entre el primer i el segon. 
Mostri les comandes on hagin demanat com a nombre de productes diferents, iguals al nombre generat (no tingueu en compte la quantitat demanada dels productes). 
Tingues en compte que l'ordre pot ser qualsevol (el primer nombre pot ser més petit que el segon o al revés).
*/

DELIMITER //
CREATE OR REPLACE PROCEDURE TascaDos(IN num1 INT, IN num2 INT)
BEGIN

	DECLARE numAleatorio INT;

	IF (num1 > num2) THEN
    
		SET numAleatorio = FLOOR(RAND()*(num1-num2+1))+num2;
    
	ELSEIF (num1 < num2) THEN
    
		SET numAleatorio = FLOOR(RAND()*(num2-num1+1))+num1;
    
    ELSE -- EN CASO DE QUE LOS NÚMEROS SEAN IGUALES
    
		SET numAleatorio = num1;
    
    END IF;
	
    SELECT *
			FROM comanda_producte
			GROUP BY numero
			HAVING COUNT(*) = numAleatorio;
	
END //
DELIMITER ;

CALL TascaDos(1, 5);
CALL TascaDos(2, 2);
CALL TascaDos(0, 3);
CALL TascaDos(4, 2);

-- Tasca 3.
/*
Crea un procediment que  indicant  per paràmetre, si vol clients o empleats, mostri tots els camps que pertanyen a cada taula, 
però amb el nom i cognoms, on la primera lletra aparegui en majúscules i la resta en minúscules (tant de nom com dels cognoms).
*/

DELIMITER //
CREATE OR REPLACE PROCEDURE TascaTres(IN tipo ENUM('C', 'E'))
BEGIN

	CASE tipo
		WHEN 'C' THEN 
			SELECT id_client, 
					CONCAT(
						CONCAT(UPPER(LEFT(SUBSTRING_INDEX(nom, " ", 1),1)),LOWER(SUBSTRING(SUBSTRING_INDEX(nom, " ", 1),2))) /* <-- NOMBRE */
						," ", /* <-- ESPACIO ENTRE NOMBRE Y APELLIDO */
						CONCAT(UPPER(LEFT(SUBSTRING(nom, LENGTH(SUBSTRING_INDEX(nom, " ", 1)) + 2),1)),LOWER(SUBSTRING(SUBSTRING(nom, LENGTH(SUBSTRING_INDEX(nom, " ", 1)) + 1),3))) /* <-- APELLIDO */
					) as nombreYApellido, 
					telefon, adreca, poblacio from client;
		WHEN 'E' THEN 
			SELECT id_empleat, 
					CONCAT(
						UPPER(LEFT(nom,1)), LOWER(SUBSTRING(nom,2)), -- NOMBRE
						" ", -- ESPACIO ENTRE NOMBRE Y APELLIDO
						UPPER(LEFT(cognoms, 1)), LOWER(SUBSTRING(cognoms,2)) -- APELLIDO
					) AS nombreYApellido
					,empleat_id_cap
				FROM empleat;
    END CASE;

END //
DELIMITER ;

CALL TascaTres('C');
CALL TascaTres('E');

-- Tasca 4.
/*
Soluciona a partir dels disparadors que es generi una còpia de les dades d'un sorteig, quan algú elimina un sorteig. 
Crea l'estructura de taules a la base de dades necessària per a gestionar la tasca.
*/

CREATE TABLE copiaSorteig(
id_sorteig SMALLINT AUTO_INCREMENT,
nom VARCHAR(20),
data DATE,
premis TINYINT,
PRIMARY KEY (id_sorteig)
) ENGINE = INNODB;

DELIMITER //
CREATE OR REPLACE TRIGGER TascaQuatre AFTER DELETE ON sorteig FOR EACH ROW
BEGIN
	IF(SELECT 1 FROM copiaSorteig WHERE id_sorteig = OLD.id_sorteig) THEN
    
		DELETE FROM copiaSorteig WHERE id_sorteig = OLD.id_sorteig;
        INSERT INTO copiaSorteig VALUES (OLD.id_sorteig, OLD.nom, OLD.data, OLD.premis);
        
    ELSE
		INSERT INTO copiaSorteig VALUES (OLD.id_sorteig, OLD.nom, OLD.data, OLD.premis);
    END IF;
	
END //
DELIMITER ;

INSERT INTO sorteig VALUES (1, "TestEntrada", 20170109, 2);
DELETE FROM sorteig WHERE id_sorteig = 1;

SELECT *
	FROM copiaSorteig;

SELECT *
	FROM sorteig;

-- Tasca 5.
/*
Soluciona usant un cursor la generació d’un informe. Per a cada registre de la taula de clients, revisa quantes comandes ha fet superiors a un import enviat com a paràmentre, 
amb la finalitat de mostrar un resultat semblant a l’exemple. NO es vol mostrar la informació registre per registre, sinó que es vol mostrar alhora com si fos un únic registre amb tota la informació.
*/

ALTER TABLE client
	ADD registro INT;

DELIMITER //
CREATE OR REPLACE PROCEDURE TascaCinc(IN dineroMin INT)
BEGIN
	
    DECLARE final INT DEFAULT FALSE;
    DECLARE id_cliente INT;
    DECLARE numComandes, numComandestotal, clientTotales INT DEFAULT 0;
	

	DECLARE nClientes CURSOR FOR 
		SELECT id_client, COUNT(*)
			FROM (
				SELECT cl.id_client, co.numero, SUM(cp.quantitat * p.preu) AS suma
					FROM producte p
						INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte
						INNER JOIN comanda co ON co.numero = cp.numero
						INNER JOIN client cl ON cl.id_client = co.client_id
					GROUP BY co.numero
						HAVING suma > dineroMin) AS sumaDinero
					GROUP BY id_client;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET FINAL = TRUE;
    
    
	OPEN nClientes;
		bucle: LOOP
			FETCH FROM nClientes INTO id_cliente, numComandes;
			IF final THEN
				LEAVE bucle;
			END IF;
            
            UPDATE client
				SET registro = numComandes
					WHERE id_client = id_cliente;
                    
			SET numComandestotal = numComandestotal + numComandes;
			SET clientTotales = clientTotales + 1;
            
		END LOOP;
    CLOSE nClientes;


IF (numComandesTotal = 0) THEN
	
    SELECT CONCAT("No hay ningún cliente con comandas superiores a ", dineroMin, "€") AS Informe;    
    
ELSE

SET @aux = 0;

	SELECT CONCAT("Informe de clients amb Comandes > ",dineroMin ,"€") AS Informe
		UNION ALL
	SELECT "-------------------------------------------------------"
		UNION ALL
	SELECT concat(@aux:=@aux+1,". ",nom,"  (",registro, " comandes)")
		FROM client
			where registro IS NOT NULL
        UNION ALL
	SELECT "-------------------------------------------------------"
		UNION ALL
	SELECT CONCAT("Total: ",clientTotales ," clients (",numComandestotal ," comandes)");


UPDATE client SET registro = NULL;

END IF;

END //
DELIMITER ;
    
CALL TascaCinc(30);
CALL TascaCinc(0);
CALL TascaCinc(100);
