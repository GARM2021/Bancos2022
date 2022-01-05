*** ActiveX Control Event ***
*CLOSE all

CLEAR
*IF 1=2
?TIME()
*207.248.62.188
*192.10.228.10
		strconn="Driver=SQL Server;Server=192.10.228.10;Database=gpe2022;UID=sa;PWD=Gu4d4Lup317"
*	
*		MESSAGEBOX(strconn)
		PUBLIC co,w,wgpe
		co=SQLStringConnect(strconn)
		IF co>0
*			MESSAGEBOX("Si se conecto")
			ELSE 
			MESSAGEBOX("Fallo la Conexion a la BD gpe2019...")
			return
		ENDIF

w=co
wgpe=co
?sqlsetpro(co,"dispwarnings",.t.)
*endif
SET SAFETY OFF
waniofac='2022'
wanioc=waniofac

*se modifica la fecha de validacion* (aaaa/mm/dd)
**************************
wfvalban=DATE(2022,02,01)
**************************
wanio=VAL(wanioc)	
wanioc=waniofac
*wmesrec=iif( val(subs(dtos(wfvalban),5,2))=1,'12',allt(str(val(subs(dtos(wfvalban),5,2))-1,2,0)))
*se modifica el mes en ke se aplican los recargos
**************************
wmesrec='1'
*wfecbon=wanioc+RIGHT("00"+ALLTRIM(wmesrec),2)+"11"
**************************
*se modifica la bonificacion
**************************
wfecbon=wanioc+"0105"
************************* *

wanio=VAL(wanioc)
waniorezmv=ALLTRIM(STR(wanio-5,4,0))
wfechaval=dtos(wfvalban)
wfechacorte=wfecbon
wfecvalban=left(dtos(wfvalban),4)+"-"+subs(dtos(wfvalban),5,2)+"-"+subs(dtos(wfvalban),7,2)
wfecvalban2=waniofac+"-"+RIGHT("00"+ALLTRIM(wmesrec),2)+"-04"
*wfecvalban2=waniofac+"-"+"08"+"-01"
*IF 1=2
SQLEXEC(co,"select * from bondbonpred where estatus='0' order by tpocar,fecini ","dbonpred")

SQLEXEC(co,"select * from predmtabrec order by bsyb ","mtabrec")
SQLEXEC(co,"select * from predmtabrec2 order by bsyb ","mtabrec2")
*endif
SELECT * FROM mtabrec WHERE SUBSTR(bsyb,1,6)='06'+waniorezmv INTO CURSOR 'mtabrec2002'
GO top
wpctrec=mtabrec2002.pctrec_&wmesrec
SELECT * FROM mtabrec2 WHERE SUBSTR(bsyb,1,6)='06'+waniorezmv INTO CURSOR 'mtabrec22002'
GO top
wpctrec2=mtabrec22002.pctrec_&wmesrec

?tIME()
*IF 1=2
sqlcommand = "select a.exp,a.tpocar,a.yearbim,a.fechaven,a.salimp,a.salsub,b.bimsem "
sqlcommand = sqlcommand + " from preddadeudos a, preddexped b "
*sqlcommand = sqlcommand + " where (b.marca<='0000' or b.marca>'0011') and a.exp=b.exp  "
sqlcommand = sqlcommand + " where (b.marca<='0000' or b.marca>'0011') and b.marca<>'0012' and b.marca<>'0113' and b.marca<>'0036' and a.exp=b.exp "

sqlcommand = sqlcommand + " and b.fbaja=' ' and a.estatus='0000' "
sqlcommand = sqlcommand + " and tpocar<'0003' and a.salimp>0 and LEFT(rTRIM(LTRIM(b.apat)),9)<>'MUNICIPIO' "
sqlcommand = sqlcommand + " order by a.tpocar,a.yearbim"
SQLEXEC(co,sqlcommand,"dadex")

SQLEXEC(w,"select exp,MAX(freq) as freq from preddrequer group by exp,freq order by exp ","drequer")


SELECT a.*,;
		IIF(ISNULL(b.freq),'19010101',b.freq) as freq ;
		FROM dadex a LEFT JOIN drequer b ON a.exp=b.exp ;
		INTO CURSOR dade

SELECT dadex
USE

?tIME()
SELECT *,IIF(bimsem='06',bimsem+LEFT(yearbim,4)+'04',bimsem+yearbim) as bsyba FROM dade INTO CURSOR dade2
SELECT dade
USE

*endif
?tIME()
SELECT a.*,b.pctrec_&wmesrec as pctrec FROM dade2 a LEFT JOIN mtabrec b on a.bsyba=b.bsyb INTO CURSOR dade2
?tIME()
SELECT a.*,b.pctrec_&wmesrec as pctrec2 FROM dade2 a LEFT JOIN mtabrec2 b on a.bsyba=b.bsyb INTO CURSOR dade2
*brow
?tIME()
SELECT exp,tpocar,yearbim,fechaven,freq,salimp,salsub,bimsem,bsyba,;
	IIF(isnull(pctrec),IIF(tpocar<'0003',wpctrec,000.00),;
	IIF(tpocar<'0003',pctrec,000.00)) as pctrec,;
	IIF(isnull(pctrec2),IIF(tpocar<'0003',wpctrec2,000.00),IIF(tpocar<'0003',pctrec2,000.00)) as pctrec2 FROM dade2 INTO CURSOR dade2
*brow
?tIME()
SELECT exp,tpocar,yearbim,fechaven,freq,salimp,salsub,bimsem,bsyba,pctrec,pctrec2,;
	IIF(tpocar<='0002' and fechaven<=freq,ROUND(salimp,0),iif(tpocar='0001',ROUND(salimp,0),000000000.00)) as sancion,;
	IIF(tpocar<='0002' and fechaven<=freq,round(salimp*.10,2),IIF(tpocar='0001',round(salimp*.10,2),000000000.00)) as gastos ;
	FROM dade2 INTO CURSOR dade2

*!*	SELECT exp,tpocar,yearbim,fechaven,freq,salimp,bimsem,bsyba,pctrec,pctrec2,;
*!*		IIF(tpocar<'0002' ,ROUND(salimp,0),iif(tpocar='0001',ROUND(salimp,0),000000000.00)) as sancion,;
*!*		IIF(tpocar<'0002' ,round(salimp*.10,2),IIF(tpocar='0001',round(salimp*.10,2),000000000.00)) as gastos ;
*!*		FROM dade2 INTO CURSOR dade2

*brow
?tIME()
select * from dbonpred where fecini<= wfecbon and fecfin>=wfecbon and estatus='0' ORDER BY tpocar INTO CURSOR 'dbp'
?tIME()
SELECT * from dbp WHERE tpocar='0003' INTO CURSOR dbp0003
GO top
wpctbongas=dbp0003.pctbonimp
SELECT * from dbp WHERE tpocar='0004' INTO CURSOR dbp0004
GO top
wpctbonsan=dbp0004.pctbonimp

?tIME()

SELECT a.exp,a.tpocar,a.yearbim,a.fechaven,a.freq,a.salimp as impuesto,a.bimsem,a.bsyba,a.salsub,;
		IIF(ISNULL(b.pctbonimp),000.00,b.pctbonimp) as pctbonimp,(((a.salimp)*IIF(ISNULL(b.pctbonimp),000.00,b.pctbonimp)/100)*10 /10) + a.salsub as bonimp,;
		iif(a.fechaven<a.freq,a.pctrec2,a.pctrec) as pctrec,INT((a.salimp*iif(a.fechaven<a.freq,a.pctrec2,a.pctrec)/100)*100)/100 as recargos,;
		IIF(ISNULL(b.pctbonrec),000.00,b.pctbonrec) as pctbonrec,;
		a.sancion,a.gastos,;
		IIF(ISNULL(wpctbongas),000.00,wpctbongas) as pctbongas,IIF(ISNULL(wpctbonsan),000.00,wpctbonsan) as pctbonsan;
		FROM dade2 a LEFT JOIN dbp b ON a.tpocar=b.tpocar ;
		INTO CURSOR dade2


*!*	SELECT a.exp,a.tpocar,a.yearbim,a.fechaven,a.freq,a.salimp as impuesto,a.bimsem,a.bsyba,;
*!*			IIF(ISNULL(b.pctbonimp),000.00,b.pctbonimp) as pctbonimp,INT((a.salimp*IIF(ISNULL(b.pctbonimp),000.00,b.pctbonimp)/100)*10)/10 as bonimp,;
*!*			iif(a.fechaven<'20081231',a.pctrec2,a.pctrec) as pctrec,INT((a.salimp*iif(a.fechaven<'20081231',a.pctrec2,a.pctrec)/100)*10)/10 as recargos,;
*!*			IIF(ISNULL(b.pctbonrec),000.00,b.pctbonrec) as pctbonrec,;
*!*			a.sancion,a.gastos,;
*!*			IIF(ISNULL(wpctbongas),000.00,wpctbongas) as pctbongas,IIF(ISNULL(wpctbonsan),000.00,wpctbonsan) as pctbonsan;
*!*			FROM dade2 a LEFT JOIN dbp b ON a.tpocar=b.tpocar ;
*!*			INTO CURSOR dade2

?tIME()		
SELECT *,INT((recargos*pctbonrec/100)*100)/100 as bonrec,;
		 INT((sancion*pctbonsan/100)*100)/100 as bonsan,;
		 INT((gastos*pctbongas/100)*100)/100 as bongas ;
		 FROM dade2 INTO CURSOR dade2
?tIME()		 

* SELECT *,(impuesto+recargos+sancion+gastos) as neto FROM dade2 INTO CURSOR dade2
SELECT *,(impuesto+recargos+sancion+gastos-bonimp-bonrec-bonsan-bongas) as neto FROM dade2 INTO CURSOR dade2
?tIME()
SELECT exp,MIN(yearbim) as bimrez,SUM(IIF(LEFT(yearbim,4)<wanioc,impuesto,0)) as rezago,SUM(IIF(LEFT(yearbim,4)=wanioc,impuesto,0)) as impuesto, SUM(bonimp) as bonimp,;
           SUM(recargos) as recargos,SUM(bonrec) as bonrec,;
           SUM(sancion) as sancion,SUM(bonsan) as bonsan,;
           SUM(gastos) as gastos,SUM(bongas) as bongas,;
           SUM(neto) as neto  FROM dade2 GROUP BY exp INTO CURSOR totxexp
?tIME()
SELECT '19' as entidad,'28' as mun,LEFT(ALLTRIM(exp),8) as exp,'7777' as concepto,RIGHT(yearbim,1)+LEFT(yearbim,4) as bimanio,;
		RIGHT("00000000000"+ALLTRIM(str(impuesto,14,2)),14) as impuesto,;
		RIGHT("00000000000"+ALLTRIM(str(recargos ,14,2)),14) as recargos,;
		RIGHT("00000000000"+ALLTRIM(str(sancion ,14,2)),14) as sancion,;
		RIGHT("00000000000"+ALLTRIM(str(gastos ,14,2)),14) as gastos,;
		RIGHT("00000000000"+ALLTRIM(str((bonimp+bonrec+bonsan+bongas),14,2)),14)  as bonif ;
		FROM dade2 INTO CURSOR dade3a
		
SELECT * FROM DADE3a ORDER BY EXP,BIMANIO INTO CURSOR DADE3       


*ENDIF
SET SAFETY OFF

?tIME()
SQLEXEC(co,"select exp,valcat,apat,amat,nombre,dompart,colpart,cdpart,domubi,colubi,areater,areaconst,valter,valconst from preddexped where fbaja=' '  order by exp ","dexped")
?tIME()

SELECT * FROM dexped WHERE exp in (SELECT exp FROM totxexp) INTO CURSOR dexped2
?tIME()

SELECT dexped
USE
?tIME()

SELECT '19' as entidad,'28' as mun,LEFT(ALLTRIM(exp),8) as exp,;
	   RIGHT("0000000000000"+ALLTRIM(str(valcat,13,0)),13) as valcat,;
	   LEFT(ALLTRIM(apat)+" "+ALLTRIM(amat)+" "+ALLTRIM(nombre),50) as nom, ;
       LEFT(ALLTRIM(dompart),35) as dompart,"0000000000" as nume,"0000000000" as numi,LEFT(ALLTRIM(colpart),20) as colpart,'00' as pob,'00000' as codpost,;
       LEFT(ALLTRIM(domubi),35) as domubi,"0000000000" as numeu,"0000000000" as numiu,LEFT(ALLTRIM(colubi),20) as colubi,;
       RIGHT("0000000000000"+ALLTRIM(str(areater ,13,2)),13) as areater,RIGHT("000000000000"+ALLTRIM(str(areaconst ,12,0)),12) as areaconst,'0' as periodo FROM dexped2 ORDER BY exp INTO CURSOR dexped3
?tIME()

SELECT dexped3
gcDelimFile = PUTFILE('Archivo de Texto:', "AfirmeDatGen", 'TXT')
IF !EMPTY(gcDelimFile)  && Esc pressed
   COPY TO (gcDelimFile) SDF    && Create delimited file
ENDIF
 *  COPY TO afirmedatgen200901 SDF    && Create delimited file

SELECT dade3
gcDelimFile = PUTFILE('Archivo de Texto:', "AfirmeAdeudos", 'TXT')
IF !EMPTY(gcDelimFile)  && Esc pressed
   COPY TO (gcDelimFile) sdf   && Create delimited file
ENDIF
*COPY TO AfirmeAdeudos200901 sdf   && Create delimited file
*endif
*!*	wtermino="Proceso Terminado"
*!*	?wtermino
*!*	return

?tIME()
wcob=0.00
wejec=0.00
wmulta=0.00
SELECT LEFT(ALLTRIM(a.exp),8) as exp,;
		LEFT(ALLTRIM("Ubicacion:"+ALLTRIM(a.domubi)),40) as ubica,;
		LEFT(ALLTRIM(IIF(LEN(ALLTRIM(a.colubi))>0,"Colonia:",".")+ALLTRIM(a.colubi)),40) as colubi,;
		LEFT(ALLTRIM("Sup Terr:"+RIGHT("             "+ALLTRIM(str(a.areater ,13,2)),13)),40) as tareater,;
		LEFT(ALLTRIM("Sup Const:"+RIGHT("             "+ALLTRIM(str(a.areaconst ,13,2)),13)),40) as tareaconst,;
		LEFT(ALLTRIM("Val Terr:"+RIGHT("             "+TRANSFORM(a.valter, '$,$$$,$$$,$$$.99'),13)),40) as tvalter,;
		LEFT(ALLTRIM("Val Const:"+RIGHT("             "+TRANSFORM(a.valconst, '$,$$$,$$$,$$$.99'),13)),40) as tvalconst,;
		LEFT(ALLTRIM("Val Cat:"+RIGHT("             "+TRANSFORM(a.valcat, '$,$$$,$$$,$$$.99'),13)),40) as tvalcat,;
		LEFT(ALLTRIM("IMPTO BIM."+RIGHT(b.bimrez,1) +" DEL " +LEFT(b.bimrez,4) + " AL BIM. 6 DEL 2019"),40) as RANGOPAGAR,;
		LEFT(ALLTRIM("Impuesto       :"+RIGHT("             "+TRANSFORM(b.impuesto, '$,$$$,$$$,$$$.99'),13)),40) as timpuesto,;
		LEFT(ALLTRIM("Rezago         :"+RIGHT("             "+TRANSFORM(b.rezago, '$,$$$,$$$,$$$.99'),13)),40) as trezago,;
		LEFT(ALLTRIM("Recargos       :"+RIGHT("             "+TRANSFORM(b.recargos, '$,$$$,$$$,$$$.99'),13)),40) as trecargos,;
		LEFT(ALLTRIM("Gastos         :"+RIGHT("             "+TRANSFORM(b.gastos, '$,$$$,$$$,$$$.99'),13)),40) as tgastos,;
		LEFT(ALLTRIM("Sanciones      :"+RIGHT("             "+TRANSFORM(b.sancion, '$,$$$,$$$,$$$.99'),13)),40) as tsancion,;
		LEFT(ALLTRIM("Cobranza       :"+RIGHT("             "+TRANSFORM(wcob, '$,$$$,$$$,$$$.99'),13)),40) as tcobranza,;
		LEFT(ALLTRIM("Ejecucion      :"+RIGHT("             "+TRANSFORM(wejec, '$,$$$,$$$,$$$.99'),13)),40) as tejecucion,;
		LEFT(ALLTRIM("Multa          :"+RIGHT("             "+TRANSFORM(wmulta, '$,$$$,$$$,$$$.99'),13)),40) as tmulta,;
		LEFT(ALLTRIM("Bonificacion(-):"+RIGHT("             "+TRANSFORM(b.bonimp+b.bonrec+b.bongas+b.bonsan, '$,$$$,$$$,$$$.99'),13)),40) as tbonif,;
		LEFT(ALLTRIM("PAGO DEL IMPUESTO PREDIAL 2019"),40) as ANIOPAGAR, b.neto ;
		FROM dexped2 a, totxexp b WHERE a.exp=b.exp ORDER BY a.exp INTO CURSOR 'x'
?tIME()
CREATE  CURSOR banorte ;
(exp char(8),;
espacios CHaR(22),;
empresaval char(5),;
rezval char(17),;
consval char(40),;
fechaval char(10),;
fechacorte char(10))
?tIME()
SELECT banorte
zap
?tIME()
SELECT x
GO top
DO WHILE !EOF()

	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000','Municipio de Guadalupe,N.L.',wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.ubica,                      wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.colubi,                     wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tareater,                   wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tareaconst,                 wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tvalter,                    wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tvalconst,                  wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tvalcat,                    wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.rangopagar,                 wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.timpuesto,                  wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.trezago,                    wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.trecargos,                  wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tgastos,                    wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tsancion,                   wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tcobranza,                  wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tejecucion,                 wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tmulta,                     wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984','00000000000000000',x.tbonif,                     wfecvalban,wfecvalban2)
	INSERT INTO banorte VALUES (x.exp,SPACE(22),'01984',RIGHT("00000000000000000"+ALLTRIM(str(x.neto*100 ,17,0)),17),x.aniopagar,wfecvalban,wfecvalban2)
	
	
SELECT x
SKIP
ENDDO
?tIME()
CREATE  CURSOR banorte2 ;
(exp char(8),;
espacios CHaR(22),;
empresaval char(5),;
cargoaut char(1),;
balin1 char(14),;
nombre char(60),;
domubi char(34),;
balin2 char(57),;
codigo char(1))

SELECT banorte2
zap
?tIME()
SELECT dexped3
GO top
DO WHILE !EOF()

	insert into banorte2 VALUES (dexped3.exp,space(22),'01984','0',SPACE(14),dexped3.nom,dexped3.domubi,SPACE(57),'1')

	SELECT dexped3
	SKIP
ENDDO
?tIME()
SELECT banorte2
	gcDelimFile = PUTFILE('Archivo de Texto:', "BanorteDatGen", 'TXT')
	IF !EMPTY(gcDelimFile)  && Esc pressed
	   COPY TO (gcDelimFile) sdf   && Create delimited file
	ENDIF
*COPY TO BanorteDatGen200901 sdf   && Create delimited file
SELECT banorte
	gcDelimFile = PUTFILE('Archivo de Texto:', "BanorteAdeudos", 'TXT')
	IF !EMPTY(gcDelimFile)  && Esc pressed
	   COPY TO (gcDelimFile) sdf   && Create delimited file
	ENDIF
*COPY TO BanorteAdeudos200901 sdf   && Create delimited file

?tIME()
wtermino="Generacion de archivos para bancos Terminado"
?wtermino
RETURN


