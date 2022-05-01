# DAW M02 UF3
# Activitat Activitat 6.4 Programació amb REPEAT (solució)

use uf2_p2_pizzeria;

-- Tasca 1. Realitza la transformació en un nou procediment de la Tasca 1 de l'Activitat 6.3 Programació amb WHILE, pero ara usant REPEAT.
-- DROP PROCEDURE delReunionsByDatesRepeat;
DELIMITER //
CREATE PROCEDURE delReunionsByDatesRepeat(OUT pError VARCHAR(100), IN pData_inici DATE, IN pData_fi DATE)
BEGIN
	-- Solució amb WHILE
	IF (
		(pData_inici IS NOT NULL) AND (pData_inici IS NOT NULL) AND 
        (pData_inici <= pData_fi) AND
        (SELECT 1 FROM reunio WHERE data BETWEEN pData_inici AND pData_fi LIMIT 1)
	   ) THEN
		SET pError = '';        
        
		REPEAT
			-- Esborrem també les convocatories a les reunions.
			DELETE er
			FROM empleat_reunio er
				INNER JOIN reunio r ON er.id_reunio = r.id_reunio
			WHERE r.data = pData_inici;

			DELETE FROM reunio WHERE data = pData_inici;
            
			SET pData_inici = ADDDATE(pData_inici, INTERVAL 1 DAY);
            
		UNTIL (pData_inici > pData_fi)
        END REPEAT;
	ELSE
		SET pError = 'No hi ha reunions o les dates són incorrectes';
    END IF;
END //
DELIMITER ;

CALL delReunionsByDatesRepeat(@missatge, '2020/04/15', '2020/04/19');
SELECT @missatge;
CALL delReunionsByDatesRepeat(@missatge, '2020/04/15', '2020/04/19');
SELECT @missatge;
CALL delReunionsByDatesRepeat(@missatge, '2020/04/17', '2020/04/16');
SELECT @missatge;
CALL delReunionsByDatesRepeat(@missatge, NULL, '2020/04/19');
SELECT @missatge;


-- Tasca 2. Realitza la transformació en un nou procediment de la Tasca 2 de l'Activitat 6.3 Programació amb WHILE, pero ara usant REPEAT.
-- DROP PROCEDURE setReunionsRepeat;
DELIMITER //
CREATE PROCEDURE setReunionsRepeat(IN pData_inici DATE, IN pData_fi DATE, IN pHora TIME, 
	IN pDescripcio VARCHAR(20), IN pTipus_id TINYINT, IN pOpcio ENUM('D', 'W', 'M', 'Y'))
BEGIN
	DECLARE data_reunio DATE DEFAULT pData_inici;
    DECLARE id_reunio SMALLINT(6);
    
	IF (data_reunio <= pData_fi) THEN
		REPEAT
			-- Ens aprofitem de la funció addReunio de l'Activitat 6.1 Tasca 3 per afegir una reunió
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
		UNTIL (data_reunio > pData_fi)
		END REPEAT;
	END IF;
END //
DELIMITER ;

SELECT *
FROM reunio;

CALL setReunionsRepeat('2020/04/30', '2020/05/30', '20:00', 'Reunió de Caps 4', (SELECT id_tipus FROM tipus WHERE nom = 'Caps'), 'M');
SELECT *
FROM reunio r
	INNER JOIN tipus t ON r.tipus_id = t.id_tipus AND t.nom = 'Caps'
WHERE (data BETWEEN '2020/04/30' AND '2020/05/30') AND hora = '20:00'; 

CALL setReunionsRepeat('2020/04/30', '2025/04/30', '21:00', 'Reunió General 4', (SELECT id_tipus FROM tipus WHERE nom = 'General'), 'Y');
SELECT *
FROM reunio r
	INNER JOIN tipus t ON r.tipus_id = t.id_tipus AND t.nom = 'General'
WHERE (data BETWEEN '2020/04/30' AND '2025/04/30') AND hora = '21:00'; 
    
CALL setReunionsRepeat('2020/04/30', '2020/05/10', '22:00', 'Reunió de Personal 4', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'), 'D');
SELECT *
FROM reunio r
	INNER JOIN tipus t ON r.tipus_id = t.id_tipus AND t.nom = 'Personal'
WHERE (data BETWEEN '2020/04/30' AND '2020/05/10') AND hora = '22:00'; 
    
CALL setReunionsRepeat('2020/04/30', '2020/06/10', '23:00', 'Reunió de Personal 5', (SELECT id_tipus FROM tipus WHERE nom = 'Personal'), 'W');
SELECT *
FROM reunio r
	INNER JOIN tipus t ON r.tipus_id = t.id_tipus AND t.nom = 'Personal'
WHERE (data BETWEEN '2020/04/30' AND '2020/06/10') AND hora = '23:00'; 
