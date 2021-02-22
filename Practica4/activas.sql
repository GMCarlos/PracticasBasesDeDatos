SET SERVEROUTPUT ON

/* ------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------ */
/* Tablas */
/*Hago el borrado al principio por si hubiese algo en las tablas y seguidamente las creo*/
DROP TABLE personajes;
DROP TABLE clases;

CREATE TABLE clases (
  cod NUMBER(2),
  nombre VARCHAR2(20),
  ingresos NUMBER(10,2),
  num_pob NUMBER(3),
  PRIMARY KEY (cod)
);

CREATE TABLE personajes (
  id VARCHAR2(3), 
  nombre VARCHAR(36), 
  fechanac DATE,
  cp VARCHAR2(5),
  sexo VARCHAR2(1),
  patrimonio NUMBER(10,2),
  clase NUMBER(2), 
  PRIMARY KEY (id),
  FOREIGN KEY (clase) REFERENCES clases (cod) ON DELETE SET NULL
);

/* ------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------ */
/* Triggers */

/* R1: Inserción de tuplas en personajes */
CREATE OR REPLACE TRIGGER ingresos1 
AFTER INSERT ON personajes 
REFERENCING NEW AS NUEVA
FOR EACH ROW
WHEN (NUEVA.clase IS NOT NULL)
DECLARE
num_personas NUMBER(3);
BEGIN
  UPDATE clases
  SET ingresos = ingresos + :NUEVA.patrimonio
  WHERE cod = :NUEVA.clase;
  
--Apartado A--
  UPDATE clases
  SET num_pob = num_pob + 1
  WHERE cod = :NUEVA.clase;
--
  DBMS_OUTPUT.ENABLE;
---APARTADO B---------
SELECT num_pob INTO num_personas FROM clases WHERE cod = :NUEVA.clase;

	IF(num_personas=3) THEN
		DBMS_OUTPUT.PUT_LINE('El tercer personaje insertado en la clase '|| :NUEVA.clase||' se llama '|| :NUEVA.nombre);
	END IF;
----------------------


  DBMS_OUTPUT.PUT_LINE('Ejecutada R1. Acaba de actualizarse los ingresos de la clase ' || :NUEVA.clase);

END;
/

/* R2: Modificación de patrimonio de personajes */
CREATE OR REPLACE TRIGGER ingresos2 
AFTER UPDATE OF patrimonio ON personajes 
REFERENCING OLD AS ANTIGUA NEW AS NUEVA
FOR EACH ROW
WHEN (NUEVA.clase IS NOT NULL)
BEGIN
  UPDATE clases
  SET ingresos = ingresos + :NUEVA.patrimonio - :ANTIGUA.patrimonio
  WHERE cod = :NUEVA.clase;

  DBMS_OUTPUT.ENABLE;
  DBMS_OUTPUT.PUT_LINE('Ejecutada R2. Acaba de actualizarse los ingresos de la clase ' || :NUEVA.clase);

END;
/

/* R3: Modificación de clase en personajes */
CREATE OR REPLACE TRIGGER ingresos3 
AFTER UPDATE OF clase ON personajes 
FOR EACH ROW 
WHEN (NEW.clase IS NOT NULL AND OLD.clase IS NOT NULL)
BEGIN
  UPDATE clases
  SET ingresos = ingresos + :NEW.patrimonio
  WHERE cod = :NEW.clase;
  
  UPDATE clases
  SET ingresos = ingresos - :OLD.patrimonio
  WHERE cod = :OLD.clase;

  ----------------------------------
  ------------APARTADO A----------------------
  UPDATE clases
  SET num_pob = num_pob + 1
  WHERE cod = :NEW.clase;
  
  UPDATE clases
  SET num_pob = num_pob - 1
  WHERE cod = :OLD.clase;
  ----------------------------------
  ----------------------------------

  DBMS_OUTPUT.ENABLE;
  DBMS_OUTPUT.PUT_LINE('Ejecutada R3. Acaban de actualizarse los ingresos de la clase ' || :OLD.clase || ' y de la clase  ' || :NEW.clase);

END;
/

/* R4: Eliminación de tuplas de personajes */
CREATE OR REPLACE TRIGGER ingresos4 
AFTER DELETE ON personajes 
FOR EACH ROW 
WHEN (OLD.clase IS NOT NULL)
BEGIN
  UPDATE clases
  SET ingresos = ingresos - :OLD.patrimonio
  WHERE cod = :OLD.clase;

  -----------------------APARTADO A----------------------------------
  UPDATE clases
  SET num_pob = num_pob - 1
  WHERE cod = :OLD.clase;
  ---------------------------------------------------------
   
  DBMS_OUTPUT.ENABLE;
  DBMS_OUTPUT.PUT_LINE('Ejecutada R4. Acaba de borrarse de personajes a la persona con ID ' || :OLD.ID || ' y llamada ' || :OLD.nombre);

END;
/

--------------------------EJERCICIO 7.C---------------------------------
CREATE OR REPLACE TRIGGER avisoDeIngresos
AFTER INSERT OR UPDATE ON personajes
REFERENCING NEW AS NUEVA
FOR EACH ROW
WHEN (NUEVA.patrimonio IS NOT NULL)
BEGIN
IF(:NUEVA.patrimonio<20000) THEN 
		DBMS_OUTPUT.ENABLE;
		DBMS_OUTPUT.PUT_LINE('El patrimonio debe de ser mayor o igual a 20000');
END IF;

IF (:NUEVA.patrimonio>30000) THEN 
		DBMS_OUTPUT.ENABLE;
		DBMS_OUTPUT.PUT_LINE('El patrimonio debe de ser menor o igual a 30000');
END IF;
END;
/

------------------------------------------------------------------------

-------------------------EJERCICIO 7.D----------------------------------
CREATE OR REPLACE TRIGGER corregirDni
BEFORE INSERT OR UPDATE ON personajes
REFERENCING NEW AS NUEVA
FOR EACH ROW
WHEN (NUEVA.id IS NOT NULL)
BEGIN
IF(:NUEVA.id='ABC') THEN
	:NUEVA.id:='abc';
	DBMS_OUTPUT.ENABLE;
	DBMS_OUTPUT.PUT_LINE('Se ha corregido el personaje con id igual a ABC por el valor de abc.');
END IF;
END;
/

------------------------------------------------------------------------

--------------------------EJERCICIO 7.E---------------------------------
CREATE OR REPLACE TRIGGER validarId
BEFORE INSERT OR UPDATE ON personajes
REFERENCING NEW AS NUEVA
FOR EACH ROW
WHEN (NUEVA.id IS NOT NULL)
BEGIN
IF(:NUEVA.id='ASD') THEN
	RAISE_Application_Error( -20000, 'NO SE PUEDE INSERTAR ESTE VALOR DE ID.' );
END IF;
END;
/

------------------------------------------------------------------------

/* ------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------ */
/* Inserciones */

INSERT INTO clases
  VALUES (1,'Nobleza',0, 0);

INSERT INTO clases
  VALUES (2,'Clero',0, 0);

INSERT INTO clases
  VALUES (3,'Artesanos',0, 0);

INSERT INTO clases
  VALUES (4,'Campesinos',0, 0);

/* ------------------------------------------------------------------------------------ */
/* Invocacion al trigger: ingresos1 */

INSERT INTO personajes
  VALUES ('123','Calixto Pérez','15/11/1757','06300','H',150,4);

INSERT INTO personajes
  VALUES ('777','Gervasio Romualdo','12/12/1721','06002','H',230,4);

INSERT INTO personajes
  VALUES ('222','Prudencio González','01/02/1720','06300','H',220,4);

INSERT INTO personajes
  VALUES ('333','Macaria Gil','10/04/1731','06400','M',195,4);

INSERT INTO personajes
  VALUES ('666','Honorio Marín','12/12/1742','10005','H',370,4);

INSERT INTO personajes
  VALUES ('555','Venancio Fernández','15/11/1738','10600','H',4600,3);

INSERT INTO personajes
  VALUES ('696','Balbina Sánchez','12/04/1734','06400','M',5000,3);

INSERT INTO personajes
  VALUES ('888','Faustino Martínez','30/05/1731','06002','H',7000,3);

INSERT INTO personajes
  VALUES ('999','Facundo Fernández','12/03/1739','10800','H',6300,3);

INSERT INTO personajes
  VALUES ('444','Pandulfa Ruiz','01/02/1750','06800','M',2500,3);

INSERT INTO personajes
  VALUES ('987','Eduviges Pozo','10/05/1734','10005','M',40000,2);
  
INSERT INTO personajes
  VALUES ('234','Abundio Hernández','01/07/1749','06800','H',25000,2);

INSERT INTO personajes
  VALUES ('345','Salustiana Moreno','07/04/1733','10300','M',40000,2);

INSERT INTO personajes
  VALUES ('567','Camelia Cortés','12/05/1736','10600','M',48000,2);

INSERT INTO personajes
  VALUES ('789','Sagrario Méndez','22/06/1759','10800','M',18000,2);

INSERT INTO personajes
  VALUES ('901','Amable Montero','07/04/1760','10300','H',140000,1);

INSERT INTO personajes
  VALUES ('012','Martiniano Zarzal','23/11/1736','10005','H',360000,1);

INSERT INTO personajes
  VALUES ('876','Mederica Campos','19/03/1734','06800','M',500000,1);

INSERT INTO personajes
  VALUES ('321','Filiberto Torres','08/08/1748','06002','H',250000,1);

INSERT INTO personajes
  VALUES ('221','Obdulia Candil','08/08/1737','10005','M',502000,1);

SELECT * FROM clases;
SELECT * FROM personajes;

/* ------------------------------------------------------------------------------------ */
/* Invocacion al trigger: ingresos2 */

UPDATE personajes SET patrimonio=20000 WHERE ID = '123';

SELECT * FROM clases;
SELECT * FROM personajes;

/* ------------------------------------------------------------------------------------ */
/* Invocacion al trigger: ingresos3 */

UPDATE personajes
SET clase=2
WHERE ID = '123';

SELECT * FROM clases;
SELECT * FROM personajes;

/* ------------------------------------------------------------------------------------ */
/* Invocacion al trigger: ingresos4 */

DELETE FROM personajes WHERE ID = '222';

SELECT * FROM clases;
SELECT * FROM personajes;


INSERT INTO personajes
  VALUES ('ABC','Apartado D','15/11/1757','06300','H',150,4);


INSERT INTO personajes
  VALUES ('ASD','Apartado D','15/11/1757','06300','H',150,4);
  
SELECT * FROM personajes;
/* ------------------------------------------------------------------------------------ */
/* Borrar tablas y triggers */

DROP TRIGGER ingresos1;
DROP TRIGGER ingresos2;
DROP TRIGGER ingresos3;
DROP TRIGGER ingresos4;
DROP TRIGGER avisoDeIngresos;
DROP TRIGGER corregirDni;
DROP TRIGGER validarId;