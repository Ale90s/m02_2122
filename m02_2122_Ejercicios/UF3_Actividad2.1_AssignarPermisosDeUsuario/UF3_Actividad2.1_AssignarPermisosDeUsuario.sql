DROP DATABASE IF EXISTS m03_uf3;
CREATE DATABASE m03_uf3;
USE m03_uf3;

SELECT * 
	FROM mysql.user;

-- Tasca 1. L'usuari yoda és l'administrador, per tant que tingui permís per a fer tot.

GRANT ALL PRIVILEGES
	ON *.*
		TO yoda@'localhost'
	WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Tasca 2. Connectat amb l’usuari yoda i genera l’estrucura de la base de dades 
-- starwars(m02_uf3) seguint les seguents taules i camps, alhora relaciona-les:

CREATE TABLE films (
id_film TINYINT,
created DATE,
director VARCHAR(30),
title VARCHAR(50),
episode_id TINYINT,
PRIMARY KEY (id_film)
) ENGINE = INNODB;

CREATE TABLE planets (
id_planet TINYINT,
name VARCHAR(30),
population INT,
PRIMARY KEY (id_planet)
) ENGINE = INNODB;

CREATE TABLE films_planets (
id_film TINYINT,
id_planet TINYINT,
PRIMARY KEY (id_film, id_planet),
CONSTRAINT fk_films_planets_films FOREIGN KEY (id_film) 
		REFERENCES films (id_film),
CONSTRAINT fk_films_planets_planets FOREIGN KEY (id_planet)
		REFERENCES planets (id_planet)
) ENGINE = INNODB;

-- Tasca 3. Fes que l'usuari yoda doni permís a obi-wan.kenobi els privilegis de 
-- seleccionar i inserir registres sobre la taula films.

GRANT SELECT, INSERT
	ON m03_uf3.films
		TO 'obi-wan.kenobi'@'127.0.0.1';

-- Tasca 4. Comproveu que l'usuari obi-wan.kenobi pot accedir a veure les dades de 
-- la taula films i feu que insereixi un nou registre. En canvi leia.organa no pot fer res amb aquesta taula.

/* CONECTAMOS CON obi-wan.kenobi */
SELECT *
	FROM  films;
INSERT INTO films VALUES (1, NULL, "Alfred Hitchkok", "Guerra de las Galaxias", 3);
SELECT *
	FROM films;
/* SI INTENTAMOS TOCAR OTRA TABLA NOS DA UN ERROR YA QUE NO TENEMOS PERMISOS */
/* SI NOS CONECTAMOS CON LEIA NI SI QUIERA NOS DEJA USAR LA BASE DE DATOS YA QUE NO TENEMOS NINGÚN PERMISO */

-- Tasca 5. Fes que l'usuari yoda doni permís a leia.organa els privilegis d'inserir 
-- registres sobre la taula films. Comproveu que l'usuari leia.organa pot inserir un 
-- registre a la taula films. Comproveu que l'usuari yoda pot veure els registres que han afegit els altres dos usuaris

GRANT SELECT, INSERT
	ON m03_uf3.films
		TO 'leia.organa';
FLUSH PRIVILEGES;
    
/* HACEMOS LAS ACCIONES CON EL USUARIO leia.organa */
USE m03_uf3;
SELECT *	
	FROM films;
INSERT INTO films VALUES (2, NULL, "Pedro Fernandez", "Planeta de los macacos", 10);

-- Tasca 6. Fes que l'usuari yoda assigni tots els permisos a leia.organa

GRANT ALL PRIVILEGES
	ON *.*
		TO 'leia.organa'
    WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Tasca 7. Fes que l'usuari yoda assigni permisos a obi-wan.kenobi per 
-- modificar el contingut de la columna population de la taula planets. 
-- Comprova que no es pot modificar les dues columnes d'un registre de la
-- taula planets, en canvi sí la columna population.

GRANT UPDATE (population)
	ON m03_uf3.planets
    TO 'obi-wan.kenobi'@'127.0.0.1';
FLUSH PRIVILEGES;

/* NOS CONECTAMOS CON obi-wan.kenobi Y PODEMOS OBSERVAR QUE SOLO PODEMOS EJECUTAR EL SEGUNDO COMANDO*/
UPDATE planets SET name="testPermisos";
UPDATE planets SET population=12345;

-- Tasca 8. Fes que l'usuari yoda assigni tots els permisos a leia.organa 
-- per la taula films, donant-li permisos per assignar permisos a altres.

GRANT ALL PRIVILEGES
	ON m03_uf3.films
		TO 'leia.organa'
	WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Tasca 9. Fes que l'usuari leia.organa assigni a darth.vader permís per 
-- mostrar els registres de la taula films. Comprova que no li pot assignar 
-- el mateix permís per la taula planets.

GRANT SELECT
	ON m03_uf3.films
	TO 'dath.vader';
FLUSH PRIVILEGES;

-- Tasca 10. Crear els següents usuaris i aplica els permisos amb una sola 
-- intrucció. Finalment comprova l’assignació de permisos:
/*
A- r2-d2, amb contrasenya beep, té permisos per donar permisos i fer accions sobre les taules, però no sobre les dades.
B- c-3po, amb contrasenya protocol, té permisos per fer consultar i modificar les dades de la taula fims.
C- stormtrooper, amb contrasenya imperi, té permisos només per inserir registres a la taula films.
D- darth.sidious, amb contrasenya emperador, inicialment no té cap permís.
*/
-- A.

GRANT SELECT, DROP, ALTER, CREATE
	ON m03_uf3.*
		TO 'r2-d2' IDENTIFIED BY 'beep'
	WITH GRANT OPTION;
    
-- B.

GRANT SELECT, UPDATE
	ON m03_uf3.films
		TO 'c-3po' IDENTIFIED BY 'protocol';

-- C.

GRANT INSERT
	ON m03_uf3.films
		TO stormtrooper IDENTIFIED BY 'imperi';

-- D.

GRANT USAGE
	ON *.*
		TO 'darth.sidious' IDENTIFIED BY 'emperador';
