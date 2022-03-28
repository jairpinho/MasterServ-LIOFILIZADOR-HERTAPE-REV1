#Include "minigui.ch"
#Include "F_sistema.ch"
#Include "Common.ch"
#Include "Fileio.CH"
#Include "Directry.ch"


#define _EOL    Chr(13)+Chr(10) && significa os pares CR/LF.
#define _BUFFER_LEN 4*1024

DECLARE WINDOW Form_OS
DECLARE WINDOW Form_Novo_OS
DECLARE WINDOW Form_Progresso
DECLARE WINDOW Form_Novo_Produto
DECLARE WINDOW Form_Main
DECLARE WINDOW Form_Master
DECLARE WINDOW Form_Acesso
DECLARE WINDOW Form_Modbus_CNET
DECLARE WINDOW Form_Conectar


*********************************************************************************************************************************************************************
FUNCTION TempFileName(cBuffer)
*********************************************************************************************************************************************************************

    LOCAL nFileHandle
	Local cDirBase      :=DiskName()+":\"+CurDir() + "\Temp\"
	LOCAL cFileName     := "" 
	Local cVarFile := "arq.tmp" 
		
		//cFileName := BUFF_TO_VAR(cVarFile,@cBuffer)
		msginfo(cFileName)
      
	  nFileHandle := HB_FTempCreate( cDirBase+cFileName )

      IF nFileHandle > 0
         FClose( nFileHandle )
      ENDIF
	  
RETURN(cDirBase+cFileName)


*************************************************************************************************************************************
Function GeraCodigo( oTabela ,cCampo_Controle, lCod_start)
*************************************************************************************************************************************
	 Local nCod	:= 0
	 Local oQuery :=""
	 Local oRow :={}
				
		IF Empty(cCampo_Controle)
          cCampo_Controle := "codigo"
        ENDIF
        
        
        oQuery := oServer:Query( "Select * From " + oTabela + " Order By " + cCampo_Controle + " DESC limit 1") 
				
				
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado  em GeraCodigo() " + oQuery:Error())
					 return nil
					Endif
		oQuery:LastRec()
					oRow:= oQuery:GetRow()
					
				nCod := oRow:fieldGet(1) + 1  && gera o codigo (Ultimo + 1), genado Zeros à esquerda de acordo com o tamanho solicitado
				
              
               //MSGINFO("codigo : " + str(nCod) )
    
Return( nCod )

*************************************************************************************************************************************
Function Total_Registro( oTabela , Campo_Controle)
*************************************************************************************************************************************
	 Local nTotCod	:= 0
	 Local oQuery :=""
	 Local oRow :={}
				
				IF Empty(Campo_Controle)
          Campo_Controle := "codigo"
        ENDIF
        
        
        oQuery := oServer:Query( "Select * From " + oTabela + " Order By " + Campo_Controle + " DESC limit 1") 
				
				
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado  em GeraCodigo() " + oQuery:Error())
					 return nil
					Endif
			oQuery:LastRec()
					oRow:= oQuery:GetRow()
          
          	
  			cTotCod := STR(oRow:fieldGet(1))  && gera o codigo (Ultimo + 1), genado Zeros à esquerda de acordo com o tamanho solicitado
				
				//MSGINFO("codigo : " + str(nCod) )
    
Return( cTotCod )

*************************************************************************************************************************************
Function PGeneric( nTipoCampo,oSel_Campo, oTabela , oWhe_Campo1 ,oVar1,oWhe_Campo2 ,oVar2  )
*************************************************************************************************************************************
	  Local oRow     	:= {}
      Local oQuery    := "" 
	  Local Erro 		:= .F.
	  Local lTabelasExistente 	:= .F.
	  Private oNome := ""
	  Private aNome := {}
	  

 		  
				//msginfo("oVar1 : " + alltrim(oVar1) )
				
		IF Empty(aTabelasExistentes)
			       	aTabelasExistentes := oServer:ListTables()
        ENDIF
				
				   //msginfo( "scan " + str(AScan( aTabelasExistentes, oTabela )) )
                  If AScan( aTabelasExistentes, oTabela ) == 0
						          lTabelasExistente:= .T.
                  EndIf 
		  
IF lTabelasExistente == .T.
				
				oNome := "---"
				
Else
				*----- Monta Objeto Query com Selecão
				
				//If 	Erro := .F.
			

	IF nTipoCampo == 1 && se for o campo Retornado for character 

		      oQuery := oServer:Query( "Select "+ oSel_Campo +" From "+ oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1)  )			
					
				  *----- Verifica se ocorreu algum erro na Pesquisa
				  If oQuery:NetErr()												
                    // MsgInfo("Registro não Encontrado em ( Select "+ oSel_Campo +" From "+ oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1) + oQuery:Error())
					           Return( oNome )
				  Endif
				  				oRow:= oQuery:GetRow(1)

					oNome := AllTrim(oRow:fieldGet(1))
					//msginfo (oNome)
					
					IF Empty(oNome)
							oNome := ""
					Endif
					
	Endif	
				
	If nTipoCampo == 2 && se for o campo Retornado for Numerico

							oQuery := oServer:Query( "Select "+ oSel_Campo +" From "+ oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1)  )			
					
				*----- Verifica se ocorreu algum erro na Pesquisa
				    If oQuery:NetErr()												
                     //MsgInfo("Registro não Encontrado em ( Select "+ oSel_Campo +" From "+ oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1) + oQuery:Error())
					           Return( oNome )
				    Endif
          
              				oRow:= oQuery:GetRow(1)
          oNome := AllTrim( STR( oRow:fieldGet(1) ) )
		  IF Empty(oNome)
			oNome := ""
		  Endif
					//msginfo("oQuery  pge: " + oNome )
	Endif	
				//msginfo("oQuery : " + oNome )
				
	If nTipoCampo == 3 && se for o campo Retornado for data
				
		      oQuery := oServer:Query( "Select "+ oSel_Campo +" From "+ oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1)  )			
					
				    *----- Verifica se ocorreu algum erro na Pesquisa
				      If oQuery:NetErr()												
                     //MsgInfo("Registro não Encontrado em ( Select "+ oSel_Campo +" From "+ oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1) + oQuery:Error())
					           Return( oNome )
				      Endif		
              				oRow:= oQuery:GetRow(1)			
					oNome := AllTrim( DTOC( oRow:fieldGet(1) ) )
					IF Empty(oNome)
							oNome := ""
					Endif
	Endif	
	
	If nTipoCampo == 4 && se for o campo Retornado for aray de todos os campos
				
		      oQuery := oServer:Query( "Select * From " + oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1)  )			
					
				    *----- Verifica se ocorreu algum erro na Pesquisa
				      If oQuery:NetErr()												
                     //MsgInfo("Registro não Encontrado em ( Select "+ oSel_Campo +" From "+ oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1) + oQuery:Error())
					           Return( oNome )
				      Endif		
					
					oRow    := oQuery:GetRow(1)
					aNome := array(14)					
					aNome[1] := Str( oRow:fieldGet(1) )
					aNome[2] := AllTrim( oRow:fieldGet(2) )
					aNome[3] := AllTrim( oRow:fieldGet(3) )
					aNome[4] := AllTrim( STR(oRow:fieldGet(4) ))
					aNome[5] := DTOC(oRow:fieldGet(5))
					aNome[6] := DTOC(oRow:fieldGet(6))
					aNome[7] := AllTrim( oRow:fieldGet(7) )
					aNome[8] := AllTrim( oRow:fieldGet(8) )
					aNome[9] := AllTrim( oRow:fieldGet(9) )
					aNome[10] := AllTrim( oRow:fieldGet(10) )
					aNome[11] := AllTrim( oRow:fieldGet(11) )					
					aNome[12] := AllTrim( oRow:fieldGet(12) )
					aNome[13] := DTOC(oRow:fieldGet(13))
					aNome[14] := DTOC(oRow:fieldGet(14))
					
				  

					
          //msginfo("oQuery  pge: " + oNome )
	Endif	

				  
Endif

   IF	nTipoCampo == 4

      oNome := aNome 

   ENDIF

	IF nTipoCampo == 5 && se for o campo Retornado for character 

		      oQuery := oServer:Query( "Select "+ oSel_Campo +" From "+ oTabela +"  WHERE "+ oWhe_Campo1 +" = "+ AllTrim( oVar1) +" AND "+ oWhe_Campo2 +" = "+ AllTrim( oVar2)  )			
					
				  *----- Verifica se ocorreu algum erro na Pesquisa
				  If oQuery:NetErr()												
                    MsgInfo("Registro não Encontrado na tabela " + oTabela)
					           Return( oNome )
				  Endif
				  				oRow:= oQuery:GetRow(1)

					oNome := AllTrim(oRow:fieldGet(1))
					
	Endif

			
		lTabelasExistente:= .F.
					
					IF Empty(oNome)
							oNome := ""
					Endif
Return( oNome )


/*
**************************************************************************************************************
FUNCTION ProgressUpdate(nPos,xForm,xProgress,xControl_1,xControl_2,xControl_3,xPercent,cFile1,cFile2,cFile3,nRange_max  )
**************************************************************************************************************
  Local := 0
  cPorcento := STR( (nPos*100)/ nRange_max ,3,0)

  FOR I:=1 TO nRange_max
    DO EVENTS


  SetProperty ( xForm , xProgress , 'Value', nPos )
  SetProperty ( xForm , xControl_1 , 'Value', cFile1 )
  SetProperty ( xForm , xControl_2 , 'Value', cFile2 )
  SetProperty ( xForm , xControl_3 , 'Value', cFile3 )
  SetProperty ( xForm , xPercent , 'Value', cPorcento + " %" )
  
NEXT 


Return
*/


*************************************************************************************************************************************
Function Busca_Generic( nTipoCampo,xObj, xForm,cPesquisa )
*************************************************************************************************************************************

	Local nCount :=GetProperty ( xForm , xObj , 'ItemCount' )
	Local i      		
	Private 	nCodigo := 0
	
			  	//msginfo(" Total " + str(nCount) )
		If nTipoCampo == 1 
				//msginfo(" Codigo " + str(i) )
				
			For i:= 1 to nCount
				
				SetProperty ( xForm , xObj , 'Value', i ) && tem que ser no inicio se nao o for conta um a menos
					
				//nPos := GetProperty ( xForm , xObj , 'Value' )
				//msginfo(" Value " + alltrim(str(nPos)) )
				
				//cItem := GetProperty ( xForm , xObj , 'Item' , nPos )
				//msginfo(" Item " + alltrim(cItem) )
				
				cDisplay :=  Alltrim(GetProperty ( xForm , xObj , 'DisplayValue' ) )
				//msginfo(" Displayvalue " + alltrim(cDisplay) )
				
			//msginfo(" Display : " + cDisplay + "  /   Pesquisa : " +  cPesquisa)
			
			If  cDisplay == Alltrim(cPesquisa)
				nCodigo  := GetProperty ( xForm , xObj , 'Value' )
				//msginfo(" Codigo  encontrado : " + str(nCodigo) )
				exit
			Endif
			
			
			Next
			
		Endif
			
		
Return( nCodigo )







*************************************************************************************************************************************
Function PegaValorDaColuna( xObj, xForm, nCol)
*************************************************************************************************************************************

	Local nPos := GetProperty ( xForm , xObj , 'Value' )
	Local aRet := GetProperty ( xForm , xObj , 'Item' , nPos )
	Return aRet[nCol]
/*
*
* Sintaxe: LinhaDeMesagem(  [ cMensagem ] )
* Esta função, recebe uma mensagem e atualiza a Linha de Status do Formulário atual
* Se não for passado nenhum parâmetro, a mensagem será atualizada com BaseDeDados()
*
*/

*************************************************************************************************************************************
Function LinhaDeStatus(cMensagem)
*************************************************************************************************************************************

PRIVATE oForm_Main  := "Form_Main"     // CadEnd.PRG CadEnd.FMG
DECLARE WINDOW &oForm_Main.  // Form_Main.FMG
		cMensagem := Iif( cMensagem == Nil , "Base de Dados: "+BaseDeDados("DIR1") , AllTrim(cMensagem) )
        &oForm_Main..StatusBar.Item(1) := cMensagem
		//msginfo("teste base de dados item(1)" + cMensagem)
	Return Nil

*------------------------------------------------------------------------------------------------------------------------------------------
* Função		: Cria_Ini()
* Finalidade	: Cria o Arquivo Config.ini assim que o sistema é inicializado no diretório atual
* Observação	: Sempre que o sistema é executado, verifica se o Arquivo existe, e se não existir cria.
*-----------------------------------------------------------------------------------------------------------------------------------------

*************************************************************************************************************************************
Function Cria_File_Ini()
*************************************************************************************************************************************
/*
Servidor Host=192.168.0.26
Usuario do servidor=esterilizacao
Senha do servidor=0708648
Banco de Dados=esterilizacao
*/


	If ! File(cIniFile)
	    BEGIN INI FILE(cIniFile)
			SET SECTION "Host" 				ENTRY "Servidor Host"          	To "192.168.0.26"
			SET SECTION "Host"		 		ENTRY "Usuario do servidor" 	To "esterilizacao"
			SET SECTION "Host"        		ENTRY "Senha do servidor"		To "0708648"
			SET SECTION "Host"		        ENTRY "Banco de Dados"			To "esterilizacao"
			SET SECTION "Host" 				ENTRY "Porta"					To "3306"
			SET SECTION "COM_SERIAL"		ENTRY "porta"					To "1"			
			SET SECTION "COM_SERIAL"		ENTRY "baudrate"				To "19200"
			SET SECTION "COM_SERIAL"   		ENTRY "data_bits" 	 			To "8"
			SET SECTION "COM_SERIAL"       	ENTRY "stop_bits"				To "1"
			SET SECTION "COM_SERIAL"	    ENTRY "parity"					To "0"
			SET SECTION "COM_SERIAL"	    ENTRY "buffer"					To "3000"
		END INI				
	
	EndIf
Return Nil

*************************************************************************************************************************************
Function Atualiza_File_Ini()
*************************************************************************************************************************************
  cDatabase   := ""
  cHostName   := ""
  cUser       := ""
  cPassWord   := ""
  cTitulo := "Atualiza Arquivo .ini"
  


IF IsWindowDefined( Form_acesso )
	If File(cIniFile)
	    BEGIN INI FILE(cIniFile)
			   SET SECTION "Host" 			ENTRY "Servidor Host"		      To   AllTrim(Form_acesso.HostName.Value )
			   SET SECTION "Host"		 	ENTRY "Usuario do servidor" 	To   AllTrim(Form_acesso.Text_2.Value )
			   SET SECTION "Host"        	ENTRY "Senha do servidor"			To   AllTrim(Form_acesso.Text_3.Value )      
			   SET SECTION "Host"		    ENTRY "Banco de Dados"				To   AllTrim(Form_acesso.Text_1.Value )
			   SET SECTION "Host"		    ENTRY "Porta"				To   AllTrim(Form_acesso.Text_4.Value )
		    END INI	
	EndIf
  
	If File(cIniFile)	   	
		BEGIN INI FILE(cIniFile)
		    GET cHostName 	   SECTION  "Host" ENTRY "Servidor Host"
		    GET cUser 		     SECTION  "Host" ENTRY "Usuario do servidor"
		    GET cPassWord 	   SECTION  "Host" ENTRY "Senha do servidor"
		    GET cDatabase 	   SECTION  "Host" ENTRY "Banco de Dados"
			GET cPort 	   		SECTION  "Host" ENTRY "Porta"
	   END INI
	Endif

        Form_acesso.Title := "Acesso ao Sistema [" + cHostName + "]"
       // Form_Main.Title := cTitulo +"  [" + cHostName + "]"
       // Form_Master.NotifyTooltip := "Masterserv - MySQL" + CHR(13)+CHR(10) + "[" + cHostName + "]"
      //  Form_Master.Title := "Masterserv - MySQL [" + cHostName + "]"  
    
     

		Abre_conexao_MySql()
 
	 
	   If oServer != Nil 
        //MSGINFO("Conexão com o Servidor Completada !","Sistema")
     Return Nil
     Endif 
	 
	 
endif




             
Return Nil


*************************************************************************************************************************************
Function Atualiza_COM_Ini()
*************************************************************************************************************************************

IF IsWindowDefined( Form_Modbus_CNET )
  If File(cIniFile)
	    BEGIN INI FILE(cIniFile)
			SET SECTION "COM_SERIAL"		ENTRY "porta"					To AllTrim(Form_Modbus_CNET.Combo_1.DisplayValue )		
			SET SECTION "COM_SERIAL"		ENTRY "baudrate"				To AllTrim(Form_Modbus_CNET.Combo_2.DisplayValue )
			SET SECTION "COM_SERIAL"   		ENTRY "data_bits" 	 			To AllTrim(Form_Modbus_CNET.Combo_3.DisplayValue )
			SET SECTION "COM_SERIAL"       	ENTRY "stop_bits"				To AllTrim(Form_Modbus_CNET.Combo_4.DisplayValue )
			SET SECTION "COM_SERIAL"	    ENTRY "parity"					To AllTrim(Form_Modbus_CNET.Combo_5.DisplayValue )
			SET SECTION "COM_SERIAL"	    ENTRY "buffer"					To AllTrim(Form_Modbus_CNET.Combo_6.DisplayValue )
		END INI	
	EndIf
ENDIF

             
Return Nil	
*************************************************************************************************************************************
Function NoModulo()
*************************************************************************************************************************************
         MsgBox("Modulo não Disponível !!")
Return Nil



//strreplace("'","",cPesq)
*************************************************************************************************************************************
Function StrReplace( cChar, cCharSub , cPesq )
*************************************************************************************************************************************

	cPesq := StrTran( cPesq, cChar, cCharSub )

Return cPesq


*************************************************************************************************************************************
FUNCTION StringToArray( cString, cSeparator )
*************************************************************************************************************************************

   LOCAL nPos
   LOCAL aString := {}
   DEFAULT cSeparator := ";"
   cString := ALLTRIM( cString ) + cSeparator
   DO WHILE .T.
      nPos := AT( cSeparator, cString )
      IF nPos = 0
         EXIT
      ENDIF
      AADD( aString, SUBSTR( cString, 1, nPos-1 ) )
      cString := SUBSTR( cString, nPos+1 )
   ENDDO
RETURN ( aString )

*************************************************************************************************************************************
FUNCTION StringToVar( cString )
*************************************************************************************************************************************

	IF EMPTY(cString)
		vString := ""
	ELSE
		vString := &( ALLTRIM( cString )  )
	ENDIF
	
RETURN ( vString )


*************************************************************************************************************************************
FUNCTION ArrayToVar( cString )
*************************************************************************************************************************************

	IF EMPTY(cString)
		vString := {}
	ELSE
		vString := &( ALLTRIM( cString )  )
	ENDIF
	
RETURN ( vString )

************************************************************************************************************************************
FUNCTION Generic_Check_Combo(oCombo)
************************************************************************************************************************************

If 	   oCombo == "Combo_1"
	lCombo_1 := .T.
	//msginfo("teste ok")
ElseIf oCombo == "Combo_2"
	lCombo_2 := .T.
Endif

RETURN( lCombo_1,lCombo_2 )


*************************************************************************************************************************************
Function Database_Name()
*************************************************************************************************************************************
         Local oQuery :=""
         Local oRow :={}          
                  oQuery := oServer:Query( "Select DATABASE()" )
                  
                    If oQuery:NetErr()												
                      MsgInfo("Erro de Pesquisa (DATABASE) (Select):  " + oQuery:Error())
					           return nil
					         Endif
					         
					         oRow := oQuery:GetRow()
					         
					        // MsgInfo("Banco De Dados " + Alltrim( oRow:FieldGet(1)))
					        cNome_Database := Alltrim(oRow:FieldGet(1))
                  
Return (cNome_Database)


*************************************************************************************************************************************
Function SomaHora(ctime1,ctime2)
*************************************************************************************************************************************
local nsub1 := 0 
local nsub2 := 0
local nmin  := 0
Local cHora_Minuto := ""

nsub1 :=  val(right(ctime1, 2)) + val(right(ctime2, 2)) 
nsub2 :=  (val( left(ctime1, 2)) + val( left(ctime2, 2))) * 60
nmin  := nsub1 + nsub2

cHora_Minuto := strzero(int(nmin / 60), 2) + ":" + strzero(nmin % 60, 2) 
Return(cHora_Minuto)

*************************************************************************************************************************************
Function SubtraiHora(ctime1,ctime2)
*************************************************************************************************************************************
 
local nsub2 := 0
local nmin  := 0
Local cHora_Minuto := ""

nsub1 :=  val(right(ctime1, 2)) - val(right(ctime2, 2)) 
nsub2 :=  (val( left(ctime1, 4)) - val( left(ctime2, 4))) * 60
nmin  := nsub1 + nsub2

cHora_Minuto := strzero(int(nmin / 60), 4) + ":" + strzero(nmin % 60, 2) 
Return(cHora_Minuto)  


** Função para retornar diferenca de horas de 24hs a 00 da noite nao faz
*diferença de um dia para o outro.
*************************************************************************************************************************************
Function DiferencaHora(cl_start, cl_end,nIntervalo)
*************************************************************************************************************************************
if empty(nIntervalo)
nIntervalo := 0
endif
Return F_TString( If( cl_end < cl_start, 86400, 0) + F_Secs(cl_end) - F_SECS(cl_start),nIntervalo )

** Fonte da função ELAPTIME() para modificar do jeito de cada programador
*sao tres funcao ElapTime(), Tstring(),Secs() que ja existem 
*
*************************************************************************************************************************************
Function F_ElapTempo(cl_start, cl_end)
*************************************************************************************************************************************
Return F_TString( If( cl_end < cl_start, 86400, 0) + F_Secs(cl_end) - F_SECS(cl_start) )

*************************************************************************************************************************************
Function F_Tstring(cl_secs,nIntervalo)
*************************************************************************************************************************************
Return StrZero( Int(MOD(cl_secs/3600, 24))-nIntervalo, 2, 0 ) +':'+ StrZero( Int(MOD(cl_secs/  60, 60)), 2, 0 ) 

*************************************************************************************************************************************
Function F_Secs(cl_time)
*************************************************************************************************************************************
Return Val(cl_time ) * 3600 + (Val(SubStr(cl_time,4))) * 60 +Val(SubStr(cl_time,7)) 


/* codigo font da funcao ELAPTIME()
Function ElapTime(cl_start, cl_end)
Return TString( If( cl_end < cl_start, 86400, 0) + ;
                   Secs(cl_end) - SECS(cl_start) )

Function Tstring(cl_secs)
Return StrZero( Int(MOD(cl_secs/3600, 24)), 2, 0 ) +':'+;
       StrZero( Int(MOD(cl_secs/  60, 60)), 2, 0 ) +':'+;
       StrZero( Int(MOD(cl_secs   , 60)), 2, 0 )

Function Secs(cl_time)
Return Val(    cl_time ) * 3600 +;
   Val(SubStr(cl_time,4)) *   60 +;
   Val(SubStr(cl_time,7)) 
   
*/


*******************************************************************************************************************
Function Pesquisa_Item(cReg,cTabela,cCampo)
*******************************************************************************************************************
	Local oRow     	:= {}
	Local aDados   	:= {}
  Local oQuery    := "" 
	
	aDados   	:= array(4)
          If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!") ; Return Nil ; EndIf
            
          oQuery  := oServer:Query( "Select * From "+cTabela+" WHERE " + cCampo + " = " + AllTrim( cReg )  )
          
                  
				  If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado em Pesquisa_Manutentor(): " + oQuery:Error())
                     Return Nil
          Endif               
               //msginfo("qt. " + STR(oQuery:LastRec())) 
                IF oQuery:LastRec() >= 1 
            			oRow := oQuery:GetRow()
		              aDados[1] := ALLTRIM(oRow:FieldGet(10))
		              aDados[2] := AlLTrim(oRow:FieldGet(9))
		              aDados[3] := .T.
		              aDados[4] := AlLTrim(oRow:FieldGet(11))
		            ELseIF oQuery:LastRec() == 0
		              aDados[3] := .F.
		            ENDIF

Return(aDados)

*******************************************************************************************************************
Function Espera(nTempo)
*******************************************************************************************************************
  nTempo +=SECONDS()
  WHILE SECONDS() <nTempo
  ENDDO
  
Return


*******************************************************************************************************************
Function Status_Logico(lVar)
*******************************************************************************************************************
 cLogico := Transform( lVar , "L") 
 Msginfo("Satus da Variavel : " +  cLogico )
  
Return

*******************************************************************************************************************
Function Total_Linha(nFileH)
*******************************************************************************************************************

#define _EOL    Chr(13)+Chr(10)
#define _BUFFER_LEN 4*1024

local cBuffer := Space(_BUFFER_LEN)
local nLines := 0
local cRead := ""
local i
local n

while (n := FRead(nFileH,@cBuffer,_BUFFER_LEN)) > 0
 cRead += Left(cBuffer,n)
 while (i := At(_EOL,cRead)) > 0
   nLines+= 1
   cRead := SubStr(cRead,i+Len(_EOL))
 end
 cBuffer := Space(_BUFFER_LEN)
end
FSeek(nFileH,nFileH,0) && Retorna para o inicio do aquivo pesquisado para evitar falha de leitura na rotina que a chamou

Return(nLines)


*************************************************************************************************************************************
Function Deleta_Temp(cDir, cExt)
*************************************************************************************************************************************
cBase := DiskName()+":\"+CurDir() + "\" + cDir + "\"

aDiretorio:= Directory(cBase + cExt  )

For X:= 1 To Len(aDiretorio)
    Delete File (cBase + aDiretorio[X, 1])
Next X

Return


*************************************************************************************************************************************
Function Deleta(cDir, cExt)
*************************************************************************************************************************************

cBase:= "c:\logar do programa\"

aDirec:= Directory(cBase + "*.cdx")

For x:= 1 To Len(aDirec)
    Delete File (cBase + aDirec[x, 1])
Next x

Return Nil


*************************************************************************************************************************************
Function Carrega_Arquivo(nTipoCampo,xObjImg, xFormImg,xObjForm, xForm, cTitle, cDefaultPath , lMultiSelect , lNoChangeDir)
*************************************************************************************************************************************
//local lMultiSelect := AppWin.CheckBtn_1.Value
local aFiles, cValue := "", nI
Local cFilePath := ""

// Carrega_Arquivo(nTipoCampo,xObj, xForm,acFilter ,'Abrir Arquivo' , '.\' , .F. , .T. )
// GetFile ( acFilter , cTitle, cDefaultPath , lMultiSelect , lNoChangeDir)--> cSelectedFileName
// aFiles := GetFile({ {"All Files", "*.*"}, {"Prg Files", "*.prg"} }, 'Select files', '.\', lMultiSelect)

    
IF nTipoCampo == 1      

cFilePath := Getfile ( { {'All Files','*.*'} } , cTitle , cDefaultPath ,lMultiSelect  , lNoChangeDir )
// msginfo(cFilePath)
SetProperty ( xForm , xObjForm , 'Value',cFilePath) 	
SetProperty ( xFormImg , xObjImg , 'Picture', cFilePath) 	


/*
if lMultiSelect
   for nI := 1 to len(aFiles)
      cValue := cValue + aFiles[nI] + CRLF
   next
else
   cValue := aFiles
endif
if ! empty( cValue )
   AppWin.RichEdit_1.Value := cValue
endif
*/

ELSEIF nTipoCampo == 2

cFilePath := Getfile (   { ;
                     {'Arquivos de Imagem' , '*.JPG;*.BMP;*.GIF;*.PNG'} ,;
                        {'Arquivos JPG' , '*.JPG'} ,;
                        {'Arquivos BMP' , '*.BMP'} ,;
                        {'Arquivos GIF' , '*.GIF'} ,;
                        {'Arquivos PNG' , '*.PNG'}  } ,;
                        cTitle ,;
                        cDefaultPath ,;
                        lMultiSelect  ,;
                        lNoChangeDir )


// msginfo(cFilePath)
SetProperty ( xForm , xObjForm , 'Value',cFilePath) 	
SetProperty ( xFormImg , xObjImg , 'Picture', cFilePath) 

ENDIF

return


Function 	Fim_Linha1(cTexto)
	
	Local nPos := 0
	Local cRetorno := ""

         WHILE nPos <= LEN(cTexto)
		 //msginfo(STR(LEN(cTexto)))
            if .not. SUBSTR( cTexto, nPos, 1 ) $ CHR(13)
                     ++nPos
			Else 
				//msginfo(STR(nPos-1))
                cRetorno := SUBSTR( cTexto, 1, nPos-1 ) && retorna somente até encontrar o enter
             cRetorno := Alltrim(StrTran( cRetorno, '"' , "'" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "\", "-" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "/", "-" ))			
           cRetorno := Alltrim(StrTran( cRetorno, ":", " -" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "?", " -" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "<", " -" ))			
           cRetorno := Alltrim(StrTran( cRetorno, ">", " -" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "|", " -" ))
                //msginfo(cRetorno)
				Exit
			ENDIF
			
            cRetorno := SUBSTR( cTexto, 1, nPos ) && retorna somente até encontrar o enter 
              cRetorno := Alltrim(StrTran( cRetorno, '"' , "'" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "\", "-" ))			
            cRetorno := Alltrim(StrTran( cRetorno, "/", "-" ))			
           cRetorno := Alltrim(StrTran( cRetorno, ":", " -" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "?", " -" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "<", " -" ))			
           cRetorno := Alltrim(StrTran( cRetorno, ">", " -" ))			
           cRetorno := Alltrim(StrTran( cRetorno, "|", " -" ))			
            
         ENDDO
	
					
			
	
Return (cRetorno)



*-------------------------------------------------------------------------
* Função : Incrementa meses em uma data
* Parâmetros : Data, Número
* Retorna : Data
* Notas : Nenhuma
*-------------------------------------------------------------------------
Function Addmes(Data, Increm)
LOCAL cDia, cMes, cAno, nDia, nMes, nAno

nDia = Day(Data)
nMes = Month(Data)
nAno = Year(Data)

nMes = nMes + Increm
Do While nMes > 12
nAno = nAno + 1
nMes = nMes - 12
Enddo
If nMes = 2 .And. nDia > 28
If Mod(nAno,4) = 0
nDia = 29
Else
nDia = 28
Endif
Endif
cDia = Transform(nDia,"@L 99")
cMes = Transform(nMes,"@L 99")
cAno = Transform(nAno,"@L 9999")

Return(Ctod(cDia+'/'+cMes+'/'+cAno))







