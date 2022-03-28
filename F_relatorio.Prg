#include <hmg.ch>
#Include "minigui.ch"
#Include "Common.ch"
#Include "Fileio.CH"
#Include "Directry.ch"
#include "hbclass.ch"
DECLARE WINDOW Form_Relatorio
*************************************************************************************************************************************
Function Relatorio_Esterilizacao()
*************************************************************************************************************************************
Private aColunaX := {}
Private aColunaY := {}
Private aColunaXX := {}
Private aColor := {}
//Private fColor := {}


	
IF !IsWindowDefined(Form_Relatorio)	
        Load Window Form_Relatorio
			Form_Relatorio.Row := 10
			Form_Relatorio.Col := 10
			Pesquisa_Ciclos_Maquinas()			
        Form_Relatorio.Activate
ENDIF
return



STATIC FUNCTION BC_Grid_1()
/*****************************/
LOCAL a
LOCAL aColors  := { { RED, RED, BLACK, BLACK ,BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK } } // EQUAL TO NUMBER OF COLUMNS == 6
LOCAL aItem    := {}


//{60,80,70,130,100,60,60,60,60,60,60,70,70,250}
//{{ || BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()}, { BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()} ,{BC_Grid_1()} ,{BC_Grid_1()} ,{BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()} }
/*
IF IsWindowActive(Form_Relatorio)

aItem    := Form_Relatorio.Grid_1.Item (This.CellRowIndex)



  FOR a = 1 TO 14
		if Val(aItem [6]) > 50 // some condition to set color//  for val to colunn?
			aColors [1] [a] := RED  
		endif
   NEXT a

endif
*/

RETURN aColors // [1][ This.CellColIndex ]


************************************************************************************************************************************
FUNCTION CALCULA_F0(nTemperatura,nSet_Point_Temp,nZ_Set_Point,cSituacao)
************************************************************************************************************************************
Local nResultado
local naux1 := 0
local naux2 := 0
Local cEtapa := ""

if empty(cSituacao)
	cEtapa := "TODOS"
	cSituacao := "TODOS"
elseif cSituacao == "ESTERILIZAÇÃO"
	cEtapa := "ESTERILIZAÇÃO"
endif

//msginfo (STR( nTemperatura) +"  " + STR(nSet_Point_Temp) + "  " +STR(nZ_Set_Point) )
IF nTemperatura > 0 .AND. cSituacao == cEtapa
naux1 := nTemperatura - nSet_Point_Temp
//msginfo (STR(naux1))
naux2 := naux1 / nZ_Set_Point
//msginfo (STR(naux2))
nResultado := 10^naux2
//msginfo (STR(nResultado))
ELSE
nResultado := 0
ENDIF

RETURN (STRZERO(nResultado,6,4))


*************************************************************************************************************************************
Function Pesquisa_Ciclos_Maquinas()
*************************************************************************************************************************************
	Local dData1	:= Form_Relatorio.DatePicker_1.Value
	Local i           					:= 0
	Local oRow     						:= {}
	Local oQuery      				:= "" 
	Local oRow1     						:= {}
	Local oRow2    						:= {}
	Local oQuery1      				:= ""	
	Local aColunaX := {}
	Local cInicio_est := ""
	Local cFinal_est  := ""
	
	
	
IF IsWindowActive(Form_Relatorio)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_2 OF Form_Relatorio

				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( +;
				" (SELECT  'Autoclave Luferco' as maquina, codigo,setor,data,operador,lote,setpoint,carga,tempo_esterili,materiais FROM dados_autoclave1 WHERE data = " + Data_BRITISH_ANSI( dData1) + " group by codigo ) "+;
				" UNION  " +;
				" (SELECT  'Autoclave Sercon' as maquina , codigo,setor,data,operador,lote,setpoint,carga,tempo_esterili,materiais FROM dados_autoclave2 WHERE data = "  + Data_BRITISH_ANSI( dData1)+ " group by codigo ) "+;
				" UNION " +;
				" (SELECT  'Estufa 28' as maquina , codigo,setor,data,operador,lote,setpoint,carga,tempo_esterili,materiais FROM dados_estufa1 WHERE data = " + Data_BRITISH_ANSI( dData1) + " group by codigo ) "+;
				" UNION " +; 
				" (SELECT  'Estufa 26' as maquina , codigo,setor,data,operador,lote,setpoint,carga,tempo_esterili,materiais FROM dados_estufa2 WHERE data = " + Data_BRITISH_ANSI( dData1)+ " group by codigo ) "+;
				" UNION " +; 
				" (SELECT  'EStufa 29' as maquina , codigo,setor,data,operador,lote,setpoint,carga,tempo_esterili,materiais FROM dados_estufa3 WHERE data = " + Data_BRITISH_ANSI( dData1) + " group by codigo ) "  )

				If oQuery:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif				
				/*
				oQuery1 := oServer:Query( "Select MIN(hora),MAX(hora) From " + cTabela1 + " WHERE codigo = " + cPesq + " AND situacao = 'ESTERILIZAÇÃO' " )
				oRow1 := oQuery1:GetRow()
				//MSGINFO("min " + Alltrim(oRow1:fieldGet(1) ) )
				//MSGINFO("max " + Alltrim(oRow1:fieldGet(2) ) )
				//MSGINFO("total : " + str(oQuery1:LastRec()) )
				IF oQuery1:LastRec() >= 1
					cInicio_est := Alltrim(oRow1:fieldGet(1) )
					cFinal_est := Alltrim(oRow1:fieldGet(2) )
				ENDIF
				//MSGINFO("total : " + str(oQuery:LastRec()) )
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery1:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
					
				*/
	// {"MÁQUINA","SEQ.","SETOR","DATA","OPERADOR","LOTE","SETPOINT","CARGA","TEMPO EST.","MATERIAIS"}			
					
	//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUAÇÃO"}
               For i:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim( oRow:fieldGet(1) )  ,;
						Alltrim(STR(oRow:fieldGet(2)) ),;
						Alltrim(oRow:fieldGet(3) ),;
						DTOC( oRow:fieldGet(4) ) ,;
						Alltrim(oRow:fieldGet(5) ),;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(oRow:fieldGet(7) ),;
						Alltrim(oRow:fieldGet(8) ),;
						Alltrim(oRow:fieldGet(9) ),;
						Alltrim(oRow:fieldGet(10) )} TO Grid_2 OF Form_Relatorio
						oQuery:Skip(1)
			
               Next


		//msginfo(str(len(aColunaX)))
		//msginfo(str(len(aColunaY)))			
		   
			   
/*			   
oRow := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Relatorio.Text_62.Value := Alltrim(oRow:fieldGet(2))  // setor
Form_Relatorio.Text_63.Value :=Alltrim(oRow:fieldGet(6))  // ciclo
Form_Relatorio.Text_64.Value :=Alltrim(oRow:fieldGet(8))  // temperatura esterilizacao
Form_Relatorio.Text_65.Value :=Alltrim(oRow:fieldGet(5))  // lote
Form_Relatorio.Text_66.Value :=Alltrim(oRow:fieldGet(7))  // carga
Form_Relatorio.Text_67.Value :=Alltrim(oRow:fieldGet(4))  // operaodr
Form_Relatorio.Text_68.Value := Alltrim(STR(oRow:fieldGet(1)) ) // CODIGO
Form_Relatorio.Edit_6.Value :=Alltrim(oRow:fieldGet(26)) // materiais
Form_Relatorio.Text_69.Value := cInicio_est // inicio esterilizacao
Form_Relatorio.Text_70.Value := cFinal_est // final esterilizacao			   
*/

IF oQuery:LastRec() >= 1						
	Form_Relatorio.Label_15.Value := "Total de Registros : " + Alltrim(STR(oQuery:LastRec()))
Elseif oQuery:LastRec() = 0
	MSGINFO("Consulta sem Registros")
endif			   


ENDIF





	Return Nil








*************************************************************************************************************************************
Function Pesquisa_Relatorio_Maquinas()
*************************************************************************************************************************************


	Local cPesq	:= Alltrim(Form_Relatorio.Text_1.Value)
	Local i           					:= 0
	Local i2           					:= 0
	Local oRow     						:= {}
	Local oQuery      				:= "" 
	Local oRow1     						:= {}
	Local oRow2    						:= {}
	Local oQuery1      				:= ""	
	Local aColunaX := {}
	Local cInicio_est := ""
	Local cFinal_est  := ""
	Local cTabela := ""
	Local cMaquina := ""
	Local aF0Acumulado := Array(6)
	Local nTipo := 0
	Local aCfg_Rel1 := Carrega_Config_Relatorios("autoclaves")
	Local aCfg_Rel2 := Carrega_Config_Relatorios("estufas")
	
	
AFILL( aF0Acumulado,0,1, 6)	


 	If Empty(cPesq)

			MsgExclamation("Digite uma sequência !!","SISTEMA")
			Return Nil
      Endif
	
IF Form_Relatorio.Combo_1.Value == 1
	cTabela := cTabela1
	cMaquina := "Autoclave Luferco"
	nTipo := 1
ELSEIF Form_Relatorio.Combo_1.Value == 2
	cTabela := cTabela2
	cMaquina := "Autoclave Sercon"	
	nTipo := 2
ELSEIF Form_Relatorio.Combo_1.Value == 3
	cTabela := cTabela3
	cMaquina := "Estufa 28"	
	nTipo := 3
ELSEIF Form_Relatorio.Combo_1.Value == 4
	cTabela := cTabela4
	cMaquina := "Estufa 26"	
	nTipo := 4
ELSEIF Form_Relatorio.Combo_1.Value == 5
	cTabela := cTabela5
	cMaquina := "Estufa Leboc"	
	nTipo := 5
ENDIF


 
	
IF IsWindowActive(Form_Relatorio)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_1 OF Form_Relatorio

				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela + " WHERE codigo = " + cPesq + " Order By data, hora" ) 
					If oQuery:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif				
				
				oQuery1 := oServer:Query( "Select hora From " + cTabela + " WHERE codigo = " + cPesq + " AND situacao = 'ESTERILIZAÇÃO' " + " Order By data , hora")
				//oRow1 := oQuery1:GetRow()
				//MSGINFO("total : " + str(oQuery1:LastRec()) )
		IF oQuery1:LastRec() >= 1
				
               For i2:= 1 To oQuery1:LastRec()
                        oRow1 := oQuery1:GetRow(i2)
				
					//msginfo(STR(i2) + " - " + Alltrim(oRow1:fieldGet(1) ) )
					IF I2 == 1	
						cInicio_est := Alltrim(oRow1:fieldGet(1) )
					ENDIF
					
					IF I2 == oQuery1:LastRec()
						cFinal_est := Alltrim(oRow1:fieldGet(1) )
					ENDIF
					
					oQuery1:Skip(1)
               Next
				

		ENDIF
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery1:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
					
//fColor := { || {255,085,085 }  }
				
 IF oQuery:LastRec() >= 1					

               For i:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(i)
						
						//fColor := { || if ( oRow:fieldGet(12) > 50 , {255,085,085 } , { 255,255,255 } ) } //branco ou vermelho    //x[4] é a coluna do estoque
						//bColor1 :={ |x| IIf ( x[4] <=0 , {255,200,200} , ) }     //x[4] é a coluna do estoque
			//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUAÇÃO"}			
						iif( oRow:fieldGet(12) > 50 ,SetProperty( "Form_Relatorio","Grid_1","FORECOLOR", 6, RED ) , { 0,0,0 } ) 
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(1)) )  ,;
						DTOC( oRow:fieldGet(3) ) ,;
						Alltrim(oRow:fieldGet(10) ),;
						cMaquina ,;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(STR(oRow:fieldGet(12) )),;
						Alltrim(STR(oRow:fieldGet(14) )),;
						Alltrim(STR(oRow:fieldGet(16) )),;
						Alltrim(STR(oRow:fieldGet(18) )),;
						Alltrim(STR(oRow:fieldGet(20) )),;
						Alltrim(STR(oRow:fieldGet(22) )),;
						Alltrim(STR(oRow:fieldGet(25) )),;
						Alltrim(STR(oRow:fieldGet(24) )),;
						Alltrim(oRow:fieldGet(11) )} TO Grid_1 OF Form_Relatorio
						oQuery:Skip(1)
						Aadd( aColunaX , oRow:fieldGet(14)  )
						Aadd( aColunaY , Alltrim(oRow:fieldGet(10) )  )
// FUNCTION CALCULA_F0(nTemperatura,nSet_Point_Temp,nZ_Set_Point,cSituacao)

						IF nTipo == 1 .OR. nTipo == 2
								aF0Acumulado[1] := aF0Acumulado[1] + VAL(CALCULA_F0(oRow:fieldGet(12),VAL(oRow:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[2] := aF0Acumulado[2] + VAL(CALCULA_F0(oRow:fieldGet(14),VAL(oRow:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[3] := aF0Acumulado[3] + VAL(CALCULA_F0(oRow:fieldGet(16),VAL(oRow:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[4] := aF0Acumulado[4] + VAL(CALCULA_F0(oRow:fieldGet(18),VAL(oRow:fieldGet(6)),aCfg_Rel1[4] ))
						endif
						
						IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5 
							aF0Acumulado[1] += VAL(CALCULA_F0(oRow:fieldGet(12),VAL(oRow:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[2] += VAL(CALCULA_F0(oRow:fieldGet(14),VAL(oRow:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[3] += VAL(CALCULA_F0(oRow:fieldGet(16),VAL(oRow:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[4] += VAL(CALCULA_F0(oRow:fieldGet(18),VAL(oRow:fieldGet(6)),aCfg_Rel2[4] ))
							//aF0Acumulado[1] += VAL(CALCULA_F0(oRow:fieldGet(3),oRow:fieldGet(25),46.4,Alltrim(oRow:fieldGet(12) )))
							//aF0Acumulado[1] += VAL(CALCULA_F0(oRow:fieldGet(3),oRow:fieldGet(25),46.4,Alltrim(oRow:fieldGet(12) )))
						endif
						

               Next
			   
			   
			   
			   
SetProperty('Form_Relatorio','Label_17','BackColor', Verifica_F0_Acumulado(STR(aF0Acumulado[1]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )
SetProperty('Form_Relatorio','Label_18','BackColor', Verifica_F0_Acumulado(STR(aF0Acumulado[2]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )
SetProperty('Form_Relatorio','Label_19','BackColor', Verifica_F0_Acumulado(STR(aF0Acumulado[3]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )
SetProperty('Form_Relatorio','Label_20','BackColor', Verifica_F0_Acumulado(STR(aF0Acumulado[4]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )
Form_Relatorio.Label_17.Value :=	Alltrim(STR(aF0Acumulado[1],6,2	))
Form_Relatorio.Label_18.Value :=	Alltrim(STR(aF0Acumulado[2],6,2	))
Form_Relatorio.Label_19.Value :=	Alltrim(STR(aF0Acumulado[3],6,2	))
Form_Relatorio.Label_20.Value :=	Alltrim(STR(aF0Acumulado[4],6,2	))
			   

Aadd( aColunaXX , aColunaX )			   

		//msginfo(str(len(aColunaX)))
		//msginfo(str(len(aColunaY)))			
		   
			   
			   
oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Relatorio.Text_2.Value := Alltrim(oRow2:fieldGet(2))
Form_Relatorio.Text_3.Value :=Alltrim(oRow2:fieldGet(6))
Form_Relatorio.Text_4.Value :=Alltrim(oRow2:fieldGet(8))
Form_Relatorio.Text_5.Value :=Alltrim(oRow2:fieldGet(5))
Form_Relatorio.Text_6.Value :=Alltrim(oRow2:fieldGet(7))
Form_Relatorio.Text_7.Value :=Alltrim(oRow2:fieldGet(4))
Form_Relatorio.Text_8.Value :=Alltrim(DTOC(oRow2:fieldGet(3)))
Form_Relatorio.Edit_1.Value :=Alltrim(oRow2:fieldGet(26))
Form_Relatorio.Text_11.Value := cInicio_est // inicio esterilizacao
Form_Relatorio.Text_19.Value := cFinal_est // final esterilizacao			   
			   
ENDIF

IF oQuery:LastRec() >= 1						
	Form_Relatorio.Label_14.Value := "Total de Registros : " + Alltrim(STR(oQuery:LastRec()))
Elseif oQuery:LastRec() = 0
	MSGINFO("Consulta sem Registros")
endif

ENDIF



	Return Nil



*********************************************************************************************************************************************************************
Function Relatorio() && 1 ordem em 1 folha A4
*********************************************************************************************************************************************************************

local lSuccess := .f.
local cLB := chr( 10 )
lOCAL cArquivo, cData
Local cFonte1:= "Helvetica"
Local nFonte_size00 := 8
Local nFonte_size0 := 9
Local nFonte_size1 := 10
Local nFonte_size2 := 11
Local nFonte_size3 := 12
Local nFonte_size4 := 14
Local nFonte_size5 := 15
Local nTotal_material := 0
LOCAL aARQUI_Email := {}
Local cCodigo	:= Alltrim(Form_Relatorio.Text_1.Value)
Local cEdit1	:= Alltrim(Form_Relatorio.Edit_1.Value)
Local nPos := 1
Local nPage := 0
Local cTotal := "", cValor1 := "" , cValor2 :="", cEntrada := "" , cPendente := ""
Local nCount := 10
Local cData1 := ""
Local cSetor := ""
Local cCiclo := ""
Local cTempo_est := ""
Local cLote := ""
Local cCarga := ""
Local cOperador := ""
Local cData_EST := ""
Local cInicio_est := ""
Local cFinal_est := ""
Local lBlack := Form_Relatorio.Check_1.Value

Local cF0Acumulado1 := Alltrim(Form_Relatorio.Label_17.Value)
Local cF0Acumulado2 := Alltrim(Form_Relatorio.Label_18.Value)
Local cF0Acumulado3 := Alltrim(Form_Relatorio.Label_19.Value)
Local cF0Acumulado4 := Alltrim(Form_Relatorio.Label_20.Value)
Local aCfg_Rel1 := Carrega_Config_Relatorios("autoclaves")
Local aCfg_Rel2 := Carrega_Config_Relatorios("estufas")
/*
///////////////////////////////////////////////////////////////////////////////
// PDF CONFIGURATION CONSTANTS
///////////////////////////////////////////////////////////////////////////////


* Orientation

#define HPDF_ORIENT_PORTRAIT   1
#define HPDF_ORIENT_LANDSCAPE  2


* Paper Size

Syntax:
@ Row , Col HPDFPRINT cText ;
 [ FONT cFontName ] ;
 [ SIZE nFontSize ] ;
 [ COLOR aColor ] ;
 [ CENTER|RIGHT ]
Examples:
@ 205, 10 HPDFPRINT "This is a sample Text in default font."
This is a sample Text in default font.
@ 220, 10 HPDFPRINT "This is a sample Text in Times-Roman font." FONT "Times-Roman" SIZE 14
This is a sample Text in Times-Roman font.
@ 235, 200 HPDFPRINT "This is right aligned text" FONT "Courier-Bold" SIZE 14 RIGHT
This is right aligned text
@ 250, 105 HPDFPRINT "This is center aligned text" COLOR { 255, 0, 0 } CENTER
This is center aligned text
@ 270, 105 HPDFPRINT "This is text in bigger font size" SIZE 30 COLOR { 255, 0, 0 }
This is text in bigger font size
@ 290, 10 HPDFPRINT "The font is Tscparan.TTF" FONT "Tscparan.TTF" size 12


Syntax:
@ Row , Col HPDFPRINT cText ;
 TO ToRow, ToCol ;
 [ FONT cFontName ] ;
 [ SIZE nFontSize ] ;
 [ COLOR aColor ] ;
 [ CENTER|RIGHT ]
Examples:
@ 230, 10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned." to 250, 60
@ 230, 80 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area right aligned." to 250, 130 RIGHT
@ 230, 150 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area justified." to 250, 200 JUSTIFY
@ 255, 10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area justified." to 275, 60 JUSTIFY
*/
 
*******************************************************/  gera pdf na janela edicao orçamento///**********************************************

IF Form_Relatorio.Combo_1.Value == 1
	cMaquina := "Autoclave Luferco"
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Form_Relatorio.Combo_1.Value == 2
	cMaquina := "Autoclave Sercon"
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Form_Relatorio.Combo_1.Value == 3
	cMaquina := "Estufa 28"	
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ELSEIF Form_Relatorio.Combo_1.Value == 4
	cMaquina := "Estufa 26"	
	nTipo := 4
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ELSEIF Form_Relatorio.Combo_1.Value == 5
	cMaquina := "Estufa Leboc"
	nTipo := 5
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ENDIF


 
IF nTipo == 1 .OR. nTipo == 2 

cData1 := DTOC(Date())
cSetor := Form_Relatorio.Text_2.Value 
cCiclo := Form_Relatorio.Text_3.Value 
cTempo_est := Form_Relatorio.Text_4.Value 
cLote := Form_Relatorio.Text_5.Value 
cCarga := Form_Relatorio.Text_6.Value 
cOperador := Form_Relatorio.Text_7.Value 
cData_EST := Form_Relatorio.Text_8.Value
cInicio_est := Form_Relatorio.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio.Text_19.Value // final esterilizacao	

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio MasterServ " +cMaquina +"-"+ cCodigo + ".pdf" 


   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
      
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos MasterServ" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

             page = 1    
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	30, 10 HPDFPRINT RECTANGLE TO 52, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 31, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 38, 12 HPDFPRINT "F0 Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 38, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 175 HPDFPRINT "F0 Min. : " +  Alltrim(STR(aCfg_Rel1[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 45, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
     @ 55, 10 HPDFPRINT RECTANGLE TO 80, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 56, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 60, 15 HPDFPRINT cEdit1 TO 78, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 

   *------------------------------- CABE?LHO DA TABELA -----------------*          

	@ 82, 10 HPDFPRINT RECTANGLE TO 90, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 84, 13  HPDFPRINT "HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 84, 28  HPDFPRINT "SITUAÇÃO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 84, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 100 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 115 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 130 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 145 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 160 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 175 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 190 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 220 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 265 HPDFPRINT "P. INT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 280 HPDFPRINT "P. EXT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
 
 F:=91
 DO WHILE npos != (Form_Relatorio.Grid_1.ItemCount +1)
			
		aLinha := GetProperty ( 'Form_Relatorio' , 'Grid_1' , 'ITEM' , nPos )
		//cFabricante := PGENERIC( 1 , "descricao", "fabricantes" , "codigo" , Alltrim(aLinha [7]) )

		//msginfo(ALLtrim( "T = " + aLinha [11] + "  C = " + cCiclo ))
       *--------------------------------------------------*          
         
        *--- Colunas da tabela EM TODAS AS PAGINAS
		// {"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUA?O"}  
//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUAÇÃO"}		
		@ F, 13 HPDFPRINT Alltrim(aLinha [3]) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 28 HPDFPRINT Alltrim(aLinha [14]) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA DESCRIÇÃO
        @ F, 85 HPDFPRINT TRANSFORM(aLinha [6],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [6] , cCiclo, 4 , aLinha [14]  , 1,lBlack )  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [6]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT TRANSFORM(aLinha [7],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [7] , cCiclo, 4 , aLinha [14] , 1 ,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 130 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [7]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 145 HPDFPRINT TRANSFORM(aLinha [8],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [8] , cCiclo, 4 , aLinha [14] , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 160 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [8]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 175 HPDFPRINT TRANSFORM(aLinha [9],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [9] , cCiclo, 4 , aLinha [14] , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 190 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [9]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 205 HPDFPRINT TRANSFORM(aLinha [10],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [10] , cCiclo, 4 , aLinha [14] , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 220 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [10]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 265 HPDFPRINT TRANSFORM(aLinha [12],"99999") FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 280 HPDFPRINT TRANSFORM(aLinha [13],"99999") FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
		 
 npos ++
IF F > (91+90) .AND. npos < Form_Relatorio.Grid_1.ItemCount  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1

nPage ++
//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos MasterServ - " + Alltrim(STR(nPage))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 		HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Pagina: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	30, 10 HPDFPRINT RECTANGLE TO 52, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 31, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 38, 12 HPDFPRINT "F0 Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 38, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 175 HPDFPRINT "F0 Min. : " +  Alltrim(STR(aCfg_Rel1[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 45, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
 
	 @ 55, 10 HPDFPRINT RECTANGLE TO 80, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 56, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 60, 15 HPDFPRINT cEdit1 TO 78, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
          
        
   *------------------------ Logo da Empresa   -------------------------------*        
      //@ 16, 115 HPDFPRINT IMAGE "Logo_1.jpg" width 80 height 35 TYPE JPG
   
   *------------------------------- CABE?LHO DA TABELA -----------------*          
  
	//	{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
	@ 82, 10 HPDFPRINT RECTANGLE TO 90, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 84, 13  HPDFPRINT "HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 84, 28  HPDFPRINT "SITUAÇÃO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 84, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 100 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 115 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 130 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 145 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 160 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 175 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 190 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 220 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 265 HPDFPRINT "P. INT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 280 HPDFPRINT "P. EXT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	

	F := 91		  
ENDIF  	
ENDDO


	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo
      
ENDIF  





IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5

cData1 := DTOC(Date())
cSetor := Form_Relatorio.Text_2.Value 
cCiclo := Form_Relatorio.Text_3.Value 
cTempo_est := Form_Relatorio.Text_4.Value 
cLote := Form_Relatorio.Text_5.Value 
cCarga := Form_Relatorio.Text_6.Value 
cOperador := Form_Relatorio.Text_7.Value 
cData_EST := Form_Relatorio.Text_8.Value
cInicio_est := Form_Relatorio.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio.Text_19.Value // final esterilizacao	

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio MasterServ " +cMaquina +"-"+ cCodigo + ".pdf" 


   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
      
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos MasterServ" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

             page = 1    
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 		HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	30, 10 HPDFPRINT RECTANGLE TO 52, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 31, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 38, 12 HPDFPRINT "FH Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 38, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 175 HPDFPRINT "FH Min. : " +  Alltrim(STR(aCfg_Rel2[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 45, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
     @ 55, 10 HPDFPRINT RECTANGLE TO 80, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 56, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 60, 15 HPDFPRINT cEdit1 TO 78, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 

   *------------------------------- CABE?LHO DA TABELA -----------------*          

	@ 82, 10 HPDFPRINT RECTANGLE TO 90, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 84, 13  HPDFPRINT "HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 84, 28  HPDFPRINT "SITUAÇÃO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 84, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 100 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 115 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 130 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 145 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 160 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 175 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 190 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 220 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 235 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 250 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
 
 F:=91
 DO WHILE npos != (Form_Relatorio.Grid_1.ItemCount +1)
			
		aLinha := GetProperty ( 'Form_Relatorio' , 'Grid_1' , 'ITEM' , nPos )
		//cFabricante := PGENERIC( 1 , "descricao", "fabricantes" , "codigo" , Alltrim(aLinha [7]) )

       *--------------------------------------------------*          
    //           
        *--- Colunas da tabela EM TODAS AS PAGINAS
		// {"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUA?O"}       
		@ F, 13 HPDFPRINT Alltrim(aLinha [3]) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 28 HPDFPRINT Alltrim(aLinha [14]) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA DESCRIÇÃO
        @ F, 85 HPDFPRINT TRANSFORM(aLinha [6],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [6] , cCiclo, 15 , aLinha [14] , 2,lBlack)  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [6]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT TRANSFORM(aLinha [7],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [7] , cCiclo, 15 , aLinha [14], 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 130 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [7]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 145 HPDFPRINT TRANSFORM(aLinha [8],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [8] , cCiclo, 15 ,aLinha [14] , 2 ,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 160 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [8]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 175 HPDFPRINT TRANSFORM(aLinha [9],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [9] , cCiclo, 15 ,aLinha [14] , 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 190 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [9]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 205 HPDFPRINT TRANSFORM(aLinha [10],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [10] , cCiclo, 15, aLinha [14] , 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		//@ F, 220 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [10]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 235 HPDFPRINT TRANSFORM(aLinha [11],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( aLinha [11] , cCiclo, 15 , aLinha [14], 2,lBlack ) CENTER// COLUNA DESCRIÇÃO
		//@ F, 250 HPDFPRINT ALLtrim(CALCULA_F0(Val(aLinha [11]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		
          F:=F+5
		 
 npos ++
IF F > (91+90) .AND. npos < Form_Relatorio.Grid_1.ItemCount  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1

nPage ++
//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos MasterServ - " + Alltrim(STR(nPage))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 		HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Pagina: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	30, 10 HPDFPRINT RECTANGLE TO 50, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 31, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 38, 12 HPDFPRINT "FH Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 38, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 175 HPDFPRINT "FH Min. : " +  Alltrim(STR(aCfg_Rel2[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }	  
      @ 45, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
 
	 @ 55, 10 HPDFPRINT RECTANGLE TO 80, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 56, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 60, 15 HPDFPRINT cEdit1 TO 78, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
          
        
   *------------------------ Logo da Empresa   -------------------------------*        
      //@ 16, 115 HPDFPRINT IMAGE "Logo_1.jpg" width 80 height 35 TYPE JPG
   
   *------------------------------- CABE?LHO DA TABELA -----------------*          
  
	//	{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
	@ 82, 10 HPDFPRINT RECTANGLE TO 90, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 84, 13  HPDFPRINT "HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 84, 28  HPDFPRINT "SITUAÇÃO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 84, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 100 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 115 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 130 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 145 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 160 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 175 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 190 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 220 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 235 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 250 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	

	F := 91		  
ENDIF  	
ENDDO


	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo
      
ENDIF



*********************************************************************************************************************************************************************
Function Relatorio_Maq1_Mysql() && 1 ordem em 1 folha A4
*********************************************************************************************************************************************************************

local lSuccess := .f.
local cLB := chr( 10 )
lOCAL cArquivo, cData
Local cFonte1:= "Helvetica"
Local nFonte_size00 := 8
Local nFonte_size0 := 9
Local nFonte_size1 := 10
Local nFonte_size2 := 11
Local nFonte_size3 := 12
Local nFonte_size4 := 14
Local nFonte_size5 := 15
Local nTotal_material := 0
LOCAL aARQUI_Email := {}
Local cEdit1	:= ""
Local nPos := 1
Local nPage := 0
Local cTotal := "", cValor1 := "" , cValor2 :="", cEntrada := "" , cPendente := ""
Local nCount := 10
Local cData1 := ""
Local cSetor := ""
Local cCiclo := ""
Local cTempo_est := ""
Local cLote := ""
Local cCarga := ""
Local cOperador := ""
Local cData_EST := ""
Local cInicio_est := ""
Local cFinal_est := ""
Local lBlack := Form_Relatorio.Check_1.Value
Local cF0Acumulado1 := "" // Alltrim(Form_Relatorio.Label_17.Value)
Local cF0Acumulado2 := "" //Alltrim(Form_Relatorio.Label_18.Value)
Local cF0Acumulado3 := "" //Alltrim(Form_Relatorio.Label_19.Value)
Local cF0Acumulado4 := "" //Alltrim(Form_Relatorio.Label_20.Value)
Local aCfg_Rel1 := Carrega_Config_Relatorios("autoclaves")
Local aCfg_Rel2 := Carrega_Config_Relatorios("estufas")

Local aF0Acumulado := Array(6)
Local cMaquina := ""
Local cPesq := ALLTRIM( PegaValorDaColuna( "Grid_2" , "Form_Relatorio" , 2 ))
Local cMaquina1 := ALLTRIM( PegaValorDaColuna( "Grid_2" , "Form_Relatorio" , 1 ))

AFILL( aF0Acumulado,0,1, 6)	 // inicializa como numero e com zero


If Empty(cPesq)

			MsgExclamation("Nenhum Registro Informado para Edição!!","SISTEMA")
			Return Nil

Endif



IF Alltrim(cMaquina1) == "Autoclave Luferco"
	cMaquina := "Autoclave Luferco"
	cTabela := cTabela1
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Alltrim(cMaquina1) == "Autoclave Sercon"
	cMaquina := "Autoclave Sercon"
	cTabela := cTabela2
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Alltrim(cMaquina1) == "Estufa 28"
	cMaquina := "Estufa 28"	
	cTabela := cTabela3
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ELSEIF Alltrim(cMaquina1) == "Estufa 26"
	cMaquina := "Estufa 26"	
	cTabela := cTabela4
	nTipo := 4
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ELSEIF Alltrim(cMaquina1) == "EStufa 29"
	cMaquina := "Estufa Leboc"
	cTabela := cTabela5
	nTipo := 5
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ENDIF

                oQuery := oServer:Query( "Select * From " + cTabela + " WHERE codigo = " + cPesq + " Order By data, hora" ) 
					If oQuery:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif				
				
				oQuery1 := oServer:Query( "Select hora From " + cTabela + " WHERE codigo = " + cPesq + " AND situacao = 'ESTERILIZAÇÃO' " + " Order By data , hora")

					
					If oQuery1:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery1:Error())
					Endif	


		IF oQuery1:LastRec() >= 1
				
               For i2:= 1 To oQuery1:LastRec()
                        oRow1 := oQuery1:GetRow(i2)
				
					//msginfo(STR(i2) + " - " + Alltrim(oRow1:fieldGet(1) ) )
					IF I2 == 1	
						cInicio_est := Alltrim( oRow1:fieldGet(1) )
					ENDIF
					
					IF I2 == oQuery1:LastRec()
						cFinal_est := Alltrim(oRow1:fieldGet(1) )
					ENDIF
					
					oQuery1:Skip(1)
               Next
				

		ENDIF
				  			  

			     oQuery2 := oServer:Query( "Select * From " + cTabela + " WHERE codigo = " + cPesq + " Order By data, hora" )  
					
					If oQuery2:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery2:Error())
					Endif	


		IF oQuery2:LastRec() >= 1
				
               For i3:= 1 To oQuery2:LastRec()
                        oRow3 := oQuery2:GetRow(i3)
						IF nTipo == 1 .OR. nTipo == 2
								aF0Acumulado[1] := aF0Acumulado[1] + VAL(CALCULA_F0_2(oRow3:fieldGet(12),VAL(oRow3:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[2] := aF0Acumulado[2] + VAL(CALCULA_F0_2(oRow3:fieldGet(14),VAL(oRow3:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[3] := aF0Acumulado[3] + VAL(CALCULA_F0_2(oRow3:fieldGet(16),VAL(oRow3:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[4] := aF0Acumulado[4] + VAL(CALCULA_F0_2(oRow3:fieldGet(18),VAL(oRow3:fieldGet(6)),aCfg_Rel1[4] ))
						endif
						
						IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5 
							aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow3:fieldGet(12),VAL(oRow3:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[2] += VAL(CALCULA_F0_2(oRow3:fieldGet(14),VAL(oRow3:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[3] += VAL(CALCULA_F0_2(oRow3:fieldGet(16),VAL(oRow3:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[4] += VAL(CALCULA_F0_2(oRow3:fieldGet(18),VAL(oRow3:fieldGet(6)),aCfg_Rel2[4] ))
							//aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow:fieldGet(3),oRow:fieldGet(25),46.4,UTF8ToStr(oRow:fieldGet(12) )))
							//aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow:fieldGet(3),oRow:fieldGet(25),46.4,UTF8ToStr(oRow:fieldGet(12) )))
						endif				
					
					oQuery2:Skip(1)
               Next

		ENDIF


cF0Acumulado1 :=	Alltrim(STR(aF0Acumulado[1],6,2	))
cF0Acumulado2 :=	Alltrim(STR(aF0Acumulado[2],6,2	))
cF0Acumulado3 :=	Alltrim(STR(aF0Acumulado[3],6,2	))
cF0Acumulado4 :=	Alltrim(STR(aF0Acumulado[4],6,2	))



*******************************************************/  gera pdf na janela edicao orçamento///**********************************************
cCodigo := cPesq


 
IF nTipo == 1 .OR. nTipo == 2 
oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
cData1 := DTOC(Date())
cSetor := alltrim( oRow2:FieldGet(2) )
cCiclo := alltrim( oRow2:FieldGet(6) )
cTempo_est := alltrim(oRow2:FieldGet(8)) 
cLote := alltrim(oRow2:FieldGet(5))
cCarga := alltrim(oRow2:FieldGet(7))
cOperador := alltrim( oRow2:FieldGet(4))
cData_EST := Alltrim(DTOC(oRow2:fieldGet(3)))
cEdit1 := alltrim( oRow2:FieldGet(26)) ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))


//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio MasterServ(M) " +cMaquina +"-"+ cCodigo + ".pdf" 


   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
      
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos MasterServ" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

             page = 1    
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 		HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	30, 10 HPDFPRINT RECTANGLE TO 52, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 31, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 38, 12 HPDFPRINT "F0 Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 38, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 175 HPDFPRINT "F0 Min. : " +  Alltrim(STR(aCfg_Rel1[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 45, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
     @ 55, 10 HPDFPRINT RECTANGLE TO 80, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 56, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 60, 15 HPDFPRINT cEdit1 TO 78, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 

   *------------------------------- CABE?LHO DA TABELA -----------------*          

	@ 82, 10 HPDFPRINT RECTANGLE TO 90, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 84, 13  HPDFPRINT "HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 84, 28  HPDFPRINT "SITUAÇÃO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 84, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 100 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 115 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 130 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 145 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 160 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 175 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 190 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 220 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 235 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 250 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 265 HPDFPRINT "P. INT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 280 HPDFPRINT "P. EXT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
 
 F:=91
IF oQuery:LastRec() >= 1
               For npos:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(npos)
			
        
        *--- Colunas da tabela EM TODAS AS PAGINAS
//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}

		@ F, 13 HPDFPRINT alltrim(oRow:fieldGet(10) ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 28 HPDFPRINT alltrim(oRow:FieldGet(11)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA DESCRIÇÃO
        @ F, 85 HPDFPRINT Alltrim(STR(oRow:FieldGet(12),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(12))) , cCiclo, 4 , alltrim(oRow:FieldGet(11)) , 1,lBlack)  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(12),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT Alltrim(STR(oRow:FieldGet(14),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(14))) , cCiclo, 4 , alltrim(oRow:FieldGet(11)), 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 130 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(14),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 145 HPDFPRINT Alltrim(STR(oRow:FieldGet(16),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(16))) , cCiclo, 4 ,alltrim(oRow:FieldGet(11)) , 1 ,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 160 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(16),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 175 HPDFPRINT Alltrim(STR(oRow:FieldGet(18),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(18))) , cCiclo, 4 ,alltrim(oRow:FieldGet(11)) , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 190 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(18),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 205 HPDFPRINT Alltrim(STR(oRow:FieldGet(20),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(20))) , cCiclo, 4 , alltrim(oRow:FieldGet(11)) , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 220 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(20),Val(cCiclo),aCfg_Rel1[4] ) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 265 HPDFPRINT Alltrim(STR(oRow:FieldGet(25),0,2)) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 280 HPDFPRINT Alltrim(STR(oRow:FieldGet(24),0,2)) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
	 

IF F > (91+90) .AND. npos < oQuery:LastRec()  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1

//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos MasterServ - " + Alltrim(STR(nPage))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25, 12 	HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25, 170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Pagina: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	30, 10 HPDFPRINT RECTANGLE TO 52 , 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 31, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 38, 12 HPDFPRINT "F0 Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 38, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 175 HPDFPRINT "F0 Min. : " +  Alltrim(STR(aCfg_Rel1[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 45, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
 
	 @ 55, 10 HPDFPRINT RECTANGLE TO 80, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 56, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 60, 15 HPDFPRINT cEdit1 TO 78, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
          
        
   *------------------------ Logo da Empresa   -------------------------------*        
      //@ 16, 115 HPDFPRINT IMAGE "Logo_1.jpg" width 80 height 35 TYPE JPG
   
   *------------------------------- CABE?LHO DA TABELA -----------------*          
  
	//	{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
	@ 82, 10 HPDFPRINT RECTANGLE TO 90, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 84, 13  HPDFPRINT "HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 84, 28  HPDFPRINT "SITUAÇÃO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 84, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 100 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 115 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 130 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 145 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 160 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 175 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 190 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 220 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 265 HPDFPRINT "P. INT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 280 HPDFPRINT "P. EXT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	

	F := 91		  
ENDIF 
		oQuery:Skip(1)
Next
ENDIF 

	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo
      
ENDIF  





IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5

oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
cData1 := DTOC(Date())
cSetor := alltrim( oRow2:FieldGet(2) )
cCiclo := alltrim( oRow2:FieldGet(6) )
cTempo_est := alltrim(oRow2:FieldGet(8)) 
cLote := alltrim(oRow2:FieldGet(5))
cCarga := alltrim(oRow2:FieldGet(7))
cOperador := alltrim( oRow2:FieldGet(4))
cData_EST := Alltrim(DTOC(oRow2:fieldGet(3)))
cEdit1 := alltrim( oRow2:FieldGet(26)) ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio MasterServ(M) " +cMaquina +"-"+ cCodigo + ".pdf" 


   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
      
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos MasterServ" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

             page = 1    
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	30, 10 HPDFPRINT RECTANGLE TO 52 , 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 31, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 38, 12 HPDFPRINT "FH Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 38, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 175 HPDFPRINT "FH Min. : " +  Alltrim(STR(aCfg_Rel2[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }	  
      @ 45, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
     @ 55, 10 HPDFPRINT RECTANGLE TO 80, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 56, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 60, 15 HPDFPRINT cEdit1 TO 78, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 

   *------------------------------- CABE?LHO DA TABELA -----------------*          

	@ 82, 10 HPDFPRINT RECTANGLE TO 90, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 84, 13  HPDFPRINT "HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 84, 28  HPDFPRINT "SITUAÇÃO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 84, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 100 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 115 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 130 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 145 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 160 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 175 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 190 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 220 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 235 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 250 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 265 HPDFPRINT "P. EXT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 280 HPDFPRINT "P. INT" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
 
 F:=91
IF oQuery:LastRec() >= 1 
 For npos:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(npos)
		//cFabricante := PGENERIC( 1 , "descricao", "fabricantes" , "codigo" , Alltrim(aLinha [7]) )

       *--------------------------------------------------*          
    //           
        *--- Colunas da tabela EM TODAS AS PAGINAS
		// {"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUA?O"}       
		@ F, 13 HPDFPRINT alltrim(oRow:fieldGet(10) ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 28 HPDFPRINT alltrim(oRow:FieldGet(11)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA DESCRIÇÃO
        @ F, 85 HPDFPRINT Alltrim(STR(oRow:FieldGet(12),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(12))) , cCiclo, 15 , alltrim(oRow:FieldGet(11)) , 1,lBlack)  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(12),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT Alltrim(STR(oRow:FieldGet(14),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(14))) , cCiclo, 15 , alltrim(oRow:FieldGet(11)), 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 130 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(14),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 145 HPDFPRINT Alltrim(STR(oRow:FieldGet(16),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(16))) , cCiclo, 15 ,alltrim(oRow:FieldGet(11)) , 1 ,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 160 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(16),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 175 HPDFPRINT Alltrim(STR(oRow:FieldGet(18),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(18))) , cCiclo, 15 ,alltrim(oRow:FieldGet(11)) , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 190 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(18),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
		 

IF F > (91+90) .AND. npos < oQuery:LastRec()  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1

//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos MasterServ - " + Alltrim(STR(nPage))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Pagina: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	30, 10 HPDFPRINT RECTANGLE TO 52 , 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 31, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 31, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 38, 12 HPDFPRINT "FH Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 38, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 38, 175 HPDFPRINT "FH Min. : " +  Alltrim(STR(aCfg_Rel2[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 45, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 45, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
 
	 @ 55, 10 HPDFPRINT RECTANGLE TO 80, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 56, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 60, 15 HPDFPRINT cEdit1 TO 78, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
          
        
   *------------------------ Logo da Empresa   -------------------------------*        
      //@ 16, 115 HPDFPRINT IMAGE "Logo_1.jpg" width 80 height 35 TYPE JPG
   
   *------------------------------- CABE?LHO DA TABELA -----------------*          
  
	//	{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
	@ 82, 10 HPDFPRINT RECTANGLE TO 90, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 84, 13  HPDFPRINT "HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 84, 28  HPDFPRINT "SITUAÇÃO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 84, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 100 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 115 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 130 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 145 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 160 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 175 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 190 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 220 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 235 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 250 HPDFPRINT "FH" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	

	F := 91		  
ENDIF 
		oQuery:Skip(1)
Next
ENDIF 

	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo
      
ENDIF 

      
****************************************************************************************
Function Verifica_F0_Acumulado( cF0 ,nMaquina,nF0_Min_Autoclaves,nF0_Min_Estufas )
****************************************************************************************
Local aColor_temp := BLACK   /// quando estiver fora de esterilizao fonte color igual a preto
acolor_ok := {38,167,0}	 // verde mais escuro que o padrao

/*
	aColor [1] := YELLOW	
	aColor [2] := PINK	
	aColor [3] := RED	
	aColor [4] := FUCHSIA  // rosa claro	
	aColor [5] := BROWN	
	aColor [6] := ORANGE	
	aColor [7] := GREEN	
	aColor [8] := PURPLE	
	aColor [9] := BLACK	
	aColor [10] := BLUE
*/

IF nMaquina == 1 .OR. nMaquina == 2
	if   Val(cF0) >=  nF0_Min_Autoclaves
			aColor_temp := acolor_ok
	elseif   Val(cF0) < nF0_Min_Autoclaves 
			aColor_temp := RED
	endif
		
ELSEIF nMaquina == 3 .OR. nMaquina == 4 .OR. nMaquina == 5
	if Val(cF0) >= nF0_Min_Estufas
			aColor_temp := acolor_ok
	elseif  Val(cF0) < nF0_Min_Estufas  
			aColor_temp := RED
	endif
endif
Return(aColor_temp)

	
****************************************************************************************
Function Verifica_temp( cTemp , cCiclo, nTolerancia , cSituacao ,nMaquina , lBlack )
****************************************************************************************
Local aColor_temp := BLACK   /// quando estiver fora de esterilizao fonte color igual a preto
Private nTemp_max := 0
Private nTemp_min := 0
acolor_ok := {38,167,0}	 // verde mais escuro que o padrao


/*
	aColor [1] := YELLOW	
	aColor [2] := PINK	
	aColor [3] := RED	
	aColor [4] := FUCHSIA	
	aColor [5] := BROWN	
	aColor [6] := ORANGE	
	aColor [7] := GREEN	
	aColor [8] := PURPLE	
	aColor [9] := BLACK	
	aColor [10] := BLUE
*/

IF nMaquina == 2 
nTemp_max := VAL(cCiclo) + nTolerancia
nTemp_min := VAL(cCiclo) - nTolerancia
ELSEIF nMaquina == 1
nTemp_max := VAL(cCiclo) + nTolerancia
nTemp_min := VAL(cCiclo) - (nTolerancia/2)
endif 


IF VAL(cTemp) > nTemp_max .AND. Alltrim(cSituacao) == "ESTERILIZAÇÃO"

	IF !lBlack 
		aColor_temp := FUCHSIA
	else
		aColor_temp := BLACK
	endif

ELSEIF VAL(cTemp) < nTemp_min .AND. Alltrim(cSituacao) == "ESTERILIZAÇÃO"

	IF !lBlack
		aColor_temp := RED
	else
		aColor_temp := BLACK
	endif

ELSEIF VAL(cTemp) > nTemp_min .AND. VAL(cTemp) < nTemp_max  .AND. Alltrim(cSituacao) == "ESTERILIZAÇÃO"

	IF !lBlack
		aColor_temp := acolor_ok
	else
		aColor_temp := BLACK
	endif
ENDIF

Return(aColor_temp)





*************************************************************************************************************************************
Function Pesquisa_Relatorio_Esterilizacao_Maquinas()
*************************************************************************************************************************************
	Local dData1	:= Form_Relatorio.DatePicker_2.Value	
    Local dData2	:= Form_Relatorio.DatePicker_3.Value
	Local i           					:= 0
	Local i2           					:= 0
	Local oRow     						:= {}
	Local oQuery      				:= "" 
	Local oRow1     						:= {}
	Local oRow2    						:= {}
	Local oQuery1      				:= ""	
	Local aColunaX := {}
	Local cInicio_est := ""
	Local cFinal_est  := ""
	Local cTabela := ""
	Local cMaquina := ""


IF Form_Relatorio.Combo_2.Value == 1
	cTabela := cTabela1
	cMaquina := "Autoclave Luferco"
ELSEIF Form_Relatorio.Combo_2.Value == 2
	cTabela := cTabela2
	cMaquina := "Autoclave Sercon"	
ELSEIF Form_Relatorio.Combo_2.Value == 3
	cTabela := cTabela3
	cMaquina := "Estufa 28"	
ELSEIF Form_Relatorio.Combo_2.Value == 4
	cTabela := cTabela4
	cMaquina := "Estufa 26"	
ELSEIF Form_Relatorio.Combo_2.Value == 5
	cTabela := cTabela5
	cMaquina := "Estufa Leboc"	
ENDIF



	
IF IsWindowActive(Form_Relatorio)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_3 OF Form_Relatorio

	
		If Empty (Form_Relatorio.DatePicker_3.Value)
				oQuery := oServer:Query( " Select * From " + cTabela + " WHERE data = " + Data_BRITISH_ANSI( dData1)  + " AND situacao = 'ESTERILIZAÇÃO' " + " Order By data , hora" )
		ELSE
				
				oQuery := oServer:Query( " Select * From " + cTabela + " WHERE data >= " + Data_BRITISH_ANSI( dData1) + " AND data <= " + Data_BRITISH_ANSI( dData2) + " AND situacao = 'ESTERILIZAÇÃO' " + " Order By data , hora" )
		ENDIF
		
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
					

				
 IF oQuery:LastRec() >= 1					
	//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUAÇÃO" ,"SETOR","CICLO","LOTE","CARGA","OPERADOR"}
               For i:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(1)) )  ,;
						DTOC( oRow:fieldGet(3) ) ,;
						Alltrim(oRow:fieldGet(10) ),;
						cMaquina ,;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(STR(oRow:fieldGet(12) )),;
						Alltrim(STR(oRow:fieldGet(14) )),;
						Alltrim(STR(oRow:fieldGet(16) )),;
						Alltrim(STR(oRow:fieldGet(18) )),;
						Alltrim(STR(oRow:fieldGet(20) )),;
						Alltrim(STR(oRow:fieldGet(22) )),;
						Alltrim(STR(oRow:fieldGet(25) )),;
						Alltrim(STR(oRow:fieldGet(24) )),;
						Alltrim(oRow:fieldGet(11) ),;
						Alltrim(oRow:fieldGet(2) ),;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(oRow:fieldGet(5) ),;
						Alltrim(oRow:fieldGet(7) ),;
						Alltrim(oRow:fieldGet(4) )} TO Grid_3 OF Form_Relatorio
						oQuery:Skip(1)
						Aadd( aColunaX , oRow:fieldGet(14)  )
						Aadd( aColunaY , Alltrim(oRow:fieldGet(10) )  )
						

               Next

Aadd( aColunaXX , aColunaX )			   

		//msginfo(str(len(aColunaX)))
		//msginfo(str(len(aColunaY)))			
		   
			   
/*			   
oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Relatorio.Text_2.Value := Alltrim(oRow2:fieldGet(2))
Form_Relatorio.Text_3.Value :=Alltrim(oRow2:fieldGet(6))
Form_Relatorio.Text_4.Value :=Alltrim(oRow2:fieldGet(8))
Form_Relatorio.Text_5.Value :=Alltrim(oRow2:fieldGet(5))
Form_Relatorio.Text_6.Value :=Alltrim(oRow2:fieldGet(7))
Form_Relatorio.Text_7.Value :=Alltrim(oRow2:fieldGet(4))
Form_Relatorio.Text_8.Value :=Alltrim(DTOC(oRow2:fieldGet(3)))
Form_Relatorio.Edit_1.Value :=Alltrim(oRow2:fieldGet(26))
Form_Relatorio.Text_11.Value := cInicio_est // inicio esterilizacao
Form_Relatorio.Text_19.Value := cFinal_est // final esterilizacao			   
*/
			   
ENDIF

ENDIF

IF oQuery:LastRec() >= 1						
	Form_Relatorio.Label_13.Value := "Total de Registros : " + Alltrim(STR(oQuery:LastRec()))
Elseif oQuery:LastRec() = 0
	MSGINFO("Consulta sem Registros")
endif


	Return Nil


*********************************************************************************************************************************************************************
Function Historico_Data_esterilizacao_Maq() && 1 ordem em 1 folha A4
*********************************************************************************************************************************************************************
*************************************************************************************************************************************
Local dData1	:= Form_Relatorio.DatePicker_2.Value	
Local dData2	:= Form_Relatorio.DatePicker_3.Value
local lSuccess := .f.
local cLB := chr( 10 )
lOCAL cArquivo, cData
Local cFonte1:= "Helvetica"
Local nFonte_size00 := 8
Local nFonte_size0 := 9
Local nFonte_size1 := 10
Local nFonte_size2 := 11
Local nFonte_size3 := 12
Local nFonte_size4 := 14
Local nFonte_size5 := 15
Local nTotal_material := 0
LOCAL aARQUI_Email := {}
Local cCodigo	:= ""//Alltrim(Form_Relatorio.Text_1.Value)
Local cEdit1	:= ""//Alltrim(Form_Relatorio.Edit_1.Value)
Local nPos := 1
Local nPage := 0
Local cTotal := "", cValor1 := "" , cValor2 :="", cEntrada := "" , cPendente := ""
Local nCount := 10
Local cData1 := ""
Local cSetor := ""
Local cCiclo := ""
Local cTempo_est := ""
Local cLote := ""
Local cCarga := ""
Local cOperador := ""
Local cData_EST := ""
Local cInicio_est := ""
Local cFinal_est := ""
Local lBlack := Form_Relatorio.Check_2.Value

/*
///////////////////////////////////////////////////////////////////////////////
// PDF CONFIGURATION CONSTANTS
///////////////////////////////////////////////////////////////////////////////


* Orientation

#define HPDF_ORIENT_PORTRAIT   1
#define HPDF_ORIENT_LANDSCAPE  2


* Paper Size

Syntax:
@ Row , Col HPDFPRINT cText ;
 [ FONT cFontName ] ;
 [ SIZE nFontSize ] ;
 [ COLOR aColor ] ;
 [ CENTER|RIGHT ]
Examples:
@ 205, 10 HPDFPRINT "This is a sample Text in default font."
This is a sample Text in default font.
@ 220, 10 HPDFPRINT "This is a sample Text in Times-Roman font." FONT "Times-Roman" SIZE 14
This is a sample Text in Times-Roman font.
@ 235, 200 HPDFPRINT "This is right aligned text" FONT "Courier-Bold" SIZE 14 RIGHT
This is right aligned text
@ 250, 105 HPDFPRINT "This is center aligned text" COLOR { 255, 0, 0 } CENTER
This is center aligned text
@ 270, 105 HPDFPRINT "This is text in bigger font size" SIZE 30 COLOR { 255, 0, 0 }
This is text in bigger font size
@ 290, 10 HPDFPRINT "The font is Tscparan.TTF" FONT "Tscparan.TTF" size 12


Syntax:
@ Row , Col HPDFPRINT cText ;
 TO ToRow, ToCol ;
 [ FONT cFontName ] ;
 [ SIZE nFontSize ] ;
 [ COLOR aColor ] ;
 [ CENTER|RIGHT ]
Examples:
@ 230, 10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned." to 250, 60
@ 230, 80 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area right aligned." to 250, 130 RIGHT
@ 230, 150 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area justified." to 250, 200 JUSTIFY
@ 255, 10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area justified." to 275, 60 JUSTIFY
*/
 
*******************************************************/  gera pdf na janela edicao orçamento///**********************************************

IF Form_Relatorio.Combo_2.Value == 1
	cMaquina := "Autoclave Luferco"
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
	cTabela := cTabela1
ELSEIF Form_Relatorio.Combo_2.Value == 2
	cMaquina := "Autoclave Sercon"
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
	cTabela := cTabela2
ELSEIF Form_Relatorio.Combo_2.Value == 3
	cMaquina := "Estufa 28"	
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
	cTabela := cTabela3
ELSEIF Form_Relatorio.Combo_2.Value == 4
	cMaquina := "Estufa 26"	
	nTipo := 4
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
	cTabela := cTabela4
ELSEIF Form_Relatorio.Combo_2.Value == 5
	cMaquina := "Estufa Leboc"
	nTipo := 5
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
	cTabela := cTabela5
ENDIF



		If Empty (Form_Relatorio.DatePicker_3.Value)
				oQuery := oServer:Query( " Select * From " + cTabela + " WHERE data = " + Data_BRITISH_ANSI( dData1)  + " AND situacao = 'ESTERILIZAÇÃO' " + " Order By data , hora" )
		ELSE
				
				oQuery := oServer:Query( " Select * From " + cTabela + " WHERE data >= " + Data_BRITISH_ANSI( dData1) + " AND data <= " + Data_BRITISH_ANSI( dData2) + " AND situacao = 'ESTERILIZAÇÃO' " + " Order By data , hora" )
		ENDIF
		
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif


					
 
IF nTipo == 1 .OR. nTipo == 2 

cData1 := DTOC(Date())


/*
cSetor := Form_Relatorio.Text_2.Value 
cCiclo := Form_Relatorio.Text_3.Value 
cTempo_est := Form_Relatorio.Text_4.Value 
cLote := Form_Relatorio.Text_5.Value 
cCarga := Form_Relatorio.Text_6.Value 
cOperador := Form_Relatorio.Text_7.Value 
cData_EST := Form_Relatorio.Text_8.Value
cInicio_est := Form_Relatorio.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio.Text_19.Value // final esterilizacao	
*/



					

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Historico MasterServ " +cMaquina +"_"+ cCodigo + hb_DTOC(dData1,"DD-MM-YYYY") + IIF(EMPTY(dData2),"", " - " + hb_DTOC(dData2,"DD-MM-YYYY")) + ".pdf" 


   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
             page = 1       
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Histórico de Eventos MasterServ - " + Alltrim(STR(Page)) 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

   
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
		@ 25,12 	HPDFPRINT "Histórico de Esterilização MasterServ - " + cMaquina + + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


 

   *------------------------------- CABE?LHO DA TABELA -----------------*          
	//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUAÇÃO" ,"SETOR","CICLO","LOTE","CARGA","OPERADOR"}
	@ 30, 10 HPDFPRINT RECTANGLE TO 38, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 32, 13  HPDFPRINT "DATA/HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 32, 60  HPDFPRINT "SEQUENCIA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER	
	@ 32, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 100 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 115 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 130 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 145 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 150 HPDFPRINT "SETOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 205 HPDFPRINT "CICLO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 220 HPDFPRINT "LOTE" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 245 HPDFPRINT "OPERADOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 265 HPDFPRINT "P. INT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 280 HPDFPRINT "P. EXT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
 
 F:=39
 
  IF oQuery:LastRec() >= 1					
	//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUAÇÃO" ,"SETOR","CICLO","LOTE","CARGA","OPERADOR"}
               For i:= 1 To oQuery:LastRec()
			
		oRow := oQuery:GetRow(i)
		cCiclo := Alltrim(oRow:fieldGet(6))
        //@ 25,12 	HPDFPRINT "Histórico de Esterilização - " + cMaquina + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER

		//msginfo(ALLtrim( "T = " + oRow [11] + "  C = " + cCiclo ))
		//Function Verifica_temp( cTemp , cCiclo, nTolerancia , cSituacao ,nMaquina )
        *--- Colunas da tabela EM TODAS AS PAGINAS
		@ F, 13  HPDFPRINT DTOC(oRow:fieldGet(3)) +" - " + Alltrim(oRow:fieldGet(10)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 60  HPDFPRINT Alltrim(str(oRow:fieldGet(1))) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
        @ F, 85  HPDFPRINT Alltrim(str(oRow:fieldGet(12))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(12))) , cCiclo, 4 , Alltrim(oRow:fieldGet(11)) , 1 , lBlack )  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT Alltrim(str(oRow:fieldGet(14))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(14))) , cCiclo, 4 , Alltrim(oRow:fieldGet(11)) , 1 , lBlack ) CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT Alltrim(str(oRow:fieldGet(16))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(16))) , cCiclo, 4 , Alltrim(oRow:fieldGet(11)) , 1 , lBlack )CENTER// COLUNA DESCRIÇÃO 
		@ F, 130 HPDFPRINT Alltrim(str(oRow:fieldGet(18))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(18))) , cCiclo, 4 , Alltrim(oRow:fieldGet(11)) , 1 , lBlack ) CENTER// COLUNA DESCRIÇÃO 
		@ F, 145 HPDFPRINT Alltrim(str(oRow:fieldGet(20))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(20))) , cCiclo, 4 , Alltrim(oRow:fieldGet(11)) , 1 , lBlack ) CENTER// COLUNA DESCRIÇÃO
		@ F, 180 HPDFPRINT Alltrim(oRow:fieldGet(2)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 205 HPDFPRINT Alltrim(oRow:fieldGet(6)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 220 HPDFPRINT Alltrim(oRow:fieldGet(5)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 245 HPDFPRINT Alltrim(oRow:fieldGet(4)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 265 HPDFPRINT Alltrim(str(oRow:fieldGet(25))) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 280 HPDFPRINT Alltrim(str(oRow:fieldGet(24))) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
		 
IF F > (39+140) .AND. i < oQuery:LastRec()  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page + 1


	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Histórico de Eventos MasterServ - " + Alltrim(STR(Page))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Histórico de Esterilização MasterServ - " + cMaquina + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Pagina: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER

        
   *------------------------------- CABE?LHO DA TABELA -----------------*          
  
	//	{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
	@ 30, 10 HPDFPRINT RECTANGLE TO 38, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 32, 13  HPDFPRINT "DATA/HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 32, 50  HPDFPRINT "SEQUENCIA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } //CENTER	
	@ 32, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 100 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 115 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 130 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 145 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 180 HPDFPRINT "SETOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 205 HPDFPRINT "CICLO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 220 HPDFPRINT "LOTE" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 245 HPDFPRINT "OPERADOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 265 HPDFPRINT "P. INT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 280 HPDFPRINT "P. EXT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	

	F := 39		  
ENDIF  

		oQuery:Skip(1)
Next

ENDIF
	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo

ENDIF  





IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5

cData1 := DTOC(Date())
/*
cSetor := Form_Relatorio.Text_2.Value 
cCiclo := Form_Relatorio.Text_3.Value 
cTempo_est := Form_Relatorio.Text_4.Value 
cLote := Form_Relatorio.Text_5.Value 
cCarga := Form_Relatorio.Text_6.Value 
cOperador := Form_Relatorio.Text_7.Value 
cData_EST := Form_Relatorio.Text_8.Value
cInicio_est := Form_Relatorio.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio.Text_19.Value // final esterilizacao	
*/

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Historico MasterServ " +cMaquina +"_"+ cCodigo + hb_DTOC(dData1,"DD-MM-YYYY") + IIF(EMPTY(dData2),"", " - " + hb_DTOC(dData2,"DD-MM-YYYY")) + ".pdf" 


   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
             page = 1       
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Histórico de Eventos MasterServ - " + Alltrim(STR(Page))
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

   
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Histórico de Esterilização MasterServ - " + cMaquina + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      /*
	  @	30, 10 HPDFPRINT RECTANGLE TO 50, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     */
	 

   *------------------------------- CABE?LHO DA TABELA -----------------*          

	@ 30, 10 HPDFPRINT RECTANGLE TO 38, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 32, 13  HPDFPRINT "DATA/HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 32, 60  HPDFPRINT "SEQUENCIA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER	
	@ 32, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 100 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 115 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 130 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 32, 145 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 32, 160 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 180 HPDFPRINT "SETOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 205 HPDFPRINT "CICLO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 220 HPDFPRINT "LOTE" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 245 HPDFPRINT "OPERADOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
 
 F:=39
 
  IF oQuery:LastRec() >= 1					
	//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUAÇÃO" ,"SETOR","CICLO","LOTE","CARGA","OPERADOR"}
               For i:= 1 To oQuery:LastRec()
			
		oRow := oQuery:GetRow(i)
		cCiclo := Alltrim(oRow:fieldGet(6))

       *--------------------------------------------------*          
    //           
        *--- Colunas da tabela EM TODAS AS PAGINAS
		// {"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUA?O"}       
		@ F, 13  HPDFPRINT DTOC(oRow:fieldGet(3)) +" - " + Alltrim(oRow:fieldGet(10)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 60  HPDFPRINT Alltrim(str(oRow:fieldGet(1))) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
        @ F, 85  HPDFPRINT Alltrim(str(oRow:fieldGet(12))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(12))) , cCiclo, 15 , Alltrim(oRow:fieldGet(11)) , 2 , lBlack )  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT Alltrim(str(oRow:fieldGet(14))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(14))) , cCiclo, 15 , Alltrim(oRow:fieldGet(11)) , 2 , lBlack ) CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT Alltrim(str(oRow:fieldGet(16))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(16))) , cCiclo, 15 , Alltrim(oRow:fieldGet(11)) , 2 , lBlack ) CENTER// COLUNA DESCRIÇÃO 
		@ F, 130 HPDFPRINT Alltrim(str(oRow:fieldGet(18))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(18))) , cCiclo, 15 , Alltrim(oRow:fieldGet(11)) , 2 , lBlack ) CENTER// COLUNA DESCRIÇÃO 
		//@ F, 145 HPDFPRINT Alltrim(str(oRow:fieldGet(20))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(20))) , cCiclo, 15 , Alltrim(oRow:fieldGet(11)) , 2 , lBlack ) CENTER// COLUNA DESCRIÇÃO
		//@ F, 160 HPDFPRINT Alltrim(str(oRow:fieldGet(22))) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp( Alltrim(STR(oRow:fieldGet(22))) , cCiclo, 15 , Alltrim(oRow:fieldGet(11)) , 2 , lBlack ) CENTER// COLUNA DESCRIÇÃO
		@ F, 180 HPDFPRINT Alltrim(oRow:fieldGet(2)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 205 HPDFPRINT Alltrim(oRow:fieldGet(6)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 220 HPDFPRINT Alltrim(oRow:fieldGet(5)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 245 HPDFPRINT Alltrim(oRow:fieldGet(4)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
		 

IF F > (39+140) .AND. npos < Form_Relatorio.Grid_3.ItemCount  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1


//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Histórico de Eventos MasterServ - " + Alltrim(STR(Page))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 		HPDFPRINT "Histórico de Esterilização MasterServ - " + cMaquina + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 25,170 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
        @ 25, 260 	HPDFPRINT "Pagina: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      //@	30, 10 HPDFPRINT RECTANGLE TO 50, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
     // @ 31, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
 
          
        
   *------------------------ Logo da Empresa   -------------------------------*        
      //@ 16, 115 HPDFPRINT IMAGE "Logo_1.jpg" width 80 height 35 TYPE JPG
   
   *------------------------------- CABE?LHO DA TABELA -----------------*          
  
	//	{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
	@ 30, 10 HPDFPRINT RECTANGLE TO 38, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }  

	@ 32, 13  HPDFPRINT "DATA/HORA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } // CENTER
	@ 32, 60  HPDFPRINT "SEQUENCIA" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER	
	@ 32, 85  HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 100 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 115 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 130 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 32, 145 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 32, 160 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 180 HPDFPRINT "SETOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 205 HPDFPRINT "CICLO" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 220 HPDFPRINT "LOTE" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 245 HPDFPRINT "OPERADOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	

	F := 39	  
ENDIF

		oQuery:Skip(1)
Next

ENDIF


	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo
      
ENDIF 

  





********************************************************************************************************************************************************************
Function CRia_Grafico_PDF1()
********************************************************************************************************************************************************************

Local lSuccess := .f. 
local cLB := chr( 10 )
lOCAL cArquivo, cData
Local cFonte1:= "Helvetica"
Local nFonte_size00 := 8
Local nFonte_size0 := 9
Local nFonte_size1 := 10
Local nFonte_size2 := 11
Local nFonte_size3 := 12
Local nFonte_size4 := 14
Local nFonte_size5 := 15
Local nTotal_material := 0
LOCAL aARQUI_Email := {}
Local cCodigo	:= Alltrim(Form_Relatorio.Text_1.Value)
Local cEdit1	:= Alltrim(Form_Relatorio.Edit_1.Value)
Local nPage := 0
Local cTotal := "", cValor1 := "" , cValor2 :="", cEntrada := "" , cPendente := ""
Local nCount := 10
Local cData1 := ""
Local cSetor := ""
Local cCiclo := ""
Local cTempo_est := ""
Local cLote := ""
Local cCarga := ""
Local cOperador := ""
Local cData_EST := ""
Local cInicio_est := ""
Local cFinal_est := ""
Local lBlack := Form_Relatorio.Check_1.Value
Local cF0Acumulado1 := Alltrim(Form_Relatorio.Label_17.Value)
Local cF0Acumulado2 := Alltrim(Form_Relatorio.Label_18.Value)
Local cF0Acumulado3 := Alltrim(Form_Relatorio.Label_19.Value)
Local cF0Acumulado4 := Alltrim(Form_Relatorio.Label_20.Value)
Local aCfg_Rel1 := Carrega_Config_Relatorios("autoclaves")
Local aCfg_Rel2 := Carrega_Config_Relatorios("estufas")
Local nRow_Lines_Autoclave := 370
Local nRow_Lines_Estufas := 475
Local nCol_Lines := 110


   LOCAL x_x1 := 300 , x_y1:= 300 , x_x2:=300 , x_y2:= 800
   LOCAL y_x1 := 30 , y_y1:= 200, y_x2:=300 , y_y2:= 200  // y_y2 e x_x1 inicio onde comecaa geral as linhas "xx to xy" maior valor mais em baixo da tela

   Local y1b:= 0 , y2b :=0 , y3b:=0 , y4b:=0, y5b:=0, y6b:=0
   //local x_x1 := 500 , y_y2 := 200  // inicio onde comecaa geral as linhas "xx to xy" maior valor mais em baixo da tela
   //Local y1a := linha_xy , y2a := linha_xy , y3a := linha_xy, y4a:= linha_xy, y5a:= linha_xy, y6a:= linha_xy
   Local y1a := 0 , y2a := 0 , y3a := 0, y4a:= 0, y5a:= 0, y6a:= 0
   LOCAL x1 := 0 // linha_xy 
   Local x2 := 0
   Local x2_pdf := 0
   Local x1_pdf := 0
   Local x1_pdf_est := 0
   Local nPos,nPos_Label, cLabelName  


   Local nEscala_X_pdf :=  Form_Relatorio.Combo_3.Value / 2
   Local lInicio := .F. , lFim := .F.
   
   /*
   DRAW LINE IN WINDOW <WindowName> AT <nRow>,<nCol>   TO <nRow>,<nCol>  [PENCOLOR <anPenColor>]  [PENWIDTH <nPenWidth>]
   */
 //msginfo("GErando PDF")   

 


IF Form_Relatorio.Combo_1.Value == 1
	cMaquina := "Autoclave Luferco"
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Form_Relatorio.Combo_1.Value == 2
	cMaquina := "Autoclave Sercon"
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Form_Relatorio.Combo_1.Value == 3
	cMaquina := "Estufa 28"	
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ELSEIF Form_Relatorio.Combo_1.Value == 4
	cMaquina := "Estufa 26"	
	nTipo := 4
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ELSEIF Form_Relatorio.Combo_1.Value == 5
	cMaquina := "Estufa Leboc"
	nTipo := 5
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ENDIF


 
IF nTipo == 1 .OR. nTipo == 2

cData1 := DTOC(Date())
cSetor := Form_Relatorio.Text_2.Value 
cCiclo := Form_Relatorio.Text_3.Value 
cTempo_est := Form_Relatorio.Text_4.Value 
cLote := Form_Relatorio.Text_5.Value 
cCarga := Form_Relatorio.Text_6.Value 
cOperador := Form_Relatorio.Text_7.Value 
cData_EST := Form_Relatorio.Text_8.Value
cInicio_est := Form_Relatorio.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio.Text_19.Value // final esterilizacao	 
nMIM_Autoclave := VAL(cCiclo) -2
nMax_Autoclave := VAL(cCiclo) +4
	
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio Grafico MasterServ -" +cMaquina +"-"+ cCodigo + ".pdf" 

   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"
   
	
	START HPDFPAGE
	SET HPDFDOC PAGEOUTLINE TITLE "Relatorio Resumido de Esterilização MasterServ" 
	//@ 10,10 HPDFPRINT ""
	
 //msgdebug(int(Form_Relatorio.Grid_1.ItemCount / 2))	
 //msgdebug(Form_Relatorio.Grid_1.ItemCount / 2)
	   if lSuccess
	   
		@ 05, 240 	HPDFPRINT IMAGE "logo_cliente.png" width 35 height 4 TYPE PNG
        @ 05,12 		HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 05,140 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
      //  @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	10, 10 HPDFPRINT RECTANGLE TO 32 , 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 11, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 11, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 18, 12 HPDFPRINT "F0 Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 18, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 175 HPDFPRINT "F0 Min. : " +  Alltrim(STR(aCfg_Rel1[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 25, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
 
	 @ 35, 10 HPDFPRINT RECTANGLE TO 58, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 36, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 40, 15 HPDFPRINT cEdit1 TO 57, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }

            
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 

  

	print_grid( nRow_Lines_Autoclave , nCol_Lines -20 , 200, 700 ,10, 5, 10 , 10 , 10 , 10 ,nMIM_Autoclave,nMax_Autoclave)
		 // @ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave - nMIM_Autoclave),  _HMG_HPDF_Pixel2MM(nCol_Lines -30 )  HPDFPRINT "Mínimo : " +  Alltrim(STR(nMIM_Autoclave))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT
		  //@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave - (nMAx_Autoclave + 11)  ),  _HMG_HPDF_Pixel2MM(nCol_Lines -30)  HPDFPRINT "Máximo : " +  Alltrim(STR(nMax_Autoclave))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT

		// Tag das Penas(Linhas)
		@ 070 , 285 HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0 , 0 , 0 } RIGHT
		@ 072 , 287  HPDFPRINT LINE TO  72 , 290 PENWIDTH 1 COLOR BLACK
		
		@ 075 , 285 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0 , 0 , 0 } RIGHT
		@ 077 , 287  HPDFPRINT LINE TO  77 , 290 PENWIDTH 1 COLOR BLUE
		
		@ 080 , 285 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0 , 0 , 0 } RIGHT		  
		@ 082 , 287  HPDFPRINT LINE TO  82 , 290 PENWIDTH 1 COLOR GREEN
		
		@ 085 , 285 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0 , 0 , 0 } RIGHT		  		
		@ 087 , 287  HPDFPRINT LINE TO  87 , 290 PENWIDTH 1 COLOR RED		  
	
	//@ 010 , 049  HPDFPRINT LINE TO  141 , 049 PENWIDTH 0.5 COLOR { 255, 0, 0 }   // linha y  mm inicia em cima top = 0
	endif

        for nPos := 1 to Form_Relatorio.Grid_1.ItemCount
 
            aLinha_g:=GetProperty ( 'Form_Relatorio' , 'Grid_1' , 'ITEM' , nPos )
			//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}
			nPos_Label := 5 * nPos	
			
				x1_pdf := 1 + (nPos * nEscala_X_pdf)
				//msginfo(SUBSTR(aLinha_g[3],1,2) +"   " + SUBSTR(aLinha_g[3],4,2) )
				y1a:= val(aLinha_g[6])
				y2a:= val(aLinha_g[7])
				y3a:= val(aLinha_g[8])
				y4a:= val(aLinha_g[9])
				y5a:= val(aLinha_g[10])
				y6a:= val(aLinha_g[11])
				
				if nPos == 1  // para iniciar apartir da temperatura inicial ao inves do zero ate primeira leitura
					y1b:= y1a  
					y2b:= y2a
					y3b:= y3a
					y4b:= y4a
					y5b:= y5a
					y6b:= y6a
				endif

   if lSuccess
					
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLACK
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y2a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y2b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLUE
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y3a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y3b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR GREEN
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y4a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y4b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR RED
			//@   _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y5a) , _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y5b),  _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.15 COLOR ORANGE
			//@   _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y6a) , _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y6b),  _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.15 COLOR YELLOW
	
			if npos == 1
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Ciclo : " + aLinha_g[3], Nil, 8, 90 , , , , 'T' ) 
			endif
			
			if aLinha_g[14] == "ESTERILIZAÇÃO" .AND. lInicio == .F.
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Est. : " + aLinha_g[3], Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) PENWIDTH 0.25 COLOR {204,102,255}   // linha inicio esterilizacao
				HPDFPRINT_SetDash(0)
				lInicio := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif

			if aLinha_g[14] == "DEPRESSAO" .AND. lFim == .F.
				x1_pdf_est := 1 + ( (nPos -1) * nEscala_X_pdf)  // volta uma posição pra tracar a linha
				aLinha_Esterilizacao := GetProperty ( 'Form_Relatorio' , 'Grid_1' , 'ITEM' , (nPos - 1)  )
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines + x1_pdf) ,"F. Est. : " + aLinha_Esterilizacao[3], Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(val(aLinha_Esterilizacao[6])) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est) PENWIDTH 0.25 COLOR {204,102,255}   // linha fim esterilizacao
				HPDFPRINT_SetDash(0)
				lFim := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif
			
			if npos == Form_Relatorio.Grid_1.ItemCount
			// HPDF_RotateText( 50, 100, "Top", Nil, Nil, 90 , , ,{255 , 0, 255} , 'T' ) // vertical top e bottom
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Ciclo : " + aLinha_g[3], Nil, 8, 90 , , , , 'T' ) 
			endif

			
//msgdebug(str(50 + _HMG_HPDF_Pixel2MM( x1_pdf/10 ) )	)
	endif

				// grava as posiçãoe final de cada valor para iniciar na proxima leitura de valor deve ficar abaixo do desenho do grafico sempre
				x2_pdf := x1_pdf
				y1b:= y1a  
				y2b:= y2a
				y3b:= y3a
				y4b:= y4a
				y5b:= y5a
				y6b:= y6a

	
		
	Next


	
	
  END HPDFPAGE
 END HPDFDOC
 //msgdebug(lSuccess)
 	   if lSuccess	
			execute file cArquivo
		else
			msginfo("Arquivo nao foi criado")
		endif

 
/*
	aColor [1] := YELLOW	
	aColor [2] := PINK	
	aColor [3] := RED	
	aColor [4] := FUCHSIA	
	aColor [5] := BROWN	
	aColor [6] := ORANGE	
	aColor [7] := GREEN	
	aColor [8] := PURPLE	
	aColor [9] := BLACK	
	aColor [10] := BLUE			   
  */
					
endif


IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5

cData1 := DTOC(Date())
cSetor := Form_Relatorio.Text_2.Value 
cCiclo := Form_Relatorio.Text_3.Value 
cTempo_est := Form_Relatorio.Text_4.Value 
cLote := Form_Relatorio.Text_5.Value 
cCarga := Form_Relatorio.Text_6.Value 
cOperador := Form_Relatorio.Text_7.Value 
cData_EST := Form_Relatorio.Text_8.Value
cInicio_est := Form_Relatorio.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio.Text_19.Value // final esterilizacao	 
nMIM_Estufas := VAL(cCiclo) -15
nMax_Estufas := VAL(cCiclo) +15
 
	
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio Grafico MasterServ -" +cMaquina +"-"+ cCodigo + ".pdf" 

   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"
   
	
	START HPDFPAGE
	SET HPDFDOC PAGEOUTLINE TITLE "Relatorio Resumido de Esterilização MasterServ" 
	//@ 10,10 HPDFPRINT ""
	
 //msgdebug(int(Form_Relatorio.Grid_1.ItemCount / 2))	
 //msgdebug(Form_Relatorio.Grid_1.ItemCount / 2)
	   if lSuccess
	   
		@ 05, 240 	HPDFPRINT IMAGE "logo_cliente.png" width 35 height 4 TYPE PNG
        @ 05,12 		HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 05,140 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
      //  @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	10, 10 HPDFPRINT RECTANGLE TO 32 , 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 11, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 11, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 18, 12 HPDFPRINT "FH Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 18, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 175 HPDFPRINT "FH Min. : " +  Alltrim(STR(aCfg_Rel2[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }	  
      @ 25, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
     @ 35, 10 HPDFPRINT RECTANGLE TO 58, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 36, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 40, 15 HPDFPRINT cEdit1 TO 57, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }
   *---------------------------    Soma e Continua    ----------------------------*

            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 
//msgdebug(nMIM_Estufas)
//msgdebug(nMax_Estufas)
 
	print_grid( nRow_Lines_Estufas , nCol_Lines -20 , 300, 700 ,10, 5, 10 , 10 , 10 , 10 ,nMIM_Estufas , nMax_Estufas)
		 // @ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas - nMIM_Estufas),  _HMG_HPDF_Pixel2MM(nCol_Lines -30 )  HPDFPRINT "Mínimo : " +  Alltrim(STR(nMIM_Estufas))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT
		 // @ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas - (nMax_Estufas + 10.5)  ),  _HMG_HPDF_Pixel2MM(nCol_Lines -30)  HPDFPRINT "Máximo : " +  Alltrim(STR(nMax_Estufas))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT

		// Tag das Penas(Linhas)
		@ 070 , 285 HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT
		@ 072 , 287  HPDFPRINT LINE TO  72 , 290 PENWIDTH 1 COLOR BLACK
		
		@ 075 , 285 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT
		@ 077 , 287  HPDFPRINT LINE TO  77 , 290 PENWIDTH 1 COLOR BLUE
		
		@ 080 , 285 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  
		@ 082 , 287  HPDFPRINT LINE TO  82 , 290 PENWIDTH 1 COLOR GREEN
		
		@ 085 , 285 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		@ 087 , 287  HPDFPRINT LINE TO  87 , 290 PENWIDTH 1 COLOR RED
	
	endif

        for nPos := 1 to Form_Relatorio.Grid_1.ItemCount
 
            aLinha_g:=GetProperty ( 'Form_Relatorio' , 'Grid_1' , 'ITEM' , nPos )
			//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}
			nPos_Label := 5 * nPos	
			
				x1_pdf := 1 + (nPos * nEscala_X_pdf)
				//msginfo(SUBSTR(aLinha_g[3],1,2) +"   " + SUBSTR(aLinha_g[3],4,2) )
				y1a:= val(aLinha_g[6])
				y2a:= val(aLinha_g[7])
				y3a:= val(aLinha_g[8])
				y4a:= val(aLinha_g[9])
				y5a:= val(aLinha_g[10])
				y6a:= val(aLinha_g[11])
				
				if nPos == 1  // para iniciar apartir da temperatura inicial ao inves do zero ate primeira leitura
					y1b:= y1a  
					y2b:= y2a
					y3b:= y3a
					y4b:= y4a
					y5b:= y5a
					y6b:= y6a
				endif

   if lSuccess
					
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y1b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLACK
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y2a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y2b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLUE
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y3a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y3b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR GREEN
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y4a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y4b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR RED
			//@   _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y5a) , _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y5b),  _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.15 COLOR ORANGE
			//@   _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y6a) , _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y6b),  _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.15 COLOR YELLOW
	
			if npos == 1
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Ciclo : " + aLinha_g[3], Nil, 8, 90 , , , , 'T' ) 
			endif
			
			if aLinha_g[14] == "ESTERILIZAÇÃO" .AND. lInicio == .F.
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Est. : " + aLinha_g[3], Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) PENWIDTH 0.25 COLOR {204,102,255}   // linha inicio esterilizacao
				HPDFPRINT_SetDash(0)
				lInicio := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif

			if aLinha_g[14] == "RESFRIAMENTO"  .AND. lFim == .F.
				x1_pdf_est := 1 + ( (nPos -1) * nEscala_X_pdf)  // volta uma posição pra tracar a linha
				aLinha_Esterilizacao := GetProperty ( 'Form_Relatorio' , 'Grid_1' , 'ITEM' , (nPos - 1)  )
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Est. : " + aLinha_Esterilizacao[3], Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(val(aLinha_Esterilizacao[6])) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est) PENWIDTH 0.25 COLOR {204,102,255}   // linha fim esterilizacao
				HPDFPRINT_SetDash(0)
				lFim := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif
			
			if npos == Form_Relatorio.Grid_1.ItemCount
			// HPDF_RotateText( 50, 100, "Top", Nil, Nil, 90 , , ,{255 , 0, 255} , 'T' ) // vertical top e bottom
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Ciclo : " + aLinha_g[3], Nil, 8, 90 , , , , 'T' ) 
			endif

			
//msgdebug(str(50 + _HMG_HPDF_Pixel2MM( x1_pdf/10 ) )	)
	endif

				// grava as posiçãoe final de cada valor para iniciar na proxima leitura de valor deve ficar abaixo do desenho do grafico sempre
				x2_pdf := x1_pdf
				y1b:= y1a  
				y2b:= y2a
				y3b:= y3a
				y4b:= y4a
				y5b:= y5a
				y6b:= y6a

	
		
	Next


	
	
  END HPDFPAGE
 END HPDFDOC
 //msgdebug(lSuccess)
 	   if lSuccess	
			execute file cArquivo
		else
			msginfo("Arquivo nao foi criado")
		endif

 
/*
	aColor [1] := YELLOW	
	aColor [2] := PINK	
	aColor [3] := RED	
	aColor [4] := FUCHSIA	
	aColor [5] := BROWN	
	aColor [6] := ORANGE	
	aColor [7] := GREEN	
	aColor [8] := PURPLE	
	aColor [9] := BLACK	
	aColor [10] := BLUE			   
  */
					
endif

Return

  
  
********************************************************************************************************************************************************************
Function CRia_Grafico_PDF1_Mysql()
********************************************************************************************************************************************************************

local lSuccess := .f.
local cLB := chr( 10 )
lOCAL cArquivo, cData
Local cFonte1:= "Helvetica"
Local nFonte_size00 := 8
Local nFonte_size0 := 9
Local nFonte_size1 := 10
Local nFonte_size2 := 11
Local nFonte_size3 := 12
Local nFonte_size4 := 14
Local nFonte_size5 := 15
Local nTotal_material := 0
LOCAL aARQUI_Email := {}
Local cEdit1	:= ""
Local nPos := 1
Local nPage := 0
Local cTotal := "", cValor1 := "" , cValor2 :="", cEntrada := "" , cPendente := ""
Local nCount := 10
Local cData1 := ""
Local cSetor := ""
Local cCiclo := ""
Local cTempo_est := ""
Local cLote := ""
Local cCarga := ""
Local cOperador := ""
Local cData_EST := ""
Local cInicio_est := ""
Local cFinal_est := ""
Local lBlack := Form_Relatorio.Check_1.Value
Local cF0Acumulado1 := "" // Alltrim(Form_Relatorio.Label_17.Value)
Local cF0Acumulado2 := "" //Alltrim(Form_Relatorio.Label_18.Value)
Local cF0Acumulado3 := "" //Alltrim(Form_Relatorio.Label_19.Value)
Local cF0Acumulado4 := "" //Alltrim(Form_Relatorio.Label_20.Value)
Local aCfg_Rel1 := Carrega_Config_Relatorios("autoclaves")
Local aCfg_Rel2 := Carrega_Config_Relatorios("estufas")

Local nRow_Lines_Autoclave := 370
Local nRow_Lines_Estufas := 475
Local nCol_Lines := 110


Local aF0Acumulado := Array(6)
Local cMaquina := ""
Local cPesq := ALLTRIM( PegaValorDaColuna( "Grid_2" , "Form_Relatorio" , 2 ))
Local cMaquina1 := ALLTRIM( PegaValorDaColuna( "Grid_2" , "Form_Relatorio" , 1 ))



   LOCAL x_x1 := 300 , x_y1:= 300 , x_x2:=300 , x_y2:= 800
   LOCAL y_x1 := 30 , y_y1:= 200, y_x2:=300 , y_y2:= 200  // y_y2 e x_x1 inicio onde comecaa geral as linhas "xx to xy" maior valor mais em baixo da tela

   Local y1b:= 0 , y2b :=0 , y3b:=0 , y4b:=0, y5b:=0, y6b:=0
   //local x_x1 := 500 , y_y2 := 200  // inicio onde comecaa geral as linhas "xx to xy" maior valor mais em baixo da tela
   //Local y1a := linha_xy , y2a := linha_xy , y3a := linha_xy, y4a:= linha_xy, y5a:= linha_xy, y6a:= linha_xy
   Local y1a := 0 , y2a := 0 , y3a := 0, y4a:= 0, y5a:= 0, y6a:= 0
   LOCAL x1 := 0 // linha_xy 
   Local x2 := 0
   Local x2_pdf := 0
   Local x1_pdf := 0
   Local x1_pdf_est := 0
   Local nPos_Label, cLabelName  


   Local nEscala_X_pdf :=  Form_Relatorio.Combo_4.Value / 2
   Local lInicio := .F. , lFim := .F.



AFILL( aF0Acumulado,0,1, 6)	 // inicializa como numero e com zero


If Empty(cPesq)

			MsgExclamation("Nenhum Registro Informado para Edição!!","SISTEMA")
			Return Nil

Endif



IF Alltrim(cMaquina1) == "Autoclave Luferco"
	cMaquina := "Autoclave Luferco"
	cTabela := cTabela1
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Alltrim(cMaquina1) == "Autoclave Sercon"
	cMaquina := "Autoclave Sercon"
	cTabela := cTabela2
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Alltrim(cMaquina1) == "Estufa 28"
	cMaquina := "Estufa 28"	
	cTabela := cTabela3
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ELSEIF Alltrim(cMaquina1) == "Estufa 26"
	cMaquina := "Estufa 26"	
	cTabela := cTabela4
	nTipo := 4
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ELSEIF Alltrim(cMaquina1) == "EStufa 29"
	cMaquina := "Estufa Leboc"
	cTabela := cTabela5
	nTipo := 5
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ENDIF



                oQuery := oServer:Query( "Select * From " + cTabela + " WHERE codigo = " + cPesq + " Order By data, hora" ) 
					If oQuery:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif				
				
				oQuery1 := oServer:Query( "Select hora From " + cTabela + " WHERE codigo = " + cPesq + " AND situacao = 'ESTERILIZAÇÃO' " + " Order By data , hora")
				
				
					If oQuery1:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery1:Error())
					Endif	


		IF oQuery1:LastRec() >= 1
				
               For i2:= 1 To oQuery1:LastRec()
                        oRow1 := oQuery1:GetRow(i2)
				
					//msginfo(STR(i2) + " - " + Alltrim(oRow1:fieldGet(1) ) )
					IF I2 == 1	
						cInicio_est := Alltrim( oRow1:fieldGet(1) )
					ENDIF
					
					IF I2 == oQuery1:LastRec()
						cFinal_est := Alltrim( oRow1:fieldGet(1) )
					ENDIF
					
					oQuery1:Skip(1)
               Next
				

		ENDIF
				  			  

			     oQuery2 := oServer:Query( "Select * From " + cTabela + " WHERE codigo = " + cPesq + " Order By data, hora" )  
					
					If oQuery2:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery2:Error())
					Endif	


		IF oQuery2:LastRec() >= 1
				
               For i3:= 1 To oQuery2:LastRec()
                        oRow3 := oQuery2:GetRow(i3)
						IF nTipo == 1 .OR. nTipo == 2
								aF0Acumulado[1] := aF0Acumulado[1] + VAL(CALCULA_F0_2(oRow3:fieldGet(12),VAL(oRow3:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[2] := aF0Acumulado[2] + VAL(CALCULA_F0_2(oRow3:fieldGet(14),VAL(oRow3:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[3] := aF0Acumulado[3] + VAL(CALCULA_F0_2(oRow3:fieldGet(16),VAL(oRow3:fieldGet(6)),aCfg_Rel1[4] ))
								aF0Acumulado[4] := aF0Acumulado[4] + VAL(CALCULA_F0_2(oRow3:fieldGet(18),VAL(oRow3:fieldGet(6)),aCfg_Rel1[4] ))
						endif
						
						IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5 
							aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow3:fieldGet(12),VAL(oRow3:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[2] += VAL(CALCULA_F0_2(oRow3:fieldGet(14),VAL(oRow3:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[3] += VAL(CALCULA_F0_2(oRow3:fieldGet(16),VAL(oRow3:fieldGet(6)),aCfg_Rel2[4] ))
							aF0Acumulado[4] += VAL(CALCULA_F0_2(oRow3:fieldGet(18),VAL(oRow3:fieldGet(6)),aCfg_Rel2[4] ))
							//aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow:fieldGet(3),oRow:fieldGet(25),46.4,UTF8ToStr(oRow:fieldGet(12) )))
							//aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow:fieldGet(3),oRow:fieldGet(25),46.4,UTF8ToStr(oRow:fieldGet(12) )))
						endif				
					
					oQuery2:Skip(1)
               Next

		ENDIF


cF0Acumulado1 :=	Alltrim(STR(aF0Acumulado[1],6,2	))
cF0Acumulado2 :=	Alltrim(STR(aF0Acumulado[2],6,2	))
cF0Acumulado3 :=	Alltrim(STR(aF0Acumulado[3],6,2	))
cF0Acumulado4 :=	Alltrim(STR(aF0Acumulado[4],6,2	))



*******************************************************/  gera pdf na janela edicao orçamento///**********************************************


cCodigo := cPesq
 
IF nTipo == 1 .OR. nTipo == 2 
oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
cData1 := DTOC(Date())
cSetor := alltrim( oRow2:FieldGet(2) )
cCiclo := alltrim( oRow2:FieldGet(6) )
cTempo_est := alltrim(oRow2:FieldGet(8)) 
cLote := alltrim(oRow2:FieldGet(5))
cCarga := alltrim(oRow2:FieldGet(7))
cOperador := alltrim( oRow2:FieldGet(4))
cData_EST := Alltrim(DTOC(oRow2:fieldGet(3)))
cEdit1 := alltrim( oRow2:FieldGet(26)) ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))



nMIM_Autoclave := VAL(cCiclo) -2
nMax_Autoclave := VAL(cCiclo) +4


cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio Grafico MasterServ(M) -" +cMaquina +"-"+ cCodigo + ".pdf" 

   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
      
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Relatorio Resumido de Esterilização MasterServ" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
		@ 05, 240 	HPDFPRINT IMAGE "logo_cliente.png" width 35 height 4 TYPE PNG
        @ 05,12 		HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 05,140 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
      //  @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	10, 10 HPDFPRINT RECTANGLE TO 32 , 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 11, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 11, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 18, 12 HPDFPRINT "F0 Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 18, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 175 HPDFPRINT "F0 Min. : " +  Alltrim(STR(aCfg_Rel1[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 25, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
 
	 @ 35, 10 HPDFPRINT RECTANGLE TO 58, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 36, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 40, 15 HPDFPRINT cEdit1 TO 57, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }


	 


            
       *----------------------- nº de Pagina OFERTA --------------------------------*  
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 
	print_grid( nRow_Lines_Autoclave , nCol_Lines -20 , 200, 700 ,10, 5, 10 , 10 , 10 , 10 ,nMIM_Autoclave,nMax_Autoclave)
	//print_grid( nRow_Lines_Estufas , nCol_Lines -20 , 300, 700 ,10, 5, 10 , 10 , 10 , 10 ,nMIM_Estufas , nMax_Estufas)
		 // @ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas - nMIM_Estufas),  _HMG_HPDF_Pixel2MM(nCol_Lines -30 )  HPDFPRINT "Mínimo : " +  Alltrim(STR(nMIM_Estufas))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT
		 // @ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas - (nMax_Estufas + 10.5)  ),  _HMG_HPDF_Pixel2MM(nCol_Lines -30)  HPDFPRINT "Máximo : " +  Alltrim(STR(nMax_Estufas))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT

		// Tag das Penas(Linhas)
		@ 070 , 285 HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT
		@ 072 , 287  HPDFPRINT LINE TO  72 , 290 PENWIDTH 1 COLOR BLACK
		
		@ 075 , 285 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT
		@ 077 , 287  HPDFPRINT LINE TO  77 , 290 PENWIDTH 1 COLOR BLUE
		
		@ 080 , 285 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  
		@ 082 , 287  HPDFPRINT LINE TO  82 , 290 PENWIDTH 1 COLOR GREEN
		
		@ 085 , 285 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		@ 087 , 287  HPDFPRINT LINE TO  87 , 290 PENWIDTH 1 COLOR RED
		
		@ 090 , 285 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		@ 092 , 287  HPDFPRINT LINE TO  92 , 290 PENWIDTH 1 COLOR BROWN
		
		@ 095 , 285 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		@ 097 , 287  HPDFPRINT LINE TO  97 , 290 PENWIDTH 1 COLOR ORANGE

IF oQuery:LastRec() >= 1
               For npos:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(npos)
			

			//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}
			
				x1_pdf := 1 + (nPos * nEscala_X_pdf)
				//msginfo(SUBSTR(aLinha_g[3],1,2) +"   " + SUBSTR(aLinha_g[3],4,2) )
				y1a:= oRow:FieldGet(12)
				y2a:= oRow:FieldGet(14)
				y3a:= oRow:FieldGet(16)
				y4a:= oRow:FieldGet(18)
				y5a:= oRow:FieldGet(20)
				y6a:= oRow:FieldGet(22)
				
				if nPos == 1  // para iniciar apartir da temperatura inicial ao inves do zero ate primeira leitura
					y1b:= y1a  
					y2b:= y2a
					y3b:= y3a
					y4b:= y4a
					y5b:= y5a
					y6b:= y6a
				endif

   if lSuccess
					
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLACK
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y2a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y2b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLUE
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y3a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y3b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR GREEN
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y4a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y4b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR RED
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y5a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y5b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BROWN
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y6a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y6b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR ORANGE
	
			if npos == 1
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Ciclo : " +  Alltrim(oRow:fieldGet(10)), Nil, 8, 90 , , , , 'T' ) 
			endif
			
			if alltrim(oRow:FieldGet(11)) == "ESTERILIZAÇÃO" .AND. lInicio == .F.
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Est. : "  +  Alltrim(oRow:fieldGet(10)), Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) PENWIDTH 0.25 COLOR {204,102,255}   // linha inicio esterilizacao
				HPDFPRINT_SetDash(0)
				lInicio := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif

			if alltrim(oRow:FieldGet(11)) == "DEPRESSAO"  .AND. lFim == .F.
			//msginfo(STR(x1_pdf))
				oRow := oQuery:GetRow(npos-1)
				x1_pdf_est := 1 + ( ( nPos-1) * nEscala_X_pdf  )  // volta uma posição pra tracar a linha
				//msginfo(STR(x1_pdf_est))
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Est. : " + Alltrim(oRow:fieldGet(10)), Nil, 8, 90 , , , , 'T' )  

				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(oRow:FieldGet(12)) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est )  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est) PENWIDTH 0.25 COLOR {204,102,255}   // linha fim esterilizacao
				HPDFPRINT_SetDash(0)
				lFim := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
				
			endif
			
			if npos == oQuery:LastRec()
			// HPDF_RotateText( 50, 100, "Top", Nil, Nil, 90 , , ,{255 , 0, 255} , 'T' ) // vertical top e bottom
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Ciclo : " + Alltrim(oRow:fieldGet(10)), Nil, 8, 90 , , , , 'T' ) 
			endif

			
//msgdebug(str(50 + _HMG_HPDF_Pixel2MM( x1_pdf/10 ) )	)
	endif

				// grava as posiçãoe final de cada valor para iniciar na proxima leitura de valor deve ficar abaixo do desenho do grafico sempre
				x2_pdf := x1_pdf
				y1b:= y1a  
				y2b:= y2a
				y3b:= y3a
				y4b:= y4a
				y5b:= y5a
				y6b:= y6a 

		oQuery:Skip(1)
Next
ENDIF 

	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo
      
ENDIF  





IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5

oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
cData1 := DTOC(Date())
cSetor := alltrim( oRow2:FieldGet(2) )
cCiclo := alltrim( oRow2:FieldGet(6) )
cTempo_est := alltrim(oRow2:FieldGet(8)) 
cLote := alltrim(oRow2:FieldGet(5))
cCarga := alltrim(oRow2:FieldGet(7))
cOperador := alltrim( oRow2:FieldGet(4))
cData_EST := Alltrim(DTOC(oRow2:fieldGet(3)))
cEdit1 := alltrim( oRow2:FieldGet(26)) ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))
nMIM_Estufas := VAL(cCiclo) -15
nMax_Estufas := VAL(cCiclo) +15
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio Grafico MasterServ(M) -" +cMaquina +"-"+ cCodigo + ".pdf" 


   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'Jair Pinho'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
      
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Relatorio Resumido de Esterilização MasterServ" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*

   		@ 05, 240 	HPDFPRINT IMAGE "logo_cliente.png" width 35 height 4 TYPE PNG
        @ 05,12 	HPDFPRINT "Relatório de Esterilização MasterServ - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
        @ 05,140 	HPDFPRINT "Data/Hora Emissão " + cData1 + "  " + time() FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER
      //  @ 25, 260 	HPDFPRINT "Página: " + STR(page) FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 } // CENTER


		*---------------------- Retangulo O F E R T A -----------------------* 
           
      @	10, 10 HPDFPRINT RECTANGLE TO 32 , 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }      
      @ 11, 12 HPDFPRINT "Setor " + cSetor FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 100 HPDFPRINT "Codigo Seq : " + cCodigo  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 140 HPDFPRINT "Set Point : " + cCiclo FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
  	  @ 11, 175 HPDFPRINT "Tempo Est. : " + cTempo_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 220 HPDFPRINT "I.Est.: " + cInicio_est FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 11, 255 HPDFPRINT "F.Est.: " + cFinal_est  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
 	  @ 18, 12 HPDFPRINT "FH Acumulado"  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 18, 50 HPDFPRINT "T1: " + cF0Acumulado1 FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado1,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 75 HPDFPRINT "T2: " + cF0Acumulado2  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado2,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 100 HPDFPRINT "T3: " +  cF0Acumulado3  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado3,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 125 HPDFPRINT "T4: " +  cF0Acumulado4  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado4,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 175 HPDFPRINT "FH Min. : " +  Alltrim(STR(aCfg_Rel2[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }	  
      @ 25, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
     @ 35, 10 HPDFPRINT RECTANGLE TO 58, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 36, 12 HPDFPRINT "Materiais:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 40, 15 HPDFPRINT cEdit1 TO 57, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }

            
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 
	//print_grid( nRow_Lines_Autoclave , nCol_Lines -20 , 200, 700 ,10, 5, 10 , 10 , 10 , 10 ,nMIM_Autoclave,nMax_Autoclave)
	print_grid( nRow_Lines_Estufas , nCol_Lines -20 , 300, 700 ,10, 5, 10 , 10 , 10 , 10 ,nMIM_Estufas , nMax_Estufas)
		 // @ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas - nMIM_Estufas),  _HMG_HPDF_Pixel2MM(nCol_Lines -30 )  HPDFPRINT "Mínimo : " +  Alltrim(STR(nMIM_Estufas))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT
		 // @ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas - (nMax_Estufas + 10.5)  ),  _HMG_HPDF_Pixel2MM(nCol_Lines -30)  HPDFPRINT "Máximo : " +  Alltrim(STR(nMax_Estufas))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT

		// Tag das Penas(Linhas)
		@ 070 , 285 HPDFPRINT "T1" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT
		@ 072 , 287  HPDFPRINT LINE TO  72 , 290 PENWIDTH 1 COLOR BLACK
		
		@ 075 , 285 HPDFPRINT "T2" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT
		@ 077 , 287  HPDFPRINT LINE TO  77 , 290 PENWIDTH 1 COLOR BLUE
		
		@ 080 , 285 HPDFPRINT "T3" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  
		@ 082 , 287  HPDFPRINT LINE TO  82 , 290 PENWIDTH 1 COLOR GREEN
		
		@ 085 , 285 HPDFPRINT "T4" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		@ 087 , 287  HPDFPRINT LINE TO  87 , 290 PENWIDTH 1 COLOR RED

IF oQuery:LastRec() >= 1 
 For npos:= 1 To oQuery:LastRec()
        oRow := oQuery:GetRow(npos)
		
		//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}
			
				x1_pdf := 1 + (nPos * nEscala_X_pdf)
				//msginfo(SUBSTR(aLinha_g[3],1,2) +"   " + SUBSTR(aLinha_g[3],4,2) )
				y1a:= oRow:FieldGet(12)
				y2a:= oRow:FieldGet(14)
				y3a:= oRow:FieldGet(16)
				y4a:= oRow:FieldGet(18)
				y5a:= oRow:FieldGet(20)
				y6a:= oRow:FieldGet(22)
				
				if nPos == 1  // para iniciar apartir da temperatura inicial ao inves do zero ate primeira leitura
					y1b:= y1a  
					y2b:= y2a
					y3b:= y3a
					y4b:= y4a
					y5b:= y5a
					y6b:= y6a
				endif

   if lSuccess
					
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y1b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLACK
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y2a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y2b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLUE
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y3a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y3b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR GREEN
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y4a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y4b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR RED
			//@   _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y5a) , _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y5b),  _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.15 COLOR ORANGE
			//@   _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y6a) , _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(400) - _HMG_HPDF_Pixel2MM(Y6b),  _HMG_HPDF_Pixel2MM(140) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.15 COLOR YELLOW
	
			if npos == 1
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Ciclo : " +  Alltrim(oRow:fieldGet(10)), Nil, 8, 90 , , , , 'T' ) 
			endif
			
			if alltrim(oRow:FieldGet(11)) == "ESTERILIZAÇÃO" .AND. lInicio == .F.
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Est. : "  +  Alltrim(oRow:fieldGet(10)), Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) PENWIDTH 0.25 COLOR {204,102,255}   // linha inicio esterilizacao
				HPDFPRINT_SetDash(0)
				lInicio := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif

			if alltrim(oRow:FieldGet(11)) == "RESFRIAMENTO"  .AND. lFim == .F.
				oRow := oQuery:GetRow(npos-1)
				//msginfo(STR(x1_pdf))
				x1_pdf_est := 1 + ( (nPos-1) * nEscala_X_pdf )  // volta uma posição pra tracar a linha
				//msginfo(STR(x1_pdf_est))
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Est. : " + Alltrim(oRow:fieldGet(10)), Nil, 8, 90 , , , , 'T' )  
				
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(oRow:FieldGet(12)) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est )  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est) PENWIDTH 0.25 COLOR {204,102,255}   // linha fim esterilizacao
				HPDFPRINT_SetDash(0)
				lFim := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
				
			endif
			
			if npos == oQuery:LastRec()
			// HPDF_RotateText( 50, 100, "Top", Nil, Nil, 90 , , ,{255 , 0, 255} , 'T' ) // vertical top e bottom
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Ciclo : " + Alltrim(oRow:fieldGet(10)), Nil, 8, 90 , , , , 'T' ) 
			endif

			
//msgdebug(str(50 + _HMG_HPDF_Pixel2MM( x1_pdf/10 ) )	)
	endif

				// grava as posiçãoe final de cada valor para iniciar na proxima leitura de valor deve ficar abaixo do desenho do grafico sempre
				x2_pdf := x1_pdf
				y1b:= y1a  
				y2b:= y2a
				y3b:= y3a
				y4b:= y4a
				y5b:= y5a
				y6b:= y6a 

		oQuery:Skip(1)


Next
ENDIF 

	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo
      
ENDIF 





