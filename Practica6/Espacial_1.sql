SET SERVEROUTPUT ON

/* ------------------------------------------------------------------------------------ */

-- Crear tabla 
CREATE TABLE Caceres (
  Cod NUMBER PRIMARY KEY,
  Nombre VARCHAR2(32),
  Tipo VARCHAR2(32),
  Geom SDO_GEOMETRY
);

-- Crear secuencia
CREATE SEQUENCE numGeom INCREMENT BY 1 START WITH 1 ORDER;

-- Crear capa Caceres
INSERT INTO USER_SDO_GEOM_METADATA VALUES (
  'Caceres',
  'Geom',
  SDO_DIM_ARRAY(
    SDO_DIM_ELEMENT('X', -10, 10, 0.005),
    SDO_DIM_ELEMENT('Y', -10, 10, 0.005)
  ),
  NULL
);

--Insertar farolas
INSERT INTO Caceres VALUES(
numGeom.nextval,
'Farola1',
'Luz',
SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-4,5,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Caceres VALUES(
numGeom.nextval,
'Farola2',
'Luz',
SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(3,0,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Caceres VALUES(
numGeom.nextval,
'Farola3',
'Luz',
SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(6,5,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Caceres VALUES(
numGeom.nextval,
'Farola4',
'Luz',
SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(3,-1,NULL),
    NULL,
    NULL
  )
);
-- Insertar personas
INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'Andr�s',
  'Persona',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(6,5,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'Marta',
  'Persona',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(3,-1,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'Sergio',
  'Persona',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-3,7,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'Eva',
  'Persona',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(1,1,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'Luc�a',
  'Persona',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-2,3,NULL),
    NULL,
    NULL
  )
);

-- Insertar barrios
INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'Parque del Pr�ncipe',
  'Barrio',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(-2,9,-4,8,-6,6,-6,4,-2,4,-2,7,-1,8,-2,9)
  )
);

INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'C�novas',
  'Barrio',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(0,1,1,0,3,2,2,3,0,1)
  )
);

INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'Parte Antigua',
  'Barrio',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(3,4,3,5,4,5,4,7,5,8,7,8,8,6,7,4,6,3,4,3,4,4,3,4)
  )
);

INSERT INTO Caceres VALUES(
  numGeom.nextval,
  'Parque El Rodeo',
  'Barrio',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(0,-2,4,0,8,-2,0,-2)
  )
);

/* ------------------------------------------------------------------------------------ */
/* BLOQUE PL/SQL */

DECLARE

  PROCEDURE amigoMasCercano(pnombre IN VARCHAR2) IS
    geomEntrada SDO_GEOMETRY;
    dist NUMBER;
    distMin NUMBER;
    tupla Caceres%ROWTYPE;
    dim SDO_DIM_ARRAY;
    nomAmigo caceres.Nombre%TYPE;
    -- Cursor para recuperar los barrios
    CURSOR cursor_barrio IS 
      SELECT *
      FROM caceres
      WHERE tipo = 'Persona';
	   
  BEGIN
    distMin := 9999;

    -- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada
    FROM Caceres
    WHERE Nombre = pnombre;

    -- Obtener dim
	SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='CACERES'; --Ojo, CACERES en may�sculas

    -- Recorrer todos los barrios
    OPEN cursor_barrio;
    LOOP
      FETCH cursor_barrio INTO tupla;
      EXIT WHEN cursor_barrio%NOTFOUND;
      dist := SDO_GEOM.SDO_DISTANCE(geomEntrada,dim,tupla.Geom,dim);
      IF (dist < distMin) and (tupla.Nombre <> pnombre) THEN
        distMin := dist;
        nomAmigo := tupla.Nombre;
      END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('El amigo m�s cercano a '||pnombre||' es '||nomAmigo||', a una distancia de '||distMin);
  END amigoMasCercano;

/* ------------------------------------------------------------------------------------ */
	
  PROCEDURE barrioMasCercano(pnombre IN VARCHAR2) IS
    geomEntrada SDO_GEOMETRY;
    dist NUMBER;
    distMin NUMBER;
    tupla caceres%ROWTYPE;
    dim SDO_DIM_ARRAY;
    nomBarrio caceres.Nombre%TYPE;
    -- Cursor para recuperar los barrios
    CURSOR cursor_barrio IS 
      SELECT *
      FROM caceres
      WHERE tipo = 'Barrio';
	   
  BEGIN
    distMin := 9999;

    -- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada
    FROM Caceres
    WHERE Nombre = pnombre;

    -- Obtener dim
	SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='CACERES'; --Ojo, CACERES en may�sculas

    -- Recorrer todos los barrios
    OPEN cursor_barrio;
    LOOP
      FETCH cursor_barrio INTO tupla;
      EXIT WHEN cursor_barrio%NOTFOUND;
      dist := SDO_GEOM.SDO_DISTANCE(geomEntrada,dim,tupla.Geom,dim);
      IF dist < distMin THEN
        distMin := dist;
        nomBarrio := tupla.Nombre;
      END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('El barrio m�s cercano a '||pnombre||' es '||nomBarrio||', a una distancia de '||distMin);
  END barrioMasCercano;

/* ------------------------------------------------------------------------------------ */
  PROCEDURE farolaMasCercana(pnombre IN VARCHAR2) IS
    geomEntrada SDO_GEOMETRY;
    dist NUMBER;
    distMin NUMBER;
    tupla Caceres%ROWTYPE;
    dim SDO_DIM_ARRAY;
    nomFarola caceres.Nombre%TYPE;
    -- Cursor para recuperar las farolas
    CURSOR cursor_farola IS 
      SELECT *
      FROM caceres
      WHERE tipo = 'Luz';
	   
  BEGIN
  DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
    distMin := 9999;

    -- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada
    FROM Caceres
    WHERE Nombre = pnombre;

    -- Obtener dim
	SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='CACERES'; --Ojo, CACERES en may�sculas

    -- Recorrer todos las farolas
    OPEN cursor_farola;
    LOOP
      FETCH cursor_farola INTO tupla;
      EXIT WHEN cursor_farola%NOTFOUND;
      dist := SDO_GEOM.SDO_DISTANCE(geomEntrada,dim,tupla.Geom,dim);
      IF (dist < distMin) and (tupla.Nombre <> pnombre) THEN
        distMin := dist;
        nomFarola := tupla.Nombre;
      END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('La farola m�s cercana a '||pnombre||' es '||nomFarola||', a una distancia de '||distMin);
	IF distMin<5.0 THEN
		DBMS_OUTPUT.PUT_LINE('Tienes luz suficiente para seguir tu camino.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('�Esc�ndete de los posibles vampiros de la noche!');
	END IF;
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
  END farolaMasCercana;
	
  PROCEDURE enQueBarrio(pnombre IN VARCHAR2) IS
    geomEntrada SDO_GEOMETRY;
    tupla caceres%ROWTYPE;
    dim SDO_DIM_ARRAY;
    -- Cursor para recuperar los barrios
    CURSOR cursor_barrio IS 
      SELECT *
      FROM caceres
      WHERE tipo = 'Barrio';
	   
  BEGIN
    
    -- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada
    FROM Caceres
    WHERE Nombre = pnombre;

    -- Obtener dim
	SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='CACERES'; --Ojo, CACERES en may�sculas

    -- Recorrer todos los barrios
    OPEN cursor_barrio;
    LOOP
      FETCH cursor_barrio INTO tupla;
      EXIT WHEN cursor_barrio%NOTFOUND;
      IF (SDO_GEOM.RELATE(tupla.Geom,dim,'anyinteract',geomEntrada,dim)='TRUE') THEN
    	DBMS_OUTPUT.PUT_LINE(pnombre||' est� en '||tupla.Nombre);
	  ELSE
        DBMS_OUTPUT.PUT_LINE(pnombre||' NO est� en '||tupla.Nombre);
	  END IF;
    END LOOP;

  END enQueBarrio;

   PROCEDURE farolasPorBarrio(pnombre IN VARCHAR2) IS
    geomEntrada SDO_GEOMETRY;
    tupla caceres%ROWTYPE;
    dim SDO_DIM_ARRAY;
	farolas NUMBER;
    -- Cursor para recuperar las farolas
    CURSOR cursor_farola IS 
      SELECT *
      FROM caceres
      WHERE tipo = 'Luz';
	   
  BEGIN
    farolas:=0;
    -- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada
    FROM Caceres
    WHERE Nombre = pnombre AND tipo = 'Barrio';

    -- Obtener dim
	SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='CACERES'; --Ojo, CACERES en may�sculas

    -- Recorrer todos los barrios
    OPEN cursor_farola;
    LOOP
      FETCH cursor_farola INTO tupla;
      EXIT WHEN cursor_farola%NOTFOUND;
	  --si hay interaccion entre ambas
      IF (SDO_GEOM.RELATE(geomEntrada,dim,'anyinteract',tupla.Geom,dim)='TRUE') THEN
		farolas:= farolas + 1;
	  END IF;
    END LOOP;

	DBMS_OUTPUT.PUT_LINE('El n�mero de farolas en el '||pnombre||' es de '||farolas||'.');
  END farolasPorBarrio;
  
  
BEGIN

  DBMS_OUTPUT.ENABLE;
  
  amigoMasCercano('Andr�s');
  amigoMasCercano('Eva');
  amigoMasCercano('Luc�a');
  
  barrioMasCercano('Andr�s');
  barrioMasCercano('Eva');
  barrioMasCercano('Luc�a');
  
  farolaMasCercana('Andr�s');
  farolaMasCercana('Eva');
  farolaMasCercana('Luc�a');

  -- Modificar Andr�s a C�novas */
  UPDATE Caceres
  SET Geom = SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(2,2,NULL),
    NULL,
    NULL
  )
  WHERE Nombre = 'Andr�s';

  amigoMasCercano('Andr�s');
  barrioMasCercano('Andr�s');
  
  enQueBarrio('Andr�s');
  enQueBarrio('Marta');
  
  farolasPorBarrio('Parque del Pr�ncipe');
  farolasPorBarrio('C�novas');
  farolasPorBarrio('Parte Antigua');
  farolasPorBarrio('Parque El Rodeo');
  
  
  
  
END;

/

/* Borrado */

DROP TABLE caceres;
DROP SEQUENCE numGeom;
DELETE FROM USER_SDO_GEOM_METADATA m;