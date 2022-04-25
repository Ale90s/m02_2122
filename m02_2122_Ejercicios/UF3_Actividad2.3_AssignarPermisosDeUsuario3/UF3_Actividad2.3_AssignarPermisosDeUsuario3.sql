-- Tasca 1. L'usuari yoda és l'administrador, per tant que tingui permís per a fer tot i donar permisos.

GRANT ALL PRIVILEGES
	ON *.*
	TO 'yoda'@'localhost'
    WITH GRANT OPTION;
    
FLUSH PRIVILEGES;

-- Tasca 2.  Crea a partir de l'usuari yoda els seguents rols: resistencia, imperi, pilot i droide.

CREATE ROLE resistencia;
CREATE ROLE imperi;
CREATE ROLE pilot;
CREATE ROLE droide;

/* OTRA OPCION */

-- CREATE ROLE resistencia, imperi, pilot, droide;

-- Tasca 3. Mostra els rols creats a la Tasca 2.

SELECT * 
	FROM information_schema.applicable_roles;

-- Tasca 4. El rol imperi té tots els permisos sobre la base de dades m02_uf3.

GRANT ALL PRIVILEGES
	ON m03_uf3.*
		TO imperi;
FLUSH PRIVILEGES;

-- Tasca 5. El rol resistencia té tots els permisos sobre la base de dades m02_uf3 i pot donar permisos.

GRANT ALL PRIVILEGES
	ON m03_uf3.*
		TO resistencia
	WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Tasca 6. El rol pilot pot consultar, modificar i esborrar dades de la taula planets.

GRANT SELECT, UPDATE, DELETE
	ON m03_uf3.planets
		TO pilot;
FLUSH PRIVILEGES;

-- Tasca 7. El rol droide pot consultar i modificar dades de la taula films.

GRANT SELECT, UPDATE
	ON m03_uf3.films
		TO droide;
FLUSH PRIVILEGES;

-- Tasca 8. El rol droide pot crear usuaris.

GRANT CREATE USER
	ON *.*
		TO droide;
FLUSH PRIVILEGES;

-- Tasca 9. Assigna a leia.organa el rol de resistencia.

GRANT resistencia
	TO 'leia.organa';
FLUSH PRIVILEGES;

-- Tasca 10. Assigna a darth.vader el rol de imperi.

GRANT imperi
	TO 'dath.vader';
FLUSH PRIVILEGES;
    
-- Tasca 11. Assigna a r2-d2 i c-3po el rol de droide.

GRANT droide
	TO 'r2-d2', 'c-3po';
FLUSH PRIVILEGES;

-- Tasca 12. Assigna a r2-d2 el rol de pilot.

GRANT pilot
	TO 'r2-d2';
FLUSH PRIVILEGES;

-- Tasca 13. El rol per defecte de l'usuari r2-d2 és droide.

SET DEFAULT ROLE droide FOR 'r2-d2';
FLUSH PRIVILEGES;

-- Tasca 14. Entra amb l'usuari r2-d2. Mostra els rols que li 
-- podem aplicar a l'usuari actual. Mostra el rol actiu d'un usuari. 
-- Canvia el rol per obtenir els permisos momentaniament del rol pilot. 
-- Prova'ls, i finalment posa-li per defecte aquest rol.

SELECT * 
	FROM information_schema.applicable_roles;

/*
COMO ESPECIFICAMOS ANTES EL USUARIO r2-d2 ESTÁ EN EL GRUPO pilot Y droide
*/

-- Tasca 15. Elimina el rol imperi.

DROP ROLE imperi;
