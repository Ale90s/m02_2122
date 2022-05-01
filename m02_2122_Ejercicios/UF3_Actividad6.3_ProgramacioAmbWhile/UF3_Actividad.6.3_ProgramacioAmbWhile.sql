# DAW M02 UF3
# Activitat Activitat 6.3 Programació amb WHILE (solució)

use uf2_p2_pizzeria;

-- Tasca 1. Crea un procediment que donat dues dates, esborri totes les reunions compreses entre aquells dies. Si no hi ha reunions a esborrar o les dates no s'informen, retornar un avís d'error.
-- DROP PROCEDURE delReunionsByDates;
DELIMITER //
CREATE PROCEDURE delReunionsByDates(OUT pError VARCHAR(100), IN pData_inici DATE, IN pData_fi DATE)
BEGIN
	-- Solució amb WHILE
	IF (
		(pData_inici IS NOT NULL) AND (pData_inici IS NOT NULL) AND 
        (pData_inici <= pData_fi) AND
        (SELECT 1 FROM reunio WHERE data BETWEEN pData_inici AND pData_fi LIMIT 1)
	   ) THEN
		SET pError = '';        
        
		WHILE (pData_inici <= pData_fi) DO
        
			-- Esborrem també les convocatories a les reunions.
			DELETE er
			FROM empleat_reunio er
				INNER JOIN reunio r ON er.id_reunio = r.id_reunio
			WHERE r.data = pData_inici;

			DELETE FROM reunio WHERE data = pData_inici;
            
			SET pData_inici = ADDDATE(pData_inici, INTERVAL 1 DAY);
            
		END WHILE;
	ELSE
		SET pError = 'No hi ha reunions o les dates són incorrectes';
    END IF;
END //
DELIMITER ;
/* o
DELIMITER //
CREATE PROCEDURE delReunionsByDates(OUT pError VARCHAR(100), IN pData_inici DATE, IN pData_fi DATE)
BEGIN
	-- Solució amb BETWEEN
	IF (
		(pData_inici IS NOT NULL) AND (pData_inici IS NOT NULL) AND 
        (pData_inici <= pData_fi) AND
        (SELECT 1 FROM reunio WHERE data BETWEEN pData_inici AND pData_fi LIMIT 1)
	   ) THEN
		SET pError = '';
        
        -- Esborrem també les convocatories a les reunions.
        DELETE er
        FROM empleat_reunio er
			INNER JOIN reunio r ON er.id_reunio = r.id_reunio
		WHERE r.data BETWEEN pData_inici AND pData_fi;
        
		DELETE FROM reunio WHERE data BETWEEN pData_inici AND pData_fi;
	ELSE
		SET pError = 'No hi ha reunions o les dates són incorrectes';
    END IF;
END //
DELIMITER ;
*/

CALL delReunionsByDates(@missatge, '2020/04/15', '2020/04/19');
SELECT @missatge;
CALL delReunionsByDates(@missatge, '2020/04/15', '2020/04/19');
SELECT @missatge;
CALL delReunionsByDates(@missatge, '2020/04/17', '2020/04/16');
SELECT @missatge;
CALL delReunionsByDates(@missatge, NULL, '2020/04/19');
SELECT @missatge;


-- Tasca 2. Crea un procediment que generi reunions, de manera que inserirà un esdeveniment repetit cada cert temps.
-- Els paràmetres que li donarem seran els següents:
--  - Data d'inici de les insercions,
--  - Data final de les insercions,
--  - Hora de l'esdeveniment,
--  - Esdeveniment
--  - Identificador del Tipus de reunió, recordeu que les reunions de :
--      - Caps assisteixen els empleats que són caps, 
--      - a les reunions General assisteixen tots els empleats
--      - i les reunions de Personal només aquells que no són caps
--  - Freqüència: D (diària), W (setmanal), M (mensual) i Y (anual)
-- Genera diverses reunions per provar varies de les combinacions possibles.
DELIMITER //
CREATE OR REPLACE PROCEDURE setReunions(IN pData_inici DATE, IN pData_fi DATE, IN pHora TIME, 
	IN pDescripcio VARCHAR(20), IN pTipus_id TINYINT, IN pOpcio ENUM('D', 'W', 'M', 'Y'))
BEGIN
	DECLARE data_reunio DATE DEFAULT pData_inici;
    DECLARE id_reunio SMALLINT(6);
    
	WHILE (data_reunio <= pData_fi) DO
		-- Ens aprofitem de la funció addReunions de l'Activitat 6.1 Tasca 3 per afegir una reunió
        CALL addReunio(data_reunio, pHora, pDescripcio, pTipus_id);
        SET id_reunio = LAST_INSERT_ID();
        -- Ens aprofitem de la funció setConvocatoriesReunio de l'Activitat 6.2 Tasca 6. per convocar als empleats
        CALL setConvocatoriesReunio(id_reunio);
        
		CASE pOpcio
			WHEN 'D' THEN
				SET data_reunio = ADDDATE(data_reunio, INTERVAL 1 DAY);
			WHEN 'W' THEN
				SET data_reunio = ADDDATE(data_reunio, INTERVAL 1 WEEK);
			WHEN 'M' THEN
				SET data_reunio = ADDDATE(data_reunio, INTERVAL 1 MONTH);
			WHEN 'Y' THEN
				SET data_reunio = ADDDATE(data_reunio, INTERVAL 1 YEAR);
		END CASE;
	END WHILE;
END //
DELIMITER ;

SELECT *
FROM reunio;
CALL setReunions('2020/04/30', '2020/05/30', '20:00', 'Reunió de Caps 4', (SELECT id_tipus FROM tipus WHERE nom = 'Caps'), 'M');
SELECT *
FROM reunio r
	INNER JOIN tipus t ON r.tipus_id = t.id_tipus AND t.nom = 'Caps'
WHERE (data BETWEEN '2020/04/30' AND '2020/05/30') AND hora = '20:00'; 

CALL setReunions('2020/04/30', '2025/04/30', '21:00', 'Reunió General 4', (SELECT id_tipus FROM tipus WHERE nom = 'General'), 'Y');
SELECT *
FROM reunio r
	INNER JOIN tipus t ON r.tipus_id = t.id_tipus AND t.nom = 'General'
WHERE (data BETWEEN '2020/04/30' AND '2025/04/30') AND hora = '21:00'; 

    
CALL setReunions('2020/04/30', '2020/05/10', '22:00', 'Reunió de Personal 4', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'), 'D');
SELECT *
FROM reunio r
	INNER JOIN tipus t ON r.tipus_id = t.id_tipus AND t.nom = 'Personal'
WHERE (data BETWEEN '2020/04/30' AND '2020/05/10') AND hora = '22:00'; 

   
CALL setReunions('2020/04/30', '2020/06/10', '23:00', 'Reunió de Personal 5', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'), 'W');
SELECT *
FROM reunio r
	INNER JOIN tipus t ON r.tipus_id = t.id_tipus AND t.nom = 'Personal'
WHERE (data BETWEEN '2020/04/30' AND '2020/06/10') AND hora = '23:00'; 
