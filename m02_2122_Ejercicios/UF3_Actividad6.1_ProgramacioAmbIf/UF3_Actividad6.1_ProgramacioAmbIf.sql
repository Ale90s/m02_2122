-- Tasca 1. Crea un procediment per generar l’estructura de la gestió de reunions.

DELIMITER //
CREATE PROCEDURE crearOBorrarReunions(IN eleccion CHAR(1))
BEGIN
	IF (eleccion = "C") THEN

		CREATE TABLE tipus_reunio(
		id_tipus TINYINT AUTO_INCREMENT,
		nom VARCHAR(10),
		lloc VARCHAR(20),
		PRIMARY KEY (id_tipus)
		)ENGINE = INNODB;

		CREATE TABLE reunio(
		id_reunio SMALLINT AUTO_INCREMENT,
		descripcio VARCHAR(20),
		data DATE,
		hora TIME,
		id_tipus TINYINT,
		PRIMARY KEY (id_reunio),
		CONSTRAINT fk_reunio_tipus_reunio FOREIGN KEY (id_tipus)
			REFERENCES tipus_reunio (id_tipus)
		)ENGINE = INNODB;

		CREATE TABLE empleat_reunio(
		id_empleat SMALLINT(3),
		id_reunio SMALLINT,
		PRIMARY KEY (id_empleat, id_reunio),
		CONSTRAINT fk_empleat_reunio_empleat FOREIGN KEY (id_empleat)
			REFERENCES empleat (id_empleat),
		CONSTRAINT fk_empleat_reunio_reunio FOREIGN KEY (id_reunio)
			REFERENCES reunio (id_reunio)
		)ENGINE = INNODB;

		ALTER TABLE empleat
			ADD COLUMN empleat_id_cap SMALLINT(3);
		ALTER TABLE empleat
			ADD CONSTRAINT fk_empleat FOREIGN KEY (empleat_id_cap)
												REFERENCES empleat (id_empleat);
	ELSEIF (eleccion = "D") THEN
		ALTER TABLE empleat
			DROP FOREIGN KEY fk_empleat;
		ALTER TABLE empleat 
			DROP INDEX fk_empleat;
		ALTER TABLE empleat
			DROP COLUMN empleat_id_cap;
		DROP TABLE empleat_reunio;
		DROP TABLE reunio;
		DROP TABLE tipus_reunio;
	END IF;
END //
DELIMITER ;

CALL crearOBorrar('C');

-- Tasca 2. Crea una procediment per afegir Tipus de reunió.

DELIMITER //
CREATE PROCEDURE afegirTipusReunio(IN nombre VARCHAR(10), IN lugar VARCHAR(20))
BEGIN
	INSERT INTO tipus_reunio (nom, lloc) VALUES (nombre, lugar);
END //
DELIMITER ;

CALL afegirTipusReunio("Caps", "Oficina Central");
CALL afegirTipusReunio("General", "Local Principal");
CALL afegirTipusReunio("Personal", "Local Principal");

SELECT *
	FROM tipus_reunio;

-- Tasca 3. Crea una procediment per afegir una Reunió. 
-- Afegeix un parell per a cada Tipus de reunió.

DELIMITER //
CREATE PROCEDURE afegirReunio(IN descripcion VARCHAR(20), IN fecha DATE, IN hora2 TIME, IN id_tipus TINYINT)
BEGIN
	INSERT INTO reunio (descripcio, data, hora, id_tipus) VALUES (descripcion, fecha, hora2, id_tipus);
END //
DELIMITER ;

CALL afegirReunio("Reunió de caps", '1956-05-25', '12:25', 2);
CALL afegirReunio("Jefes", '2020-02-04', '13:35', 2);
CALL afegirReunio("Generales", '2052-12-29', '18:45', 3);
CALL afegirReunio("Discusiones", '1782-01-07', '05:50', 3);
CALL afegirReunio("Personal", '1492-08-05', '08:30', 4);
CALL afegirReunio("Ruegos y preguntas", '2450-04-23', '08:30', 4);

SELECT * 
	FROM reunio;

-- Tasca 4. Crea un procediment que busqui els empleats per nom i cognoms. 
-- Tingueu en compte que si deixem algun dels paràmetres buits cerqui pels altres
--  o mostri tots els empleats.

DELIMITER //
CREATE PROCEDURE cercaEmpleat(IN nombre VARCHAR(50), IN apellido VARCHAR(50))
BEGIN
	IF (nombre IS NOT NULL AND apellido IS NOT NULL) THEN
    SELECT *
		FROM empleat
			WHERE nom = nombre AND cognoms = apellido;
    ELSE 
    SELECT *
		FROM empleat;
    END IF;
END //
DELIMITER ;

SELECT * 
	FROM empleat;

CALL cercaEmpleat("Jesús", "González");
CALL cercaEmpleat("Marta", NULL);


-- Tasca 5. Crea una procediment per gestionar els Empleats.

DELIMITER //
CREATE PROCEDURE gestionaEmpleats(IN numEmpleat TINYINT, IN nombre VARCHAR(30), IN apellidos VARCHAR(30))
BEGIN

	DECLARE comprobador INT DEFAULT NULL;

	SELECT id_empleat INTO comprobador
		FROM empleat
			WHERE id_empleat = numEmpleat;
            
	IF (comprobador IS NOT NULL) THEN
    UPDATE empleat
	SET nom = nombre, cognoms = apellidos
		WHERE id_empleat = numEmpleat;
    ELSE
    INSERT INTO empleat (id_empleat, nom, cognoms) VALUES (numEmpleat, nombre, apellidos);
    END IF ;
END //
DELIMITER ;

DROP PROCEDURE gestionaEmpleats;

CALL gestionaEmpleats(3, "Juan", "Pérez");
    
SELECT *
	FROM empleat;
        
-- Tasca 6. Crea una procediment per asignar un cap a un empleat.
-- Dona d’alta un parell d’empleats siguin caps.

INSERT INTO empleat (nom, cognoms, empleat_id_cap) VALUES ("Julia", "Florente", 1);
INSERT INTO empleat (nom, cognoms, empleat_id_cap) VALUES ("Georgina", "Fernández", 2);

DELIMITER //
CREATE PROCEDURE asignarCapEmpleat (pid_empleat SMALLINT, IN pempleat_id_cap SMALLINT, 
OUT MissatgeError VARCHAR(10))
BEGIN
	SET MissatgeError = "Tot bé";
	IF (SELECT 1 FROM empleat WHERE (id_empleat = pid_empleat) AND (empleat_id_cap IS NULL))
	THEN
		UPDATE empleat
			SET empleat_id_cap = pempleat_id_cap
				WHERE id_empleat = pid_empleat;
	ELSE
		SET MissatgeError = "ERROR";
	END IF;
END //
DELIMITER ;

CALL asignarCapEmpleat(2, 2, @error);
SELECT @error;
SELECT *
	FROM empleat;

-- Tasca 7. Crea un procediment que esborri totes les reunions entre dues dates.
DELIMITER //
CREATE PROCEDURE esborraReunions(IN dataIniciReunio DATE, IN dataFinalReunio DATE)
BEGIN
	IF ((dataIniciReunio IS NOT NULL) AND (dataFinalReunio IS NOT NULL))
	THEN
		DELETE FROM reunio 
			WHERE (data > dataIniciReunio) AND (data < dataFinalReunio);     
    ELSEIF (dataIniciReunio IS NOT NULL) 
	THEN
		DELETE FROM reunio 
			WHERE data > dataIniciReunio;
    ELSEIF (dataFinalReunio IS NOT NULL) THEN
		DELETE FROM reunio 
			WHERE data < dataFinalReunio;   
    ELSE
		DELETE FROM reunio;    
	END IF;
END //
DELIMITER ;

CALL delReunions(NULL, NULL);
CALL delReunions('1956-05-20', NULL);
CALL delReunions(NULL, '1955-02-02');

SELECT * 
	FROM reunio;

-- Tasca 8. Crea un procediment que donada una data endarrereixi els esdeveniments d’aquella data un mes.

DELIMITER //
CREATE PROCEDURE retrocedeFecha(IN data date)
BEGIN
SELECT SUBDATE(DATE(data), INTERVAL 1 MONTH);
END //
DELIMITER ;

CALL retrocedeFecha('1953-07-20');

-- Tasca 9. Crea un procediment que donada una reunió i un paràmetre amb els valors ‘W’, ‘D’, ‘M’ o ‘Y’, 
-- endarrereixi una setmana, un dia, un més o un any la reunió, respectivament.

DELIMITER //
CREATE PROCEDURE cambiarFecha(IN tipo VARCHAR(1), IN identificador INT)
BEGIN
IF (tipo = 'W') THEN
	UPDATE reunio
		SET data = SUBDATE(DATE(data), INTERVAL 1 WEEK)
		WHERE id_reunio = identificador;
ELSEIF (tipo = 'D') THEN
	UPDATE reunio
		SET data = SUBDATE(DATE(data), INTERVAL 1 DAY)
		WHERE id_reunio = identificador;
ELSEIF (tipo = 'M') THEN
	UPDATE reunio
		SET data = SUBDATE(DATE(data), INTERVAL 1 MONTH)
		WHERE id_reunio = identificador;
ELSEIF (tipo = 'Y') THEN
	UPDATE reunio
		SET data = SUBDATE(DATE(data), INTERVAL 1 YEAR)
		WHERE id_reunio = identificador;
ELSE
	SELECT "ERROR";
END IF;
END //
DELIMITER ;

CALL cambiarFecha('Y', 22);
CALL cambiarFecha('D', 23);
CALL cambiarFecha('W', 24);
CALL cambiarFecha('M', 27);
CALL cambiarFecha('A', 23);

-- Tasca 10. Crea un procediment per generar l’estructura de la gestió de sorteigs.

DELIMITER //
CREATE PROCEDURE crearOBorrarSorteigs(IN eleccion CHAR(1))
BEGIN
	IF (eleccion = "C") THEN
    
		CREATE TABLE sorteig (
		id_sorteig SMALLINT AUTO_INCREMENT,
		nom VARCHAR(20),
		data DATE,
		premis TINYINT,
		PRIMARY KEY (id_sorteig)
		)ENGINE = INNODB;

		CREATE TABLE sorteig_comanda(
		id_sorteig SMALLINT,
		numero SMALLINT,
		PRIMARY KEY(id_sorteig, numero),
		CONSTRAINT fk_sorteig_comanda_sorteig FOREIGN KEY (id_sorteig)
			REFERENCES sorteig (id_sorteig),
		CONSTRAINT fk_sorteig_comanda_comanda FOREIGN KEY (numero)
			REFERENCES comanda (numero)
		)ENGINE = INNODB;
        
	ELSEIF (eleccion = "D") THEN
		DROP TABLE sorteig_comanda;
		DROP TABLE sorteig;
	END IF;
END //
DELIMITER ;

CALL crearOBorrar('C');

-- Tasca 11. Crea una procediment per afegir Sorteigs.

DELIMITER //
CREATE PROCEDURE afegirSorteigs(IN pNom VARCHAR(20), IN pData DATE, IN premis TINYINT)
BEGIN
	INSERT INTO sorteig (nom, data, premis)
		VALUES (pNom, pData, premis);
END //
DELIMITER ;

CALL afegirSorteigs("Sorteo FNAC", "2022-05-25", 50);
CALL afegirSorteigs("BC", "2030-10-03", 34);
CALL afegirSorteigs("MediaMarkt", "1953-03-05", 40);
CALL afegirSorteigs("Sorteo FNAC", "2025-08-07", 15);

SELECT *
	FROM sorteig;

-- Tasca 12. Crea una procediment per eliminar Sorteigs.

DELIMITER //
CREATE PROCEDURE eliminarSorteigs(IN identificador INT)
BEGIN
IF (identificador IS NOT NULL) THEN
	IF (SELECT 1 FROM sorteig WHERE id_sorteig = identificador) THEN
		DELETE FROM sorteig
			WHERE id_sorteig = identificador;
	ELSE
		SELECT "No existe ese sorteo";
    END IF;    
ELSE
	DELETE FROM sorteig;
END IF;
END //
DELIMITER ;

DROP PROCEDURE eliminarSorteigs;

CALL eliminarSorteigs(2);
CALL eliminarSorteigs(13);
CALL eliminarSorteigs(NULL);

SELECT *
	FROM sorteig;
