#include <hmg.ch>
#Include "minigui.ch"
#Include "Common.ch"
#Include "Fileio.CH"
#Include "Directry.ch"
#include "hbclass.ch"
DECLARE WINDOW Form_Relatorio2
DECLARE WINDOW Form_Grafico
*************************************************************************************************************************************
Function Relatorio_Esterilizacao2()
*************************************************************************************************************************************
Private aColunaX := {}
Private aColunaY := {}
Private aColunaXX := {}
Private aColor := {}
//Private x2 := 0   
//Private y2 := 0 
Private cTabela1a := "RECOMBINANTES_AUTOCLAVE09_data"
Private cTabela2a := "RECOMBINANTES_AUTOCLAVE10_data"
Private cTabela3a := "RECOMBINANTES_ESTUFA_27_data"
//Private cTabela4a := "ESTERILIZACAO_SVR_ESTUFA26_data"
//Private cTabela5a := "ESTERILIZACAO_SVR_ESTUFA_29_data"
//Private fColor := {}


	
IF !IsWindowDefined(Form_Relatorio2)	
        Load Window Form_Relatorio2
			Form_Relatorio2.Row := 10
			Form_Relatorio2.Col := 10
			Pesquisa_Ciclos_Maquinas2()			
        Form_Relatorio2.Activate
ENDIF
return



STATIC FUNCTION BC_Grid_1_2()
/*****************************/
LOCAL a
LOCAL aColors  := { { RED, RED, BLACK, BLACK ,BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK } } // EQUAL TO NUMBER OF COLUMNS == 6
LOCAL aItem    := {}


//{60,80,70,130,100,60,60,60,60,60,60,70,70,250}
//{{ || BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()}, { BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()} ,{BC_Grid_1()} ,{BC_Grid_1()} ,{BC_Grid_1()},{BC_Grid_1()},{BC_Grid_1()} }
/*
IF IsWindowActive(Form_Relatorio2)

aItem    := Form_Relatorio2.Grid_1.Item (This.CellRowIndex)



  FOR a = 1 TO 14
		if Val(aItem [6]) > 50 // some condition to set color//  for val to colunn?
			aColors [1] [a] := RED  
		endif
   NEXT a

endif
*/

RETURN aColors // [1][ This.CellColIndex ]


************************************************************************************************************************************
FUNCTION CALCULA_F0_2(nTemperatura,nSet_Point_Temp,nZ_Set_Point,cSituacao)
************************************************************************************************************************************
Local nResultado
local naux1 := 0
local naux2 := 0
Local cEtapa := ""

if empty(cSituacao)
	cEtapa := "TODOS"
	cSituacao := "TODOS"
elseif cSituacao == "ESTERILIZACAO"
	cEtapa := "ESTERILIZACAO"
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
Function Pesquisa_Ciclos_Maquinas2()
*************************************************************************************************************************************
	Local dData1	:= Form_Relatorio2.DatePicker_1.Value
	Local i           					:= 0
	Local oRow     						:= {}
	Local oQuery      				:= "" 
	Local oRow1     						:= {}
	Local oRow2    						:= {}
	Local oQuery1      				:= ""	
	Local aColunaX := {}
	Local cInicio_est := ""
	Local cFinal_est  := ""
	
	
	
IF IsWindowActive(Form_Relatorio2)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_2 OF Form_Relatorio2
	
			//union ja usa distinct nao repete arquivos unial all repete arquivos para este caso tem que colocar group para nao repetir com timestamp
				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( +;
				" (SELECT  'Autoclave 09' as maquina, data_format_8,data_format_14,`time@timestamp`,data_format_11,data_format_12,data_format_22,data_format_13,data_format_23,data_format_17 FROM RECOMBINANTES_AUTOCLAVE09_data WHERE FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) = " + Data_BRITISH_ANSI( dData1) + " GROUP BY data_format_8  ) " +;
				" UNION " +;
				" (SELECT  'Autoclave 10' as maquina , data_format_8,data_format_14,`time@timestamp`,data_format_11,data_format_12,data_format_22,data_format_13,data_format_23,data_format_17 FROM RECOMBINANTES_AUTOCLAVE10_data WHERE FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) = "  + Data_BRITISH_ANSI( dData1)+ "  GROUP BY data_format_8 )" +;
				" UNION " +;
				" (SELECT  'Estufa 27' as maquina , data_format_8,data_format_14,`time@timestamp`,data_format_11,data_format_12,data_format_22,data_format_13,data_format_23,data_format_17 FROM RECOMBINANTES_ESTUFA_27_data WHERE FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) = " + Data_BRITISH_ANSI( dData1) + "  GROUP BY data_format_8 )" )

				If oQuery:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
				Endif				

				
					
	//{"MÁQUINA","SEQ.","SETOR","DATA","OPERADOR","LOTE","SETPOINT","CARGA","TEMPO EST.","MATERIAIS"}
               For i:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim( oRow:fieldGet(1) )  ,;
						Alltrim(STR(oRow:fieldGet(2)) ),;
						UTF8ToStr(oRow:fieldGet(3) ) ,;
						hb_TtoC(t"1970-01-01" + oRow:fieldGet(4) /60 /60 /24, "DD/MM/YYYY" , ""  ) ,;
						UTF8ToStr(oRow:fieldGet(5) ),;
						UTF8ToStr(oRow:fieldGet(6) ),;
						Alltrim(str(oRow:fieldGet(7) )),;
						UTF8ToStr(oRow:fieldGet(8) ),;
						Alltrim(str(oRow:fieldGet(9))),;
						UTF8ToStr(oRow:fieldGet(10)) } TO Grid_2 OF Form_Relatorio2
						oQuery:Skip(1)
			
               Next


		//msginfo(str(len(aColunaX)))
		//msginfo(str(len(aColunaY)))			
		   
			   
/*			   
oRow := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Relatorio2.Text_62.Value := Alltrim(oRow:fieldGet(2))  // setor
Form_Relatorio2.Text_63.Value :=Alltrim(oRow:fieldGet(6))  // ciclo
Form_Relatorio2.Text_64.Value :=Alltrim(oRow:fieldGet(8))  // temperatura esterilizacao
Form_Relatorio2.Text_65.Value :=Alltrim(oRow:fieldGet(5))  // lote
Form_Relatorio2.Text_66.Value :=Alltrim(oRow:fieldGet(7))  // carga
Form_Relatorio2.Text_67.Value :=Alltrim(oRow:fieldGet(4))  // operaodr
Form_Relatorio2.Text_68.Value := Alltrim(STR(oRow:fieldGet(1)) ) // CODIGO
Form_Relatorio2.Edit_6.Value :=Alltrim(oRow:fieldGet(26)) // materiais
Form_Relatorio2.Text_69.Value := cInicio_est // inicio esterilizacao
Form_Relatorio2.Text_70.Value := cFinal_est // final esterilizacao			   
*/

IF oQuery:LastRec() >= 1						
	Form_Relatorio2.Label_15.Value := "Total de Registros : " + Alltrim(STR(oQuery:LastRec()))
Elseif oQuery:LastRec() = 0
	MSGINFO("Consulta sem Registros")
endif			   


ENDIF





	Return Nil



*************************************************************************************************************************************
Function Pesquisa_Relatorio_Maquinas2()
*************************************************************************************************************************************


	Local cPesq	:= Alltrim(Form_Relatorio2.Text_1.Value)
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
	
IF Form_Relatorio2.Combo_1.Value == 1
	cTabela := cTabela1a
	cMaquina := "Autoclave 09"
	nTipo := 1
ELSEIF Form_Relatorio2.Combo_1.Value == 2
	cTabela := cTabela2a
	cMaquina := "Autoclave 10"	
	nTipo := 2
ELSEIF Form_Relatorio2.Combo_1.Value == 3
	cTabela := cTabela3a
	cMaquina := "Estufa 27"	
	nTipo := 3
ENDIF


 
	
IF IsWindowActive(Form_Relatorio2)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_1 OF Form_Relatorio2

				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela + " WHERE data_format_8 = " + cPesq + " Order By `time@timestamp` " ) 
					If oQuery:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif				
				
				oQuery1 := oServer:Query( "Select `time@timestamp` From " + cTabela + " WHERE data_format_8 = " + cPesq + " AND INSTR(data_format_9,'ESTERILIZACAO')  Order By `time@timestamp` ")
				//oRow1 := oQuery1:GetRow()
				//MSGINFO("total : " + str(oQuery1:LastRec()) )
		IF oQuery1:LastRec() >= 1
				
               For i2:= 1 To oQuery1:LastRec()
                        oRow1 := oQuery1:GetRow(i2)
				
					//msginfo(STR(i2) + " - " + Alltrim(oRow1:fieldGet(1) ) )
					IF I2 == 1	
						cInicio_est := hb_GetDateTimeTT(oRow1:fieldGet(1),"" , "HH:MM:SS" )
					ENDIF
					
					IF I2 == oQuery1:LastRec()
						cFinal_est := hb_GetDateTimeTT(oRow1:fieldGet(1),"" , "HH:MM:SS" )
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
						
						//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}
						
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(11)) )  ,;
						hb_TtoC(t"1970-01-01" + oRow:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  ) ,;
						hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS" ),;
						Alltrim(oRow:fieldGet(13) ) ,;
						Alltrim(STR(oRow:fieldGet(25))),;
						Alltrim(STR(oRow:fieldGet(3),0,2 )),;
						Alltrim(STR(oRow:fieldGet(4),0,2 )),;
						Alltrim(STR(oRow:fieldGet(5),0,2 )),;
						Alltrim(STR(oRow:fieldGet(6),0,2 )),;
						Alltrim(STR(oRow:fieldGet(7),0,2 )),;
						Alltrim(STR(oRow:fieldGet(8),0,2 )),;
						Alltrim(STR(oRow:fieldGet(10),0,2 )),;
						Alltrim(STR(oRow:fieldGet(9),0,2 )),;
						UTF8ToStr(oRow:fieldGet(12) ),;
						UTF8ToStr(oRow:fieldGet(14) ),;
						UTF8ToStr(oRow:fieldGet(15) ),;
						UTF8ToStr(oRow:fieldGet(16) ),;
						UTF8ToStr(oRow:fieldGet(17) ),;
						UTF8ToStr(oRow:fieldGet(20) ),;
						UTF8ToStr(oRow:fieldGet(21) ),;
						UTF8ToStr(oRow:fieldGet(22) ),;
						UTF8ToStr(oRow:fieldGet(23) ),;
						UTF8ToStr(oRow:fieldGet(24) )} TO Grid_1 OF Form_Relatorio2
						oQuery:Skip(1)
						
						IF nTipo == 1 .OR. nTipo == 2
								aF0Acumulado[1] := aF0Acumulado[1] + VAL(CALCULA_F0_2(oRow:fieldGet(3),oRow:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[2] := aF0Acumulado[2] + VAL(CALCULA_F0_2(oRow:fieldGet(4),oRow:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[3] := aF0Acumulado[3] + VAL(CALCULA_F0_2(oRow:fieldGet(5),oRow:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[4] := aF0Acumulado[4] + VAL(CALCULA_F0_2(oRow:fieldGet(6),oRow:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[5] := aF0Acumulado[5] + VAL(CALCULA_F0_2(oRow:fieldGet(7),oRow:fieldGet(25),aCfg_Rel1[4] ))

						endif
						
						IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5 
							aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow:fieldGet(3),oRow:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[2] += VAL(CALCULA_F0_2(oRow:fieldGet(4),oRow:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[3] += VAL(CALCULA_F0_2(oRow:fieldGet(5),oRow:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[4] += VAL(CALCULA_F0_2(oRow:fieldGet(6),oRow:fieldGet(25),aCfg_Rel2[4] ))
							//aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow:fieldGet(3),oRow:fieldGet(25),46.4,UTF8ToStr(oRow:fieldGet(12) )))
							//aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow:fieldGet(3),oRow:fieldGet(25),46.4,UTF8ToStr(oRow:fieldGet(12) )))
						endif
						
						//Aadd( aColunaX , oRow:fieldGet(14)  )
						//Aadd( aColunaY , Alltrim(oRow:fieldGet(10) )  )
						

               Next


		   
			   
SetProperty('Form_Relatorio2','Label_17','BackColor', Verifica_F0_Acumulado2(STR(aF0Acumulado[1]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )
SetProperty('Form_Relatorio2','Label_18','BackColor', Verifica_F0_Acumulado2(STR(aF0Acumulado[2]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )
SetProperty('Form_Relatorio2','Label_19','BackColor', Verifica_F0_Acumulado2(STR(aF0Acumulado[3]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )
SetProperty('Form_Relatorio2','Label_20','BackColor', Verifica_F0_Acumulado2(STR(aF0Acumulado[4]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )
//SetProperty('Form_Relatorio2','Label_28','BackColor', Verifica_F0_Acumulado2(STR(aF0Acumulado[5]),nTipo,aCfg_Rel1[3],aCfg_Rel2[3]) )



Form_Relatorio2.Label_17.Value :=	Alltrim(STR(aF0Acumulado[1],6,2	))
Form_Relatorio2.Label_18.Value :=	Alltrim(STR(aF0Acumulado[2],6,2	))
Form_Relatorio2.Label_19.Value :=	Alltrim(STR(aF0Acumulado[3],6,2	))
Form_Relatorio2.Label_20.Value :=	Alltrim(STR(aF0Acumulado[4],6,2	))
//Form_Relatorio2.Label_28.Value :=	Alltrim(STR(aF0Acumulado[5],6,2	))

/*

HB_StrToUTF8( cStr ) e UTF8ToStr( cUtf8 )
   
cStrOut := (cStrIn,"PLMAZ","U16")   //  string from Polish Mazovia to
Unicode
cStrOut := (cStrIn,"UTF8","PLWIN")   //  string from UTF-8 to ANSI
*/
 
oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Relatorio2.Text_2.Value := UTF8ToStr(Alltrim(oRow2:fieldGet(17)))
Form_Relatorio2.Text_3.Value :=Alltrim(str(oRow2:fieldGet(25)))
Form_Relatorio2.Text_4.Value := Alltrim(str(oRow2:fieldGet(26)))
Form_Relatorio2.Text_5.Value :=UTF8ToStr(oRow2:fieldGet(15)) 
Form_Relatorio2.Text_6.Value :=UTF8ToStr(oRow2:fieldGet(16)) 
Form_Relatorio2.Text_7.Value :=UTF8ToStr(oRow2:fieldGet(14)) 
Form_Relatorio2.Text_8.Value := hb_TtoC(t"1970-01-01" + oRow2:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  )

cLinha1 := iif( empty(UTF8ToStr( oRow2:fieldGet(21))) .or. UTF8ToStr( oRow2:fieldGet(21)) == "NA", UTF8ToStr( oRow2:fieldGet(20) ) , UTF8ToStr( oRow2:fieldGet(20) ) + ", "  )
cLinha2 := iif( empty(UTF8ToStr( oRow2:fieldGet(22))) .or. UTF8ToStr( oRow2:fieldGet(22)) == "NA", UTF8ToStr( oRow2:fieldGet(21) ) , UTF8ToStr( oRow2:fieldGet(21) ) + ", "  )
cLinha3 := iif( empty(UTF8ToStr( oRow2:fieldGet(23))) .or. UTF8ToStr( oRow2:fieldGet(23)) == "NA", UTF8ToStr( oRow2:fieldGet(22) ) , UTF8ToStr( oRow2:fieldGet(22) ) + ", "  )
cLinha4 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", UTF8ToStr( oRow2:fieldGet(23) ) , UTF8ToStr( oRow2:fieldGet(23) ) + ", "  )
cLinha5 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", "" , UTF8ToStr( oRow2:fieldGet(24) ) )

Form_Relatorio2.Edit_1.Value := cLinha1 + cLinha2 + cLinha3 + cLinha4 + cLinha5 ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))
Form_Relatorio2.Text_11.Value := cInicio_est // inicio esterilizacao
Form_Relatorio2.Text_19.Value := cFinal_est // final esterilizacao			   

	
ENDIF

IF oQuery:LastRec() >= 1						
	Form_Relatorio2.Label_14.Value := "Total de Registros : " + Alltrim(STR(oQuery:LastRec()))
Elseif oQuery:LastRec() = 0
	MSGINFO("Consulta sem Registros")
endif

ENDIF



	Return Nil



*********************************************************************************************************************************************************************
Function Relatorio_Maq2() && 1 ordem em 1 folha A4
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
Local cCodigo	:= Alltrim(Form_Relatorio2.Text_1.Value)
Local cEdit1	:= Alltrim(Form_Relatorio2.Edit_1.Value)
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
Local lBlack := Form_Relatorio2.Check_1.Value
Local cF0Acumulado1 := Alltrim(Form_Relatorio2.Label_17.Value)
Local cF0Acumulado2 := Alltrim(Form_Relatorio2.Label_18.Value)
Local cF0Acumulado3 := Alltrim(Form_Relatorio2.Label_19.Value)
Local cF0Acumulado4 := Alltrim(Form_Relatorio2.Label_20.Value)
Local cF0Acumulado5 := Alltrim(Form_Relatorio2.Label_28.Value)

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

IF Form_Relatorio2.Combo_1.Value == 1
	cMaquina := "Autoclave 09"
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Form_Relatorio2.Combo_1.Value == 2
	cMaquina := "Autoclave 10"
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Form_Relatorio2.Combo_1.Value == 3
	cMaquina := "Estufa 27"	
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ENDIF


 
IF nTipo == 1 .OR. nTipo == 2 

cData1 := DTOC(Date())
cSetor := Form_Relatorio2.Text_2.Value 
cCiclo := Form_Relatorio2.Text_3.Value 
cTempo_est := Form_Relatorio2.Text_4.Value 
cLote := Form_Relatorio2.Text_5.Value 
cCarga := Form_Relatorio2.Text_6.Value 
cOperador := Form_Relatorio2.Text_7.Value 
cData_EST := Form_Relatorio2.Text_8.Value
cInicio_est := Form_Relatorio2.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio2.Text_19.Value // final esterilizacao	

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio cMT Viewer " +cMaquina +"-"+ cCodigo + ".pdf" 


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
            SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos cMT Viewer" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

             page = 1    
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 		HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
	  @ 38, 150 HPDFPRINT "T5: " +  cF0Acumulado5  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado5,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
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
	//@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 220 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 235 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 250 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 265 HPDFPRINT "P. INT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 84, 280 HPDFPRINT "P. EXT." FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
 
 F:=91
 DO WHILE npos != (Form_Relatorio2.Grid_1.ItemCount +1)
			
		aLinha := GetProperty ( 'Form_Relatorio2' , 'Grid_1' , 'ITEM' , nPos )
		//cFabricante := PGENERIC( 1 , "descricao", "fabricantes" , "codigo" , Alltrim(aLinha [7]) )

		//msginfo(ALLtrim( "T = " + aLinha [11] + "  C = " + cCiclo ))
       *--------------------------------------------------*          
         
        *--- Colunas da tabela EM TODAS AS PAGINAS
//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}

		@ F, 13 HPDFPRINT Alltrim(aLinha [3]) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 28 HPDFPRINT Alltrim(aLinha [14]) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA DESCRIÇÃO
        @ F, 85 HPDFPRINT TRANSFORM(aLinha [6],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [6] , cCiclo, 4 , aLinha [14]  , 1,lBlack )  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [6]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT TRANSFORM(aLinha [7],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [7] , cCiclo, 4 , aLinha [14] , 1 ,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 130 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [7]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 145 HPDFPRINT TRANSFORM(aLinha [8],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [8] , cCiclo, 4 , aLinha [14] , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 160 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [8]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 175 HPDFPRINT TRANSFORM(aLinha [9],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [9] , cCiclo, 4 , aLinha [14] , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 190 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [9]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 205 HPDFPRINT TRANSFORM(aLinha [10],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [10] , cCiclo, 4 , aLinha [14] , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		//@ F, 220 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [10]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 235 HPDFPRINT TRANSFORM(aLinha [11],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [11] , cCiclo, 4 , aLinha [14] , 1) CENTER// COLUNA DESCRIÇÃO
		//@ F, 250 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [11]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 265 HPDFPRINT TRANSFORM(aLinha [12],"99999") FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 280 HPDFPRINT TRANSFORM(aLinha [13],"99999") FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
		 
 npos ++
IF F > (91+90) .AND. npos < Form_Relatorio2.Grid_1.ItemCount  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1

nPage ++
//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos cMT Viewer - " + Alltrim(STR(nPage))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 		HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
	//@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 220 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
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
cSetor := Form_Relatorio2.Text_2.Value 
cCiclo := Form_Relatorio2.Text_3.Value 
cTempo_est := Form_Relatorio2.Text_4.Value 
cLote := Form_Relatorio2.Text_5.Value 
cCarga := Form_Relatorio2.Text_6.Value 
cOperador := Form_Relatorio2.Text_7.Value 
cData_EST := Form_Relatorio2.Text_8.Value
cInicio_est := Form_Relatorio2.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio2.Text_19.Value // final esterilizacao	

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio cMT Viewer " +cMaquina +"-"+ cCodigo + ".pdf" 


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
            SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos cMT Viewer" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

             page = 1    
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
 DO WHILE npos != (Form_Relatorio2.Grid_1.ItemCount +1)
			
		aLinha := GetProperty ( 'Form_Relatorio2' , 'Grid_1' , 'ITEM' , nPos )
		//cFabricante := PGENERIC( 1 , "descricao", "fabricantes" , "codigo" , Alltrim(aLinha [7]) )

       *--------------------------------------------------*          
    //           
        *--- Colunas da tabela EM TODAS AS PAGINAS
		// {"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUA?O"}       
		@ F, 13 HPDFPRINT Alltrim(aLinha [3]) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 28 HPDFPRINT Alltrim(aLinha [14]) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA DESCRIÇÃO
        @ F, 85 HPDFPRINT TRANSFORM(aLinha [6],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [6] , cCiclo, 15 , aLinha [14] , 2,lBlack)  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [6]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT TRANSFORM(aLinha [7],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [7] , cCiclo, 15 , aLinha [14], 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 130 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [7]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 145 HPDFPRINT TRANSFORM(aLinha [8],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [8] , cCiclo, 15 ,aLinha [14] , 2 ,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 160 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [8]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 175 HPDFPRINT TRANSFORM(aLinha [9],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [9] , cCiclo, 15 ,aLinha [14] , 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 190 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [9]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 205 HPDFPRINT TRANSFORM(aLinha [10],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [10] , cCiclo, 15, aLinha [14] , 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		//@ F, 220 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [10]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 235 HPDFPRINT TRANSFORM(aLinha [11],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [11] , cCiclo, 15 , aLinha [14], 2,lBlack ) CENTER// COLUNA DESCRIÇÃO
		//@ F, 250 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [11]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
		 
 npos ++
IF F > (91+90) .AND. npos < Form_Relatorio2.Grid_1.ItemCount  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1

nPage ++
//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos cMT Viewer - " + Alltrim(STR(nPage))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
ENDDO


	END HPDFPAGE

		  
ENDIF  	  

    END HPDFDOC	  
  execute file cArquivo
      
ENDIF 
      

	  
	  
*********************************************************************************************************************************************************************
Function Relatorio_Maq2_Mysql() && 1 ordem em 1 folha A4
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
Local lBlack := Form_Relatorio2.Check_1.Value
Local cF0Acumulado1 := "" // Alltrim(Form_Relatorio2.Label_17.Value)
Local cF0Acumulado2 := "" //Alltrim(Form_Relatorio2.Label_18.Value)
Local cF0Acumulado3 := "" //Alltrim(Form_Relatorio2.Label_19.Value)
Local cF0Acumulado4 := "" //Alltrim(Form_Relatorio2.Label_20.Value)
Local cF0Acumulado5 := "" //Alltrim(Form_Relatorio2.Label_20.Value)
Local aCfg_Rel1 := Carrega_Config_Relatorios("autoclaves")
Local aCfg_Rel2 := Carrega_Config_Relatorios("estufas")

Local aF0Acumulado := Array(6)
Local cMaquina := ""
Local cCodigo := ALLTRIM( PegaValorDaColuna( "Grid_2" , "Form_Relatorio2" , 2 ))
Local cMaquina1 := ALLTRIM( PegaValorDaColuna( "Grid_2" , "Form_Relatorio2" , 1 ))

AFILL( aF0Acumulado,0,1, 6)	 // inicializa como numero e com zero


If Empty(cCodigo)

			MsgExclamation("Nenhum Registro Informado para Edição!!","SISTEMA")
			Return Nil

Endif



IF Alltrim(cMaquina1) == "Autoclave 09"
	cMaquina := "Autoclave 09"
	cTabela := cTabela1a
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Alltrim(cMaquina1) == "Autoclave 10"
	cMaquina := "Autoclave 10"
	cTabela := cTabela2a
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Alltrim(cMaquina1) == "Estufa 27"
	cMaquina := "Estufa 27"	
	cTabela := cTabela3a
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ENDIF



				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela + " WHERE data_format_8 = " + cCodigo + " Order By `time@timestamp` " ) 
					If oQuery:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif				
				
				oQuery1 := oServer:Query( "Select `time@timestamp` From " + cTabela + " WHERE data_format_8 = " + cCodigo + " AND INSTR(data_format_9,'ESTERILIZACAO')  Order By `time@timestamp` ")
				//oRow1 := oQuery1:GetRow()
				//MSGINFO("total : " + str(oQuery1:LastRec()) )
					If oQuery1:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery1:Error())
					Endif	


		IF oQuery1:LastRec() >= 1
				
               For i2:= 1 To oQuery1:LastRec()
                        oRow1 := oQuery1:GetRow(i2)
				
					//msginfo(STR(i2) + " - " + Alltrim(oRow1:fieldGet(1) ) )
					IF I2 == 1	
						cInicio_est := hb_GetDateTimeTT(oRow1:fieldGet(1),"" , "HH:MM:SS" )
					ENDIF
					
					IF I2 == oQuery1:LastRec()
						cFinal_est := hb_GetDateTimeTT(oRow1:fieldGet(1),"" , "HH:MM:SS" )
					ENDIF
					
					oQuery1:Skip(1)
               Next
				

		ENDIF
				  			  

			     oQuery2 := oServer:Query( "Select * From " + cTabela + " WHERE data_format_8 = " + cCodigo + " Order By `time@timestamp` " ) 
					
					If oQuery2:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery2:Error())
					Endif	


		IF oQuery2:LastRec() >= 1
				
               For i3:= 1 To oQuery2:LastRec()
                        oRow3 := oQuery2:GetRow(i3)
						IF nTipo == 1 .OR. nTipo == 2
								aF0Acumulado[1] := aF0Acumulado[1] + VAL(CALCULA_F0_2(oRow3:fieldGet(3),oRow3:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[2] := aF0Acumulado[2] + VAL(CALCULA_F0_2(oRow3:fieldGet(4),oRow3:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[3] := aF0Acumulado[3] + VAL(CALCULA_F0_2(oRow3:fieldGet(5),oRow3:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[4] := aF0Acumulado[4] + VAL(CALCULA_F0_2(oRow3:fieldGet(6),oRow3:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[5] := aF0Acumulado[5] + VAL(CALCULA_F0_2(oRow3:fieldGet(7),oRow3:fieldGet(25),aCfg_Rel1[4] ))
						endif
						
						IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5 
							aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow3:fieldGet(3),oRow3:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[2] += VAL(CALCULA_F0_2(oRow3:fieldGet(4),oRow3:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[3] += VAL(CALCULA_F0_2(oRow3:fieldGet(5),oRow3:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[4] += VAL(CALCULA_F0_2(oRow3:fieldGet(6),oRow3:fieldGet(25),aCfg_Rel2[4] ))
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
cF0Acumulado5 :=	Alltrim(STR(aF0Acumulado[5],6,2	))



*******************************************************/  gera pdf na janela edicao orçamento///**********************************************



 
IF nTipo == 1 .OR. nTipo == 2 
oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
cData1 := DTOC(Date())
cSetor := alltrim(UTF8ToStr( oRow2:FieldGet(17)))
cCiclo := alltrim(str(oRow2:FieldGet(25)) )
cTempo_est := alltrim(str(oRow2:FieldGet(26)) )
cLote := alltrim(UTF8ToStr( oRow2:FieldGet(15)))
cCarga := alltrim(UTF8ToStr( oRow2:FieldGet(16)))
cOperador := alltrim(UTF8ToStr( oRow2:FieldGet(14)))
cData_EST := hb_TtoC(t"1970-01-01" + oRow2:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  ) 
cLinha1 := iif( empty(UTF8ToStr( oRow2:fieldGet(21))) .or. UTF8ToStr( oRow2:fieldGet(21)) == "NA", UTF8ToStr( oRow2:fieldGet(20) ) , UTF8ToStr( oRow2:fieldGet(20) ) + ", "  )
cLinha2 := iif( empty(UTF8ToStr( oRow2:fieldGet(22))) .or. UTF8ToStr( oRow2:fieldGet(22)) == "NA", UTF8ToStr( oRow2:fieldGet(21) ) , UTF8ToStr( oRow2:fieldGet(21) ) + ", "  )
cLinha3 := iif( empty(UTF8ToStr( oRow2:fieldGet(23))) .or. UTF8ToStr( oRow2:fieldGet(23)) == "NA", UTF8ToStr( oRow2:fieldGet(22) ) , UTF8ToStr( oRow2:fieldGet(22) ) + ", "  )
cLinha4 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", UTF8ToStr( oRow2:fieldGet(23) ) , UTF8ToStr( oRow2:fieldGet(23) ) + ", "  )
cLinha5 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", "" , UTF8ToStr( oRow2:fieldGet(24) ) )
cEdit1 := cLinha1 + cLinha2 + cLinha3 + cLinha4 + cLinha5 ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))


//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio cMT Viewer(M) " +cMaquina +"-"+ cCodigo + ".pdf" 


   SELECT HPDFDOC cArquivo TO lSuccess ORIENTATION HPDF_ORIENT_LANDSCAPE PAPERSIZE HPDF_PAPER_A4
   SET HPDFDOC  COMPRESS ALL
   SET HPDFDOC  PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'Jair Pinho'
   SET HPDFINFO CREATOR     TO 'TECHWORKS'
   SET HPDFINFO TITLE      TO 'Relaório'
   SET HPDFINFO SUBJECT     TO 'Criado com LibHaru/HPDF Library'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   SET HPDFDOC  ENCODING TO "WinAnsiEncoding"


   if lSuccess
      
        START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos cMT Viewer" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

             page = 1    
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 		HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
	 // @ 38, 150 HPDFPRINT "T5: " +  cF0Acumulado5  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado5,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
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
	//@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 220 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
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

		@ F, 13 HPDFPRINT hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS" ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 28 HPDFPRINT alltrim(oRow:FieldGet(12)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA DESCRIÇÃO
        @ F, 85 HPDFPRINT Alltrim(STR(oRow:FieldGet(3),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(3))) , cCiclo, 4 , alltrim(oRow:FieldGet(12)) , 1,lBlack)  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(3),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT Alltrim(STR(oRow:FieldGet(4),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(4))) , cCiclo, 4 , alltrim(oRow:FieldGet(12)), 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 130 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(4),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 145 HPDFPRINT Alltrim(STR(oRow:FieldGet(5),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(5))) , cCiclo, 4 ,alltrim(oRow:FieldGet(12)) , 1 ,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 160 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(5),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 175 HPDFPRINT Alltrim(STR(oRow:FieldGet(6),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(6))) , cCiclo, 4 ,alltrim(oRow:FieldGet(12)) , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 190 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(6),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 205 HPDFPRINT Alltrim(STR(oRow:FieldGet(7),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(7))) , cCiclo, 4 , alltrim(oRow:FieldGet(12)) , 1,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 220 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(7),Val(cCiclo),aCfg_Rel1[4] ) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 235 HPDFPRINT STR(aLinha [11],0,2) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [11] , cCiclo, 4 , aLinha [14] , 1) CENTER// COLUNA DESCRIÇÃO
		//@ F, 250 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [11]),Val(cCiclo),aCfg_Rel1[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 265 HPDFPRINT Alltrim(STR(oRow:FieldGet(10),0,2)) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 280 HPDFPRINT Alltrim(STR(oRow:FieldGet(9),0,2)) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
	 

IF F > (91+90) .AND. npos < oQuery:LastRec()  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1

//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos cMT Viewer - " + Alltrim(STR(nPage))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25, 12 	HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
	  //@ 38, 150 HPDFPRINT "T5: " +  cF0Acumulado5  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado5,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
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
	//@ 84, 205 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	//@ 84, 220 HPDFPRINT "F0" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
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
cSetor := alltrim(UTF8ToStr( oRow2:FieldGet(17)))
cCiclo := alltrim(str(oRow2:FieldGet(25)) )
cTempo_est := alltrim(str(oRow2:FieldGet(26)) )
cLote := alltrim(UTF8ToStr( oRow2:FieldGet(15)))
cCarga := alltrim(UTF8ToStr( oRow2:FieldGet(16)))
cOperador := alltrim(UTF8ToStr( oRow2:FieldGet(14)))
cData_EST := hb_TtoC(t"1970-01-01" + oRow2:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  ) 
cLinha1 := iif( empty(UTF8ToStr( oRow2:fieldGet(21))) .or. UTF8ToStr( oRow2:fieldGet(21)) == "NA", UTF8ToStr( oRow2:fieldGet(20) ) , UTF8ToStr( oRow2:fieldGet(20) ) + ", "  )
cLinha2 := iif( empty(UTF8ToStr( oRow2:fieldGet(22))) .or. UTF8ToStr( oRow2:fieldGet(22)) == "NA", UTF8ToStr( oRow2:fieldGet(21) ) , UTF8ToStr( oRow2:fieldGet(21) ) + ", "  )
cLinha3 := iif( empty(UTF8ToStr( oRow2:fieldGet(23))) .or. UTF8ToStr( oRow2:fieldGet(23)) == "NA", UTF8ToStr( oRow2:fieldGet(22) ) , UTF8ToStr( oRow2:fieldGet(22) ) + ", "  )
cLinha4 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", UTF8ToStr( oRow2:fieldGet(23) ) , UTF8ToStr( oRow2:fieldGet(23) ) + ", "  )
cLinha5 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", "" , UTF8ToStr( oRow2:fieldGet(24) ) )
cEdit1 := cLinha1 + cLinha2 + cLinha3 + cLinha4 + cLinha5 ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio cMT Viewer(M) " +cMaquina +"-"+ cCodigo + ".pdf" 


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
            SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos cMT Viewer" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

             page = 1    
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
		@ F, 13 HPDFPRINT hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS" ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 28 HPDFPRINT alltrim(oRow:FieldGet(12)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA DESCRIÇÃO
        @ F, 85 HPDFPRINT Alltrim(STR(oRow:FieldGet(3),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(3))) , cCiclo, 15 , alltrim(oRow:FieldGet(12)) , 2,lBlack)  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(3),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT Alltrim(STR(oRow:FieldGet(4),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(4))) , cCiclo, 15 , alltrim(oRow:FieldGet(12)), 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 130 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(4),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 145 HPDFPRINT Alltrim(STR(oRow:FieldGet(5),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(5))) , cCiclo, 15 ,alltrim(oRow:FieldGet(12)) , 2 ,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 160 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(5),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 175 HPDFPRINT Alltrim(STR(oRow:FieldGet(6),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( alltrim(str(oRow:FieldGet(6))) , cCiclo, 15 ,alltrim(oRow:FieldGet(12)) , 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 190 HPDFPRINT ALLtrim(CALCULA_F0_2(oRow:FieldGet(6),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 205 HPDFPRINT TRANSFORM(aLinha [10],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [10] , cCiclo, 15, aLinha [14] , 2,lBlack) CENTER// COLUNA DESCRIÇÃO
		//@ F, 220 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [10]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		//@ F, 235 HPDFPRINT TRANSFORM(aLinha [11],"99999") FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( aLinha [11] , cCiclo, 15 , aLinha [14], 2,lBlack ) CENTER// COLUNA DESCRIÇÃO
		//@ F, 250 HPDFPRINT ALLtrim(CALCULA_F0_2(Val(aLinha [11]),Val(cCiclo),aCfg_Rel2[4]) ) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
		 

IF F > (91+90) .AND. npos < oQuery:LastRec()  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1

//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Relatório de Eventos cMT Viewer - " + Alltrim(STR(nPage))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
Function Verifica_F0_Acumulado2( cF0 ,nMaquina,nF0_Min_Autoclaves,nF0_Min_Estufas )
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
Function Verifica_temp2( cTemp , cCiclo, nTolerancia , cSituacao ,nMaquina , lBlack )
****************************************************************************************
Local aColor_temp := BLACK   /// quando estiver fora de esterilizao fonte color igual a preto
Local  nTemp_max := 0
Local  nTemp_min := 0
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


IF VAL(cTemp) > nTemp_max .AND. Alltrim(cSituacao) == "ESTERILIZACAO"

	IF !lBlack
		aColor_temp := FUCHSIA
	else
		aColor_temp := BLACK
	endif

ELSEIF VAL(cTemp) < nTemp_min .AND. Alltrim(cSituacao) == "ESTERILIZACAO"
	IF !lBlack
		aColor_temp := RED
	else
		aColor_temp := BLACK
	endif

ELSEIF VAL(cTemp) > nTemp_min .AND. VAL(cTemp) < nTemp_max  .AND. Alltrim(cSituacao) == "ESTERILIZACAO"
	IF !lBlack
		aColor_temp := acolor_ok
	else
		aColor_temp := BLACK
	endif
ENDIF

Return(aColor_temp)





*************************************************************************************************************************************
Function Pesquisa_Relatorio_Esterilizacao_Maquinas2()
*************************************************************************************************************************************
	Local dData1	:= Form_Relatorio2.DatePicker_2.Value	
    Local dData2	:= Form_Relatorio2.DatePicker_3.Value
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


IF Form_Relatorio2.Combo_2.Value == 1
	cTabela := cTabela1a
	cMaquina := "Autoclave 09"
ELSEIF Form_Relatorio2.Combo_2.Value == 2
	cTabela := cTabela2a
	cMaquina := "Autoclave 10"	
ELSEIF Form_Relatorio2.Combo_2.Value == 3
	cTabela := cTabela3a
	cMaquina := "Estufa 27"	
ENDIF



	
IF IsWindowActive(Form_Relatorio2)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_3 OF Form_Relatorio2

	
		If Empty (Form_Relatorio2.DatePicker_3.Value)
				oQuery := oServer:Query( " Select * From " + cTabela + " WHERE FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) = " + Data_BRITISH_ANSI( dData1)  + " AND INSTR(data_format_9,'ESTERILIZACAO') " + " Order By `time@timestamp` " )
		ELSE
				oQuery := oServer:Query( " Select * From " + cTabela + " WHERE FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) >= " + Data_BRITISH_ANSI( dData1) + " AND FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) <= " + Data_BRITISH_ANSI( dData2) + " AND INSTR(data_format_9,'ESTERILIZACAO') " + " Order By `time@timestamp` " )
		ENDIF
		
//
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
					

				
 IF oQuery:LastRec() >= 1					
	//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUAÇÃO" ,"SETOR","CICLO","LOTE","CARGA","OPERADOR"}
               For i:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(11)) )  ,;
						hb_TtoC(t"1970-01-01" + oRow:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  ) ,;
						hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS" ),;
						Alltrim(oRow:fieldGet(13) ) ,;
						Alltrim(STR(oRow:fieldGet(25))),;
						Alltrim(STR(oRow:fieldGet(3),0,2 )),;
						Alltrim(STR(oRow:fieldGet(4),0,2 )),;
						Alltrim(STR(oRow:fieldGet(5),0,2 )),;
						Alltrim(STR(oRow:fieldGet(6),0,2 )),;
						Alltrim(STR(oRow:fieldGet(7),0,2 )),;
						Alltrim(STR(oRow:fieldGet(8),0,2 )),;
						Alltrim(STR(oRow:fieldGet(10),0,2 )),;
						Alltrim(STR(oRow:fieldGet(9),0,2 )),;
						Alltrim(oRow:fieldGet(12) ),;
						UTF8ToStr(oRow:fieldGet(17) ),;
						Alltrim(STR(oRow:fieldGet(25) )),;
						UTF8ToStr(oRow:fieldGet(15) ),;
						UTF8ToStr(oRow:fieldGet(16) ),;
						UTF8ToStr(oRow:fieldGet(14) )} TO Grid_3 OF Form_Relatorio2
						oQuery:Skip(1)
						
			

               Next

   

		//msginfo(str(len(aColunaX)))
		//msginfo(str(len(aColunaY)))			
		   
			   
/*			   
oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Relatorio2.Text_2.Value := Alltrim(oRow2:fieldGet(2))
Form_Relatorio2.Text_3.Value :=Alltrim(oRow2:fieldGet(6))
Form_Relatorio2.Text_4.Value :=Alltrim(oRow2:fieldGet(8))
Form_Relatorio2.Text_5.Value :=Alltrim(oRow2:fieldGet(5))
Form_Relatorio2.Text_6.Value :=Alltrim(oRow2:fieldGet(7))
Form_Relatorio2.Text_7.Value :=Alltrim(oRow2:fieldGet(4))
Form_Relatorio2.Text_8.Value :=Alltrim(DTOC(oRow2:fieldGet(3)))
Form_Relatorio2.Edit_1.Value :=Alltrim(oRow2:fieldGet(26))
Form_Relatorio2.Text_11.Value := cInicio_est // inicio esterilizacao
Form_Relatorio2.Text_19.Value := cFinal_est // final esterilizacao			   
*/
			   
ENDIF

ENDIF

IF oQuery:LastRec() >= 1						
	Form_Relatorio2.Label_13.Value := "Total de Registros : " + Alltrim(STR(oQuery:LastRec()))
Elseif oQuery:LastRec() = 0
	MSGINFO("Consulta sem Registros")
endif


	Return Nil


*********************************************************************************************************************************************************************
Function Historico_Data_esterilizacao_Maq2() && 1 ordem em 1 folha A4
*********************************************************************************************************************************************************************
*************************************************************************************************************************************
Local dData1	:= Form_Relatorio2.DatePicker_2.Value	
Local dData2	:= Form_Relatorio2.DatePicker_3.Value
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
Local cCodigo	:= ""//Alltrim(Form_Relatorio2.Text_1.Value)
Local cEdit1	:= ""//Alltrim(Form_Relatorio2.Edit_1.Value)
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
Local lBlack := Form_Relatorio2.Check_2.Value
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

IF Form_Relatorio2.Combo_2.Value == 1
	cMaquina := "Autoclave 09"
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
	cTabela := cTabela1a
ELSEIF Form_Relatorio2.Combo_2.Value == 2
	cMaquina := "Autoclave 10"
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
	cTabela := cTabela2a
ELSEIF Form_Relatorio2.Combo_2.Value == 3
	cMaquina := "Estufa 27"	
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
	cTabela := cTabela3a
ENDIF



		If Empty (Form_Relatorio2.DatePicker_3.Value)
				oQuery := oServer:Query( " Select * From " + cTabela + " WHERE FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) = " + Data_BRITISH_ANSI( dData1)  + " AND INSTR(data_format_9,'ESTERILIZACAO') " + " Order By `time@timestamp` " )
		ELSE
				oQuery := oServer:Query( " Select * From " + cTabela + " WHERE FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) >= " + Data_BRITISH_ANSI( dData1) + " AND FROM_UNIXTIME(`time@timestamp` +3*3600,'%Y%m%d' ) <= " + Data_BRITISH_ANSI( dData2) + " AND INSTR(data_format_9,'ESTERILIZACAO') " + " Order By `time@timestamp` " )
		ENDIF
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif


					
 
IF nTipo == 1 .OR. nTipo == 2 

cData1 := DTOC(Date())


/*
cSetor := Form_Relatorio2.Text_2.Value 
cCiclo := Form_Relatorio2.Text_3.Value 
cTempo_est := Form_Relatorio2.Text_4.Value 
cLote := Form_Relatorio2.Text_5.Value 
cCarga := Form_Relatorio2.Text_6.Value 
cOperador := Form_Relatorio2.Text_7.Value 
cData_EST := Form_Relatorio2.Text_8.Value
cInicio_est := Form_Relatorio2.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio2.Text_19.Value // final esterilizacao	
*/



					

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Historico cMT Viewer " +cMaquina +"_"+ cCodigo + hb_DTOC(dData1,"DD-MM-YYYY") + IIF(EMPTY(dData2),"", " - " + hb_DTOC(dData2,"DD-MM-YYYY")) + ".pdf" 


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
            SET HPDFDOC PAGEOUTLINE TITLE "Histórico de Eventos cMT Viewer - " + Alltrim(STR(Page)) 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

   
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
		@ 25,12 	HPDFPRINT "Histórico de Esterilização - cMT Viewer " + cMaquina + + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
	//@ 32, 145 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
	@ 32, 180 HPDFPRINT "SETOR" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
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
		cCiclo := Alltrim(STR(oRow:fieldGet(25))) // para o verifica valor
        //@ 25,12 	HPDFPRINT "Histórico de Esterilização - " + cMaquina + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER

		//msginfo(ALLtrim( cCiclo ))
		//Verifica_temp2( cTemp , cCiclo, nTolerancia , cSituacao ,nMaquina , lBlack )
        *--- Colunas da tabela EM TODAS AS PAGINAS
		@ F, 13  HPDFPRINT hb_TtoC(t"1970-01-01" + oRow:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  )  +" - " + hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS" ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 60  HPDFPRINT Alltrim(str(oRow:fieldGet(11))) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
        @ F, 85  HPDFPRINT Alltrim(str(oRow:fieldGet(3),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(3))) , cCiclo, 4 , UTF8ToStr(oRow:fieldGet(12)) , 1 , lBlack )  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT Alltrim(str(oRow:fieldGet(4),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(4))) , cCiclo, 4 , UTF8ToStr(oRow:fieldGet(12)) , 1 , lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT Alltrim(str(oRow:fieldGet(5),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(5))) , cCiclo, 4 , UTF8ToStr(oRow:fieldGet(12)) , 1 , lBlack)CENTER// COLUNA DESCRIÇÃO 
		@ F, 130 HPDFPRINT Alltrim(str(oRow:fieldGet(6),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(6))) , cCiclo, 4 , UTF8ToStr(oRow:fieldGet(12)) , 1 , lBlack) CENTER// COLUNA DESCRIÇÃO 
		//@ F, 145 HPDFPRINT Alltrim(str(oRow:fieldGet(7),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(7))) , cCiclo, 4 , UTF8ToStr(oRow:fieldGet(12)) , 1 , lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 180 HPDFPRINT UTF8ToStr(Alltrim(oRow:fieldGet(17)) ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 205 HPDFPRINT Alltrim(STR(oRow:fieldGet(25)) ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 220 HPDFPRINT UTF8ToStr(Alltrim(oRow:fieldGet(15)) ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 245 HPDFPRINT UTF8ToStr(Alltrim(oRow:fieldGet(14))) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 265 HPDFPRINT Alltrim(str(oRow:fieldGet(10),0,3)) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 280 HPDFPRINT Alltrim(str(oRow:fieldGet(9),0,3)) FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO

          F:=F+5
		 
IF F > (39+140) .AND. i < oQuery:LastRec()  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page + 1


	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Histórico de Eventos cMT Viewer - " + Alltrim(STR(Page))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Histórico de Esterilização cMT Viewer - " + cMaquina + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
	//@ 32, 145 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } CENTER
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
cSetor := Form_Relatorio2.Text_2.Value 
cCiclo := Form_Relatorio2.Text_3.Value 
cTempo_est := Form_Relatorio2.Text_4.Value 
cLote := Form_Relatorio2.Text_5.Value 
cCarga := Form_Relatorio2.Text_6.Value 
cOperador := Form_Relatorio2.Text_7.Value 
cData_EST := Form_Relatorio2.Text_8.Value
cInicio_est := Form_Relatorio2.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio2.Text_19.Value // final esterilizacao	
*/

//cArquivo:= DiskName()+ ":\"+CurDir() + "\Orçamentos\" + pDocs_Empresa + " ORÇAMENTO - "+cCodigo_Orcamento+".pdf" 
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio cMT Viewer " +cMaquina +"_"+ cCodigo + hb_DTOC(dData1,"DD-MM-YYYY") + IIF(EMPTY(dData2),"", " - " + hb_DTOC(dData2,"DD-MM-YYYY")) + ".pdf" 


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
            SET HPDFDOC PAGEOUTLINE TITLE "Histórico de Eventos cMT Viewer - " + Alltrim(STR(Page))
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
     // @ 14, 10 HPDFPRINT RECTANGLE TO 53, 200 PENWIDTH 1 COLOR { 0, 0, 0 } 

   
		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Histórico de Esterilização cMT Viewer - " + cMaquina + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
		cCiclo := Alltrim(STR(oRow:fieldGet(25))) // para o verifica valor

       *--------------------------------------------------*          
    //           
        *--- Colunas da tabela EM TODAS AS PAGINAS
		// {"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", "SITUA?O"}       


		@ F, 13  HPDFPRINT hb_TtoC(t"1970-01-01" + oRow:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  )  +" - " + hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS" ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } //CENTER// COLUNA ITEM
        @ F, 60  HPDFPRINT Alltrim(str(oRow:fieldGet(11))) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
        @ F, 85  HPDFPRINT Alltrim(str(oRow:fieldGet(3),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(3))) , cCiclo, 15 , UTF8ToStr(oRow:fieldGet(12)) , 2 , lBlack )  CENTER// COLUNA DESCRIÇÃO
        @ F, 100 HPDFPRINT Alltrim(str(oRow:fieldGet(4),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(4))) , cCiclo, 15 , UTF8ToStr(oRow:fieldGet(12)) , 2 , lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 115 HPDFPRINT Alltrim(str(oRow:fieldGet(5),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(5))) , cCiclo, 15 , UTF8ToStr(oRow:fieldGet(12)) , 2 , lBlack)CENTER// COLUNA DESCRIÇÃO 
		@ F, 130 HPDFPRINT Alltrim(str(oRow:fieldGet(6),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(6))) , cCiclo, 15 , UTF8ToStr(oRow:fieldGet(12)) , 2 , lBlack) CENTER// COLUNA DESCRIÇÃO 
		//@ F, 145 HPDFPRINT Alltrim(str(oRow:fieldGet(7),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(7))) , cCiclo, 15 , UTF8ToStr(oRow:fieldGet(12)) , 2 , lBlack) CENTER// COLUNA DESCRIÇÃO
		//@ F, 160 HPDFPRINT Alltrim(str(oRow:fieldGet(8),0,2)) FONT cFonte1 size nFonte_size1 COLOR Verifica_temp2( Alltrim(STR(oRow:fieldGet(8))) , cCiclo, 15 , UTF8ToStr(oRow:fieldGet(12)) , 2 , lBlack) CENTER// COLUNA DESCRIÇÃO
		@ F, 180 HPDFPRINT UTF8ToStr(oRow:fieldGet(17) ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 205 HPDFPRINT Alltrim(STR(oRow:fieldGet(25)) ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 220 HPDFPRINT UTF8ToStr(oRow:fieldGet(15) ) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO
		@ F, 245 HPDFPRINT UTF8ToStr(oRow:fieldGet(14)) FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } CENTER// COLUNA DESCRIÇÃO


          F:=F+5
		 

IF F > (39+140) .AND. npos < Form_Relatorio2.Grid_3.ItemCount  //(91+20) 91 linha inicial 20 espac? de F=5  4 linhas 20 linhas = 100

		 
END HPDFPAGE	  
		  
page = page+1


//msginfo(str(F))

	  
         START HPDFPAGE
         SET HPDFDOC PAGEOUTLINE TITLE "Histórico de Eventos cMT Viewer - " + Alltrim(STR(Page))  
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

		@ 10, 230 	HPDFPRINT IMAGE "logo_cliente.png" width 60 height 10 TYPE PNG
        @ 25,12 	HPDFPRINT "Histórico de Esterilização cMT Viewer - " + cMaquina + " " + DTOC(dData1) + IIF(EMPTY(dData2),"", " a " + DTOC(dData2)) FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
Function CRia_Grafico_PDF2()
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
Local cCodigo	:= Alltrim(Form_Relatorio2.Text_1.Value)
Local cEdit1	:= Alltrim(Form_Relatorio2.Edit_1.Value)
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
Local lBlack := Form_Relatorio2.Check_1.Value
Local cF0Acumulado1 := Alltrim(Form_Relatorio2.Label_17.Value)
Local cF0Acumulado2 := Alltrim(Form_Relatorio2.Label_18.Value)
Local cF0Acumulado3 := Alltrim(Form_Relatorio2.Label_19.Value)
Local cF0Acumulado4 := Alltrim(Form_Relatorio2.Label_20.Value)
//Local cF0Acumulado5 := Alltrim(Form_Relatorio2.Label_28.Value)
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


   Local nEscala_X_pdf :=  Form_Relatorio2.Combo_3.Value / 2
   Local lInicio := .F. , lFim := .F.
   
   /*
   DRAW LINE IN WINDOW <WindowName> AT <nRow>,<nCol>   TO <nRow>,<nCol>  [PENCOLOR <anPenColor>]  [PENWIDTH <nPenWidth>]
   */
 //msginfo("GErando PDF")   

 


IF Form_Relatorio2.Combo_1.Value == 1
	cMaquina := "Autoclave 09"
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Form_Relatorio2.Combo_1.Value == 2
	cMaquina := "Autoclave 10"
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Form_Relatorio2.Combo_1.Value == 3
	cMaquina := "Estufa 27"	
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ENDIF


 
IF nTipo == 1 .OR. nTipo == 2

cData1 := DTOC(Date())
cSetor := Form_Relatorio2.Text_2.Value 
cCiclo := Form_Relatorio2.Text_3.Value 
cTempo_est := Form_Relatorio2.Text_4.Value 
cLote := Form_Relatorio2.Text_5.Value 
cCarga := Form_Relatorio2.Text_6.Value 
cOperador := Form_Relatorio2.Text_7.Value 
cData_EST := Form_Relatorio2.Text_8.Value
cInicio_est := Form_Relatorio2.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio2.Text_19.Value // final esterilizacao	 
nMIM_Autoclave := VAL(cCiclo) -2
nMax_Autoclave := VAL(cCiclo) +4
	
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio Grafico cMT Viewer -" +cMaquina +"-"+ cCodigo + ".pdf" 

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
	SET HPDFDOC PAGEOUTLINE TITLE "Relatorio Resumido de Esterilização cMT Viewer" 
	//@ 10,10 HPDFPRINT ""
	
 //msgdebug(int(Form_Relatorio2.Grid_1.ItemCount / 2))	
 //msgdebug(Form_Relatorio2.Grid_1.ItemCount / 2)
	   if lSuccess
	   
		@ 05, 240 	HPDFPRINT IMAGE "logo_cliente.png" width 35 height 4 TYPE PNG
        @ 05,12 		HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
//	  @ 18, 150 HPDFPRINT "T5: " +  cF0Acumulado5  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado5,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
	  @ 18, 175 HPDFPRINT "F0 Min. : " +  Alltrim(STR(aCfg_Rel1[3]))  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
      @ 25, 12 HPDFPRINT "Data Est. : " + cData_EST  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 60 HPDFPRINT "Operador : " + cOperador FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 120 HPDFPRINT "Lote : " + cLote FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 160 HPDFPRINT "Carga : " + cCarga  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
	  @ 25, 220 HPDFPRINT cTolerancia  FONT cFonte1 size nFonte_size3 COLOR { 0, 0, 0 }
     
 
	 @ 35, 10 HPDFPRINT RECTANGLE TO 58, 290 PENWIDTH 0.2 COLOR { 0, 0, 0 }
     @ 36, 12 HPDFPRINT "Materiais1:"  FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }	 
     @ 40, 15 HPDFPRINT cEdit1 TO 57, 285 FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 }

            
 
         @ 200, 10 HPDFPRINT "Visto do Operador __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
         @ 200, 190 HPDFPRINT "Visto do Chefe do Setor __________________________" FONT cFonte1 size nFonte_size0 COLOR { 0, 0, 0 } // CENTER
 

  

	print_grid( nRow_Lines_Autoclave , nCol_Lines -20 , 200, 700 ,10, 5, 10 , 10 , 10 , 10 ,nMIM_Autoclave,nMax_Autoclave)
		  //@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave - nMIM_Autoclave),  _HMG_HPDF_Pixel2MM(nCol_Lines -30 )  HPDFPRINT "Mínimo : " +  Alltrim(STR(nMIM_Autoclave))  FONT cFonte1 size nFonte_size00 COLOR { 0, 0, 0 } 	RIGHT
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
		
		//@ 090 , 285 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		//@ 092 , 287  HPDFPRINT LINE TO  92 , 290 PENWIDTH 1 COLOR BROWN
		
		//@ 095 , 285 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		//@ 097 , 287  HPDFPRINT LINE TO  97 , 290 PENWIDTH 1 COLOR ORANGE		
	
	//@ 010 , 049  HPDFPRINT LINE TO  141 , 049 PENWIDTH 0.5 COLOR { 255, 0, 0 }   // linha y  mm inicia em cima top = 0
	endif

        for nPos := 1 to Form_Relatorio2.Grid_1.ItemCount
 
            aLinha_g:=GetProperty ( 'Form_Relatorio2' , 'Grid_1' , 'ITEM' , nPos )
			//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}
			nPos_Label := 5 * nPos	
			
				x1_pdf := 1 + (nPos * nEscala_X_pdf)
				//msginfo(SUBSTR(aLinha_g[3],1,2) +"   " + SUBSTR(aLinha_g[3],4,2) )
				y1a:= val(aLinha_g[6])
				y2a:= val(aLinha_g[7])
				y3a:= val(aLinha_g[8])
				y4a:= val(aLinha_g[9])
				//y5a:= val(aLinha_g[10])
				//y6a:= val(aLinha_g[11])
				
				if nPos == 1  // para iniciar apartir da temperatura inicial ao inves do zero ate primeira leitura
					y1b:= y1a  
					y2b:= y2a
					y3b:= y3a
					y4b:= y4a
					//y5b:= y5a
					//y6b:= y6a
				endif

   if lSuccess
					
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLACK
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y2a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y2b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLUE
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y3a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y3b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR GREEN
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y4a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y4b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR RED
			//@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y5a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y5b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BROWN
			//@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y6a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y6b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR ORANGE

			if npos == 1
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Ciclo : " +  aLinha_g[3], Nil, 8, 90 , , , , 'T' ) 
			endif
			
			if aLinha_g[14] == "ESTERILIZACAO" .AND. lInicio == .F.
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Est. : " +  aLinha_g[3], Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) PENWIDTH 0.25 COLOR {204,102,255}   // linha inicio esterilizacao
				HPDFPRINT_SetDash(0)
				lInicio := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif

			if aLinha_g[14] == "DEPRESSAO" .AND. lFim == .F.
			//msginfo(STR(x1_pdf))
			
				x1_pdf_est := 1 + ( (nPos-1) * nEscala_X_pdf)  // volta uma posição pra tracar a linha
				aLinha_Esterilizacao := GetProperty ( 'Form_Relatorio2' , 'Grid_1' , 'ITEM' , nPos - 1  )
				//msginfo(STR(x1_pdf_est))
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines + x1_pdf) ,"F. Est. : " +  aLinha_Esterilizacao[3], Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(val(aLinha_g[6])) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est) PENWIDTH 0.25 COLOR {204,102,255}   // linha fim esterilizacao
				HPDFPRINT_SetDash(0)
				lFim := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif
			
			if npos == Form_Relatorio2.Grid_1.ItemCount
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
				//y5b:= y5a
				//y6b:= y6a

	
		
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
cSetor := Form_Relatorio2.Text_2.Value 
cCiclo := Form_Relatorio2.Text_3.Value 
cTempo_est := Form_Relatorio2.Text_4.Value 
cLote := Form_Relatorio2.Text_5.Value 
cCarga := Form_Relatorio2.Text_6.Value 
cOperador := Form_Relatorio2.Text_7.Value 
cData_EST := Form_Relatorio2.Text_8.Value
cInicio_est := Form_Relatorio2.Text_11.Value // inicio esterilizacao
cFinal_est := Form_Relatorio2.Text_19.Value // final esterilizacao	 
nMIM_Estufas := VAL(cCiclo) -15
nMax_Estufas := VAL(cCiclo) +15
 
	
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio Grafico cMT Viewer -" +cMaquina +"-"+ cCodigo + ".pdf" 

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
	SET HPDFDOC PAGEOUTLINE TITLE "Relatorio Resumido de Esterilização cMT Viewer" 
	//@ 10,10 HPDFPRINT ""
	
 //msgdebug(int(Form_Relatorio2.Grid_1.ItemCount / 2))	
 //msgdebug(Form_Relatorio2.Grid_1.ItemCount / 2)
	   if lSuccess
	   
		@ 05, 240 	HPDFPRINT IMAGE "logo_cliente.png" width 35 height 4 TYPE PNG
        @ 05,12 		HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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

        for nPos := 1 to Form_Relatorio2.Grid_1.ItemCount
 
            aLinha_g:=GetProperty ( 'Form_Relatorio2' , 'Grid_1' , 'ITEM' , nPos )
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
	
			if npos == 1
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Ciclo : " +  aLinha_g[3], Nil, 8, 90 , , , , 'T' ) 
			endif
			
			if aLinha_g[14] == "ESTERILIZACAO" .AND. lInicio == .F.
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Est. : "  +  aLinha_g[3], Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) PENWIDTH 0.25 COLOR {204,102,255}   // linha inicio esterilizacao
				HPDFPRINT_SetDash(0)
				lInicio := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif

			if aLinha_g[14] == "RESFRIAMENTO"  .AND. lFim == .F.
			//msginfo(STR(x1_pdf))

				x1_pdf_est := 1 + ( (nPos-1) * nEscala_X_pdf )  // volta uma posição pra tracar a linha
			//msginfo(STR(x1_pdf_est))
				aLinha_Esterilizacao := GetProperty ( 'Form_Relatorio2' , 'Grid_1' , 'ITEM' , nPos - 1 )
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Est. : " + aLinha_Esterilizacao[3], Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(val(aLinha_Esterilizacao[6])) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est )  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est) PENWIDTH 0.25 COLOR {204,102,255}   // linha fim esterilizacao
				HPDFPRINT_SetDash(0)
				lFim := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif
			
			if npos == Form_Relatorio2.Grid_1.ItemCount
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
Function CRia_Grafico_PDF2_Mysql()
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
Local lBlack := Form_Relatorio2.Check_1.Value
Local cF0Acumulado1 := "" // Alltrim(Form_Relatorio2.Label_17.Value)
Local cF0Acumulado2 := "" //Alltrim(Form_Relatorio2.Label_18.Value)
Local cF0Acumulado3 := "" //Alltrim(Form_Relatorio2.Label_19.Value)
Local cF0Acumulado4 := "" //Alltrim(Form_Relatorio2.Label_20.Value)
Local cF0Acumulado5 := "" //Alltrim(Form_Relatorio2.Label_20.Value)
Local aCfg_Rel1 := Carrega_Config_Relatorios("autoclaves")
Local aCfg_Rel2 := Carrega_Config_Relatorios("estufas")

Local nRow_Lines_Autoclave := 370
Local nRow_Lines_Estufas := 475
Local nCol_Lines := 110


Local aF0Acumulado := Array(6)
Local cMaquina := ""
Local cCodigo := ALLTRIM( PegaValorDaColuna( "Grid_2" , "Form_Relatorio2" , 2 ))
Local cMaquina1 := ALLTRIM( PegaValorDaColuna( "Grid_2" , "Form_Relatorio2" , 1 ))



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


   Local nEscala_X_pdf :=  Form_Relatorio2.Combo_4.Value / 2
   Local lInicio := .F. , lFim := .F.



AFILL( aF0Acumulado,0,1, 6)	 // inicializa como numero e com zero


If Empty(cCodigo)

			MsgExclamation("Nenhum Registro Informado para Edição!!","SISTEMA")
			Return Nil

Endif



IF Alltrim(cMaquina1) == "Autoclave 09"
	cMaquina := "Autoclave 09"
	cTabela := cTabela1a
	nTipo := 1
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Alltrim(cMaquina1) == "Autoclave 10"
	cMaquina := "Autoclave 10"
	cTabela := cTabela2a
	nTipo := 2
	cTolerancia := "Variação Permitida : -2 a +4 ºC"
ELSEIF Alltrim(cMaquina1) == "Estufa 27"
	cMaquina := "Estufa 27"	
	cTabela := cTabela3a
	nTipo := 3
	cTolerancia := "Variação Permitida : -15 a +15 ºC"
ENDIF



				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela + " WHERE data_format_8 = " + cCodigo + " Order By `time@timestamp` " ) 
					If oQuery:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif				
				
				oQuery1 := oServer:Query( "Select `time@timestamp` From " + cTabela + " WHERE data_format_8 = " + cCodigo + " AND INSTR(data_format_9,'ESTERILIZACAO')  Order By `time@timestamp` ")
				//oRow1 := oQuery1:GetRow()
				//MSGINFO("total : " + str(oQuery1:LastRec()) )
					If oQuery1:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery1:Error())
					Endif	


		IF oQuery1:LastRec() >= 1
				
               For i2:= 1 To oQuery1:LastRec()
                        oRow1 := oQuery1:GetRow(i2)
				
					//msginfo(STR(i2) + " - " + Alltrim(oRow1:fieldGet(1) ) )
					IF I2 == 1	
						cInicio_est := hb_GetDateTimeTT(oRow1:fieldGet(1),"" , "HH:MM:SS" )
					ENDIF
					
					IF I2 == oQuery1:LastRec()
						cFinal_est := hb_GetDateTimeTT(oRow1:fieldGet(1),"" , "HH:MM:SS" )
					ENDIF
					
					oQuery1:Skip(1)
               Next
				

		ENDIF
				  			  

			     oQuery2 := oServer:Query( "Select * From " + cTabela + " WHERE data_format_8 = " + cCodigo + " Order By `time@timestamp` " ) 
					
					If oQuery2:NetErr()												
                    MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery2:Error())
					Endif	


		IF oQuery2:LastRec() >= 1
				
               For i3:= 1 To oQuery2:LastRec()
                        oRow3 := oQuery2:GetRow(i3)
						IF nTipo == 1 .OR. nTipo == 2
								aF0Acumulado[1] := aF0Acumulado[1] + VAL(CALCULA_F0_2(oRow3:fieldGet(3),oRow3:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[2] := aF0Acumulado[2] + VAL(CALCULA_F0_2(oRow3:fieldGet(4),oRow3:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[3] := aF0Acumulado[3] + VAL(CALCULA_F0_2(oRow3:fieldGet(5),oRow3:fieldGet(25),aCfg_Rel1[4] ))
								aF0Acumulado[4] := aF0Acumulado[4] + VAL(CALCULA_F0_2(oRow3:fieldGet(6),oRow3:fieldGet(25),aCfg_Rel1[4] ))
								//aF0Acumulado[5] := aF0Acumulado[5] + VAL(CALCULA_F0_2(oRow3:fieldGet(7),oRow3:fieldGet(25),aCfg_Rel1[4] ))
						endif
						
						IF nTipo == 3 .OR. nTipo == 4 .OR. nTipo == 5 
							aF0Acumulado[1] += VAL(CALCULA_F0_2(oRow3:fieldGet(3),oRow3:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[2] += VAL(CALCULA_F0_2(oRow3:fieldGet(4),oRow3:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[3] += VAL(CALCULA_F0_2(oRow3:fieldGet(5),oRow3:fieldGet(25),aCfg_Rel2[4] ))
							aF0Acumulado[4] += VAL(CALCULA_F0_2(oRow3:fieldGet(6),oRow3:fieldGet(25),aCfg_Rel2[4] ))
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
//cF0Acumulado5 :=	Alltrim(STR(aF0Acumulado[5],6,2	))



*******************************************************/  gera pdf na janela edicao orçamento///**********************************************



 
IF nTipo == 1 .OR. nTipo == 2 
oRow2 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
cData1 := DTOC(Date())
cSetor := alltrim(UTF8ToStr( oRow2:FieldGet(17)))
cCiclo := alltrim(str(oRow2:FieldGet(25)) )
cTempo_est := alltrim(str(oRow2:FieldGet(26)) )
cLote := alltrim(UTF8ToStr( oRow2:FieldGet(15)))
cCarga := alltrim(UTF8ToStr( oRow2:FieldGet(16)))
cOperador := alltrim(UTF8ToStr( oRow2:FieldGet(14)))
cData_EST := hb_TtoC(t"1970-01-01" + oRow2:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  ) 
cLinha1 := iif( empty(UTF8ToStr( oRow2:fieldGet(21))) .or. UTF8ToStr( oRow2:fieldGet(21)) == "NA", UTF8ToStr( oRow2:fieldGet(20) ) , UTF8ToStr( oRow2:fieldGet(20) ) + ", "  )
cLinha2 := iif( empty(UTF8ToStr( oRow2:fieldGet(22))) .or. UTF8ToStr( oRow2:fieldGet(22)) == "NA", UTF8ToStr( oRow2:fieldGet(21) ) , UTF8ToStr( oRow2:fieldGet(21) ) + ", "  )
cLinha3 := iif( empty(UTF8ToStr( oRow2:fieldGet(23))) .or. UTF8ToStr( oRow2:fieldGet(23)) == "NA", UTF8ToStr( oRow2:fieldGet(22) ) , UTF8ToStr( oRow2:fieldGet(22) ) + ", "  )
cLinha4 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", UTF8ToStr( oRow2:fieldGet(23) ) , UTF8ToStr( oRow2:fieldGet(23) ) + ", "  )
cLinha5 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", "" , UTF8ToStr( oRow2:fieldGet(24) ) )
cEdit1 := cLinha1 + cLinha2 + cLinha3 + cLinha4 + cLinha5 ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))
nMIM_Autoclave := VAL(cCiclo) -2
nMax_Autoclave := VAL(cCiclo) +4


cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio Grafico cMT Viewer(M) -" +cMaquina +"-"+ cCodigo + ".pdf" 

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
            SET HPDFDOC PAGEOUTLINE TITLE "Relatorio Resumido de Esterilização cMT Viewer" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*
		@ 05, 240 	HPDFPRINT IMAGE "logo_cliente.png" width 35 height 4 TYPE PNG
        @ 05,12 		HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
	  //@ 18, 150 HPDFPRINT "T5: " +  cF0Acumulado5  FONT cFonte1 size nFonte_size3 COLOR Verifica_F0_Acumulado2(cF0Acumulado5,nTipo,aCfg_Rel1[3],aCfg_Rel2[3])
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
		
		//@ 090 , 285 HPDFPRINT "T5" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		//@ 092 , 287  HPDFPRINT LINE TO  92 , 290 PENWIDTH 1 COLOR BROWN
		
		//@ 095 , 285 HPDFPRINT "T6" FONT cFonte1 size nFonte_size1 COLOR { 0, 0, 0 } RIGHT		  		
		//@ 097 , 287  HPDFPRINT LINE TO  97 , 290 PENWIDTH 1 COLOR ORANGE

IF oQuery:LastRec() >= 1
               For npos:= 1 To oQuery:LastRec()
                        oRow := oQuery:GetRow(npos)
			

			//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.","SITUAÇÃO","OPERADOR","LOTE","CARGA","SETOR","MATERIAIS1","MATERIAIS2","MATERIAIS3","MATERIAIS4","MATERIAIS5"}
			
				x1_pdf := 1 + (nPos * nEscala_X_pdf)
				//msginfo(SUBSTR(aLinha_g[3],1,2) +"   " + SUBSTR(aLinha_g[3],4,2) )
				y1a:= oRow:FieldGet(3)
				y2a:= oRow:FieldGet(4)
				y3a:= oRow:FieldGet(5)
				y4a:= oRow:FieldGet(6)
				//y5a:= oRow:FieldGet(7)
				//y6a:= oRow:FieldGet(8)
				
				if nPos == 1  // para iniciar apartir da temperatura inicial ao inves do zero ate primeira leitura
					y1b:= y1a  
					y2b:= y2a
					y3b:= y3a
					y4b:= y4a
					//y5b:= y5a
					//y6b:= y6a
				endif

   if lSuccess
					
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLACK
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y2a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y2b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BLUE
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y3a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y3b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR GREEN
			@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y4a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y4b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR RED
			//@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y5a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y5b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR BROWN
			//@   _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y6a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x1_pdf)    HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y6b),  _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM(x2_pdf) PENWIDTH 0.10 COLOR ORANGE
	
			if npos == 1
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Ciclo : " +  hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS"), Nil, 8, 90 , , , , 'T' ) 
			endif
			
			if alltrim(UTF8ToStr( oRow:FieldGet(12))) == "ESTERILIZACAO" .AND. lInicio == .F.
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Est. : "  +  hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS"), Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) PENWIDTH 0.25 COLOR {204,102,255}   // linha inicio esterilizacao
				HPDFPRINT_SetDash(0)
				lInicio := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif

			if alltrim(UTF8ToStr( oRow:FieldGet(12))) == "DEPRESSAO"  .AND. lFim == .F.
			//msginfo(STR(x1_pdf))
				oRow := oQuery:GetRow(npos-1)
				x1_pdf_est := 1 + ( ( nPos-1) * nEscala_X_pdf  )  // volta uma posição pra tracar a linha
				//msginfo(STR(x1_pdf_est))
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Est. : " + hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS"), Nil, 8, 90 , , , , 'T' )  

				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) - _HMG_HPDF_Pixel2MM(oRow:FieldGet(3)) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est )  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est) PENWIDTH 0.25 COLOR {204,102,255}   // linha fim esterilizacao
				HPDFPRINT_SetDash(0)
				lFim := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
				
			endif
			
			if npos == oQuery:LastRec()
			// HPDF_RotateText( 50, 100, "Top", Nil, Nil, 90 , , ,{255 , 0, 255} , 'T' ) // vertical top e bottom
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Autoclave) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Ciclo : " + hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS"), Nil, 8, 90 , , , , 'T' ) 
			endif

			
//msgdebug(str(50 + _HMG_HPDF_Pixel2MM( x1_pdf/10 ) )	)
	endif

				// grava as posiçãoe final de cada valor para iniciar na proxima leitura de valor deve ficar abaixo do desenho do grafico sempre
				x2_pdf := x1_pdf
				y1b:= y1a  
				y2b:= y2a
				y3b:= y3a
				y4b:= y4a
				//y5b:= y5a
				//y6b:= y6a 

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
cSetor := alltrim(UTF8ToStr( oRow2:FieldGet(17)))
cCiclo := alltrim(str(oRow2:FieldGet(25)) )
cTempo_est := alltrim(str(oRow2:FieldGet(26)) )
cLote := alltrim(UTF8ToStr( oRow2:FieldGet(15)))
cCarga := alltrim(UTF8ToStr( oRow2:FieldGet(16)))
cOperador := alltrim(UTF8ToStr( oRow2:FieldGet(14)))
cData_EST := hb_TtoC(t"1970-01-01" + oRow2:fieldGet(2) /60 /60 /24, "DD/MM/YYYY" , ""  ) 
cLinha1 := iif( empty(UTF8ToStr( oRow2:fieldGet(21))) .or. UTF8ToStr( oRow2:fieldGet(21)) == "NA", UTF8ToStr( oRow2:fieldGet(20) ) , UTF8ToStr( oRow2:fieldGet(20) ) + ", "  )
cLinha2 := iif( empty(UTF8ToStr( oRow2:fieldGet(22))) .or. UTF8ToStr( oRow2:fieldGet(22)) == "NA", UTF8ToStr( oRow2:fieldGet(21) ) , UTF8ToStr( oRow2:fieldGet(21) ) + ", "  )
cLinha3 := iif( empty(UTF8ToStr( oRow2:fieldGet(23))) .or. UTF8ToStr( oRow2:fieldGet(23)) == "NA", UTF8ToStr( oRow2:fieldGet(22) ) , UTF8ToStr( oRow2:fieldGet(22) ) + ", "  )
cLinha4 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", UTF8ToStr( oRow2:fieldGet(23) ) , UTF8ToStr( oRow2:fieldGet(23) ) + ", "  )
cLinha5 := iif( empty(UTF8ToStr( oRow2:fieldGet(24))) .or. UTF8ToStr( oRow2:fieldGet(24)) == "NA", "" , UTF8ToStr( oRow2:fieldGet(24) ) )
cEdit1 := cLinha1 + cLinha2 + cLinha3 + cLinha4 + cLinha5 ///alltrim(UTF8ToStr( Alltrim(oRow2:fieldGet(20))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(21))) + ", " + UTF8ToStr(Alltrim(oRow2:fieldGet(22))) +", " + UTF8ToStr(Alltrim(oRow2:fieldGet(23)))+", " + UTF8ToStr(Alltrim(oRow2:fieldGet(24))))
nMIM_Estufas := VAL(cCiclo) -15
nMax_Estufas := VAL(cCiclo) +15
cArquivo:= DiskName()+ ":\"+CurDir() + "\Relatorio Grafico cMT Viewer(M) -" +cMaquina +"-"+ cCodigo + ".pdf" 


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
            SET HPDFDOC PAGEOUTLINE TITLE "Relatorio Resumido de Esterilização cMT Viewer" 
            // Draw_HeaderBox_Orcamento()
            // Print_Syntax_Header_Orcamento( "HMG_HPDF Introduction" )

         *--------------- Rectangulo com Sombra e Dados do Remetente -----------*

   		@ 05, 240 	HPDFPRINT IMAGE "logo_cliente.png" width 35 height 4 TYPE PNG
        @ 05,12 	HPDFPRINT "Relatório de Esterilização cMT Viewer - " + cMaquina  FONT cFonte1 size nFonte_size3 COLOR { 50, 5, 255 } // CENTER
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
				y1a:= oRow:FieldGet(3)
				y2a:= oRow:FieldGet(4)
				y3a:= oRow:FieldGet(5)
				y4a:= oRow:FieldGet(6)
				y5a:= oRow:FieldGet(7)
				y6a:= oRow:FieldGet(8)
				
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
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Ciclo : " +  hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS"), Nil, 8, 90 , , , , 'T' ) 
			endif
			
			if alltrim(UTF8ToStr( oRow:FieldGet(12))) == "ESTERILIZACAO" .AND. lInicio == .F.
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"I. Est. : "  +  hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS"), Nil, 8, 90 , , , , 'T' )  
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(Y1a) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf)  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) PENWIDTH 0.25 COLOR {204,102,255}   // linha inicio esterilizacao
				HPDFPRINT_SetDash(0)
				lInicio := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
			endif

			if alltrim(UTF8ToStr( oRow:FieldGet(12))) == "RESFRIAMENTO"  .AND. lFim == .F.
				oRow := oQuery:GetRow(npos-1)
				//msginfo(STR(x1_pdf))
				x1_pdf_est := 1 + ( (nPos-1) * nEscala_X_pdf )  // volta uma posição pra tracar a linha
				//msginfo(STR(x1_pdf_est))
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Est. : " + hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS"), Nil, 8, 90 , , , , 'T' )  
				
				HPDFPRINT_SetDash( 1, 1, 1)
					@ _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) - _HMG_HPDF_Pixel2MM(oRow:FieldGet(3)) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est )  HPDFPRINT LINE TO  _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf_est) PENWIDTH 0.25 COLOR {204,102,255}   // linha fim esterilizacao
				HPDFPRINT_SetDash(0)
				lFim := .T. // executa uma vez depois somente quando chamar a funcaop novamente volta .f.
				
			endif
			
			if npos == oQuery:LastRec()
			// HPDF_RotateText( 50, 100, "Top", Nil, Nil, 90 , , ,{255 , 0, 255} , 'T' ) // vertical top e bottom
				HPDFPRINT_RotateText( _HMG_HPDF_Pixel2MM(nRow_Lines_Estufas) , _HMG_HPDF_Pixel2MM(nCol_Lines) + _HMG_HPDF_Pixel2MM( x1_pdf) ,"F. Ciclo : " + hb_GetDateTimeTT(oRow:fieldGet(2),"" , "HH:MM:SS"), Nil, 8, 90 , , , , 'T' ) 
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

  
  




