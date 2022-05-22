# DAM M02 UF3
# Activitat 11.2 Triggers BD Lliga (solució)

CREATE DATABASE lliga;
CREATE TABLE equip
	(codi			VARCHAR(3)	PRIMARY KEY,
	nom		 		VARCHAR(20)
	) ENGINE=InnoDB;
CREATE TABLE partit
	(jornada		INT,
	equip_local 	VARCHAR(3),
	equip_visitant	VARCHAR(3),
	gols_local		INT			DEFAULT 0,
	gols_visitant	INT			DEFAULT 0,
	finalitzat		ENUM('S','N')	DEFAULT 'N',
	PRIMARY KEY(jornada,equip_local),
	FOREIGN KEY (equip_local) REFERENCES equip (codi),
	FOREIGN KEY (equip_visitant) REFERENCES equip (codi)
	) ENGINE=InnoDB;
CREATE TABLE gol
	(jornada		INT,
	equip		 	VARCHAR(3),
	jugador			VARCHAR(20),
	minut			INT,
	propia_porta	ENUM('S','N')
	) ENGINE=InnoDB;
CREATE TABLE classificacio
	(equip	 			VARCHAR(3)		PRIMARY KEY,
	partits_guanyats	INT			DEFAULT 0,
	partits_empatats	INT			DEFAULT 0,
	partits_perduts		INT			DEFAULT 0,
	gols_favor			INT			DEFAULT 0,
	gols_contra			INT			DEFAULT 0,
	FOREIGN KEY (equip) REFERENCES equip (codi)
	) ENGINE=InnoDB;
CREATE TABLE golejador
	(jugador	 	VARCHAR(20),
	equip			VARCHAR(3),	
	gols			INT
	) ENGINE=InnoDB;

# Exercici DCL_80 i DCL_81:
DELIMITER //
CREATE TRIGGER marca_gol AFTER INSERT
	ON gol FOR EACH ROW
BEGIN
IF ((SELECT * FROM partit WHERE jornada=NEW.jornada 
	AND equip_local=NEW.equip) IS NOT NULL) THEN
	IF (NEW.propia_porta='N') THEN
		UPDATE partit SET gols_local=gols_local+1
			WHERE jornada=NEW.jornada AND equip_local=NEW.equip;
	ELSEIF (NEW.propia_porta='S') THEN
		UPDATE partit SET gols_visitant=gols_visitant+1
			WHERE jornada=NEW.jornada AND equip_visitant=NEW.visitant;
ELSEIF ((SELECT * FROM partit WHERE jornada=NEW.jornada 
	AND equip_visitant=NEW.equip) IS NOT NULL) THEN
	IF (NEW.propia_porta='S') THEN
		UPDATE partit SET gols_local=gols_local+1
			WHERE jornada=NEW.jornada AND equip_local=NEW.equip;
	ELSEIF (NEW.propia_porta='N') THEN
		UPDATE partit SET gols_visitant=gols_visitant+1
			WHERE jornada=NEW.jornada AND equip_visitant=NEW.visitant;
END IF;

IF (NEW.propia_porta LIKE 'N') THEN
	IF ((SELECT * FROM golejador WHERE equip=NEW.equip 
			AND jugador=NEW.jugador) IS NULL) THEN
		INSERT INTO golejador VALUES (NEW.jugador,NEW.equip,1);
	ELSE
		UPDATE golejador SET gols=gols+1 
			WHERE jugador=NEW.jugador AND equip=NEW.equip;
	END IF;
END IF;
END //

# Exercici DCL_82:

CREATE TRIGGER resultat AFTER UPDATE
	ON partit FOR EACH ROW 
BEGIN
IF (NEW.finalitzat='S') THEN
	UPDATE classificacio SET gols_favor=gols_favor+NEW.gols_local , 
		gols_contra=gols_contra+NEW.gols_visitant WHERE equip=NEW.equip_local;
	UPDATE classificacio SET gols_favor=gols_favor+NEW.gols_visitant ,
		gols_contra=gols_contra+NEW.gols_local WHERE equip=NEW.equip_visitant;
	IF (NEW.gols_local>NEW.gols_visitant) THEN
		UPDATE classificacio SET partits_guanyats=partits_guanyats+1 
			WHERE equip=NEW.equip_local;
		UPDATE classificacio SET partits_perduts=partits_perduts+1 
			WHERE equip=NEW.equip_visitant;
	ELSEIF (NEW.gols_local<NEW.gols_visitant) THEN
		UPDATE classificacio SET partits_guanyats=partits_guanyats+1 
			WHERE equip=NEW.equip_visitant;
		UPDATE classificacio SET partits_perduts=partits_perduts+1 
			WHERE equip=NEW.equip_local;
	ELSEIF (NEW.gols_local=NEW.gols_visitant) THEN
		UPDATE classificacio SET partits_empatats=partits_empatats+1 
			WHERE equip=NEW.equip_local OR equip=NEW.equip_visitant;
END IF;
END //

# Exercici DCL_83:

CREATE PROCEDURE classificacio ()
BEGIN
	SELECT nom, partits_guanyats+partits_empatats+partits_perduts PJ, 
		partits_guanyats PG, partits_empatats PE, partits_perduts PP, 
		gols_favor GF, gols_contra GC, 3*partits_guanyats+partits_empatats PUNTS 
	FROM classificacio JOIN equip ON codi=equip
	ORDER BY PUNTS DESC, GF DESC, GF-GC DESC; 
END //

# Exercici DCL_84:

CREATE PROCEDURE jornada(IN par_jornada INT)
BEGIN
	SELECT CONCAT(eq1.nom,'-',eq2.nom) partit, 
		CONCAT(gols_local,'-',gols_visitant) marcador
	FROM partit JOIN equip eq1 ON equip_local=eq1.codi
		JOIN equip eq2 ON equip_visitant=eq2.codi
	WHERE jornada=par_jornada;
END //

# Exercici DCL_85:

CREATE PROCEDURE golejador()
BEGIN
	SELECT jugador, nom, gols 
		FROM golejador JOIN equip ON codi=equip
		ORDER BY gols DESC;
END //
DELIMITER ;