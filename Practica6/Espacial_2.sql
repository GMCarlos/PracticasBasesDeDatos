SET SERVEROUTPUT ON

/* ------------------------------------------------------------------------------------ */
-- Crear tabla
CREATE TABLE Extremadura (
  Cod NUMBER PRIMARY KEY,
  Nombre VARCHAR2(32),
  Tipo VARCHAR2(32),
  Geom SDO_GEOMETRY
);

-- Crear secuencia
CREATE SEQUENCE numGeom INCREMENT BY 1 START WITH 1 ORDER;

-- Crear capa Extremadura
INSERT INTO USER_SDO_GEOM_METADATA VALUES (
  'Extremadura',
  'Geom',
  SDO_DIM_ARRAY(
    SDO_DIM_ELEMENT('X', -20, 20, 0.005),
    SDO_DIM_ELEMENT('Y', -20, 20, 0.005)
  ),
  NULL
);

-- Insertar localidades
INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Alcántara',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-3,4,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Badajoz',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-3,1,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Castuera',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(3,-2,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Coria',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-1.5,4.5,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Cáceres',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-1,2,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'DonBenito',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(1,-1,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Hervás',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(1.5,6.5,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Miajadas',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(1,0,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Moraleja',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-2,5,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Mérida',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-1,-1,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Navalmoral',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(2,5,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Olivenza',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-4,-2,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Plasencia',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(0,5,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Trujillo',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(1,2,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'ValenciaAlcántara',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-4,2,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Villanueva',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(1.5,-1,NULL),
    NULL,
    NULL
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Zafra',
  'Localidad',
  SDO_GEOMETRY(
    2001,
    NULL,
    SDO_POINT_TYPE(-1,-3,NULL),
    NULL,
    NULL
  )
);

-- Insertar autovías
INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'A66',
  'Autovía',
  SDO_GEOMETRY(
    2006,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,2,1),
    SDO_ORDINATE_ARRAY(-1,3.5,-1,-3,-1,-1,-1,2,0,5,1,7)
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'A5',
  'Autovía',
  SDO_GEOMETRY(
    2006,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,2,1),
    SDO_ORDINATE_ARRAY(2,5,1,2,1,0,-1,-1,-3,-1)
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'EXA1',
  'Autovía',
  SDO_GEOMETRY(
    2006,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,2,1),
    SDO_ORDINATE_ARRAY(2,5,0,5,-1.5,4.5)
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'A58',
  'Autovía',
  SDO_GEOMETRY(
    2006,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,2,1),
    SDO_ORDINATE_ARRAY(1,2,-1,2)
  )
);

-- Insertar embalses
INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'EAlcántara',
  'Embalse',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(-2.5,4,-2.5,3,-0.5,4,-2.5,4)
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'EOrellana',
  'Embalse',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(3,-1,3,0,5,1,4,-1,3,-1)
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'ESerena',
  'Embalse',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(3,-1.5,6,-1,6,-2,3,-1.5)
  )
);

-- Insertar zonas turísticas
INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Zona1',
  'Turismo',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(-3.5,4,2,7,0,3.5,-3.5,4)
  )
);

INSERT INTO Extremadura VALUES(
  numGeom.nextval,
  'Zona2',
  'Turismo',
  SDO_GEOMETRY(
    2003,
    NULL,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(-1.5,3,-1.5,-2,3,3,-1.5,3)
  )
);

/* ------------------------------------------------------------------------------------ */
/* BLOQUE PL/SQL */

DECLARE


  PROCEDURE locAutovia (pnombre IN VARCHAR2) IS
    geomEntrada SDO_GEOMETRY;
    dim SDO_DIM_ARRAY;
    dist NUMBER;
    tupla Extremadura%ROWTYPE;
    -- Cursor para recuperar las localidades	
    CURSOR distancia IS 
      SELECT *
      FROM Extremadura
	  WHERE tipo='Localidad';
		
  BEGIN
    -- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada
    FROM Extremadura
    WHERE Nombre = pnombre;

    -- Obtener dim
    SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='EXTREMADURA'; --Ojo, EXTREMADURA en mayúsculas

    DBMS_OUTPUT.ENABLE;
	-- Recorrer todas las tuplas localidades
    OPEN distancia;
    LOOP
      FETCH distancia INTO tupla;
      EXIT WHEN distancia%NOTFOUND;
      IF tupla.Geom.SDO_GTYPE = 2001 THEN
        dist:=SDO_GEOM.SDO_DISTANCE(geomEntrada,dim,tupla.Geom,dim);
        IF dist = 0 THEN
          DBMS_OUTPUT.PUT_LINE('La autovía '|| pnombre ||' pasa por '|| tupla.Nombre);
        END IF;
      END IF;
    END LOOP;
	CLOSE distancia;
	
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
  END locAutovia;

/* ------------------------------------------------------------------------------------ */

  PROCEDURE radio (pnombre IN VARCHAR2, distUmbral IN NUMBER) IS
    geomEntrada SDO_GEOMETRY;
    dim SDO_DIM_ARRAY;
    dist NUMBER;
    tupla Extremadura%ROWTYPE;
    -- Cursor para recuperar las localidades
    CURSOR cursor_radio IS 
      SELECT *
      FROM Extremadura
	  WHERE tipo='Localidad';

  BEGIN
    -- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada
    FROM Extremadura
    WHERE Nombre = pnombre;
	
	-- Obtener dim	
    SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='EXTREMADURA'; --Ojo, EXTREMADURA en mayúsculas

    DBMS_OUTPUT.PUT_LINE('Las localidades contenidas en un radio '||distUmbral||' a la localidad '||pnombre||' son:');

	-- Recorrer todas las tuplas localidades
    OPEN cursor_radio;
    LOOP
      FETCH cursor_radio INTO tupla;
      EXIT WHEN cursor_radio%NOTFOUND;
      IF tupla.Nombre != pnombre THEN
        dist:=SDO_GEOM.SDO_DISTANCE(geomEntrada,dim,tupla.Geom,dim);
        IF dist < distUmbral AND tupla.Geom.SDO_GTYPE = 2001 THEN
          DBMS_OUTPUT.PUT_LINE(tupla.Nombre||' con distancia: '||dist);
        END IF;
      END IF;
    END LOOP;
	CLOSE cursor_radio;

    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
  END radio;

/* ------------------------------------------------------------------------------------ */
  
 PROCEDURE embalseMasCercano (pnombre IN VARCHAR2) IS
    geomEntrada SDO_GEOMETRY;
    tupla Extremadura%ROWTYPE;
    dim SDO_DIM_ARRAY;
    embalse Extremadura.Nombre%TYPE;
    dist NUMBER;
    distMin NUMBER;

    CURSOR cursor_embalse IS 
      SELECT *
      FROM Extremadura
      WHERE Tipo = 'Embalse';

  BEGIN
    distMin := 9999;
	
	-- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada
    FROM Extremadura
    WHERE Nombre = pnombre;
	
	-- Obtener dim	
	SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='EXTREMADURA'; --Ojo, EXTREMADURA en mayúsculas

    -- Recorrer todas las tuplas embalses
    OPEN cursor_embalse;
    LOOP
      FETCH cursor_embalse INTO tupla;
      EXIT WHEN cursor_embalse%NOTFOUND;
      dist := SDO_GEOM.SDO_DISTANCE(geomEntrada,dim,tupla.Geom,dim);
      IF dist < distMin THEN
        distMin := dist;
        embalse := tupla.Nombre;
      END IF;
    END LOOP;
	CLOSE cursor_embalse;

    DBMS_OUTPUT.PUT_LINE('El embalse más cercano a la localidad de '||pnombre||' es '||embalse||' con distancia '||distMin);
  END embalseMasCercano;
 
/* ------------------------------------------------------------------------------------ */

  PROCEDURE embalseMasGrande IS
    superficie NUMBER;
    superAux NUMBER;
    tupla Extremadura%ROWTYPE;
    dim SDO_DIM_ARRAY;
    mayorEmbalse Extremadura.Nombre%TYPE;

    CURSOR cursor_masSuperf IS 
      SELECT *
      FROM Extremadura
      WHERE Tipo = 'Embalse';

  BEGIN
    superficie := 0;

	-- Obtener dim	
    SELECT DIMINFO INTO dim
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='EXTREMADURA'; --Ojo, EXTREMADURA en mayúsculas
    
    OPEN cursor_masSuperf;
    LOOP
      FETCH cursor_masSuperf INTO tupla;
      EXIT WHEN cursor_masSuperf%NOTFOUND;
      superAux := SDO_GEOM.SDO_AREA(tupla.Geom,dim);
      IF superficie < superAux THEN
        superficie := superAux;
        mayorEmbalse := tupla.Nombre;
      END IF;
    END LOOP;
	CLOSE cursor_masSuperf;

    DBMS_OUTPUT.PUT_LINE('El embalse más grande es '||mayorEmbalse||' con area '||superficie);
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
  END embalseMasGrande;

  
  ----------------------------------------
  --APARTADO A--
  --Procedimiento 1--
  --Muestra el perimetro de todos los embalses
    PROCEDURE perimetroEmbalse IS
	perimetro NUMBER;
    tupla Extremadura%ROWTYPE;
    dim SDO_DIM_ARRAY;
    -- Cursor para recuperar los embalses
    CURSOR cursor_Embalses IS 
      SELECT *
      FROM Extremadura
      WHERE Tipo = 'Embalse';
	   
  BEGIN
  
	DBMS_OUTPUT.PUT_LINE('Procedimiento 1');
	
	SELECT DIMINFO INTO dim
	FROM USER_SDO_GEOM_METADATA
	WHERE table_name='EXTREMADURA';
	
	OPEN cursor_Embalses;
	LOOP
		FETCH cursor_Embalses INTO tupla;
		EXIT WHEN cursor_Embalses%NOTFOUND;
					
			perimetro:=SDO_GEOM.SDO_LENGTH(tupla.Geom,dim);
			DBMS_OUTPUT.PUT_LINE('El perimetro del embalse   '||tupla.Nombre||' es de '||perimetro);
	END LOOP;
	CLOSE cursor_Embalses;
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
  END perimetroEmbalse;
  
  --Procedimiento 2--
  --Devuelve la distancia entre  una localidad y un embalse
  PROCEDURE distanciaLocalidadEmbalse(pLocalidad IN VARCHAR2, pEmbalse IN VARCHAR2) IS
	geomEntrada1 SDO_GEOMETRY;
	geomEntrada2 SDO_GEOMETRY;
	puntosLocalidad SDO_GEOMETRY;
	puntosEmbalse SDO_GEOMETRY;
    dim1 SDO_DIM_ARRAY;
	distancia NUMBER;
	
	
	BEGIN
	DBMS_OUTPUT.PUT_LINE('Procedimiento 2');
	
	-- Obtener dim	
    SELECT DIMINFO INTO dim1 
    FROM USER_SDO_GEOM_METADATA
    WHERE table_name='EXTREMADURA'; --Ojo, EXTREMADURA en mayúsculas
	
	SELECT Geom INTO geomEntrada1
	FROM Extremadura
	WHERE Nombre = pLocalidad AND Tipo='Localidad';

	SELECT Geom INTO geomEntrada2
	FROM Extremadura
	WHERE Nombre = pEmbalse AND Tipo='Embalse';	
	
	--Almaceno los puntos de la localidad
	puntosLocalidad:=SDO_GEOM.SDO_CENTROID(geomEntrada1, dim1);
	--Almaceno los puntos del embalse	
	puntosEmbalse:=SDO_GEOM.SDO_CENTROID(geomEntrada2, dim1);
	
	distancia:=SDO_GEOM.SDO_DISTANCE(puntosLocalidad, dim1, puntosEmbalse, dim1);
	
	DBMS_OUTPUT.PUT_LINE('La distancia entre la localidad '||pLocalidad||' y el embalse '||pEmbalse||' es de '||distancia);
	
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
   END distanciaLocalidadEmbalse;

	
	
    --Procedimiento 3--
  --Método que me devuelve la interseccion entre una zona turistica y un embalse en caso de que la haya 
  PROCEDURE intZonaTurEmb(pTurismo IN VARCHAR2, pEmbalse IN VARCHAR2) IS
 	geomEntrada1 SDO_GEOMETRY;
	geomEntrada2 SDO_GEOMETRY;
	geomSalida3 SDO_GEOMETRY;
	dim SDO_DIM_ARRAY;
	
  
  
  
  BEGIN
  
  DBMS_OUTPUT.PUT_LINE('Procedimiento 3');
  -- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada1
    FROM Extremadura
    WHERE Nombre = pTurismo AND Tipo='Turismo';
	
	-- Recuperar la geometria del parametro de entrada
    SELECT Geom INTO geomEntrada2
    FROM Extremadura
    WHERE Nombre = pEmbalse AND Tipo='Embalse';
	
	SELECT DIMINFO INTO dim
	FROM USER_SDO_GEOM_METADATA
	WHERE table_name='EXTREMADURA';
  
	geomSalida3:= SDO_GEOM.SDO_INTERSECTION(geomEntrada1, dim, geomEntrada2, dim);
	
	
	--si tiene intersección, la muestro
	IF geomSalida3 IS NOT NULL THEN
		DBMS_OUTPUT.PUT_LINE('Existe interseccion entre '|| pTurismo||' y '||pEmbalse||'.');
	--sino tiene intersección, lo muestro por pantalla
	ELSE
		DBMS_OUTPUT.PUT_LINE('No existe intersección entre las dos geometrías');
	END IF;
	
	
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
	
  
  END intZonaTurEmb;
/* ------------------------------------------------------------------------------------ */
	
BEGIN
  DBMS_OUTPUT.ENABLE;
  
  locAutovia('A66');
  locAutovia('A5');
  radio('Badajoz',3);
  radio('Badajoz',5);
  radio('Cáceres',3);
  radio('Cáceres',5);
  embalseMasCercano('Cáceres');
  embalseMasCercano('Badajoz');
  embalseMasCercano('Mérida');
  embalseMasGrande();
  perimetroEmbalse();
  distanciaLocalidadEmbalse('Alcántara','EOrellana');
  intZonaTurEmb('Zona1', 'EAlcántara');
END;

/

/* Borrado */

DROP TABLE Extremadura;
DROP SEQUENCE numGeom;
DELETE FROM USER_SDO_GEOM_METADATA m;