SET SERVEROUTPUT ON
ALTER SESSION SET NLS_TERRITORY = 'SPAIN';
ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

/* ------------------------------------------------------------------------------------ */
/* Crear tablas */

CREATE TABLE personajes_tv (
  ID VARCHAR2(3), 
  nombre VARCHAR2(36),
  fechanac DATE,
  cp VARCHAR2(5),
  sexo VARCHAR2(1),
  patrimonio NUMBER(10,2),
  clase NUMBER(2), 
  tiv DATE,
  tfv DATE,
  tit TIMESTAMP,	/*variable creada*/
  tft TIMESTAMP,	/*variable creada*/
  PRIMARY KEY (ID,tiv,tit)
);
 
/* ------------------------------------------------------------------------------------ */
/* BLOQUE PL/SQL */

DECLARE

  now CONSTANT DATE := '01/01/3000';
  uc CONSTANT DATE := '01/01/3000';

  /* ------------------------------------------------------------------------------------ */

  PROCEDURE ver is
    tupla personajes_tv%ROWTYPE;

    CURSOR cursor_ver_personajes IS 
       SELECT * 
       FROM personajes_tv; 
       --ORDER BY ID, tiv; --probar a ordenar por ID + tiv: todas las tuplas juntas

  BEGIN
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
    OPEN cursor_ver_personajes;
    LOOP
      FETCH cursor_ver_personajes INTO tupla;
      EXIT WHEN cursor_ver_personajes%NOTFOUND;
	  ---------------------------------------------
      IF tupla.tfv=now AND tupla.tft=uc THEN
        DBMS_OUTPUT.PUT_LINE(rpad(cursor_ver_personajes%ROWCOUNT,3,' ')||'  '||tupla.ID||'  '||rpad(tupla.nombre,36,' ')||'  '||rpad(tupla.patrimonio,5,' ')||'  '||tupla.clase||'  '||rpad(tupla.tiv,20,' ')||rpad('  NOW',20,' ')||'  '||rpad(tupla.tit,20,' ')||'  UC');
      ELSIF tupla.tfv=now THEN
		DBMS_OUTPUT.PUT_LINE(rpad(cursor_ver_personajes%ROWCOUNT,3,' ')||'  '||tupla.ID||'  '||rpad(tupla.nombre,36,' ')||'  '||rpad(tupla.patrimonio,5,' ')||'  '||tupla.clase||'  '||rpad(tupla.tiv,20,' ')||rpad('  NOW',20,' ')||'  '||rpad(tupla.tit,20,' ')||' '||rpad(tupla.tft,20,' '));
		ELSIF tupla.tft=uc THEN
		DBMS_OUTPUT.PUT_LINE(rpad(cursor_ver_personajes%ROWCOUNT,3,' ')||'  '||tupla.ID||'  '||rpad(tupla.nombre,36,' ')||'  '||rpad(tupla.patrimonio,5,' ')||'  '||tupla.clase||'  '||rpad(tupla.tiv,20,' ')||'  '||rpad(tupla.tfv,20,' ')||rpad(tupla.tit,20,' ')||'  UC ');
		ELSE
			DBMS_OUTPUT.PUT_LINE(rpad(cursor_ver_personajes%ROWCOUNT,3,' ')||'  '||tupla.ID||'  '||rpad(tupla.nombre,36,' ')||'  '||rpad(tupla.patrimonio,5,' ')||'  '||tupla.clase||'  '||rpad(tupla.tiv,20,' ')||'  '||rpad(tupla.tfv,20,' ')||'  '||rpad(tupla.tit,20,' ')||' '||rpad(tupla.tft,20,' '));

      END IF;

	  -------------------------------------------
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('personajes mostrados: '||cursor_ver_personajes%ROWCOUNT); 
    CLOSE cursor_ver_personajes;
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------');
  END ver;
 
  /* ------------------------------------------------------------------------------------ */

  PROCEDURE insertar (pID IN VARCHAR2, pnombre IN VARCHAR2, pfechanac IN DATE, pcp IN VARCHAR2, psexo IN VARCHAR2, ppatrimonio IN NUMBER, pclase IN NUMBER, ptiv IN DATE, ptit IN TIMESTAMP) is
  BEGIN
    -- Se insertan los parámetros, con tfv como now
    INSERT INTO personajes_tv
    VALUES (insertar.pID, insertar.pnombre, insertar.pfechanac, insertar.pcp, insertar.psexo, insertar.ppatrimonio, insertar.pclase, insertar.ptiv, now, insertar.ptit, uc);
    DBMS_OUTPUT.PUT_LINE('INSERTADO: ' || insertar.pID||'-'||pnombre||'-'||pclase||'-'||ppatrimonio||'-'||ptiv||'-NOW'||'-'||ptit||'-UC'); 
  END insertar;

  /* ------------------------------------------------------------------------------------ */

  PROCEDURE modificar (pID IN VARCHAR2, pnombre IN VARCHAR2, pfechanac IN DATE, pcp IN VARCHAR2, psexo IN VARCHAR2, ppatrimonio IN NUMBER, pclase IN NUMBER, pfecha IN DATE, pfecha2 IN TIMESTAMP) is
 
 --Variables auxiliares para hacer la copia v2
 auxID personajes_tv.ID%TYPE;
 auxNombre personajes_tv.nombre%TYPE;
 auxFechanac personajes_tv.fechanac%TYPE;
 auxCp personajes_tv.cp%TYPE;
 auxSexo personajes_tv.sexo%TYPE;
 auxPatrimonio personajes_tv.patrimonio%TYPE;
 auxClase personajes_tv.clase%TYPE;
 auxTiv personajes_tv.tiv%TYPE;
 auxTfv personajes_tv.tfv%TYPE;
 auxTit personajes_tv.tit%TYPE;
 auxTft personajes_tv.tft%TYPE;
 
 
  BEGIN  
  
  --Copia de la tupla que vamos a versionar (V2):
  
  SELECT ID,nombre,fechanac,cp,sexo, patrimonio, clase, tiv, tfv, tit, tft INTO auxID,auxNombre,auxFechanac,auxCp,auxSexo, auxPatrimonio, auxClase, auxTiv, auxTfv, auxTit, auxTft
    FROM personajes_tv
    WHERE ID=pID and tfv=now and tft=uc;
  
  --Inserción de V2:
  INSERT INTO personajes_tv
  VALUES (auxID, auxNombre, auxFechanac, auxCp, auxSexo, auxPatrimonio, auxClase, auxTiv, pfecha-1, pfecha2, auxTft);
  
  --Paso2:
  INSERT INTO personajes_tv
  VALUES (pID, pnombre, pfechanac, pcp, psexo, ppatrimonio, pclase, pfecha, now, pfecha2, uc);

  --Paso3:
  UPDATE personajes_tv
  SET tft=pfecha2
  WHERE ID=pID AND tit=auxTit AND tfv=now;
  


    DBMS_OUTPUT.PUT_LINE('MODIFICADO: ' || modificar.pnombre);
  END modificar;

  /* ------------------------------------------------------------------------------------ */

  PROCEDURE borrar (pID IN VARCHAR2, ptfv IN DATE, ptft IN TIMESTAMP) is	
   --Variables auxiliares para hacer la copia
 auxID personajes_tv.ID%TYPE;
 auxNombre personajes_tv.nombre%TYPE;
 auxFechanac personajes_tv.fechanac%TYPE;
 auxCp personajes_tv.cp%TYPE;
 auxSexo personajes_tv.sexo%TYPE;
 auxPatrimonio personajes_tv.patrimonio%TYPE;
 auxClase personajes_tv.clase%TYPE;
 auxTiv personajes_tv.tiv%TYPE;
 auxTfv personajes_tv.tfv%TYPE;
 auxTit personajes_tv.tit%TYPE;
 auxTft personajes_tv.tft%TYPE;
 
 
  BEGIN  
  
  --Copia de la tupla que vamos a versionar (V2):
  
  SELECT ID,nombre,fechanac,cp,sexo, patrimonio, clase, tiv, tfv, tit, tft INTO auxID,auxNombre,auxFechanac,auxCp,auxSexo, auxPatrimonio, auxClase, auxTiv, auxTfv, auxTit, auxTft
    FROM personajes_tv
    WHERE ID=pID and tfv=now and tft=uc;
	
	
    -- Cerrar la tupla
    UPDATE personajes_tv
    SET tft=ptft
    WHERE ID=borrar.pID AND tfv=now;
	
	INSERT INTO personajes_tv
	VALUES(auxID,auxNombre,auxFechanac,auxCp,auxSexo, auxPatrimonio, auxClase, auxTiv, ptfv, ptft, auxTft);
	
    DBMS_OUTPUT.PUT_LINE('BORRADO: ' || pID); 
  END borrar;


/* ------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------ */
/* ------------------------------------------------------------------------------------ */

BEGIN  /* Programa principal */

  dbms_output.enable;

  DELETE FROM personajes_tv;

  /* Insertar */ 
insertar('123','Calixto Pérez','15/11/1757','06300','H',150,4,'15/02/1775','07/02/2015 08:12:43');
insertar('777','Gervasio Romualdo','12/12/1721','06002','H',230,4,'24/09/1742','15/09/1982 10:10:42');
insertar('222','Prudencio González','01/02/1720','06300','H',220,4,'30/01/1743', '07/02/2013 11:43:53');
insertar('333','Macaria Gil','10/04/1731','06400','M',195,4,'28/03/1751', '25/03/2001 17:52:27');
insertar('666','Honorio Marín','12/12/1742','10005','H',370,4,'30/11/1760','07/12/2016 08:00:12');
insertar('555','Venancio Fernández','15/11/1738','10600','H',4600,3,'25/07/1752', '25/07/1998 12:42:59');
insertar('696','Balbina Sánchez','12/04/1734','06400','M',5000,3,'12/12/1755', '07/12/2015 08:32:49');
insertar('888','Faustino Martínez','30/05/1731','06002','H',7000,3,'26/01/1750', '03/02/2017 18:39:38');
insertar('999','Facundo Fernández','12/03/1739','10800','H',6300,3,'13/04/1758', '13/04/2014 13:23:40');
insertar('444','Pandulfa Ruiz','01/02/1750','06800','M',2500,3,'15/11/1773', '23/11/2013 07:56:39');
insertar('987','Eduviges Pozo','10/05/1734','10005','M',40000,2,'26/06/1755', '15/06/2016 20:53:28');
insertar('234','Abundio Hernández','01/07/1749','06800','H',25000,2,'31/03/1769', '10/06/2015 09:53:50');
insertar('345','Salustiana Moreno','07/04/1733','10300','M',40000,2,'23/11/1755', '31/07/2012 14:35:38');
insertar('567','Camelia Cortés','12/05/1736','10600','M',48000,2,'04/05/1766', '15/12/2013 15:19:17');
insertar('789','Sagrario Méndez','22/06/1759','10800','M',18000,2,'02/12/1780', '15/08/2017 09:46:59');
insertar('901','Amable Montero','07/04/1760','10300','H',140000,1,'12/12/1780', '15/10/2017 15:00:00');
insertar('012','Martiniano Zarzal','23/11/1736','10005','H',360000,1,'26/02/1754', '02/09/2016 09:10:52');
insertar('876','Mederica Campos','19/03/1734','06800','M',500000,1,'28/10/1755', '02/12/2010 11:12:13');
insertar('321','Filiberto Torres','08/08/1748','06002','H',250000,1,'25/03/1768', '15/06/2015 23:59:59');
insertar('221','Obdulia Candil','08/08/1737','10005','M',502000,1,'18/09/1777', '02/12/2010 11:12:13');
  
  ver();

  /* Modificar */
  -- Calixto cambia a clase 2-Clero e incrementa patrimonio
  modificar('123','Calixto Pérez','15/11/1757','06300','H',20000,2,'10/09/1782', '15/04/2017 23:02:47');
  ver();
  -- Macaria cambia a clase 3-Artesanos e incrementa patrimonio
  modificar('333','Macaria Gil','10/04/1731','06400','M',5500,3,'05/03/1757', '15/05/2014 09:37:40');
  ver();
  -- Macaria incrementa patrimonio
  modificar('333','Macaria Gil','10/04/1731','06400','M',6000,3,'01/01/1762', '23/12/2016 04:26:53');
  ver();

  /* Borrar */
  borrar('222','04/09/1749', '15/06/2017 07:32:56'); /* Prudencio */
  ver();

END; /* Programa principal */

/
SELECT * FROM personajes_tv;


--Consultas

--Mostrar las personas que hayan estado trabajando desde el 1 de enero de 1775 en adelante (pueden seguir trabajando o no)
SELECT *
FROM personajes_tv
WHERE (tiv>='01/01/1775' AND tfv<='01/01/3000');


--Personas que hayan trabajando en 1750
SELECT *
FROM personajes_tv
WHERE ((tiv,tfv) overlaps
(to_date('01/01/1750'),to_date('31/12/1750')));

/* ------------------------------------------------------------------------------------ */
/* Borrar tablas */

DROP TABLE personajes_tv;