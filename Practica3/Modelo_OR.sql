SET SERVEROUTPUT ON

/* --------------------------- */
/* CREACION DE OBJETOS Y TIPOS */
/* --------------------------- */

CREATE TYPE nombreCompleto AS OBJECT (
  nombre VARCHAR2(12),
  ape1 VARCHAR2(12),
  ape2 VARCHAR2(12)
);
/

CREATE TYPE numTelfs AS VARRAY(5) OF VARCHAR2(9);
/

CREATE TYPE IBANtipo AS OBJECT (
  cod VARCHAR2(5),
  pais VARCHAR2(2),
  control VARCHAR2(2),
  entidad VARCHAR2(4),
  oficina VARCHAR2(4),
  dc VARCHAR2(2),
  cuenta VARCHAR2(10)
);
/

CREATE TYPE cuentasTab AS TABLE OF IBANtipo;
/

CREATE TYPE Persona AS OBJECT (
  dni VARCHAR(9), 
  relacionado REF Persona,
  datosPersonales nombreCompleto,
  fechanac DATE,
  direccion VARCHAR2(20),
  cp VARCHAR2(5),
  sexo VARCHAR2(1),
  sector NUMBER(2),
  telefonos numTelfs,
  cuentas cuentasTab,
  --MAP MEMBER FUNCTION ret_value RETURN NUMBER,
  --APARTADO D:
  ORDER MEMBER FUNCTION ordenar (x IN Persona) RETURN INTEGER,
  ------------------------
  MEMBER PROCEDURE mostrar,
  MEMBER FUNCTION calcularDescuento RETURN NUMBER
);
/

-- Aseguramos que haya herencia
ALTER TYPE Persona NOT FINAL;
/

CREATE TYPE Estudiante UNDER Persona (
  Titulacion VARCHAR2(20),
  asigAprob NUMBER(2),

  OVERRIDING MEMBER PROCEDURE mostrar,
  OVERRIDING MEMBER FUNCTION calcularDescuento RETURN NUMBER
);
/
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
CREATE TYPE Trabajador UNDER Persona (
  ingresos NUMBER(7,2),
  gastosFijos NUMBER(7,2),
  gastosAlim NUMBER(7,2),
  gastosRopa NUMBER(7,2),
  OVERRIDING MEMBER PROCEDURE mostrar,
  --APARTADO E:
  --en función de los años trabajando se le hará más o menos descuento
  MEMBER FUNCTION calcularDescuento (años IN NUMBER) RETURN NUMBER
);
/
--Fix
CREATE TABLE Empresa OF Trabajador
  (dni PRIMARY KEY)
  NESTED TABLE cuentas STORE AS cuentas_emp
  ((PRIMARY KEY(NESTED_TABLE_ID,cod)));
/
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

CREATE TABLE PersonaTab OF Persona
  (dni PRIMARY KEY)
  NESTED TABLE cuentas STORE AS cuentas_alm
  ((PRIMARY KEY(NESTED_TABLE_ID,cod)));
/

CREATE TABLE Universidad OF Estudiante
  (dni PRIMARY KEY)
  NESTED TABLE cuentas STORE AS cuentas_univ_alm
  ((PRIMARY KEY(NESTED_TABLE_ID,cod)));
/

CREATE TABLE Referencias(
  dni VARCHAR(9),
  Puntero REF Persona
);

/* ------- */
/* METODOS */
/* ------- */

/* ------------------------------------------------------------------------------------ */
/* Metodos del objeto: Persona */

CREATE OR REPLACE TYPE BODY Persona AS

  --MAP MEMBER FUNCTION ret_value RETURN NUMBER IS
  --BEGIN
	--RETURN dni;
  --END;

  ORDER MEMBER FUNCTION ordenar(x in Persona) RETURN INTEGER IS
  BEGIN
	RETURN x.dni - dni;
  END ;

  MEMBER PROCEDURE mostrar IS
    --i INTEGER; -- No hace falta declarar i
    vdni VARCHAR2(9);
    vpais VARCHAR2(2);
    vcontrol VARCHAR2(2);
    ventidad VARCHAR2(4);
    voficina VARCHAR2(4);
    vdc VARCHAR2(2);
    vcuenta VARCHAR2(10);
        
    CURSOR cursor_ver_cuentas IS 
       SELECT p.DNI, c.pais, c.control, c.entidad, c.oficina, c.dc, c.cuenta
       FROM PersonaTab p, table(p.cuentas) c;
       
  BEGIN
    dbms_output.put_line('Método mostrar() de objeto Persona');
    dbms_output.put_line('DNI: ' || dni);
    dbms_output.put_line('Nombre: ' || datosPersonales.nombre);
    dbms_output.put_line('Apellido 1: ' || datosPersonales.ape1);
    dbms_output.put_line('Apellido 2: ' || datosPersonales.ape2);
    dbms_output.put_line('Fecha nacimiento: ' || fechanac);
    dbms_output.put_line('Dirección: ' || direccion);
    dbms_output.put_line('CP: ' || cp);
    dbms_output.put_line('Sector: ' || sector);

    dbms_output.put_line('Existen ' || telefonos.count || ' teléfonos');
    IF (telefonos.count <> 0) THEN 
      FOR i IN 1 .. telefonos.count LOOP
         dbms_output.put_line('     Teléfono ' || i || ': ' || telefonos(i));
	  END LOOP;
    END IF;
    
    dbms_output.put_line('Existen ' || cuentas.count || ' cuentas bancarias');    
    OPEN cursor_ver_cuentas;
    LOOP
      FETCH cursor_ver_cuentas INTO vDNI, vpais, vcontrol, ventidad, voficina, vdc, vcuenta;
      EXIT WHEN cursor_ver_cuentas%NOTFOUND;
      IF (vDNI = dni) THEN
        dbms_output.put_line('     IBAN: ' || vpais || vcontrol || '-' || ventidad || '-' || voficina || '-' || vdc || '-' || vcuenta);
      END IF;
    END LOOP;
    CLOSE cursor_ver_cuentas;
    
    dbms_output.put_line('---------------------------------------');    
  END; -- de Mostrar
  
  MEMBER FUNCTION calcularDescuento RETURN NUMBER IS
  BEGIN
    IF sector=1 THEN
      RETURN 10;
    ELSE 
      RETURN 0;
    END IF;
  END; -- de calcularDescuento
  


END; -- de Persona
/

/* Metodos del objeto: Estudiante */

CREATE OR REPLACE TYPE BODY Estudiante AS
  
  OVERRIDING MEMBER PROCEDURE mostrar IS
    vdni VARCHAR2(9);
    vpais VARCHAR2(2);
    vcontrol VARCHAR2(2);
    ventidad VARCHAR2(4);
    voficina VARCHAR2(4);
    vdc VARCHAR2(2);
    vcuenta VARCHAR2(10);
        
    CURSOR cursor_ver_cuentas IS 
       SELECT p.DNI, c.pais, c.control, c.entidad, c.oficina, c.dc, c.cuenta
       FROM Universidad p, table(p.cuentas) c;

  BEGIN
    dbms_output.put_line('Método mostrar() de objeto Estudiante');
    dbms_output.put_line('DNI: ' || dni);
    dbms_output.put_line('Nombre: ' || datosPersonales.nombre);
    dbms_output.put_line('Apellido 1: ' || datosPersonales.ape1);
    dbms_output.put_line('Apellido 2: ' || datosPersonales.ape2);
    dbms_output.put_line('Fecha nacimiento: ' || fechanac);
    dbms_output.put_line('Dirección: ' || direccion);
    dbms_output.put_line('CP: ' || cp);
    dbms_output.put_line('Sector: ' || sector);
    
    dbms_output.put_line('Existen ' || telefonos.count || ' teléfonos');
    IF (telefonos.count <> 0) THEN 
      FOR i IN 1 .. telefonos.count LOOP
         dbms_output.put_line('     Teléfono ' || i || ': ' || telefonos(i));
	  END LOOP;
    END IF;
    
    dbms_output.put_line('Existen ' || cuentas.count || ' cuentas bancarias');    
    OPEN cursor_ver_cuentas;
    LOOP
      FETCH cursor_ver_cuentas INTO vDNI, vpais, vcontrol, ventidad, voficina, vdc, vcuenta;
      EXIT WHEN cursor_ver_cuentas%NOTFOUND;
      IF (vDNI = dni) THEN
        dbms_output.put_line('     IBAN: ' || vpais || vcontrol || '-' || ventidad || '-' || voficina || '-' || vdc || '-' || vcuenta);
      END IF;
    END LOOP;
    CLOSE cursor_ver_cuentas;
    
    dbms_output.put_line('Titulación: ' || titulacion);
    dbms_output.put_line('Asignaturas aprobadas: ' || asigAprob);
    
    dbms_output.put_line('---------------------------------------');    
  END; -- de Mostrar
  
  OVERRIDING MEMBER FUNCTION calcularDescuento RETURN NUMBER IS
  BEGIN
    IF sector=1 THEN
      RETURN 20;
    ELSE 
      RETURN 15;
    END IF;
  END; -- de calcularDescuento

END; -- de Estudiante
/


/*-----------------------------------------------*/
/*-----------------------------------------------*/
/*-----------------------------------------------*/
CREATE OR REPLACE TYPE BODY Trabajador AS
  
  OVERRIDING MEMBER PROCEDURE mostrar IS
    vdni VARCHAR2(9);
    vpais VARCHAR2(2);
    vcontrol VARCHAR2(2);
    ventidad VARCHAR2(4);
    voficina VARCHAR2(4);
    vdc VARCHAR2(2);
    vcuenta VARCHAR2(10);
        
    CURSOR cursor_ver_cuentas IS 
       SELECT p.DNI, c.pais, c.control, c.entidad, c.oficina, c.dc, c.cuenta
       FROM Empresa p, table(p.cuentas) c;

  BEGIN
    dbms_output.put_line('Método mostrar() de objeto Trabajador');
    dbms_output.put_line('DNI: ' || dni);
    dbms_output.put_line('Nombre: ' || datosPersonales.nombre);
    dbms_output.put_line('Apellido 1: ' || datosPersonales.ape1);
    dbms_output.put_line('Apellido 2: ' || datosPersonales.ape2);
    dbms_output.put_line('Fecha nacimiento: ' || fechanac);
    dbms_output.put_line('Dirección: ' || direccion);
    dbms_output.put_line('CP: ' || cp);
    dbms_output.put_line('Sector: ' || sector);
    
    dbms_output.put_line('Existen ' || telefonos.count || ' teléfonos');
    IF (telefonos.count <> 0) THEN 
      FOR i IN 1 .. telefonos.count LOOP
         dbms_output.put_line('     Teléfono ' || i || ': ' || telefonos(i));
	  END LOOP;
    END IF;
    
    dbms_output.put_line('Existen ' || cuentas.count || ' cuentas bancarias');    
    OPEN cursor_ver_cuentas;
    LOOP
      FETCH cursor_ver_cuentas INTO vDNI, vpais, vcontrol, ventidad, voficina, vdc, vcuenta;
      EXIT WHEN cursor_ver_cuentas%NOTFOUND;
      IF (vDNI = dni) THEN
        dbms_output.put_line('     IBAN: ' || vpais || vcontrol || '-' || ventidad || '-' || voficina || '-' || vdc || '-' || vcuenta);
      END IF;
    END LOOP;
    CLOSE cursor_ver_cuentas;
    
    dbms_output.put_line('Ingresos: ' || ingresos);
    dbms_output.put_line('Gastos Fijos: ' || gastosFijos);
	dbms_output.put_line('Gastos Alimentacion: ' || gastosAlim);
    dbms_output.put_line('Gastos Ropas: ' || gastosRopa);
	
    
    dbms_output.put_line('---------------------------------------');    
  END; -- de Mostrar
  
  MEMBER FUNCTION calcularDescuento (años IN NUMBER ) RETURN NUMBER IS
	BEGIN
		IF (años>10) THEN
			RETURN 30;
		ELSE
			RETURN 15;
		END IF ;
	END ; -- de calcularDescuento
  

END; -- de Trabajador
/
/*-----------------------------------------------*/
/*-----------------------------------------------*/
/*-----------------------------------------------*/

/* ----------- */
/* INSERCIONES */
/* ----------- */

CREATE SEQUENCE num_cuenta INCREMENT BY 1 START WITH 1 ORDER;

-- Una forma de insertar, (a) primero el objeto principal
INSERT INTO PersonaTab
VALUES ('123456789', NULL, nombreCompleto('Carlos','Gutiérrez','Pérez'),'5/11/1997','Pz. Colón','06300','H',1,numTelfs('654654654','678678678'),cuentasTab());

-- Y (b) luego las colecciones, en la tabla anidada
INSERT INTO TABLE (select p.cuentas from PersonaTab p where p.DNI='123456789') 
VALUES (num_cuenta.nextval,'ES','60','0049','1500','05','1234567892'); -- Santander

INSERT INTO TABLE (select p.cuentas from PersonaTab p where p.DNI='123456789') 
VALUES (num_cuenta.nextval,'ES','54','2100','0900','15','5556669874'); -- Caixabank

INSERT INTO TABLE (select p.cuentas from PersonaTab p where p.DNI='123456789') 
VALUES (num_cuenta.nextval,'ES','28','0182','0045','64','3571598526'); -- BBVA

-- Otra forma de insertar: objeto y colecciones en una única sentencia INSERT
INSERT INTO PersonaTab
VALUES ('666884444', NULL, nombreCompleto('Ignacio','Costa','Burgos'),'12/12/1982','C. Descubrimiento','10005','H',1,numTelfs('927242526','927225005','657776398','602485000'),cuentasTab(
  IBANTipo('479','ES','58','0182','0000','33','1000375786'), -- BBVA
  IBANTipo('058','ES','10','2048','0110','13','1230984576')  -- Liberbank
));

INSERT INTO PersonaTab
VALUES ('999000111', NULL, nombreCompleto('Francisco','Fernández','Merchán'),'12/03/1979','C. Poniente','10800','H',2,numTelfs('654159753'),cuentasTab(
  IBANTipo('123','ES','16','0049','1551','45','1555567892') -- Santander
));

INSERT INTO PersonaTab
VALUES ('666999333', NULL, nombreCompleto('Paula','Ordóñez','Ruiz'),'01/02/1990','C. Atlántico','06800','M',2,numTelfs('924333435','600700800'),cuentasTab(
  IBANTipo('124','ES','16','0049','1551','45','1555567892'), -- Santander
  IBANTipo('125','ES','44','2100','0910','13','9756385634') -- Caixabank
));

-- Otra forma de insertar: objeto y colecciones en una única sentencia INSERT
INSERT INTO Universidad
VALUES ('111222333', NULL, nombreCompleto('Pedro','Salas','Gil'),'11/05/1996','Pz. América','10005','H',1,numTelfs('927229411','927232626','667555666'),cuentasTab(
  IBANTipo('047','ES','43','2038','0111','22','0000123456'), -- BBVA
  IBANTipo('053','ES','53','2048','0222','12','0022993388')  -- Liberbank
), 'Grado Informática',23);

INSERT INTO Universidad
VALUES ('987654321', NULL, nombreCompleto('Eva','Moreno','Pozo'),'10/05/1974','C. Justicia','10005','M',3,numTelfs('927223182','657332211'),cuentasTab(
  IBANTipo('126','ES','10','2100','1004','10','1004715886') -- Caixabank
), 'Grado Edificación',3);
  
INSERT INTO Universidad
VALUES ('111000111', NULL, nombreCompleto('Antonio','Muñoz','Hernández'),'01/07/1989','C. Constitución','06800','H',3,numTelfs(),cuentasTab(
  IBANTipo('047','ES','79','2038','0010','73','8365936594'), -- BBVA
  IBANTipo('053','ES','82','2048','0200','32','8465836593')  -- Liberbank
), 'Grado Veterinaria',12);

----------------------------------------------
----------------------------------------------
----------------------------------------------
INSERT INTO Empresa
VALUES ('111000333', NULL, nombreCompleto('Carlos','Guillen','Moreno'),'01/07/1989','C. Constitución','06800','H',3,numTelfs(),cuentasTab(
  IBANTipo('047','ES','79','2038','0010','73','8365936594'), -- BBVA
  IBANTipo('053','ES','82','2048','0200','32','8465836593')  -- Liberbank
), 2000, 500, 600, 200);

INSERT INTO Empresa
VALUES ('111000888', NULL, nombreCompleto('Lionel','Messi','Estaca'),'01/07/1989','C. Constitución','06800','H',3,numTelfs(),cuentasTab(
  IBANTipo('047','ES','79','2038','0010','73','8365936595'), -- BBVA
  IBANTipo('053','ES','82','2048','0200','32','8465836594')  -- Liberbank
), 3000, 600, 700, 300);

INSERT INTO Empresa
VALUES ('111000999', NULL, nombreCompleto('Cristiano','Ronaldo','Mazapan'),'01/07/1989','C. Constitución','06800','H',3,numTelfs(),cuentasTab(
  IBANTipo('047','ES','79','2038','0010','73','8365936596'), -- BBVA
  IBANTipo('053','ES','82','2048','0200','32','8465836595')  -- Liberbank
), 4000, 700, 800, 700);
----------------------------------------------
----------------------------------------------
----------------------------------------------

/* ------------------------ */
/* INSERCION DE REFERENCIAS */
/* ------------------------ */
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM PersonaTab c
  WHERE dni='123456789';
  
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM PersonaTab c
  WHERE dni='666884444';

INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM PersonaTab c
  WHERE dni='999000111';
  
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM PersonaTab c
  WHERE dni='666999333';
  
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM Universidad c
  WHERE dni='111222333';
  
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM Universidad c
  WHERE dni='987654321';
  
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM Universidad c
  WHERE dni='111000111';
  
/*Referencias de las nuevas inserciones*/
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM Empresa c
  WHERE dni='111000333';
  
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM Empresa c
  WHERE dni='111000888';
  
INSERT INTO Referencias
  SELECT c.dni,REF(c)
  FROM Empresa c
  WHERE dni='111000999';


/* ------------------ */
/* PROGRAMA PRINCIPAL */
/* ------------------ */

DECLARE

  persona_a Persona;
  persona_b Estudiante;
  persona_c Trabajador;
  
  r1 REF Persona;
  r2 REF Persona;
  r3 REF Persona;
  
  
/* ------------------------------------------------------------------------------------ */

BEGIN

  dbms_output.enable;
  
  /* ------------------------------------------- */
  /* RECUPERACIÓN DE OBJETOS DE LA BASE DE DATOS */
  /* ------------------------------------------- */

  SELECT VALUE(c) INTO persona_a
  FROM PersonaTab c
  where c.DNI='123456789';
  -- Acceso a atributos
  dbms_output.put_line(persona_a.dni);
  -- Llamada a métodos
  persona_a.mostrar();
  dbms_output.put_line('Descuento: ' || persona_a.calcularDescuento);

  /* ------------------------------------------- */

  SELECT VALUE(c) INTO persona_a
  FROM PersonaTab c
  where c.DNI='666884444';
  -- Acceso a atributos
  dbms_output.put_line(persona_a.dni);
  -- Llamada a métodos
  persona_a.mostrar();
  dbms_output.put_line('Descuento: ' || persona_a.calcularDescuento);

  /* ------------------------------------------- */

  SELECT VALUE(c) INTO persona_b
  FROM Universidad c
  where c.DNI='111222333';
  -- Acceso a atributos
  dbms_output.put_line(persona_b.dni);
  -- Llamada a métodos
  persona_b.mostrar();
  dbms_output.put_line('Descuento: ' || persona_b.calcularDescuento);

  
  ------------------------------------------------
  ------------------------------------------------
  ------------------------------------------------
  dbms_output.put_line('Se muestran las nuevas inserciones');
  
  SELECT VALUE(c) INTO persona_c
  FROM Empresa c
  where c.DNI='111000333';
  -- Acceso a atributos
  dbms_output.put_line(persona_c.dni);
  -- Llamada a métodos
  persona_c.mostrar();
  --Apartado e:
  dbms_output.put_line('Su descuento es de: '|| persona_c.calcularDescuento(20));
  
  SELECT VALUE(c) INTO persona_c
  FROM Empresa c
  where c.DNI='111000888';
  -- Acceso a atributos
  dbms_output.put_line(persona_c.dni);
  -- Llamada a métodos
  persona_c.mostrar();
  
  SELECT VALUE(c) INTO persona_c
  FROM Empresa c
  where c.DNI='111000999';
  -- Acceso a atributos
  dbms_output.put_line(persona_c.dni);
  -- Llamada a métodos
  persona_c.mostrar();
  
  
dbms_output.put_line('Fin de las nuevas inserciones');
  ------------------------------------------------
  ------------------------------------------------
  ------------------------------------------------
 

  
  
  /* ------------------------------------------- */
  /* COMPARACIÓN DE OBJETOS: MÉTODOS MAP         */
  /* ------------------------------------------- */
  /*
  dbms_output.put_line('COMPARACIÓN DE OBJETOS: MÉTODOS MAP');

  IF (persona_a < persona_b) THEN
    dbms_output.put_line(persona_a.dni || ' es menor que ' || persona_b.dni);
  ELSE	
    dbms_output.put_line(persona_a.dni || ' es mayor que ' || persona_b.dni);
  END IF;
  */
				--------APARTADO D:---------
  dbms_output.put_line('COMPARACIÓN DE OBJETOS: MÉTODOS ORDER');
IF (persona_a.ordenar(persona_b)<0) THEN
	dbms_output.put_line(persona_a.dni || ' es mayor que ' || persona_b.dni);
  ELSE
  IF (persona_a.ordenar(persona_b)=0) THEN
	dbms_output.put_line(persona_a.dni || ' es igual que ' || persona_b.dni);
  ELSE
	dbms_output.put_line(persona_a.dni || ' es menor que ' || persona_b.dni);
  END IF;
END IF;
  
  /* ------------------------------------------- */
  /* OBTENCIÓN DE REFERENCIAS A OBJETOS          */
  /* ------------------------------------------- */
 
  dbms_output.put_line('OBTENCIÓN DE REFERENCIAS: CON DEREF A PERSONA');
    
  SELECT DEREF(c.Puntero) INTO persona_a
  FROM Referencias c
  WHERE c.DNI='123456789';
    
  -- Acceso a atributos
  dbms_output.put_line(persona_a.dni);
  -- Llamada a métodos
  persona_a.mostrar();
  dbms_output.put_line('Descuento: ' || persona_a.calcularDescuento);
  
  dbms_output.put_line('OBJENCIÓN DE REFERENCIAS: CON DEREF A ESTUDIANTE');
    
  SELECT DEREF(c.Puntero) INTO persona_a
  FROM Referencias c
  WHERE c.DNI='111222333';
    
  -- Acceso a atributos
  dbms_output.put_line(persona_a.dni);
  -- Llamada a métodos
  persona_a.mostrar();
  dbms_output.put_line('Descuento: ' || persona_a.calcularDescuento);
  
  
  -------------------------------EJERCICIO B-------------------------------------- 
--Relaciono a Carlos con Eva 

SELECT r.Puntero INTO r1
FROM Referencias r 
WHERE r.dni='987654321';

UPDATE PersonaTab SET relacionado=r1 WHERE dni='123456789';

--Relaciono a Eva con Antonio

SELECT r.Puntero INTO r2
FROM Referencias r 
WHERE r.dni='111000111';

UPDATE Universidad SET relacionado=r2 WHERE dni='987654321';


--Relaciono a Antonio con Carlos

SELECT r.Puntero INTO r3
FROM Referencias r 
WHERE r.dni='123456789';

UPDATE Universidad SET relacionado=r3 WHERE dni='111000111';
  ---------------------------------------------------------------------------------
  
    -------------------------------------EJERCICIO C---------------------------------
  --c) Realizar consultas que ilustren las relaciones existentes entre las instancias
--almacenadas en la base de datos, haciendo uso de REF / DEREF / VALUE, del tipo:
SELECT VALUE (a) into persona_a
FROM Universidad a
WHERE a.dni= '987654321';


SELECT DEREF (a.relacionado) into persona_a
FROM Universidad a
WHERE a.dni= persona_a.dni;
dbms_output.put_line('Relacion 1: ');
persona_a.mostrar();

 
SELECT DEREF (x.relacionado) into persona_a
FROM PersonaTab x
WHERE x.dni= '123456789';
dbms_output.put_line('Relacion 2: ');
persona_a.mostrar();


SELECT DEREF (a.relacionado) into persona_a
FROM Universidad a
WHERE a.dni= '111000111';
dbms_output.put_line('Relacion 3: ');
persona_a.mostrar();


END;
/

/* ------------------------------------------- */
/* ACCESO A COLECCIONES                        */
/* ------------------------------------------- */

-- ACCESO A COLECCIONES: A) COMO COLECCIÓN ANIDADA
SELECT e.dni, e.telefonos -- varray
FROM PersonaTab e;

SELECT e.dni, e.cuentas -- tablas anidadas
FROM PersonaTab e;

-- ACCESO A COLECCIONES: B) CONSULTA QUE DEVUELVE EL RESULTADO COMO RESULTADO PLANO
SELECT e.dni, p.* -- varray
FROM PersonaTab e, TABLE(e.telefonos) p;

SELECT e.dni, p.* -- tablas anidadas
FROM PersonaTab e, TABLE(e.cuentas) p;

--Apartado F:
SELECT e.dni, e.telefonos -- varray
FROM Empresa e;

SELECT e.dni, e.cuentas -- tablas anidadas
FROM Empresa e;


-- CONSULTA DE OBJETOS ALMACENADOS
SELECT DEREF(c.Puntero)
FROM Referencias c;
  



  ---------------------------------------------------------------------------------
  
/* --------------------------------- */
/* BORRAR TABLAS, OBJETOS, TIPOS ... */
/* --------------------------------- */

DROP SEQUENCE num_cuenta;

DROP TABLE PersonaTab;
DROP TABLE Universidad;
DROP TABLE Empresa;
DROP TABLE Referencias;

DROP TYPE Trabajador;
DROP TYPE Estudiante;
DROP TYPE Persona;
DROP TYPE nombreCompleto;
DROP TYPE numTelfs;
DROP TYPE cuentasTab;
DROP TYPE IBANtipo;	