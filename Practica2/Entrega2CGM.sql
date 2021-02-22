SET SERVEROUTPUT ON;
DECLARE
mensaje VARCHAR2(100);
vnombre VARCHAR2(20);
vpatrimonio NUMBER(10,2);
/* ----------------------------- */
-- Procedimientos... (4.a.1, 4.a.2, 4.a.3, 4.a.4)

--4.a.1 
-- Metodo 1
PROCEDURE InsertarClases(cod NUMBER, nombre VARCHAR2, ingresos NUMBER) IS
BEGIN
	DBMS_OUTPUT.PUT_LINE( 'SE VA A INSERTAR UNA CLASE' );
	INSERT INTO clases VALUES(cod, nombre, ingresos);
	DBMS_OUTPUT.PUT_LINE( 'CLASE INSERTADA' );
	DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
END;

--Metodo 2
PROCEDURE VerClases IS
	--Creo un cursor para almacenar las tuplas y poder recorrerlas en un bucle después
	CURSOR c_clase IS SELECT * FROM clases;
	--Declaro una variable auxiliar para almacenar cada clase, la llamaré aux
	aux clases%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE( 'INFORMACION DE LAS CLASES' );
	OPEN c_clase;
    LOOP
        FETCH c_clase INTO aux;
        EXIT WHEN c_clase%notfound;
        dbms_output.put_line('Codigo clase: ' || aux.cod);
        dbms_output.put_line('Nombre clase: ' || aux.nombre);
        dbms_output.put_line('Ingresos: ' || aux.ingresos);
    END LOOP;
    CLOSE c_clase;
	DBMS_OUTPUT.PUT_LINE( 'INFORMACION MOSTRADA' );
	DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
END;

------------------------------------------------------------------------------------

--4.a.2
-- Metodo 3
PROCEDURE ModificarClases(cod2 NUMBER, nombre2 VARCHAR2, ingresos2 NUMBER) IS
BEGIN
	DBMS_OUTPUT.PUT_LINE( 'SE VA A MODIFICAR UNA CLASE' );
	UPDATE CLASES
	SET NOMBRE = nombre2, INGRESOS=ingresos2
	WHERE COD=cod2;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE( 'SE HA MODIFICADO UNA CLASE' );
	DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
END;

------------------------------------------------------------------------------------

--4.a.3
--Metodo 4
PROCEDURE ConsultarClases(cod2 NUMBER, nombre2 OUT VARCHAR2, ingresos2 OUT NUMBER) IS
BEGIN 
	DBMS_OUTPUT.PUT_LINE( 'SE VA A CONSULTAR UNA CLASE' );
	SELECT NOMBRE, INGRESOS INTO nombre2, ingresos2 FROM CLASES where COD=cod2; 
	--DBMS_OUTPUT.PUT_LINE( 'Nombre de la clase: ' || nombre2 );
	--DBMS_OUTPUT.PUT_LINE( 'Ingresos: ' || ingresos2 );
	COMMIT;
	DBMS_OUTPUT.PUT_LINE( 'INFORMACION DE LA CLASE ALMACENADA EN LAS VARIABLES');
	DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
END;

------------------------------------------------------------------------------------
--4.a.4
--Metodo 5
PROCEDURE BorrarClases (cod2 NUMBER) IS
BEGIN
	DBMS_OUTPUT.PUT_LINE('BORRADO DE LA CLASE');
	DELETE FROM clases WHERE cod=cod2;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('CLASE BORRADA');
	DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
END;


-----------------------------------------------------
---------------METODOS CON EXCEPCIONES---------------
-----------------------------------------------------
--4.b
PROCEDURE InsertarClases2(cod2 NUMBER, nombre VARCHAR2, ingresos NUMBER) IS
	x NUMBER;
	Excep1 EXCEPTION;
BEGIN
	SELECT COUNT(*) INTO x FROM CLASES WHERE COD=cod2;
	--Salta la excepción si ya existe una clase con esa clave primaria
	IF(x=1) THEN
		RAISE Excep1; --lanza la excepcion
	END IF;
	DBMS_OUTPUT.PUT_LINE( 'SE VA A INSERTAR UNA CLASE' );
	INSERT INTO clases VALUES(cod2, nombre, ingresos);
	DBMS_OUTPUT.PUT_LINE( 'CLASE INSERTADA' );
	EXCEPTION --captura la excepcion	
		WHEN Excep1 THEN DBMS_OUTPUT.PUT_LINE( 'InsertarClases2 - Ya existe una clase con ese codigo.' );
END;
---------------------------------------------------------------------------------

PROCEDURE ModificarClases2(cod2 NUMBER, nombre2 VARCHAR2, ingresos2 NUMBER) IS
	Cont NUMBER;
BEGIN
	SELECT COUNT(*) INTO Cont FROM CLASES WHERE COD=cod2;
	IF (Cont=0) THEN
		RAISE_Application_Error( -20000, 'ModificarClases2 - EXCEPCION: No existe la clase.' );
	END IF;
	DBMS_OUTPUT.PUT_LINE( 'SE VA A MODIFICAR UNA CLASE' );
	UPDATE CLASES
	SET NOMBRE = nombre2, INGRESOS=ingresos2
	WHERE COD=cod2;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE( 'SE HA MODIFICADO UNA CLASE' );
	DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
END;
-----------------------------------------------------------------------------------
PROCEDURE ConsultarClases2(cod2 NUMBER, nombre2 OUT VARCHAR2, ingresos2 OUT NUMBER) IS
BEGIN 
	DBMS_OUTPUT.PUT_LINE( 'SE VA A CONSULTAR UNA CLASE' );
	SELECT NOMBRE, INGRESOS INTO nombre2, ingresos2 FROM CLASES where COD=cod2;
	--DBMS_OUTPUT.PUT_LINE( 'Nombre de la clase: ' || nombre2 );
	--DBMS_OUTPUT.PUT_LINE( 'Ingresos: ' || ingresos2 );
	COMMIT;
	DBMS_OUTPUT.PUT_LINE( 'INFORMACION DE LA CLASE ALMACENADA EN LAS VARIABLES');
	EXCEPTION
		WHEN No_Data_Found THEN DBMS_OUTPUT.PUT_LINE( 'ConsultarClases2 - EXCEPTION: La clase no existe.' );
	DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
END;
------------------------------------------------------------------------------------
PROCEDURE BorrarClases2(cod2 NUMBER) IS
aux2 NUMBER;
BEGIN
	SELECT COUNT(*) INTO aux2 FROM CLASES WHERE COD=cod2;
	IF(aux2=0) THEN 
		RAISE_Application_Error( -20000, 'BorrarClases2 - No existe la clase.' );
	END IF;
	DBMS_OUTPUT.PUT_LINE('BORRADO DE LA CLASE');
	DELETE FROM CLASES WHERE COD=cod2;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('CLASE BORRADA');
	DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
END;






/* ----------------------------- */
BEGIN
DBMS_OUTPUT.ENABLE;
--APARTADO A
-- 4.a.1)
InsertarClases(0,'Realeza',0);
VerClases();
-- 4.a.2)
ModificarClases(0,'Desconocido',0);
VerClases();
-- 4.a.3)
ConsultarClases(0,vnombre,vpatrimonio);
dbms_output.put_line('Nombre Clase: ' || vnombre);
dbms_output.put_line('Patrimonio: ' || vpatrimonio);
DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
-- 4.a.4)
BorrarClases(0);
VerClases();
DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );

--EJERCICIOS CON EXCEPCIONES
--APARTADO B
/*
InsertarClases2(0,'Realeza',0);
VerClases();

ModificarClases2(0,'Desconocido',0);
VerClases();

ConsultarClases2(0,vnombre,vpatrimonio);
dbms_output.put_line('Nombre Clase: ' || vnombre);
dbms_output.put_line('Patrimonio: ' || vpatrimonio);
DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );

BorrarClases2();
VerClases();
DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------' );
*/
mensaje := 'Fin de programa';
DBMS_OUTPUT.PUT_LINE(mensaje);
END;