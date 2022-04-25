-- Tasca 1. (Root) - L'usuari pz.root és l'administrador, per tant que tingui permís 
-- per a gestionar tota la base de dades de pizzeria i donar permisos. 
-- Fes servir l’usuari pz.root per la resta de tasques.

GRANT ALL PRIVILEGES
	ON uf2_p2_pizzeria.*
		TO 'pz.root' IDENTIFIED BY '1234'
	WITH GRANT OPTION;

FLUSH PRIVILEGES;

-- Tasca 2. (Administració) -  Crear l’usuari pz.administracio, i aplica que pugi crear usuaris 
-- però no pot assignar cap permís, amb una sola intrucció.

## ESTE COMANDO SE DEBE EJECUTAR CON EL ROOT (NO pz.root) ##

GRANT CREATE USER
	ON *.*
		TO 'pz.administracio' IDENTIFIED BY '1234';

FLUSH PRIVILEGES;

-- Tasca 3. (Rols) -  Crea els seguents rols: dissenyador.global, dissenyador.productes, 
-- operador.persones, operador.productes i repartidor.

## ESTE COMANDO SE DEBE EJECUTAR CON EL ROOT (NO pz.root) ##

CREATE ROLE 'dissenyador.global', 'dissenyador.productes', 'operador.persones', 'operador.productes', 'repartidor';

-- Tasca 4. (Dissenyador global) -  El rol dissenyador.global pot modificar l'estructura de la 
-- base de dades. Pot crear, modificar i eliminar part de l'estructura de la base de dades, 
-- però no les dades.

GRANT CREATE, DROP, ALTER
	ON uf2_p2_pizzeria.*
		TO 'dissenyador.global';

## LOS FLUSH PRIVILEGES Y LOS SHOW GRANTS SOLO SE PUEDEN EJECUTAR CON EL ROOT ##

FLUSH PRIVILEGES;

-- Tasca 5. (Dissenyador dels productes) -  El rol dissenyador.productes pot modificar 
-- l'estructura de les taules que tenen dades dels productes. Tingues en compte que no pot 
-- crear ni esborrar taules, ni les dades.

GRANT ALTER
	ON uf2_p2_pizzeria.producte
		TO 'dissenyador.productes';
GRANT ALTER
	ON uf2_p2_pizzeria.pizza
		TO 'dissenyador.productes';
GRANT ALTER
	ON uf2_p2_pizzeria.pizza_ingredient
		TO 'dissenyador.productes';
GRANT ALTER
	ON uf2_p2_pizzeria.ingredient
		TO 'dissenyador.productes';
GRANT ALTER
	ON uf2_p2_pizzeria.postre
		TO 'dissenyador.productes';
GRANT ALTER
	ON uf2_p2_pizzeria.beguda
		TO 'dissenyador.productes';
        
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'dissenyador.productes';

-- Tasca 6. (Operador de dades de persones) -  El rol operador.persones pot treballar sobre les 
-- dades de les persones, però no sobre les dades dels productes.

GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.client
		TO 'operador.persones';
GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.empleat
		TO 'operador.persones';
        
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'operador.persones';

-- Tasca 7. (Operador de dades dels productes) -  El rol operador.productes pot treballar sobre 
-- les dades dels productes, però no sobre les dades de les persones.

GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.producte
		TO 'operador.productes';
GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.pizza
		TO 'operador.productes';
GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.pizza_ingredient
		TO 'operador.productes';
GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.ingredient
		TO 'operador.productes';
GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.postre
		TO 'operador.productes';
GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.beguda
		TO 'operador.productes';
        
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'operador.productes';

-- Tasca 8. (Repartidor) -  El rol repartidor pot treballar sobre les dades de les comandes, 
-- però no sobre la resta de dades.

GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.comanda
		TO 'repartidor';
GRANT SELECT, UPDATE, DELETE, INSERT
	ON uf2_p2_pizzeria.comanda_producte
		TO 'repartidor';
        
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'repartidor';

-- Tasca 9. (Assignació de rols) -  Dona d’alta a la base de dades els usuaris i assigna els rols segons:

GRANT 'dissenyador.global'
	TO 'pz.joan' IDENTIFIED BY '1234';

SHOW GRANTS FOR 'pz.joan';

GRANT 'dissenyador.global'
	TO 'pz.maria' IDENTIFIED BY '1234';
GRANT 'dissenyador.productes'
	TO 'pz.maria';
    
SHOW GRANTS FOR 'pz.maria';

GRANT 'dissenyador.productes'
	TO 'pz.jordi' IDENTIFIED BY '1234';

SHOW GRANTS FOR 'pz.jordi';

GRANT 'operador.persones'
	TO 'pz.eric' IDENTIFIED BY '1234';
GRANT 'operador.productes'
	TO 'pz.eric';
    
SHOW GRANTS FOR 'pz.eric';

GRANT 'operador.productes'
	TO 'pz.dani' IDENTIFIED BY '1234';
GRANT 'repartidor'
	TO 'pz.dani';

SHOW GRANTS FOR 'pz.dani';

GRANT 'repartidor'
	TO 'pz.pol' IDENTIFIED BY '1234';

SHOW GRANTS FOR 'pz.pol';

FLUSH PRIVILEGES;

-- Tasca 10. (Treure de permisos) - Treu el permis de eliminar dades dels ingredients a l’usuari pz.dani.

/*
 NO ES POSIBLE RESTRINGIR UN PERMISO ESPECÍFICO DE UN ROL A DANI, 
 HABRÍA QUE CREAR UN ROL ESPECÍFICO PARA DANI O DARLE UNOS PERMISOS
 EN CONCRETO
*/
