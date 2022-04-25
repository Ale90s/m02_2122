-- Tasca 2. BD M02 UF3

DROP DATABASE IF EXISTS m03_uf3;
CREATE DATABASE m03_uf3;
USE m03_uf3;

-- Tasca 3. Crea un usuari anomenat luke

CREATE USER luke;

-- Tasca 4. Crea un usuari anomenat yoda a l’ordinador local.

CREATE USER yoda@localhost;

-- Tasca 5. Crea un usuari anomenat leia amb contrasenya rebel.

CREATE USER leia IDENTIFIED BY 'rebel';

-- Tasca 6. Identifica la adreça IP d’on et connectes a la BD. 
-- Crea un usuari anomenat obi per accedir des de aquesta IP.

CREATE USER obi@'127.0.0.1';

-- Tasca 7. Crea un usuari anomenat chewbacca amb la contrasenya chewe per accedir 
-- des de la adreça IP de la Tasca 6.

CREATE USER chewbacca@'127.0.0.1' IDENTIFIED BY 'chewe';

-- Tasca 8. Genera el valor hash de la contrasenya imperi. Crea un usuari anomenat 
-- darth.vader per accedir des de qualsevol adreça IP amb la contrasenya en hash.

SELECT PASSWORD('imperi');
CREATE USER 'dath.vader' IDENTIFIED BY '*C7C508DE4AA9E6B82EFBA3D68C0C12B6A235BE01';

-- Tasca 9. Mostra els usuaris generats al sistema.

SELECT user AS usuarios
	FROM mysql.user
    ORDER BY user;

-- Tasca 10. Accedeix amb tots el usuaris generats al sistema i mostrats a la Tasca 9.

-- AQUI HAY QUE CREAR NUEVAS CONEXIONES CON OTROS USUARIOS Y SE PUEDE OBSERVAR QUE DEPENDE DE LOS COMANDOS TIENES LIMITACIONES

-- Tasca 11. Elimina l’usuari de la Tasca 3 i Tasca 7 en una sola linia.

DROP USER luke, chewbacca@'127.0.0.1';

-- Tasca 12. Canvia el nom l’usuari de la Tasca 6 per obi-wan.kenobi.

RENAME USER obi@127.0.0.1 TO 'obi-wan.kenobi'@127.0.0.1;
SELECT * FROM mysql.user;

-- Tasca 13. Canvia el nom l’usuari de la Tasca 5 per leia.organa.

RENAME USER leia TO 'leia.organa';

-- Tasca 14. Accedeix amb l’usuari de la Tasca 8 i canvia la contrasenya per josócelteupare.

SET PASSWORD = PASSWORD('josócelteupare');

-- Tasca 15. Modifica l’usuari de la Tasca 4 per donar-li la contrasenya força amb l’us de la
-- sintaxi SET PASSWORD FOR.

SET PASSWORD FOR yoda@'localhost' = PASSWORD('força');

-- Tasca 16. Modifica l’usuari de la Tasca 12 per donar-li la contrasenya mestre amb l’us de la
-- sintaxi UPDATE.

UPDATE mysql.user 
	SET PASSWORD=PASSWORD('mestre')
		WHERE user='obi' AND host = '127.0.0.1';
ALTER USER 'obi-wan.kenobi'@'127.0.0.1' IDENTIFIED BY 'mestre';

-- Tasca 17. Mostra els usuaris que tens al sistema.

SELECT * 
	FROM mysql.user;

-- Tasca 18. Accedeix amb tots el usuaris que tens al sistema i mostrats a la Tasca 17.

