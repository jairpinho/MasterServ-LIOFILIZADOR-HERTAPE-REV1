#include <hmg.ch>
#include "F_Sistema.ch"
DECLARE WINDOW Form_Processo
DECLARE WINDOW Form_Config_Analog4
DECLARE WINDOW Form_Relatorio
*************************************************************************************************************************************************************
Procedure Processo()
*************************************************************************************************************************************************************

lWindow := .F.
IF !IsWindowDefined(Form_Processo)	
        Load Window Form_Processo
 
		IF lCom_status == .F.
			//Sintaxe: AFILL( <vetor destino>, < valor>,<início>, <quantidade>).
			//Afill (vetor, 4) // resultado: vetor = {4, 4, 4, 4, 4}
			AFILL( aMaquina1,"",1, 10)
			AFILL( aMaquina2,"",1, 10)
			AFILL( aMaquina3,"",1, 10)
			AFILL( aMaquina4,"",1, 10)
			AFILL( aMaquina5,"",1, 10)
			//AFILL( aDados_Processo_Maq1, "0" ,2, 20)
			//AFILL( aDados_Processo_Maq2, "0" ,2, 20)
			//AFILL( aDados_Processo_Maq3, "0" ,2, 20)
			//AFILL( aDados_Processo_Maq4, "0" ,2, 20)
			//AFILL( aDados_Processo_Maq5, "0" ,2, 20)
		endif
		aCiclos_AC := EncheArray_Generic( 1,"ciclos_autoclaves", .T.) 
		aTempo_secagem_AC := EncheArray_Generic( 1,"tempo_secagem_autoclaves", .T.) 
		aTempo_esterelizacao_AC := EncheArray_Generic( 1,"tempo_esterelizacao_autoclaves", .T.) 
		aCiclos_ES := EncheArray_Generic( 1,"ciclos_estufas", .T.) 
		aTempo_esterelizacao_ES := EncheArray_Generic( 1,"tempo_esterelizacao_es", .T.) 
		
		
		
		//msginfo(STR(aConfig_Maq4[5][6] ))
		
			Form_Processo.Button_2.Enabled :=.F.
			Form_Processo.Button_4.Enabled :=.F.
			Form_Processo.Button_6.Enabled :=.F.
			Form_Processo.Button_8.Enabled :=.F.
			Form_Processo.Button_10.Enabled :=.F.
						
			Form_Processo.Row := 10
			Form_Processo.Col := 10	
			Form_Processo.Title := "Esterilização Central\" + cHostName + ":" + cPort + "\" + cDatabase			

			lWindow := .T.

        Form_Processo.Activate
ENDIF

		

Return




*************************************************************************************************************************************************************
Function Verifica_Alarmes()
*************************************************************************************************************************************************************
	IF lCom_status == .T.
			IF VAL(alltrim(aMaquina1[10])) == 1
				aEnvia[1] := "0" 
				estapas_processo_1 := .F.
				Form_Processo.Button_1.Enabled :=.F.
				Form_Processo.Button_2.Enabled :=.F.
				Form_Processo.Image_1.Picture := "CNX_OFF"
				MSGINFO("ALTA PRESSÃO CAMISA INTERNA LUFERCO (APERTE RESETAR NO PROCESSO) ")
			ELSEIF VAL(alltrim(aMaquina1[10])) == 2
				aEnvia[1] := "0" 
				Form_Processo.Button_1.Enabled :=.F.
				Form_Processo.Button_2.Enabled :=.F.
				Form_Processo.Image_1.Picture := "CNX_OFF"
				estapas_processo_1 := .F.
				MSGINFO("BAIXA PRESSÃO CAMISA EXTERNA LUFERCO(APERTE RESETAR NO PROCESSO) ")
			ELSEIF VAL(alltrim(aMaquina1[10])) == 3
				aEnvia[1] := "0" 
				Form_Processo.Button_1.Enabled :=.F.
				Form_Processo.Button_2.Enabled :=.F.
				Form_Processo.Image_1.Picture := "CNX_OFF"
				estapas_processo_1 := .F.
				MSGINFO("PRESSÃO CAMISA EXTERNA ABAIXO DO SETPOINT LUFERCO (APERTE RESETAR NO PROCESSO) ")
			ELSEIF VAL(alltrim(aMaquina1[10])) == 4
				aEnvia[1] := "0" 
				Form_Processo.Button_1.Enabled :=.F.
				Form_Processo.Button_2.Enabled :=.F.
				Form_Processo.Image_1.Picture := "CNX_OFF"
				estapas_processo_1 := .F.
				MSGINFO("PRESSÃO CAMISA EXTERNA ACIMA DO SETPOINT LUFERCO (APERTE RESETAR NO PROCESSO) ")
			ENDIF
	ENDIF
	
	IF lCom_status == .T.
			IF VAL(alltrim(aMaquina2[10])) == 1
				aEnvia[5] := "0" 
				estapas_processo_2 := .F.
				Form_Processo.Button_3.Enabled :=.F.
				Form_Processo.Button_4.Enabled :=.F.
				Form_Processo.Image_2.Picture := "CNX_OFF"
				MSGINFO("ALTA PRESSÃO CAMISA INTERNA SERCON (APERTE RESETAR NO PROCESSO) ")
			ELSEIF VAL(alltrim(aMaquina2[10])) == 2
				aEnvia[5] := "0" 
				Form_Processo.Button_3.Enabled :=.F.
				Form_Processo.Button_4.Enabled :=.F.
				Form_Processo.Image_2.Picture := "CNX_OFF"
				estapas_processo_2 := .F.
				MSGINFO("BAIXA PRESSÃO CAMISA EXTERNA SERCON(APERTE RESETAR NO PROCESSO) ")
			ELSEIF VAL(alltrim(aMaquina2[10])) == 3
				aEnvia[5] := "0" 
				Form_Processo.Button_3.Enabled :=.F.
				Form_Processo.Button_4.Enabled :=.F.
				Form_Processo.Image_2.Picture := "CNX_OFF"
				estapas_processo_2 := .F.
				MSGINFO("PRESSÃO CAMISA EXTERNA ABAIXO DO SETPOINT SERCON (APERTE RESETAR NO PROCESSO) ")
			ELSEIF VAL(alltrim(aMaquina2[10])) == 4
				aEnvia[5] := "0" 
				Form_Processo.Button_3.Enabled :=.F.
				Form_Processo.Button_4.Enabled :=.F.
				Form_Processo.Image_2.Picture := "CNX_OFF"
				estapas_processo_2 := .F.
				MSGINFO("PRESSÃO CAMISA EXTERNA ACIMA DO SETPOINT SERCON (APERTE RESETAR NO PROCESSO) ")
			ENDIF
	ENDIF	
	
Return

*************************************************************************************************************************************************************
Function Reseta_alarme_Maq1() 
*************************************************************************************************************************************************************
IF Usuario()
aEnvia[1] := "10"
Form_Processo.Button_1.Enabled :=.T.
AFILL( aEtapa_Maq1, .F. ,1, 10)
endif
Return

*************************************************************************************************************************************************************
Function Reseta_alarme_Maq2() 
*************************************************************************************************************************************************************
IF Usuario()
aEnvia[5] := "10"
Form_Processo.Button_3.Enabled :=.T.
AFILL( aEtapa_Maq2, .F. ,1, 10)
endif
Return




*************************************************************************************************************************************************************
Procedure Carregadados_processo()
*************************************************************************************************************************************************************

//DECLARE WINDOW Form_Processo



IF lCom_status == .T.

	IF IsWindowDefined(Form_Processo)		

		Form_Processo.Text_1.Value := escala1(aMaquina1[6],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_2.Value := escala1(aMaquina1[2],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_3.Value := escala1(aMaquina1[3],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_4.Value := escala1(aMaquina1[4],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_5.Value := escala1(aMaquina1[5],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_12.Value := escala1(aMaquina1[8],0,4000,-1,5) //alltrim(aMaquina1[1])
		Form_Processo.Text_13.Value := escala1(aMaquina1[7],0,4000,-1,5) //alltrim(aMaquina1[1])
		
		Form_Processo.Text_25.Value := escala1(aMaquina2[1],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_26.Value := escala1(aMaquina2[2],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_27.Value := escala1(aMaquina2[5],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_28.Value := escala1(aMaquina2[4],0,4000,-100,250,,10) //alltrim(aMaquina1[1])
		Form_Processo.Text_29.Value := escala1(aMaquina2[6],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_37.Value := escala1(aMaquina2[8],0,4000,-1,5) //alltrim(aMaquina1[1])
		Form_Processo.Text_38.Value := escala1(aMaquina2[7],0,4000,-1,5) //alltrim(aMaquina1[1])
		
		
		Form_Processo.Text_51.Value := escala1(aMaquina3[1],0,4000,0,400) //alltrim(aMaquina1[1])
		Form_Processo.Text_52.Value := escala1(aMaquina3[2],0,4000,0,400) //alltrim(aMaquina1[1])
		Form_Processo.Text_53.Value := escala1(aMaquina3[7],0,4000,0,400) //alltrim(aMaquina1[1])
		Form_Processo.Text_54.Value := escala1(aMaquina3[8],0,4000,0,400) //alltrim(aMaquina1[1])
		Form_Processo.Text_55.Value := escala1(aMaquina3[5],0,4000,0,400) //alltrim(aMaquina1[1])
		Form_Processo.Text_56.Value := escala1(aMaquina3[6],0,4000,0,400) //alltrim(aMaquina1[1])
		
		/*
		Form_Processo.Text_71.Value := escala1(aMaquina4[1],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_72.Value := escala1(aMaquina4[2],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_73.Value := escala1(aMaquina4[3],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_74.Value := escala1(aMaquina4[4],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_75.Value := escala1(aMaquina4[5],0,4000,0,400) //alltrim(aMaquina1[1])
		Form_Processo.Text_76.Value := escala1(aMaquina4[6],0,4000,-100,250) //alltrim(aMaquina1[1])
		*/
		
		
		Form_Processo.Text_71.Value := Temp_Maq4[1] //escala1(aMaquina4[1],aConfig_Maq4[1][5],aConfig_Maq4[1][4],aConfig_Maq4[1][3],aConfig_Maq4[1][2],,aConfig_Maq4[1][6]) //alltrim(aMaquina1[1])
		Form_Processo.Text_72.Value := Temp_Maq4[2] //escala1(aMaquina4[2],aConfig_Maq4[2][5],aConfig_Maq4[2][4],aConfig_Maq4[2][3],aConfig_Maq4[2][2],,aConfig_Maq4[2][6]) //alltrim(aMaquina1[1])
		Form_Processo.Text_73.Value := Temp_Maq4[3] // escala1(aMaquina4[3],aConfig_Maq4[3][5],aConfig_Maq4[3][4],aConfig_Maq4[3][3],aConfig_Maq4[3][2],,aConfig_Maq4[3][6]) //alltrim(aMaquina1[1])
		Form_Processo.Text_74.Value := Temp_Maq4[4] // escala1(aMaquina4[8],aConfig_Maq4[4][5],aConfig_Maq4[4][4],aConfig_Maq4[4][3],aConfig_Maq4[4][2],,aConfig_Maq4[4][6]) //alltrim(aMaquina1[1])
		Form_Processo.Text_75.Value := Temp_Maq4[5] // escala1(aMaquina4[7],aConfig_Maq4[5][5],aConfig_Maq4[5][4],aConfig_Maq4[5][3],aConfig_Maq4[5][2],,aConfig_Maq4[5][6]) //alltrim(aMaquina1[1])
		Form_Processo.Text_76.Value := Temp_Maq4[6] //escala1(aMaquina4[6],aConfig_Maq4[6][5],aConfig_Maq4[6][4],aConfig_Maq4[6][3],aConfig_Maq4[6][2],,aConfig_Maq4[6][6]) //alltrim(aMaquina1[1])	
		
		
		
		
		Form_Processo.Text_100.Value := escala1(aMaquina5[1],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_101.Value := escala1(aMaquina5[6],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_102.Value := escala1(aMaquina5[3],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_103.Value := escala1(aMaquina5[4],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_104.Value := escala1(aMaquina5[5],0,4000,-100,250) //alltrim(aMaquina1[1])
		Form_Processo.Text_105.Value := escala1(aMaquina5[2],0,4000,-100,250) //alltrim(aMaquina1[1])

	endif
	
		IF IsWindowDefined(Form_Config_Analog4)		
				Form_Config_Analog4.Text_5.Value	  := alltrim(aMaquina4[Form_Config_Analog4.Combo_1.Value])
				nOffSET1:= VAL(Form_Config_Analog4.Text_6.Value)
				Form_Config_Analog4.Text_7.Value  := Temp_Maq4[1] //escala1(aMaquina4[1],aConfig_Maq4[1][5],aConfig_Maq4[1][4],aConfig_Maq4[1][3],aConfig_Maq4[1][2],,nOffSET1)		

				Form_Config_Analog4.Text_14.Value	  := alltrim(aMaquina4[Form_Config_Analog4.Combo_2.Value])
				nOffSET2:= VAL(Form_Config_Analog4.Text_15.Value)
				Form_Config_Analog4.Text_16.Value  := Temp_Maq4[2] // escala1(aMaquina4[2],aConfig_Maq4[2][5],aConfig_Maq4[2][4],aConfig_Maq4[2][3],aConfig_Maq4[2][2],,nOffSET2)		

				Form_Config_Analog4.Text_24.Value	  := alltrim(aMaquina4[Form_Config_Analog4.Combo_3.Value])
				nOffSET3:= VAL(Form_Config_Analog4.Text_25.Value)
				Form_Config_Analog4.Text_26.Value  := Temp_Maq4[3] // escala1(aMaquina4[3],aConfig_Maq4[3][5],aConfig_Maq4[3][4],aConfig_Maq4[3][3],aConfig_Maq4[3][2],,nOffSET3)		

				Form_Config_Analog4.Text_34.Value	  := alltrim(aMaquina4[Form_Config_Analog4.Combo_4.Value])
				nOffSET4:= VAL(Form_Config_Analog4.Text_35.Value)
				Form_Config_Analog4.Text_36.Value  := Temp_Maq4[4] // escala1(aMaquina4[4],aConfig_Maq4[4][5],aConfig_Maq4[4][4],aConfig_Maq4[4][3],aConfig_Maq4[4][2],,nOffSET4)		
		
				Form_Config_Analog4.Text_44.Value	  := alltrim(aMaquina4[Form_Config_Analog4.Combo_5.Value])
				nOffSET5:= VAL(Form_Config_Analog4.Text_45.Value)
				Form_Config_Analog4.Text_46.Value  := Temp_Maq4[5] // escala1(aMaquina4[5],aConfig_Maq4[5][5],aConfig_Maq4[5][4],aConfig_Maq4[5][3],aConfig_Maq4[5][2],,nOffSET5)		
				
				Form_Config_Analog4.Text_54.Value	  := alltrim(aMaquina4[Form_Config_Analog4.Combo_6.Value])
				nOffSET6:= VAL(Form_Config_Analog4.Text_55.Value)
				Form_Config_Analog4.Text_56.Value  := Temp_Maq4[6] //escala1(aMaquina4[6],aConfig_Maq4[6][5],aConfig_Maq4[6][4],aConfig_Maq4[6][3],aConfig_Maq4[6][2],,nOffSET6)		
				
				Form_Config_Analog4.Text_64.Value	  := alltrim(aMaquina4[Form_Config_Analog4.Combo_7.Value])
				nOffSET7:= VAL(Form_Config_Analog4.Text_65.Value)
				Form_Config_Analog4.Text_66.Value  := Temp_Maq4[7] //escala1(aMaquina4[7],aConfig_Maq4[7][5],aConfig_Maq4[7][4],aConfig_Maq4[7][3],aConfig_Maq4[7][2],,nOffSET7)		
				
				Form_Config_Analog4.Text_74.Value	  := alltrim(aMaquina4[Form_Config_Analog4.Combo_8.Value])
				nOffSET8:= VAL(Form_Config_Analog4.Text_75.Value)
				Form_Config_Analog4.Text_76.Value  := Temp_Maq4[8] // escala1(aMaquina4[8],aConfig_Maq4[8][5],aConfig_Maq4[8][4],aConfig_Maq4[8][3],aConfig_Maq4[8][2],,nOffSET8)		
				
		endif

	
endif
Return



*************************************************************************************************************************************************************
Procedure Config_analogico4()
*************************************************************************************************************************************************************


IF !IsWindowDefined(Form_Config_Analog4)	
	Load Window Form_Config_Analog4
	aConfig_Maq4 := Carrega_config(4)
	
	
		Form_Config_Analog4.Text_1.Value  := Alltrim(STR(aConfig_Maq4[1][2]))
		Form_Config_Analog4.Text_2.Value  := Alltrim(STR(aConfig_Maq4[1][3]))
		Form_Config_Analog4.Text_3.Value  := Alltrim(STR(aConfig_Maq4[1][4]))
		Form_Config_Analog4.Text_4.Value  := Alltrim(STR(aConfig_Maq4[1][5]))
		Form_Config_Analog4.Text_6.Value  := Alltrim(STR(aConfig_Maq4[1][6]))
		Form_Config_Analog4.Combo_1.Value := aConfig_Maq4[1][9]

		Form_Config_Analog4.Text_10.Value := Alltrim(STR(aConfig_Maq4[2][2]))
		Form_Config_Analog4.Text_11.Value := Alltrim(STR(aConfig_Maq4[2][3]))
		Form_Config_Analog4.Text_12.Value := Alltrim(STR(aConfig_Maq4[2][4]))
		Form_Config_Analog4.Text_13.Value := Alltrim(STR(aConfig_Maq4[2][5]))
		Form_Config_Analog4.Text_15.Value := Alltrim(STR(aConfig_Maq4[2][6]))
		Form_Config_Analog4.Combo_2.Value := aConfig_Maq4[2][9]
		
		Form_Config_Analog4.Text_20.Value := Alltrim(STR(aConfig_Maq4[3][2]))
		Form_Config_Analog4.Text_21.Value := Alltrim(STR(aConfig_Maq4[3][3]))
		Form_Config_Analog4.Text_22.Value := Alltrim(STR(aConfig_Maq4[3][4]))
		Form_Config_Analog4.Text_23.Value := Alltrim(STR(aConfig_Maq4[3][5]))
		Form_Config_Analog4.Text_25.Value := Alltrim(STR(aConfig_Maq4[3][6]))
		Form_Config_Analog4.Combo_3.Value := aConfig_Maq4[3][9]
		
		Form_Config_Analog4.Text_30.Value := Alltrim(STR(aConfig_Maq4[4][2]))
		Form_Config_Analog4.Text_31.Value := Alltrim(STR(aConfig_Maq4[4][3]))
		Form_Config_Analog4.Text_32.Value := Alltrim(STR(aConfig_Maq4[4][4]))
		Form_Config_Analog4.Text_33.Value := Alltrim(STR(aConfig_Maq4[4][5]))
		Form_Config_Analog4.Text_35.Value := Alltrim(STR(aConfig_Maq4[4][6]))
		Form_Config_Analog4.Combo_4.Value := aConfig_Maq4[4][9]
		
		Form_Config_Analog4.Text_40.Value := Alltrim(STR(aConfig_Maq4[5][2]))
		Form_Config_Analog4.Text_41.Value := Alltrim(STR(aConfig_Maq4[5][3]))
		Form_Config_Analog4.Text_42.Value := Alltrim(STR(aConfig_Maq4[5][4]))
		Form_Config_Analog4.Text_43.Value := Alltrim(STR(aConfig_Maq4[5][5]))
		Form_Config_Analog4.Text_45.Value := Alltrim(STR(aConfig_Maq4[5][6]))
		Form_Config_Analog4.Combo_5.Value := aConfig_Maq4[5][9]
		
		Form_Config_Analog4.Text_50.Value := Alltrim(STR(aConfig_Maq4[6][2]))
		Form_Config_Analog4.Text_51.Value := Alltrim(STR(aConfig_Maq4[6][3]))
		Form_Config_Analog4.Text_52.Value := Alltrim(STR(aConfig_Maq4[6][4]))
		Form_Config_Analog4.Text_53.Value := Alltrim(STR(aConfig_Maq4[6][5]))
		Form_Config_Analog4.Text_55.Value := Alltrim(STR(aConfig_Maq4[6][6]))
		Form_Config_Analog4.Combo_6.Value := aConfig_Maq4[6][9]
		
		Form_Config_Analog4.Text_60.Value := Alltrim(STR(aConfig_Maq4[7][2]))
		Form_Config_Analog4.Text_61.Value := Alltrim(STR(aConfig_Maq4[7][3]))
		Form_Config_Analog4.Text_62.Value := Alltrim(STR(aConfig_Maq4[7][4]))
		Form_Config_Analog4.Text_63.Value := Alltrim(STR(aConfig_Maq4[7][5]))
		Form_Config_Analog4.Text_65.Value := Alltrim(STR(aConfig_Maq4[7][6]))
		Form_Config_Analog4.Combo_7.Value := aConfig_Maq4[7][9]
		
		Form_Config_Analog4.Text_70.Value := Alltrim(STR(aConfig_Maq4[8][2]))
		Form_Config_Analog4.Text_71.Value := Alltrim(STR(aConfig_Maq4[8][3]))
		Form_Config_Analog4.Text_72.Value := Alltrim(STR(aConfig_Maq4[8][4]))
		Form_Config_Analog4.Text_73.Value := Alltrim(STR(aConfig_Maq4[8][5]))
		Form_Config_Analog4.Text_75.Value := Alltrim(STR(aConfig_Maq4[8][6]))
		Form_Config_Analog4.Combo_8.Value := aConfig_Maq4[8][9]

	
	
	Form_Config_Analog4.Center
	Form_Config_Analog4.Activate
Else
   	*** Centraliza janela
	Form_Config_Analog4.Center
	Form_Config_Analog4.Restore

	Return
EndIF




Return


*************************************************************************************************************************************************************
FUNCTION Carrega_Config(nMAquina)
*************************************************************************************************************************************************************
Local cTabela	:= "config_maquinas"
Local oRow := {}
Local oQuery := ""
Local nCanal := 8
Local nPos	:= 0
Local aQuery := array(8,9)  //8 canais do modulo  e 9 campos de dados do banco
Local i2:=0
Local cQueri := ""

				oQuery := oServer:Query("Select * From " + cTabela + " WHERE maquina = " + AllTrim(STR(nMaquina ))  )
                  
				  If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Operação) (): " + oQuery:Error())
                     Return Nil
                  Endif               
                 
IF oQuery:LastRec() > 0
					
FOR I := 1 To oQuery:LastRec()		

		oRow := oQuery:GetRow(i)
		
		if VAL(oRow:FieldGet(8))  == I
			
			FOR I2 := 1 To 9
			
			aQuery[I][I2] := IIF( Empty( oRow:FieldGet(I2) ), 0 ,oRow:FieldGet(I2) )
			//cQueri := hb_arrayGetC(aQuery)
			
				//msginfo( STR(oRow:FieldGet(2)) +"-"+ oRow:FieldGet(8) )
				
				/*
				atribuicao direta -> Local aQuery := array(8,8)
				aQuery[I][I2] := oRow:FieldGet(I2)
				// msginfo(aQuery[I][I2])
				*/
				
				
				/*
				atribuicao dinamica -> Local aQuery := {}

				*/
				
				//AADD(aQuery[I], oRow:FieldGet(I2) ) 
				//MsgDebug(aQuery[i][I2])
				
				
			NEXT

		ENDIF


/*		
	if VAL(oRow:FieldGet(8))  == 1
		Form_Config_Analog4.Text_1.Value  := Alltrim(STR(oRow:FieldGet(2)))
		Form_Config_Analog4.Text_2.Value  := Alltrim(STR(oRow:FieldGet(3)))
		Form_Config_Analog4.Text_3.Value  := Alltrim(STR(oRow:FieldGet(4)))
		Form_Config_Analog4.Text_4.Value  := Alltrim(STR(oRow:FieldGet(5)))
	elseif VAL(oRow:FieldGet(8))  == 2
		Form_Config_Analog4.Text_10.Value := Alltrim(STR(aQuery[2][2]))
		Form_Config_Analog4.Text_11.Value := Alltrim(STR(aQuery[2][3]))
		Form_Config_Analog4.Text_12.Value := Alltrim(STR(aQuery[2][4]))
		Form_Config_Analog4.Text_13.Value := Alltrim(STR(aQuery[2][5]))
	elseif VAL(oRow:FieldGet(8))  == 3
		Form_Config_Analog4.Text_20.Value := Alltrim(STR(oRow:FieldGet(2)))
		Form_Config_Analog4.Text_21.Value := Alltrim(STR(oRow:FieldGet(3)))
		Form_Config_Analog4.Text_22.Value := Alltrim(STR(oRow:FieldGet(4)))
		Form_Config_Analog4.Text_23.Value := Alltrim(STR(oRow:FieldGet(5)))
	elseif VAL(oRow:FieldGet(8))  == 4
		Form_Config_Analog4.Text_30.Value := Alltrim(STR(oRow:FieldGet(2)))
		Form_Config_Analog4.Text_31.Value := Alltrim(STR(oRow:FieldGet(3)))
		Form_Config_Analog4.Text_32.Value := Alltrim(STR(oRow:FieldGet(4)))
		Form_Config_Analog4.Text_33.Value := Alltrim(STR(oRow:FieldGet(5)))
	elseif VAL(oRow:FieldGet(8))  == 5
		Form_Config_Analog4.Text_40.Value := Alltrim(STR(oRow:FieldGet(2)))
		Form_Config_Analog4.Text_41.Value := Alltrim(STR(oRow:FieldGet(3)))
		Form_Config_Analog4.Text_42.Value := Alltrim(STR(oRow:FieldGet(4)))
		Form_Config_Analog4.Text_43.Value := Alltrim(STR(oRow:FieldGet(5)))
	elseif VAL(oRow:FieldGet(8))  == 6
		Form_Config_Analog4.Text_50.Value := Alltrim(STR(oRow:FieldGet(2)))
		Form_Config_Analog4.Text_51.Value := Alltrim(STR(oRow:FieldGet(3)))
		Form_Config_Analog4.Text_52.Value := Alltrim(STR(oRow:FieldGet(4)))
		Form_Config_Analog4.Text_53.Value := Alltrim(STR(oRow:FieldGet(5)))
	elseif VAL(oRow:FieldGet(8))  == 7
		Form_Config_Analog4.Text_60.Value := Alltrim(STR(oRow:FieldGet(2)))
		Form_Config_Analog4.Text_61.Value := Alltrim(STR(oRow:FieldGet(3)))
		Form_Config_Analog4.Text_62.Value := Alltrim(STR(oRow:FieldGet(4)))
		Form_Config_Analog4.Text_63.Value := Alltrim(STR(oRow:FieldGet(5)))
	elseif VAL(oRow:FieldGet(8))  == 8
		Form_Config_Analog4.Text_70.Value := Alltrim(STR(oRow:FieldGet(2)))
		Form_Config_Analog4.Text_71.Value := Alltrim(STR(oRow:FieldGet(3)))
		Form_Config_Analog4.Text_72.Value := Alltrim(STR(oRow:FieldGet(4)))
		Form_Config_Analog4.Text_73.Value := Alltrim(STR(oRow:FieldGet(5)))
 	endif
*/

	
	
		oQuery:Skip(1)

NEXT	
//msginfo(STR(oQuery:LastRec()))

else
FOR I2 := 1 To 8 // linhas canal de cada modulo a serem lidos de cada modulo
	AFILL( aQuery[i2], 0 ,2, 9) // apaga os campos do 2 ao 9 de cada linha(canal) do modulo
		//msginfo( STR(i2)+ ", 2= " + STR(aQuery[i2][2] ))
		//msginfo( STR(i2)+ ", 3= " + STR(aQuery[i2][3] ))
		//msginfo( STR(i2)+ ", 4= " + STR(aQuery[i2][4] ))
		//msginfo( STR(i2)+ ", 5= " + STR(aQuery[i2][5] ))
		//msginfo( STR(i2)+ ", 6= " + STR(aQuery[i2][6] ))
Next

endif
//cQueri := hb_arrayGetc(aQuery)

//Form_Config_Analog4.Edit_1.Value := Alltrim(cQueri)
//Form_Config_Analog4.Edit_1.Value :=  Alltrim(alltrim(aQuery[1][1]) +" / "+  STR(aQuery[1][2]) +" / "+ STR(aQuery[1,2]) +" / "+ STR(aQuery[1][3]) +" / "+ STR(aQuery[1][4]) +" / "+ STR(aQuery[1][5]) +" / "+ STR(aQuery[1][6])+" / "+ Alltrim(aQuery[1][7])+" / "+ Alltrim(aQuery[1][8]) )

					
Return(aQuery)





*************************************************************************************************************************************
Function Bt_Salvar_Config_analogicas(nMaquina)  && Salva Dados do Formulário de Cadastro
*************************************************************************************************************************************
	Local cValues := ""
	Local aStruc  := {}
	Local aUpdate := {}
   Local aInsert := {}
	Local cUpdate := ""
	Local cQuery  := "" 
	 Local oRow :={}
    Local oQuery  :="" 
	Local cTabela	:= "config_maquinas"
	Local nCanal := 8
	Local nPos	:= 0
	Local aSCL := Array(9)
	Local cTitulo := "Configurações"
	
//{"CANAL 1","CANAL 2","CANAL 3","CANAL 4","CANAL 5","CANAL 6","CANAL 7","CANAL 8"}
	         	
			
			oQuery  := oServer:Query( "Select maquina From "+cTabela+" WHERE maquina = " + AllTrim( STR(nMaquina )  ))
                 
				 If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Operação) (): " + oQuery:Error())
                     Return Nil
                  Endif               
			
					oRow := oQuery:GetRow()			
			
if val(oRow:fieldGet(1)) > 0 

For nPos := 1 TO 8  // canais do modulo

	nCanal := nPos
	
	if nCanal == 1
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_1.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_2.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_3.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_4.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_6.Value )
		aSCL[6] := Form_Config_Analog4.Combo_1.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
	elseif nCanal == 2
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_10.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_11.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_12.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_13.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_15.Value )
		aSCL[6] := Form_Config_Analog4.Combo_2.Value
		
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )

	elseif nCanal == 3
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_20.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_21.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_22.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_23.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_25.Value )
		aSCL[6] := Form_Config_Analog4.Combo_3.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
		
	elseif nCanal == 4
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_30.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_31.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_32.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_33.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_35.Value )
		aSCL[6] := Form_Config_Analog4.Combo_4.Value
		
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
		
	elseif nCanal == 5
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_40.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_41.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_42.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_43.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_45.Value )
		aSCL[6] := Form_Config_Analog4.Combo_5.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
		
	elseif nCanal == 6
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_50.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_51.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_52.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_53.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_55.Value )
		aSCL[6] := Form_Config_Analog4.Combo_6.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
	elseif nCanal == 7
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_60.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_61.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_62.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_63.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_65.Value )
		aSCL[6] := Form_Config_Analog4.Combo_7.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
	elseif nCanal == 8
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_70.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_71.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_72.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_73.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_75.Value )
		aSCL[6] := Form_Config_Analog4.Combo_8.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )

 	endif
 	
			//MSGExclamation("Editando "+STR(nPos),"SISTEMA")
				
			aUpdate  := Array(9)
			aUpdate[1]:= "OFF"
			aUpdate[2]:= aSCL[1]
			aUpdate[3]:= aSCL[2]
			aUpdate[4]:= aSCL[3]
			aUpdate[5]:= aSCL[4]
			aUpdate[6]:= aSCL[5]
			aUpdate[7]:= "OFF"
			aUpdate[8]:= "OFF"
			aUpdate[9]:= aSCL[6]
	
			aStruc := array(9)	
			aStruc[1]  := 'maquina'
			aStruc[2]  := 'eng_righ'
			aStruc[3]  := 'eng_low'
			aStruc[4]  := 'input_righ'
			aStruc[5]  := 'input_low'
			aStruc[6]  := 'base_f0_z'
			aStruc[7]  := 'modulo'
			aStruc[8]  := 'canal_config'
			aStruc[9]  := 'canal_leitura'

               cUpdate := MysqlQueryUpDate(aUpdate,aStruc)
					cQuery := "UPDATE "+ cTabela + " SET " + cUpdate + " WHERE canal_config = " + AllTrim(STR(nPos)) + " and maquina = " + AllTrim(STR(nMaquina ))

					oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operaçãoxx) (): " + oQuery:Error())
								Return Nil
							Endif
							
next



					Atualiza_Config_Maq4()	
					MSGExclamation("Alteração Efetivada no "+cTitulo,"SISTEMA")  
else

For nPos := 1 TO 8	
	
			//MSGExclamation("Novo "+STR(nPos),"SISTEMA")
	nCanal := nPos
			
	if nCanal == 1
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_1.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_2.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_3.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_4.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_6.Value )
		aSCL[6] := Form_Config_Analog4.Combo_1.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
	elseif nCanal == 2
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_10.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_11.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_12.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_13.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_15.Value )
		aSCL[6] := Form_Config_Analog4.Combo_2.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )

	elseif nCanal == 3
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_20.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_21.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_22.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_23.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_25.Value )
		aSCL[6] := Form_Config_Analog4.Combo_3.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
		
	elseif nCanal == 4
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_30.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_31.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_32.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_33.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_35.Value )
		aSCL[6] := Form_Config_Analog4.Combo_4.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
		
	elseif nCanal == 5
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_40.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_41.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_42.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_43.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_45.Value )
		aSCL[6] := Form_Config_Analog4.Combo_5.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
		
	elseif nCanal == 6
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_50.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_51.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_52.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_53.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_55.Value )
		aSCL[6] := Form_Config_Analog4.Combo_6.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
	elseif nCanal == 7
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_60.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_61.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_62.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_63.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_65.Value )
		aSCL[6] := Form_Config_Analog4.Combo_7.Value
		//msginfo(aSCL[1]+ "-" + aSCL[2]+ "-" + aSCL[3]+ "-" + aSCL[4] )
	elseif nCanal == 8
		aSCL[1] := AllTrim(Form_Config_Analog4.Text_70.Value )
		aSCL[2] := AllTrim(Form_Config_Analog4.Text_71.Value )
		aSCL[3] := AllTrim(Form_Config_Analog4.Text_72.Value )
		aSCL[4] := AllTrim(Form_Config_Analog4.Text_73.Value )
		aSCL[5] := AllTrim(Form_Config_Analog4.Text_75.Value )
		aSCL[6] := Form_Config_Analog4.Combo_8.Value

 	endif
	
			aInsert  := Array(9)
			aInsert[1]:= AllTrim(STR(nMaquina ))
			aInsert[2]:= aSCL[1]
			aInsert[3]:= aSCL[2]
			aInsert[4]:= aSCL[3]
			aInsert[5]:= aSCL[4]
			aInsert[6]:= aSCL[5]
			aInsert[7]:= "OFF"
			aInsert[8]:= nPos
			aInsert[9]:= aSCL[6]
	
			aStruc := array(9)	
			aStruc[1]  := 'maquina'
			aStruc[2]  := 'eng_righ'
			aStruc[3]  := 'eng_low'
			aStruc[4]  := 'input_righ'
			aStruc[5]  := 'input_low'
			aStruc[6]  := 'base_f0_z'
			aStruc[7]  := 'modulo'
			aStruc[8]  := 'canal_config'
			aStruc[9]  := 'canal_leitura'

			
						cValues := MysqlQueryInsert(aInsert,aStruc)
						cQuery:= "INSERT INTO " + cTabela + cValues 
					
						oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operação) (): " + oQuery:Error())
								Return Nil
							Endif  

next
					Atualiza_Config_Maq4()	
					MSGExclamation("Arquivos Criado com Sucesso em "+cTitulo,"SISTEMA")
endif					
	Return Nil


	
***********************************************************************************************************************************
Function Atualiza_Config_Maq4()			
************************************************************************************************************************************
	
	
	aConfig_Maq4 := Carrega_config(4)
	
		Form_Config_Analog4.Text_1.Value  := Alltrim(STR(aConfig_Maq4[1][2]))
		Form_Config_Analog4.Text_2.Value  := Alltrim(STR(aConfig_Maq4[1][3]))
		Form_Config_Analog4.Text_3.Value  := Alltrim(STR(aConfig_Maq4[1][4]))
		Form_Config_Analog4.Text_4.Value  := Alltrim(STR(aConfig_Maq4[1][5]))
		Form_Config_Analog4.Text_6.Value  := Alltrim(STR(aConfig_Maq4[1][6]))
		Form_Config_Analog4.Combo_1.Value := aConfig_Maq4[1][9]

		Form_Config_Analog4.Text_10.Value := Alltrim(STR(aConfig_Maq4[2][2]))
		Form_Config_Analog4.Text_11.Value := Alltrim(STR(aConfig_Maq4[2][3]))
		Form_Config_Analog4.Text_12.Value := Alltrim(STR(aConfig_Maq4[2][4]))
		Form_Config_Analog4.Text_13.Value := Alltrim(STR(aConfig_Maq4[2][5]))
		Form_Config_Analog4.Text_15.Value := Alltrim(STR(aConfig_Maq4[2][6]))
		Form_Config_Analog4.Combo_2.Value := aConfig_Maq4[2][9]
		
		Form_Config_Analog4.Text_20.Value := Alltrim(STR(aConfig_Maq4[3][2]))
		Form_Config_Analog4.Text_21.Value := Alltrim(STR(aConfig_Maq4[3][3]))
		Form_Config_Analog4.Text_22.Value := Alltrim(STR(aConfig_Maq4[3][4]))
		Form_Config_Analog4.Text_23.Value := Alltrim(STR(aConfig_Maq4[3][5]))
		Form_Config_Analog4.Text_25.Value := Alltrim(STR(aConfig_Maq4[3][6]))
		Form_Config_Analog4.Combo_3.Value := aConfig_Maq4[3][9]
		
		Form_Config_Analog4.Text_30.Value := Alltrim(STR(aConfig_Maq4[4][2]))
		Form_Config_Analog4.Text_31.Value := Alltrim(STR(aConfig_Maq4[4][3]))
		Form_Config_Analog4.Text_32.Value := Alltrim(STR(aConfig_Maq4[4][4]))
		Form_Config_Analog4.Text_33.Value := Alltrim(STR(aConfig_Maq4[4][5]))
		Form_Config_Analog4.Text_35.Value := Alltrim(STR(aConfig_Maq4[4][6]))
		Form_Config_Analog4.Combo_4.Value := aConfig_Maq4[4][9]
		
		Form_Config_Analog4.Text_40.Value := Alltrim(STR(aConfig_Maq4[5][2]))
		Form_Config_Analog4.Text_41.Value := Alltrim(STR(aConfig_Maq4[5][3]))
		Form_Config_Analog4.Text_42.Value := Alltrim(STR(aConfig_Maq4[5][4]))
		Form_Config_Analog4.Text_43.Value := Alltrim(STR(aConfig_Maq4[5][5]))
		Form_Config_Analog4.Text_45.Value := Alltrim(STR(aConfig_Maq4[5][6]))
		Form_Config_Analog4.Combo_5.Value := aConfig_Maq4[5][9]
		
		Form_Config_Analog4.Text_50.Value := Alltrim(STR(aConfig_Maq4[6][2]))
		Form_Config_Analog4.Text_51.Value := Alltrim(STR(aConfig_Maq4[6][3]))
		Form_Config_Analog4.Text_52.Value := Alltrim(STR(aConfig_Maq4[6][4]))
		Form_Config_Analog4.Text_53.Value := Alltrim(STR(aConfig_Maq4[6][5]))
		Form_Config_Analog4.Text_55.Value := Alltrim(STR(aConfig_Maq4[6][6]))
		Form_Config_Analog4.Combo_6.Value := aConfig_Maq4[6][9]
		
		Form_Config_Analog4.Text_60.Value := Alltrim(STR(aConfig_Maq4[7][2]))
		Form_Config_Analog4.Text_61.Value := Alltrim(STR(aConfig_Maq4[7][3]))
		Form_Config_Analog4.Text_62.Value := Alltrim(STR(aConfig_Maq4[7][4]))
		Form_Config_Analog4.Text_63.Value := Alltrim(STR(aConfig_Maq4[7][5]))
		Form_Config_Analog4.Text_65.Value := Alltrim(STR(aConfig_Maq4[7][6]))
		Form_Config_Analog4.Combo_7.Value := aConfig_Maq4[7][9]
		
		Form_Config_Analog4.Text_70.Value := Alltrim(STR(aConfig_Maq4[8][2]))
		Form_Config_Analog4.Text_71.Value := Alltrim(STR(aConfig_Maq4[8][3]))
		Form_Config_Analog4.Text_72.Value := Alltrim(STR(aConfig_Maq4[8][4]))
		Form_Config_Analog4.Text_73.Value := Alltrim(STR(aConfig_Maq4[8][5]))
		Form_Config_Analog4.Text_75.Value := Alltrim(STR(aConfig_Maq4[8][6]))
		Form_Config_Analog4.Combo_8.Value := aConfig_Maq4[8][9]
		
		
return



************************************************************************************************************************************
Function Cria_Tabela_Config()			
************************************************************************************************************************************
		Local cTabela				:= "config_maquinas"
		Local aTabelasExistentes    := {}                                           
		Local aStruc      := {}      
		Local cQuery      :=""
		Local cPrimaryKey := NIL				&& E o campo que sera a chave primaria de indice 
		Local cUniqueKey  := NIL				&& E o campo que sera a unico 
		Local cAuto 	  := NIL			&& E o campo que sera autoincrementado (numerico e sem casas decimais 
				
              *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!") ; Return Nil ; EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
                   aTabelasExistentes  := oServer:ListTables()

              *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("Erro verificando Lista de Tabelas / <TMySQLServer> Cria_Tabela_OS_eletrica() " + oServer:Error(),"SISTEMA" )
                     Release Window ALL
                    Quit
                  Endif 
				
              *----- Verifica se na Array aTabelasExistentes tem a Tabela
                  If hb_AScan( aTabelasExistentes, Lower(cTabela),,,.T. ) != 0
                     //MsgINFO( "Tabela "+cTabela+" Já Existe!!")
                     Return Nil
                  EndIf 
	
			aStruc := array(9)	
			aStruc[1]  := { 'maquina'			    , 'C' , 5 , 0 } 
			aStruc[2]  := { 'eng_righ'			, 'N' , 12 , 2 } 			
			aStruc[3]  := { 'eng_low'				, 'N' , 12 , 2 } 			
			aStruc[4]  := { 'input_righ'			, 'N' , 12 , 2 } 			
			aStruc[5]  := { 'input_low'			, 'N' , 12 , 2 } 			
			aStruc[6]  := { 'base_f0_z'			, 'N' , 12 , 1 } 			
			aStruc[7]  := { 'modulo'				, 'C' , 10 , 0 }
			aStruc[8]  := { 'canal_config'		, 'C' , 10 , 0 }
			aStruc[9]  := { 'canal_leitura'		, 'N' , 2 , 0 } 	
			
				

               *----- Cria a Tabela
                 oServer:CreateTable(cTabela, aStruc ,cPrimaryKey,cUniqueKey,cAuto) 										
              
              *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     MsGInfo("Erro Criando Tabela "+cTabela+" / <TMySQLServer> Cria_Tabela_OS_eletrica() " + oServer:Error(),"SISTEMA" )
                    // Release Window ALL		
                    //Quit
                  Endif 

	   
                  
Return




*************************************************************************************************************************************************************
Procedure Config_Relatorios()
*************************************************************************************************************************************************************




IF !IsWindowDefined(Form_Config_Relatorios)	
	Load Window Form_Config_Relatorios
	aConfig_Rel1 := Carrega_Config_Relatorios("autoclaves")
	aConfig_Rel2 := Carrega_Config_Relatorios("estufas")
	
	
		Form_Config_Relatorios.Text_1.Value  := aConfig_Rel1[2]
		Form_Config_Relatorios.Text_2.Value  := aConfig_Rel1[3]
		Form_Config_Relatorios.Text_3.Value  := aConfig_Rel1[4]


		Form_Config_Relatorios.Text_10.Value := aConfig_Rel2[2]
		Form_Config_Relatorios.Text_11.Value := aConfig_Rel2[3]
		Form_Config_Relatorios.Text_12.Value := aConfig_Rel2[4]


	
	
	Form_Config_Relatorios.Center
	Form_Config_Relatorios.Activate
Else
   	*** Centraliza janela
	Form_Config_Relatorios.Center
	Form_Config_Relatorios.Restore

	Return
EndIF




Return



*************************************************************************************************************************************************************
FUNCTION Carrega_Config_Relatorios(cMaquina)
*************************************************************************************************************************************************************
Local cTabela	:= "config_relatorios"
Local oRow := {}
Local oQuery := ""
Local nPos	:= 0
Local aQuery := array(6)  //8 canais do modulo  e 9 campos de dados do banco
Local i:=0
Local cQueri := ""

				oQuery := oServer:Query("Select * From " + cTabela + " WHERE maquina = " + ' "'+ AllTrim(cMaquina)+'" '   )
                  
				  If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Operação) (): " + oQuery:Error())
                     Return Nil
                  Endif               
                 
IF oQuery:LastRec() > 0
					
		oRow := oQuery:GetRow()
		
			FOR I := 1 To 6
			
			if i >= 2 .and. i <= 5
				aQuery[I]:= oRow:FieldGet(I) 
			endif

				
			NEXT

//msginfo(STR(oQuery:LastRec()))

else

FOR I := 1 To 6 // linhas canal de cada modulo a serem lidos de cada modulo
	AFILL( aQuery[i], 0 ,2, 5) // apaga os campos do 2 ao 9 de cada linha(canal) do modulo
Next

endif
//cQueri := hb_arrayGetc(aQuery)

//Form_Config_Analog4.Edit_1.Value := Alltrim(cQueri)
//Form_Config_Analog4.Edit_1.Value :=  Alltrim(alltrim(aQuery[1][1]) +" / "+  STR(aQuery[1][2]) +" / "+ STR(aQuery[1,2]) +" / "+ STR(aQuery[1][3]) +" / "+ STR(aQuery[1][4]) +" / "+ STR(aQuery[1][5]) +" / "+ STR(aQuery[1][6])+" / "+ Alltrim(aQuery[1][7])+" / "+ Alltrim(aQuery[1][8]) )

					
Return(aQuery)


*************************************************************************************************************************************
Function Bt_Salvar_Config_Relatorios(cMaquina)  && Salva Dados do Formulário de Cadastro
*************************************************************************************************************************************
	Local cValues := ""
	Local aStruc  := {}
	Local aUpdate := {}
   Local aInsert := {}
	Local cUpdate := ""
	Local cQuery  := "" 
	 Local oRow :={}
    Local oQuery  :="" 
	Local cTabela	:= "config_relatorios"
	Local cTitulo := "Configurações"

		aUpdate  := Array(5)
			
			if cMaquina == "autoclaves"
				aUpdate[1]:= "OFF"
				aUpdate[2]:= Form_Config_Relatorios.Text_1.Value
				aUpdate[3]:= Form_Config_Relatorios.Text_1.Value * 12
				aUpdate[4]:= Form_Config_Relatorios.Text_3.Value
				aUpdate[5]:= "OFF"

			elseif cMaquina == "estufas"
				aUpdate[1]:= "OFF"
				aUpdate[2]:= Form_Config_Relatorios.Text_10.Value
				aUpdate[3]:= Form_Config_Relatorios.Text_10.Value * 6
				aUpdate[4]:= Form_Config_Relatorios.Text_12.Value
				aUpdate[5]:= "OFF"
			endif
	
			aStruc := array(5)	
			aStruc[1]  := 'maquina'
			aStruc[2]  := 'd'
			aStruc[3]  := 'fx_min'
			aStruc[4]  := 'z'
			aStruc[5]  := 'tipo'

               cUpdate := MysqlQueryUpDate(aUpdate,aStruc)
					cQuery := "UPDATE "+ cTabela + " SET " + cUpdate + " WHERE maquina = " + ' "'+ AllTrim(cMaquina)+'" '

					oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operaçãoxx) (): " + oQuery:Error())
								Return Nil
							Endif
							

	
	if cMaquina == "autoclaves"
		Form_Config_Relatorios.Text_2.Value := Form_Config_Relatorios.Text_1.Value * 12	
		msginfo("Parametros de Relaótios de Autoclaves Atualizados com sucesso")
	elseif cMaquina == "estufas"
		Form_Config_Relatorios.Text_11.Value := Form_Config_Relatorios.Text_10.Value * 6
		msginfo("Parametros de Relaótios de Estufas Atualizados com sucesso")		
	endif						
return							


************************************************************************************************************************************
Function Cria_Tabela_Config_Relatorios()			
************************************************************************************************************************************
		Local cTabela				:= "config_relatorios"
		Local aTabelasExistentes    := {}                                           
		Local aStruc      := {}      
		Local cQuery      :=""
		Local cPrimaryKey := NIL				&& E o campo que sera a chave primaria de indice 
		Local cUniqueKey  := NIL				&& E o campo que sera a unico 
		Local cAuto 	  := NIL			&& E o campo que sera autoincrementado (numerico e sem casas decimais 
				
              *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!") ; Return Nil ; EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
                   aTabelasExistentes  := oServer:ListTables()

              *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("Erro verificando Lista de Tabelas / <TMySQLServer> Cria_Tabela_OS_eletrica() " + oServer:Error(),"SISTEMA" )
                     Release Window ALL
                    Quit
                  Endif 
				
              *----- Verifica se na Array aTabelasExistentes tem a Tabela
                  If hb_AScan( aTabelasExistentes, Lower(cTabela),,,.T. ) != 0
                     //MsgINFO( "Tabela "+cTabela+" Já Existe!!")
                     Return Nil
                  EndIf 
	
			aStruc := array(5)	
			aStruc[1]  := { 'maquina'   , 'C' , 50 , 0 } 
			aStruc[2]  := { 'd'			, 'N' , 12 , 2 } 			
			aStruc[3]  := { 'fx_min'	, 'N' , 12 , 2 } 			
			aStruc[4]  := { 'z'			, 'N' , 12 , 1 } 
			aStruc[5]  := { 'tipo'		, 'C' , 20 , 1 } 
			
	 	
			
				

               *----- Cria a Tabela
                 oServer:CreateTable(cTabela, aStruc ,cPrimaryKey,cUniqueKey,cAuto) 										
              
              *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     MsGInfo("Erro Criando Tabela "+cTabela+" / <TMySQLServer> Cria_Tabela_OS_eletrica() " + oServer:Error(),"SISTEMA" )
                    // Release Window ALL		
                    //Quit
                  Endif 

for i:= 1 to 2
			
			aInsert  := Array(5)
			aInsert[1]:= iif( i== 1 , "autoclaves" , "estufas")
			aInsert[2]:= iif( i== 1 , 1.57 , 5)
			aInsert[3]:= iif( i== 1 , 18.84 , 30)
			aInsert[4]:= iif( i== 1 , 10 , 46.4)
			aInsert[5]:= iif( i== 1 , "F0", "FH")
	
			aStruc := array(5)	
			aStruc[1]  := 'maquina'
			aStruc[2]  := 'd'
			aStruc[3]  := 'fx_min'
			aStruc[4]  := 'z'
			aStruc[5]  := 'tipo'

			
						cValues := MysqlQueryInsert(aInsert,aStruc)
						cQuery:= "INSERT INTO " + cTabela + cValues 
					
						oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operação) (): " + oQuery:Error())
								Return Nil
							Endif  

next
					//Atualiza_Config_Maq4()	
					MSGExclamation("Arquivos de Configuração de Relatórios Criado com Sucesso","SISTEMA")

				  
                  
Return


		
		