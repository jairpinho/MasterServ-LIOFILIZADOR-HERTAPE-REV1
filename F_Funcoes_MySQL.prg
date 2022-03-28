#Include "minigui.ch"
#Include "F_sistema.ch"
#Include "Common.ch"
#Include "Fileio.CH"
#Include "Directry.ch"


#define _EOL    Chr(13)+Chr(10) && significa os pares CR/LF.
#define _BUFFER_LEN 4*1024

DECLARE WINDOW Form_OS
DECLARE WINDOW Form_Novo_OS
DECLARE WINDOW  Form_Progresso
DECLARE WINDOW Form_Novo_Materiais


*----------------------------------------------------------------------------------------------------*
*
*
*-- Classes para tratamento de dados SQL
*
*
*----------------------------------------------------------------------------------------------------*


*************************************************************************************************************************************
Function MoedaMysql(nVar)
*************************************************************************************************************************************
/*
STRTRAN (<exp.C1>, <exp.C2>, <exp.C3>, <exp.N1>, <exp.N2>)
<exp.C1> representa a cadeia de caracteres a ser pesquisada.
<exp.C2> representa a cadeia de caracteres a ser localizada.
<exp.C3> representa a cadeia de caracteres que substituirá a localizada. Se omitido, será assumido "" .
<exp.N1> representa o número da ocorrência de <exp.C2> para início da substituição. Se omitido, é assumida a primeira ocorrência.
<exp.N2> representa o número de substituições. Se omitido, todas as ocorrências de <exp.C2> a partir de <exp.N1> serão substituídas por <exp.C3>.
*/  

/*
11. Operadores relacionaIS
= (Igual que)
== (Exactamente igual que)
> (Mayor que)
< (Menor que)
>= (Mayor igual que)
<= (Menor igual que)
<> # (Distinto)
*/

  
  cTotal := ALLTRIM(TransForm( nVar , "9999,999.99"))
 //Msginfo("nVar Entrada " + cTotal ) 
 
  IF LEN(cTotal) <= 6 
    cTotal := Alltrim(StrTran( cTotal , ".", "," ,1,1 ))
  ENDIF
  
  IF LEN(cTotal) >= 7

    cTotal := Alltrim(StrTran( cTotal , ".", "," ,1,1 ))
    cTotal := Alltrim(StrTran( cTotal , ",", "." ,1,1 ))
  ENDIF
     // Msginfo("nVar saida " + cTotal )
Return cTotal

/*
Para se buscar um valor dentro do Array, usa-se a função ASCAN(), vamos recordar sua sintaxe:

ASCAN(<aARRAY>, <expPROCURA>,[<nINICIO>], [<nCONTAGEM>])

Onde:
 
aARRAY = Array onde se fará a pesquisa.
 
expPROCURA = Expressão de procura, pode ser um valor de qualquer tipo (caracter, numerico, data ou lógico) ou um bloco de código (code block).
 
nINICIO = Opcional. Valor númerico que representa o elemento inicial de pesquisa, qual a posição do Array que deve iniciar a pesquisa. Se omitido, o valor padrão será 1 (inicio do array)
 
nCONTAGEM = Opcional. O número de elementos que irá pesquisar a partir de nINICIO. Se omitido, o valor padrão será o tamanho do array ( LEN(aARRAY) ).

ASCAN() retorna um valor numérico representando a posição do elemento procurado caso este seja encontrado, caso contrário, retornará 0 (zero).

 

Agora veja alguns dos diversos modos de buscar um valor dentro de um Array, usando a função ASCAN() do Clipper:
Exemplo 1: Busca simples.

aArray := { "Tom", "Mary", "Sue" }

? ASCAN(aArray, "Mary") // Resultado: 2
? ASCAN(aArray, "mary") // Resultado: 0
? ASCAN(aArray, { |x| UPPER(x) == "MARY" }) // Resultado: 2

Exemplo 2: Verificar quantas ocorrências de um valor dentro do Array.

aArray := { "Tom", "Mary", "Sue","Mary" }
 
nStart := 1 // Armazena última posição do elemento no Array
nAtEnd := LEN(aArray) // tamanho da matriz
DO WHILE (nPos := ASCAN(aArray, "Mary", nStart)) > 0
___? nPos, aArray[nPos] // mostra posicao e valor.
___// Atribui nova posicao inicial e testa
___// com tamanho da matriz (evitar erro).
___IF (nStart := ++nPos) > nAtEnd
_____EXIT
___ENDIF
ENDDO 
*/


*************************************************************************************************************************************
Function MySQL_Valor( oValor ,nTipo )
*************************************************************************************************************************************
Local cRetorno := ""

// MSGINFO(STR(LEN(oValor)))	
/*
CadastroGenerico( cDatabase , "Manutentores" , "Modulo Manutententores" ,
"C. Ponto Nº",
"Função",
"Nome Completo :",
"Grupo" ,
"E-mail",
"Admissão",
"Demissão",
,aFuncao,"
",aGrupo_Funcao,"")
*/




IF EMPTY(nTIPO)
	IF 	oValor == "NULL" 
		cRetorno := "NULL"
	Elseif oValor == ""
        cRetorno := ""
    Else
		cRetorno := "'" + oValor + "'"
	ENDIF
	
ELSEIF nTipo == 1

	IF 	oValor == "NULL" 
		cRetorno := "NULL"
	Elseif oValor == ""
        cRetorno := ""
    Else
		cRetorno := "'" + oValor + "%'"
	ENDIF

ELSEIF nTipo == 2

	IF 	oValor == "NULL" 
		cRetorno := "NULL"
	Elseif oValor == ""
        cRetorno := ""
    Else
		cRetorno := "'%" + oValor + "%'"
	ENDIF
ENDIF

Return(cRetorno)

//StrReplaceMYSQL("'",CHR(34),"''",CHR(147),cPesq)
*************************************************************************************************************************************
Function STRReplaceMYSQL( cPesq )
*************************************************************************************************************************************

	cPesq := Alltrim(StrTran( cPesq, "'", "\'" ))
	cPesq := Alltrim(StrTran( cPesq, '"', '\"' ))

Return cPesq


*************************************************************************************************************************************
Function STRReplaceMYSQL_Pesq( cPesq )
*************************************************************************************************************************************

	cPesq := Alltrim(StrTran( cPesq, '"', '\"' ))
	cPesq := Alltrim(StrTran( cPesq, "'", "\'" ))

Return cPesq


************************************************************************************************************************************
Function Data_BRITISH_ANSI(dData)
************************************************************************************************************************************   
	Private  sDataauxiliar
	IF !empty(dData)
		sDataauxiliar := STRZERO(YEAR(dData),4) + STRZERO(MONTH(dData),2) + STRZERO(DAY(dData),2)
	ENDIF
Return(sDataauxiliar)

************************************************************************************************************************************
Function Data_ANSI_BRITISH(sData)
************************************************************************************************************************************   
Private  cDataauxiliar
	//MSGINFO("DATA sDATA" + sData )
	IF !empty(sData)
		dData:= STOD(sData)
		cDataauxiliar := STRZERO(DAY(dData),2) + "/" + STRZERO( MONTH( dData),2) + "/" +  STRZERO(YEAR(dData),4)
	ENDIF
	
	IF cDataauxiliar == "//" 
	  MSGINFO("DATA VAZIA")
	   cDataauxiliar := ""
	  Return
	ENDIF
Return (cDataauxiliar)


*******************************************************************************************************************
Function MysqlUpdate(aUpdate,aStruc)
*******************************************************************************************************************
Local cStruc := ""
Local I := 0
//msginfo(STR(LEN(aUpdate)) +"  /  " + STR(Len(aStruc)) )

 IF 	LEN(aUpdate) == LEN(aStruc)				
                        
        FOR I := 1 TO LEN(aStruc) 
            // msginfo(aStruc[i])
            IF aUpdate[i] != "OFF"
                    IF 	aUpdate[i] == "NULL" 
                        cUpdate := "NULL"
                    Else
                        cUpdate := "'" + aUpdate[i] + "'"
                    ENDIF
                 cStruc +=  aStruc[i] + " = " +  cUpdate + ","
               
            ENDIF

        NEXT
					cStruc := Left(cStruc, Len(cStruc) -1) 

ELSE

    MSGINFO("Campos diferentes da Estrutura da Table")
  

ENDIF
	
   MSGINFO(cStruc)   
Return(cStruc)

*******************************************************************************************************************
Function File_To_Buff(cFile)
*******************************************************************************************************************
local cBuff:="", fh, nLen
local lRetVal:=.f.
local cFile_in := cFile

/*
  Write file 'Test.gif' to MySQL and MariaDB table 'test.blobtest.blobfield'
*/

IF UPPER(cFile) != "DEL"
    fh:=fopen(cFile_in,0)

    if fh > -1
        // determine length of file
        nLen := fseek(fh, 0, 2)
        if nLen > 0

        //move file pointer back to begin of file
        fseek(fh, 0, 0)
        cBuff:=space(nLen)
        fread(fh, @cBuff, nLen)
        
        // escapes
        cBuff:=strtran(cBuff, chr(92), "\\")
        cBuff:=strtran(cBuff, chr(0), "\0")
        cBuff:=strtran(cBuff, chr(39), "\'")
        cBuff:=strtran(cBuff, chr(34), '\"' )
        Endif  
    Else
        cBuff := "OFF"        
    Endif
ELse
    cBuff := " "        
ENDIF
      
fclose(fh)

Return(cBuff)


*******************************************************************************************************************
Function Buff_To_File(cBuff)
*******************************************************************************************************************
local fh, nLen
local lRetVal:=.f.
Local cFile_out := ""
Local cReturn := ""
cDir_Temp := ""


/*
  Read Blobfield from MySQL and MariaDB table 'test.blobtest' and save it to file 'Test2.gif'
*/

IF !EMPTY(cBuff)

nNFile := INT(RANDOM()%999 +1)
cFile_out := "Foto" + Alltrim(STR(nNFile)) // + ".jpg"
cDir_Temp := BaseDeDados("DIR23")
 
IF !File(cDir_Temp + cFile_out)
    fh := fcreate(cDir_Temp + cFile_out,0)

    IF fh>-1
      nLen:=fwrite(fh, cBuff) 
      FCLOSE(fh)

            IF nLen==len(cBuff)
                // MsgInfo("File written back to "+ cFile_out)
            ENDIF

    ENDIF
    cReturn := cDir_Temp+cFile_out
ENDIF

ELSE
cReturn := "F"
ENDIF

RETURN(cReturn)



*************************************************************************************************************************************
// Returns an SQL string with clipper value converted ie. Date() -> "'YYYY-MM-DD'"
Function ClipValueSQL(Value)
*************************************************************************************************************************************

   local cValue
   do case
      case Valtype(Value) == "N"
          cValue := AllTrim(Str(Value))
      case Valtype(Value) == "D"
          if !Empty(Value)
             // MySQL dates are like YYYY-MM-DD
             cValue := "'"+StrZero(Year(Value), 4) + "-" + StrZero(Month(Value), 2) + "-" + StrZero(Day(Value), 2) + "'"
          else
             cValue := "'0000-00-00'"
          endif
      case Valtype(Value) $ "CM"
          IF Empty( Value)
             cValue="''"
          ELSE
             cValue := "'" +value+ "'"
          ENDIF
      case Valtype(Value) == "L"
          cValue := AllTrim(Str(iif(Value == .F., 0, 1)))
      otherwise
          cValue := "''"       // NOTE: Here we lose values we cannot convert
   endcase
return cValue



*******************************************************************************************************************
Function MysqlQueryUpDate(aUpdate,aStruc)
*******************************************************************************************************************
Local cUpdate := ""
Local I := 0
Local cValue := ""
//msginfo(STR(LEN(aUpdate)) +"  /  " + STR(Len(aStruc)) )

 IF 	LEN(aUpdate) == LEN(aStruc)				
                        
        FOR I := 1 TO LEN(aStruc) 
		
			DO CASE 
				CASE VALTYPE(aUpdate[i]) == "N"  && dados tipo numericos
				//msginfo("NUMERO")
						cValue := AllTrim(STR(aUpdate[i]))
						cUpdate +=  aStruc[i] + " = " +  cValue + ","
		  
				CASE VALTYPE(aUpdate[i]) == "D" && dados tipo data
				//msginfo("DATA")
					IF !Empty(aUpdate[i])
					// MySQL dates are like YYYY-MM-DD
						cValue := "'"+STRZERO(YEAR(aUpdate[i]), 4) + "-" + STRZERO(MONTH(aUpdate[i]), 2) + "-" + STRZERO(DAY(aUpdate[i]), 2) + "'"
						cUpdate +=  aStruc[i] + " = " +  cValue + ","
					ELSE
						cValue := "'0000-00-00'"
						cUpdate +=  aStruc[i] + " = " +  cValue + ","
					ENDIF
				
				CASE VALTYPE(aUpdate[i]) $ "CM" && dados tipo string
					//msginfo("STRING")
					// msginfo(STR(i) +" / "+ aStruc[i])
					IF aUpdate[i] != "OFF"
            
						IF 	aUpdate[i] == "NULL" 
							cValue := "NULL"
						Else
						
							IF 	SUBSTR(aStruc[i],1,4) == "foto" && para funcionar tem que criar o campo long_blob com nome inciando com foto
                                cValue := "'" + aUpdate[i] + "'"
								//msginfo(cValue)
								//msginfo(SUBSTR(aStruc[i],1,4))
							ELSE
								cValue := Alltrim(StrTran( aUpdate[i], "'", "\'" ))
                                cValue := Alltrim(StrTran( cValue, '"', '\"' ) )
                                cValue := "'" + cValue + "'"
								//msginfo(SUBSTR(aStruc[i],1,4))
								//msginfo(cValue)
							ENDIF
						ENDIF
								cUpdate +=  aStruc[i] + " = " +  cValue + ","
					ENDIF

	
				CASE VALTYPE(aUpdate[i]) == "L"
					//msginfo("LOGICO")
						cValue := AllTrim(STR(IIF(aStruc[i] == .F., 0, 1)))
						cUpdate +=  aStruc[i] + " = " +  cValue + ","
				OTHERWISE
				//msginfo("QUALQUER VALOR")
						cValue := "''"       // NOTE: Here we lose values we cannot convert
						cUpdate +=  aStruc[i] + " = " +  cValue + ","

				ENDCASE		
		
		NEXT
					cUpdate := Left(cUpdate, Len(cUpdate) -1) 

ELSE

    MSGINFO("Campos diferentes da Estrutura da Table")

ENDIF
	
    
Return(cUpdate)



*******************************************************************************************************************
Function MysqlQueryInsert(aInsert,aStruc)
*******************************************************************************************************************
Local cInsert := ""
Local cCampo := ""
Local cRetono := ""
Local I := 0
Local cValue := ""
//msginfo(STR(LEN(aUpdate)) +"  /  " + STR(Len(aStruc)) )

 IF 	LEN(aInsert) == LEN(aStruc)				
                        
        FOR I := 1 TO LEN(aStruc) 
		
			DO CASE 
				CASE VALTYPE(aInsert[i]) == "N"  && dados tipo numericos
				//msginfo("NUMERO")
						cValue := AllTrim(STR(aInsert[i]))
						cInsert +=  cValue + ","
						cCampo += aStruc[i] + ","
		  
				CASE VALTYPE(aInsert[i]) == "D" && dados tipo data
				//msginfo("DATA")
					IF !Empty(aInsert[i])
					// MySQL dates are like YYYY-MM-DD
						cValue := "'"+STRZERO(YEAR(aInsert[i]), 4) + "-" + STRZERO(MONTH(aInsert[i]), 2) + "-" + STRZERO(DAY(aInsert[i]), 2) + "'"
						cInsert +=  cValue + ","
						cCampo += aStruc[i] + ","
					ELSE
						cValue := "'0000-00-00'"
						cInsert +=  cValue + ","
						cCampo += aStruc[i] + ","
					ENDIF
				
				CASE VALTYPE(aInsert[i]) $ "CM" && dados tipo string
					//msginfo("STRING")
					// msginfo(STR(i) +" / "+ aStruc[i])
					IF aInsert[i] != "OFF"
 
					IF 	aInsert[i] == "NULL" 
							cValue := "NULL"
					Else
							IF 	SUBSTR(aStruc[i],1,4) == "foto" && para funcionar tem que criar o campo long_blob com nome inciando com foto
                                cValue := "'" + aInsert[i] + "'"
							ELSE
								cValue := Alltrim(StrTran( aInsert[i], "'", "\'" ))
								cValue := Alltrim(StrTran( cValue, '"', '\"' ) )
								cValue := "'" + cValue + "'"

							ENDIF

					ENDIF
								cInsert +=  cValue + ","
								cCampo += aStruc[i] + ","
					ENDIF

	
				CASE VALTYPE(aInsert[i]) == "L"
					//msginfo("LOGICO")
						cValue := AllTrim(STR(IIF(aInsert[i] == .F., 0, 1)))
						cInsert +=  cValue + ","
						cCampo += aStruc[i] + ","
				OTHERWISE
				//msginfo("QUALQUER VALOR")
						cValue := "''"       // NOTE: Here we lose values we cannot convert
						cInsert +=  cValue + ","
						cCampo += aStruc[i] + ","

				ENDCASE		
		
		NEXT
					cInsert := Left(cInsert, Len(cInsert) -1) 
					cCampo := Left(cCampo, Len(cCampo) -1)
					cRetono := "(" + cCampo + ") Values (" + cInsert + ")"

ELSE

    MSGINFO("Campos diferentes da Estrutura da Table")

ENDIF
	
    
Return(cRetono)










