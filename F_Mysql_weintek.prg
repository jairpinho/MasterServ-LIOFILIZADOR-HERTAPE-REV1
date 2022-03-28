#include "Inkey.ch"
#include "minigui.ch"
#Include "F_sistema.ch"


************************************************************************************************************************************
Function GetDateTT( nSeconds )
************************************************************************************************************************************
   set cent on
   nSeconds := int( nSeconds )
   nSeconds := int( nSeconds / 60 )
   nSeconds := int( nSeconds / 60 )
   nSeconds := int( nSeconds / 24 )
   
   dFirstDate := stod( '19700101' )
   dDate := dFirstDate + nSeconds
   cYear := padl( year( dDate ), 4, '0' )
   cMonth := padl( month( dDate ), 2, '0' )
   cDay := padl( day( dDate ), 2, '0' )
   cReturn :=  cDay + '/' + cMonth + '/' +  cYear
   
Return(cReturn)



************************************************************************************************************************************
Function GetTimeTT( nSeconds )
************************************************************************************************************************************
   set cent on
   cMilliSeconds := padl( STRZERO( mod( nSeconds, 1 )*1000  ,3) , 3, '0' )
   nSeconds := int( nSeconds )
   cSeconds := padl( STRZERO( mod( nSeconds, 60 ), 2 ), 2, '0' )
   
   nSeconds := int( nSeconds / 60 )
   cMinutes := padl( STRZERO( mod( nSeconds, 60 ), 2 ), 2, '0' )
   
   nSeconds := int( nSeconds / 60 )
   cHours :=  padl( STRZERO( mod( nSeconds, 24 ), 2 ) , 2, '0' ) 
   

   cReturn := cHours + ':' + cMinutes + ':' + cSeconds + '.' + cMilliSeconds
   
Return(cReturn)





************************************************************************************************************************************
Function hb_GetDateTimeTT( nTimestamp,cDataFormat, cTimeFormat )
************************************************************************************************************************************

//hb_TtoC(t"1970-01-01" + oRow:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  )   ,; 		// RETORNA cDATA SOMENTE DO NTIMESTAMP
//hb_TtoC(t"1970-01-01" + oRow:fieldGet(2) /60 /60 /24, "" , "HH:MM:SS"  )   ,;	
IF EMPTY(cTimeFormat)
	cReturn := hb_TtoC(t"1970-01-01" + nTimestamp /60 /60 /24, cDataFormat , ""  )
ENDIF


IF EMPTY(cDataFormat)
	cReturn := hb_TtoC(t"1970-01-01" + nTimestamp /60 /60 /24, "" , cTimeFormat  ) 
ENDIF

IF !EMPTY(cDataFormat) .AND. !EMPTY(cTimeFormat)
	cReturn := hb_TtoC(t"1970-01-01" + nTimestamp /60 /60 /24, cDataFormat , cTimeFormat  )
ENDIF

Return(cReturn)

************************************************************************************************************************************
Function GetDateTimeTT( nSeconds )
************************************************************************************************************************************
   set cent on
   cMilliSeconds := padl( STRZERO( mod( nSeconds, 1 )*1000  ,3) , 3, '0' )
   nSeconds := int( nSeconds )
   cSeconds := padl( STRZERO( mod( nSeconds, 60 ), 2 ), 2, '0' )
   
   nSeconds := int( nSeconds / 60 )
   cMinutes := padl( STRZERO( mod( nSeconds, 60 ), 2 ), 2, '0' )
   
   nSeconds := int( nSeconds / 60 )
   cHours :=  padl( STRZERO( mod( nSeconds, 24 ), 2 ) , 2, '0' ) 
   
   nSeconds := int( nSeconds / 24 )
   dFirstDate := stod( '19700101' )
   dDate := dFirstDate + nSeconds
   cYear := padl( year( dDate ), 4, '0' )
   cMonth := padl( month( dDate ), 2, '0' )
   cDay := padl( day( dDate ), 2, '0' )
   cReturn := cYear + '-' + cMonth + '-' + cDay + ' ' + cHours + ':' + cMinutes + ':' + cSeconds + '.' + cMilliSeconds
   
Return(cReturn)
   
   
************************************************************************************************************************************
Function GetDateTime2( nSeconds )
************************************************************************************************************************************
   set cent on
   cMilliSeconds := padl( STRZERO( mod( nSeconds, 1 )*1000  ,3) , 3, '0' )
   nSeconds := int( nSeconds )
   //msginfo(str(nSeconds))
   cSeconds := padl( STRZERO( mod( nSeconds, 60 ), 2 ), 2, '0' )
   //msginfo("segundos " +cSeconds )
   //msginfo("segundos mod  "+ STR(mod( nSeconds, 60 )))
   
   nSeconds := int( nSeconds / 60 )
   cMinutes := padl( STRZERO( mod( nSeconds, 60 ), 2 ), 2, '0' )
   //msginfo("minutos " + str(nSeconds))
   //msginfo("minutos mod  "+ STR(mod( nSeconds, 60 )))
   //msginfo(cMinutes)
   
   nSeconds := int( nSeconds / 60 )
   cHours :=  padl( STRZERO( mod( nSeconds, 24 ), 2 ) , 2, '0' ) 

   //msginfo("hora  "+ str(nSeconds))
   //msginfo("hora mod  "+ STR(mod( nSeconds, 24 )))
   //msginfo(cHours)
Return

************************************************************************************************************************************
Function UTF8ToStr( cUTF8 )
************************************************************************************************************************************
Local cRetorno := ""

cRetorno := Alltrim(STRTRAN(HB_UTF8ToStr(cUTF8),CHR(0),"" ))

Return(cRetorno)


