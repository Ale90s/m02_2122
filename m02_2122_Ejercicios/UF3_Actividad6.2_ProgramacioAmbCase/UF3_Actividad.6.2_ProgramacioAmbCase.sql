-- Tasca 1. Crea un procediment que donat un nom, un cognom, telèfon, adreça, 
-- població i indicant si és client o empleat, l'afegeixi a la taula corresponent. 
-- Si no es client o empleat, que no faci res.

DELIMITER //
CREATE PROCEDURE checkEmCl
	(IN pnom VARCHAR(25), IN pcognom VARCHAR(25), IN ptelefon VARCHAR(9), IN padreca VARCHAR(50)
    , IN ppoblacio VARCHAR(25), IN tipo VARCHAR(1))
BEGIN
	CASE (tipo)
    WHEN 'c' THEN
		INSERT INTO client (nom, telefon, adreca, poblacio) 
        VALUES (CONCAT(pnom, " ", pcognom), ptelefon, padreca, ppoblacio);
	WHEN 'e' THEN
		INSERT INTO empleat (nom, cognoms)
		VALUES (pnom, pcognom);
	ELSE	
		SELECT "ERROR";
    END CASE;
END //
DELIMITER ;
-- NO HE PUESTO ENUM PARA PROBAR EL SWITCH CASE, DE OTRA MANERA ME SALTA UN ERROR

call checkEmCl('Juan', 'Jimenez', '766654231', 'Carrer Ferrer', 'Sabadell', 'c');
call checkEmCl('Fran', 'Perez', '123452625', 'Carrer Turias', 'Terrassa', 'e');

SELECT *
	FROM empleat;
SELECT * 
	FROM client;

-- Tasca 2. Crea un procediment que, donat ‘client’ o ‘empleat’ i el seu codi 
-- identificador, calculi i mostri quantes comandes ha demanat o gestionat. 
-- Si els paràmetres no són vàlids o no hi ha dades que retorni un missatge d'error 
-- identificatiu.

DELIMITER //
CREATE PROCEDURE comandesClEm(IN tipo VARCHAR(7), IN identificador INT)
	CASE(tipo)
    WHEN "client" THEN
		IF (SELECT 1 FROM empleat WHERE id_empleat = identificador) 
		THEN
			SELECT COUNT(*) AS comandaClient
			FROM client cl
				INNER JOIN comanda co ON co.client_id = cl.id_client
				WHERE id_client = identificador
				GROUP BY id_client;
		ELSE
			SELECT "NO SE ENCUENTRA EL CLIENTE";
		END IF;
    WHEN "empleat" THEN
		IF(SELECT 1 FROM empleat WHERE id_empleat = identificador)
		THEN 
			SELECT COUNT(*) AS comandaEmpleat
			FROM empleat e
				INNER JOIN comanda co ON co.empleat_id = id_empleat
				WHERE id_empleat = identificador
				GROUP BY id_empleat;
		ELSE
			SELECT "NO SE ENCUENTRA EL EMPLEADO";
		END IF;
    ELSE 
    SELECT "SOLO CLIENT O EMPLEAT";
    END CASE;
BEGIN
END //
DELIMITER ;

CALL comandesClEm("empleat", 100);
CALL comandesClEm("client", 2);
CALL comandesClEm("empleat", 2);

-- Tasca 3. Crea un procediment que donada una data ens mostri les reunions a partir d’un paràmetre.

DELIMITER //
CREATE PROCEDURE checkReunions(IN pData date, IN opcio VARCHAR(1))
BEGIN
CASE (opcio)
	WHEN 'D' THEN
		SELECT *
			FROM reunio
			WHERE DAY(data) > DAY(pData);
	WHEN 'W' THEN
		SELECT *
			FROM reunio
			WHERE WEEK(data) > WEEK(pData);
	WHEN 'M' THEN
		SELECT *
			FROM reunio
			WHERE MONTH(data) > MONTH(pData);
	WHEN 'Y' THEN
		SELECT *
			FROM reunio
			WHERE YEAR(data) > YEAR(pData);
	ELSE
		SELECT "ERROR";
END CASE;
END //
DELIMITER ;

CALL checkReunions('2022-03-25', 'D');
CALL checkReunions('1900-01-02', 'W');
CALL checkReunions('2020-06-04', 'M');
CALL checkReunions('2000-04-26', 'Y');

SELECT * 
	FROM reunio;

-- Tasca 4. Retorna per paràmetres la quantitat de pizzes o de begudes o de 
-- postres que hem venut individualment a partir d’indicar-li que tipus de producte 
-- volem calcular respectivament. Si no indiquem un tipus de producte que faci el 
-- càlcul amb tots els productes.

DELIMITER //
CREATE PROCEDURE checkVendes(in tipus VARCHAR(7))
BEGIN
CASE(tipus)
WHEN 'pizza' THEN
	SELECT SUM(cp.quantitat) AS pizzaVendida
		FROM pizza piz
			INNER JOIN producte p ON p.id_producte = piz.id_producte
			INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte;
WHEN 'beguda' THEN
	SELECT SUM(cp.quantitat) AS bebibaVendida
		FROM beguda be
			INNER JOIN producte p ON p.id_producte = be.id_producte
			INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte;
WHEN 'postre' THEN
	SELECT SUM(cp.quantitat) AS postreVendido
		FROM postre pos
			INNER JOIN producte p ON p.id_producte = pos.id_producte
			INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte;
ELSE
	SELECT SUM(cp.quantitat) AS productosVendidos
		FROM producte p
			INNER JOIN comanda_producte cp ON cp.id_producte = p.id_producte;
END CASE;
END //
DELIMITER ;

CALL checkVendes('PIZZA');
CALL checkVendes('BEGUDA');
CALL checkVendes('POSTRE');
CALL checkVendes('OTRO');

-- Tasca 5. Retorna per paràmetre la quantitat d'ingredients que té un producte en 
-- concret a partir del seu identificador. Els productes que no són pizzes en si 
-- mateixos són un únic ingredient.

DELIMITER //
CREATE PROCEDURE quantitatsProducte(IN identificador INT)
BEGIN
IF(SELECT 1 FROM pizza WHERE id_producte = identificador) THEN
	SELECT COUNT(*) AS ingredientsPizza
		FROM pizza piz
			INNER JOIN pizza_ingredient pizing ON pizing.id_producte = piz.id_producte
		WHERE piz.id_producte = identificador
		GROUP BY piz.id_producte;
ELSEIF(SELECT 1 FROM beguda WHERE id_producte = identificador) THEN	
	SELECT COUNT(*) AS ingredientsBegudes
		FROM beguda
        WHERE id_producte = identificador
		GROUP BY id_producte;
ELSEIF(SELECT 1 FROM postre WHERE id_producte = identificador) THEN	
	SELECT COUNT(*) AS ingredientsPostres
	FROM postre
    WHERE id_producte = identificador
    GROUP BY id_producte;
ELSE
	SELECT "NOT FOUND";
END IF;
END //
DELIMITER ;

CALL quantitatsProducte(10);
CALL quantitatsProducte(1);
CALL quantitatsProducte(6);
CALL quantitatsProducte(14);
CALL quantitatsProducte(100);

-- Tasca 6. Crea un procediment per generar convocatories de reunions on enviant-li 
-- l’identificador de la reunió.

DELIMITER //
CREATE PROCEDURE convocatories(IN tipo VARCHAR(1))
BEGIN
CASE(tipo)
WHEN 'G' THEN
	SELECT *
		FROM empleat;
WHEN 'C' THEN
	SELECT *
		FROM empleat
		WHERE empleat_id_cap IS NOT NULL;
WHEN 'P' THEN
	SELECT *
		FROM empleat
		WHERE empleat_id_cap IS NULL;
ELSE
	SELECT "ERROR";
END CASE;
END //
DELIMITER ;

CALL convocatories('G');
CALL convocatories('C');
CALL convocatories('P');
CALL convocatories(1);
