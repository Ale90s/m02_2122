# DAM M02 UF3
# Activitat 11.2 Triggers BD Banc (solució)

# Exercici DCL_79:

DELIMITER //
CREATE TRIGGER moviment AFTER INSERT
ON moviment FOR EACH ROW
BEGIN
DECLARE descr VARCHAR(30);

IF (NEW.tipus LIKE 'H') THEN
   SET descr := CONCAT(NEW.descripcio,' +',NEW.valor);
ELSEIF (NEW.tipus LIKE 'D') THEN
   SET descr := CONCAT(NEW.descripcio,' -',NEW.valor);
END IF;
INSERT INTO seguretat VALUES (NEW.compte,NEW.data,CURRENT_USER(),descr);

IF ((SELECT compte FROM saldo WHERE compte LIKE NEW.compte) IS NULL) THEN
   IF (NEW.tipus LIKE 'H') THEN
      INSERT INTO saldo VALUES (NEW.compte,NEW.valor);
   ELSEIF (NEW.tipus LIKE 'D') THEN
      INSERT INTO saldo VALUES (NEW.compte,-NEW.valor);
   END IF;
ELSE 
   IF (NEW.tipus LIKE 'H') THEN
      UPDATE saldo SET saldo = saldo + NEW.valor WHERE compte = NEW.compte;
   ELSEIF (NEW.tipus LIKE 'D') THEN
      UPDATE saldo SET saldo = saldo - NEW.valor WHERE compte = NEW.compte;
   END IF;
END IF;

IF ((SELECT data FROM saldo_diari WHERE data = DATE(NEW.data)) IS NULL) THEN
   IF (NEW.tipus LIKE 'H') THEN
      INSERT INTO saldo_diari VALUES (NEW.data,NEW.valor);
   ELSEIF (NEW.tipus LIKE 'D') THEN
      INSERT INTO saldo_diari VALUES (NEW.data,-NEW.valor);
   END IF;
ELSE 
   IF (NEW.tipus LIKE 'H') THEN
      UPDATE saldo_diari SET saldo = saldo+NEW.valor WHERE data = DATE(NEW.data);
   ELSEIF (NEW.tipus LIKE 'D') THEN
      UPDATE saldo_diari SET saldo = saldo-NEW.valor WHERE data = DATE(NEW.data);
   END IF;
END IF;
END //
DELIMITER ;