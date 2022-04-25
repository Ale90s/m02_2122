USE m03_uf3;

SELECT *
	FROM mysql.user;

-- Tasca 1. Fes que l'usuari yoda retiri els permisos de seleccionar registres i 
-- actualitzar sobre la taula films a l'usuari obi-wan.kenobi. Accedeix amb aquest 
-- usuari i comprova que realment no té els dos permisos.

/* LE DAMOS LOS PERMISOS POR SI NO LOS TENÍA */
GRANT SELECT, ALTER
	ON m03_uf3.films
    TO 'obi-wan.kenobi'@'127.0.0.1';
    
FLUSH PRIVILEGES;

/* LE QUITAMOS LOS PERMISOS */
REVOKE SELECT, ALTER
	ON m03_uf3.films
    FROM 'obi-wan.kenobi'@'127.0.0.1';

-- Tasca 2. Treu tots els permisos als usuaris obi-wan.kenobi, r2-d2 i stormtrooper. 
-- Accedeix amb aquests usuaris i comprova que realment no tenen accés a cap base de dades.

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'obi-wan.kenobi'@'127.0.0.1', 'r2-d2', stormtrooper;
FLUSH PRIVILEGES;
# GRANT USAGE ES SINÓNIMO DE NO TENER PRIVILEGIOS #
SHOW GRANTS FOR 'obi-wan.kenobi'@'127.0.0.1';
SHOW GRANTS FOR 'r2-d2';
SHOW GRANTS FOR stormtrooper;

-- Tasca 3. Treu el permís d'esborrar a la taula films per l’usuari yoda. 
-- Comprova que no pot eliminar cap pel·licula.

/* NO PODEMOS BORRAR LOS PERMISOS QUE NO TIENE */

GRANT DELETE
	ON m03_uf3.films
		TO yoda@localhost;
        
FLUSH PRIVILEGES;

REVOKE DELETE
	ON m03_uf3.films
    FROM yoda@localhost;
SHOW GRANTS FOR yoda@localhost;

FLUSH PRIVILEGES;

-- Tasca 4. Treu el permís a leia.organa d'inserir registres sobre la taula films. Comproveu.

SHOW GRANTS FOR 'leia.organa';

GRANT SELECT, INSERT
	ON m03_uf3.films
		TO 'leia.organa';
    
FLUSH PRIVILEGES;
    
REVOKE SELECT, INSERT
	ON m03_uf3.films
		FROM 'leia.organa';
SHOW GRANTS FOR 'leia.organa';

FLUSH PRIVILEGES;

-- Tasca 5. Mostra els permisos de l'usuari c-3po. Aquest usuari ja no pot modificar les dades de la taula fims. Comprova-ho.

SHOW GRANTS FOR 'c-3po';

/* VEMOS QUE TIENE PERMISO DE SELECT Y UPDATE EN m03_uf3.films Y NOS PIDE QUE LE QUITEMOS EL UPDATE */

REVOKE UPDATE
	ON m03_uf3.films
		FROM 'c-3po';

-- Tasca 6. Treu els permisos a leia.organa per la taula films, que li permetia 
-- donar permisos a altres usuaris.

SHOW GRANTS FOR 'leia.organa';

GRANT SELECT, INSERT
	ON m03_uf3.films
		TO 'leia.organa'
	WITH GRANT OPTION;

FLUSH PRIVILEGES;

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'leia.organa';

-- Tasca 7. Accedix amb l'usuari root i treu tots els permisos a yoda.

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'yoda'@'localhost';

SHOW GRANTS FOR yoda@localhost;
