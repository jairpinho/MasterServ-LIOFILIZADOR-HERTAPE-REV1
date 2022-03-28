/*         IDE: HMI+
 * Description: Serial Port sample
 *      Author: Marcelo Torres <lichitorres@yahoo.com.ar>
 *        Date: 2006.08.29
 *        
 *modbus
 *local f_Com       := "COM1"
local f_BaudeRate := 19200 
local f_databits  := 8
local f_parity    := even/odd
local f_stopbit   := 1
local f_Buff      := 8000   
*/
#include <hmg.ch>
#include 'minigui.ch'
#include "hbthread.ch"
#define HB_THREAD_INHERIT_PUBLIC 1  // // NECESSARIO para manipular objetos da janela que chama

/*
static cResposta := ""
Static cRecibe    := ""
Static buffer     := 0
Static cTemp      := ""
Static aByte := {}
Static aComandType := {}
Static aComand := {}
static nHandle   := 0
*/








# define ESC CHR(27)
# define EOL CHR(13)+chr(10)
# define CR  CHR(13)

# define STX CHR(2)
# define ETX CHR(3) // Texto final Quadro de resposta terminando código ASCII
# define ENQ CHR(5) // Código de solicitação quadro inicial
# define ACK CHR(6)  // RECONHECE
# define DLE CHR(16)
# define ETB CHR(23)
# define NAK CHR(21) // NÃO RECONHECE
# define EOT CHR(4)  // Fim de texto pedido terminando código ASCII
# define WACK CHR(9)
# define RVI  CHR(0x40)
# define DC4  CHR( 20 )

# define CBR_110                110
# define CBR_300                300
# define CBR_600                600
# define CBR_1200               1200
# define CBR_2400               2400
# define CBR_4800               4800
# define CBR_9600               9600
# define CBR_14400              14400
# define CBR_19200              19200
# define CBR_38400              38400
# define CBR_56000              56000
# define CBR_57600              57600
# define CBR_115200             115200
# define CBR_128000             128000
# define CBR_256000             256000

# define NOPARITY               0
# define ODDPARITY              1
# define EVENPARITY             2
# define MARKPARITY             3
# define SPACEPARITY            4

# define ONESTOPBIT             0
# define ONE5STOPBITS           1
# define TWOSTOPBITS            2

/* DTR Control Flow Values. */
# define DTR_CONTROL_DISABLE    0x00
# define DTR_CONTROL_ENABLE     0x01
# define DTR_CONTROL_HANDSHAKE  0x02

/* RTS Control Flow Values */
# define RTS_CONTROL_DISABLE    0x00
# define RTS_CONTROL_ENABLE     0x01
# define RTS_CONTROL_HANDSHAKE  0x02
# define RTS_CONTROL_TOGGLE     0x03

# define WIN_COM_DBGBASIC       0x01
# define WIN_COM_DBGFLOW        0x02
# define WIN_COM_DBGXTRAFLOW    0x04
# define WIN_COM_DBGOTHER       0x08
# define WIN_COM_DBGTIMEOUTS    0x10
# define WIN_COM_DBGQUEUE       0x20
# define WIN_COM_DBGALL         0x3F


#define DEFMAG_DF_COMPORT  	17
*------------------------------------------------

 ** Lisata de Flags do sistema Cnet ** 

# Define F00 0
# Define F01 0
# Define F02 0
# Define F03 0
# Define F04 0
# Define F05 0
# Define F06 0
# Define F0D 0
# Define F0F 0

DECLARE WINDOW Form_MAIN
DECLARE WINDOW Form_Modbus_CNET
DECLARE WINDOW Form_Processo


******************************************************************************
Function escala1(cRef,nIN_low,nIN_high,nOUT_low,nOUT_high,nTipo_var,nOffset)
******************************************************************************

Local Relacao1 := 0
Local Relacao2 := 0
Local Relacao1_2 := 0
local Aux1 := 0
local Aux2 := 0
Local nREF := VAL(Alltrim(cREF)) 
Local escala := 0
Public Retorno := 0

IIF(EMPTY(nOffset), nOffset := 0 , nOffset)

Relacao1 := nOUT_high - nOUT_low
Relacao2 := nIN_high - nIN_low
Relacao1_2 := Relacao1 / Relacao2

Aux1 := nRef - nIN_high
Aux2 := Aux1 * Relacao1_2
escala := Aux2 + nOUT_high

if nTipo_var == 1 // tipo numero
	Retorno :=  escala + nOffset
else
	Retorno :=  Alltrim( str(escala + nOffset,0,2 ) )	
endif
	


Return(Retorno)



******************************************************************************
Procedure Config()
******************************************************************************


Local cPorta_ini 		:=""								
Local cBaudrate_ini		:=""	
Local cData_bits_ini 	:=""
Local cStop_bits_ini	:=""	
Local cParity_ini		:=""
Local cBuffer_ini		:=""


	  If File(cIniFile)
	    BEGIN INI FILE(cIniFile)
			GET cPorta_ini 		SECTION "COM_SERIAL"		ENTRY "porta"								
			GET cBaudrate_ini	SECTION "COM_SERIAL"		ENTRY "baudrate"				
			GET cData_bits_ini	SECTION "COM_SERIAL"   		ENTRY "data_bits" 	 			
			GET cStop_bits_ini	SECTION "COM_SERIAL"       	ENTRY "stop_bits"				
			GET cParity_ini		SECTION "COM_SERIAL"	    ENTRY "parity"					
			GET cBuffer_ini		SECTION "COM_SERIAL"	    ENTRY "buffer"					
		END INI	
	EndIf
	
lWindow := .F.
	
IF !IsWindowActive(Form_Modbus_CNET)
	Load window Form_Modbus_CNET
	
	Form_Modbus_CNET.Text_1.value := ""
	Form_Modbus_CNET.Text_2.value := ""
	Form_Modbus_CNET.Text_3.value := ""
				
			IF lCom_status == .T.
				Form_Modbus_CNET.Button_1.Enabled :=.F.
				Form_Modbus_CNET.Button_2.Enabled :=.T.
				Form_Modbus_CNET.Button_1.Enabled :=.F.
				Form_Modbus_CNET.Combo_1.Enabled := .F.
				Form_Modbus_CNET.Combo_2.Enabled := .F.
				Form_Modbus_CNET.Combo_3.Enabled := .F.
				Form_Modbus_CNET.Combo_4.Enabled := .F.
				Form_Modbus_CNET.Combo_5.Enabled := .F.
				Form_Modbus_CNET.Combo_6.Enabled := .F.
			ENDIF				
			
		Form_Modbus_CNET.Combo_1.DisplayValue := cPorta_ini
		Form_Modbus_CNET.Combo_2.DisplayValue := cBaudrate_ini
		Form_Modbus_CNET.Combo_3.DisplayValue := cData_bits_ini
		Form_Modbus_CNET.Combo_4.DisplayValue := cStop_bits_ini
		Form_Modbus_CNET.Combo_5.DisplayValue := cParity_ini	
		Form_Modbus_CNET.Combo_6.DisplayValue := cBuffer_ini		
lWindow := .T.

Form_Modbus_CNET.Row := 20
Form_Modbus_CNET.Col := 20

//hb_threadStart( HB_THREAD_INHERIT_MEMVARS , form_main.timer_1.enabled := .T. )

Form_Modbus_CNET.Activate
 //MILLISEC(200)
 //form_main.timer_1.enabled := .T.
endif
//form_main.timer_1.enabled := .T.

REturn


******************************************************************************
Procedure fConecta()
******************************************************************************
local f_Com       := Alltrim(Form_Modbus_CNET.Combo_1.DisplayValue)
local f_BaudeRate := VAL(Alltrim(Form_Modbus_CNET.Combo_2.DisplayValue)) 
local f_databits  := VAL(Alltrim(Form_Modbus_CNET.Combo_3.DisplayValue))
local f_parity    := VAL(Alltrim(Form_Modbus_CNET.Combo_4.DisplayValue))  //0 ninguno
local f_stopbit   := VAL(Alltrim(Form_Modbus_CNET.Combo_5.DisplayValue))
local f_Buff      := VAL(Alltrim(Form_Modbus_CNET.Combo_6.DisplayValue))
Local nCount := 0
   //Harbour - Usar a linha de baixo qdo sem a hbcomm.lib
   //nHandle:= Win_Port():Init( cPort, nBaudrate, nParity, nDatabits, nStopbits)
   
Atualiza_COM_Ini()
nHandle := Init_Port( f_Com, f_BaudeRate, f_databits, f_parity, f_stopbit, f_Buff  )

If nHandle > 0
   MsgInfo("Conectado...","hbcomm")
   //Form_Modbus_CNET.timer_1.enabled := .t.
   Form_Modbus_CNET.Button_1.Enabled :=.F.
   Form_Modbus_CNET.Combo_1.Enabled := .F.
   Form_Modbus_CNET.Combo_2.Enabled := .F.
   Form_Modbus_CNET.Combo_3.Enabled := .F.
   Form_Modbus_CNET.Combo_4.Enabled := .F.
   Form_Modbus_CNET.Combo_5.Enabled := .F.
   Form_Modbus_CNET.Combo_6.Enabled := .F.
  		//hb_threadStart(HB_THREAD_INHERIT_PUBLIC , Clock_Serial())
		
	 lCom_status := .T. 
  	IF lCom_status == .T.
		Form_Modbus_CNET.Button_1.Enabled :=.F.
		Form_Modbus_CNET.Button_2.Enabled :=.T.
		Form_Main.StatusBar.Item(4) := "CONEXÃO CLP: ON"
		Form_Main.Image_1.Picture := "CNX_ON"
	ELSE
		Form_Main.StatusBar.Item(4) := "CONEXÃO CLP: OFF"
		Form_Main.Image_1.Picture := "CNX_OFF"
	ENDIF	

   OutBufClr(nHandle)

Else
   MsgStop("Verifique os valores ou conexão de cabos para establecer uma conexão","hbcomm")
   lCom_status := .f.
EndIf


Return


FUNCTION Clock_Serial()

   * please note that this function will NEVER return the control!
   * but do not 'locks' the user interface since it is running in a separate thread 
   // se quiser habilitar o loop apos iniciar a thread use abaixo

   DO WHILE .T.
      ** FUNCIONA COM OS DOIS TIPOS DE ESPERA hb_idleSleep() OU  millisec()
	  //hb_idleSleep( 1 )
	  Read_clock()
	  millisec(1) 
   ENDDO

	
RETURN nil


******************************************************************************
Procedure Read_ModBus_Cnet()
******************************************************************************
local cFrame := ""
Local cChar1 := "02"  // ENDEREÇO
Local cChar2 := CHR(82)
Local cChar3 := "SB" 
Local cChar4 := "" // quantidade de bolcos de variaiveis
Local cChar5 := "%DW0100"  // ENDEREÇO
Local cChar6 :=  ALLTRIM(STR(LEN(cChar5))) // TAMANHO CALCULADO DA VARIAVEL ENVIADA %MW100 = H06 = 6 CHAR
Local cChar7 := NTOC( 50 ,16,2,"0") // quantidades de variaiveis a receber na leitura


cEnvia_4:= ""
cEnvia_5:= ""
cEnvia_6:= ""
		
//nFrame := ASC(ENQ) + CHR_DEC_SOMA( cChar1) + CHR_DEC_SOMA(cChar2) + CHR_DEC_SOMA(cChar3) + CHR_DEC_SOMA(cChar4) + CHR_DEC_SOMA(cChar5) + CHR_DEC_SOMA(cChar6)+ CHR_DEC_SOMA(cChar7) + ASC(EOT)

 nFrame := ASC(ENQ) + CHR_DEC_SOMA( cChar1) + CHR_DEC_SOMA(cChar2) + CHR_DEC_SOMA(cChar3) + CHR_DEC_SOMA(cChar4) + CHR_DEC_SOMA(cChar5) + CHR_DEC_SOMA(cChar6)+ CHR_DEC_SOMA(cChar7) +ASC(EOT)
 BCC := SUBSTR(NTOC(nFrame,16,4,"0"),3,4) // RETORNA EM HEXADECIMAL
 
 // ALLTRIM(ENQ) + cChar1 + cChar2=R + cChar3=SB + cChar4="" + NTOC(VAL(cChar5=cCHAR3),16,2,"0") + cChar6 + cChar7 + EOT + BCC // FUNCIONOU EM XGB
 cFrame := ALLTRIM(ENQ) + cChar1 + cChar2 + cChar3 + cChar4 + NTOC(VAL(cChar6),16,2,"0") + cChar5 + cChar7 + EOT + BCC // FUNCIONOU EM XGB
 cEnvia_4:= cFrame
 //cQuery := ALltrim(cFrame)
//MSGINFO(cFrame)	

cEnvia_6 :=  "." + ALLTRIM(cChar1) + cChar2 + cChar3 + cChar4 +  NTOC(VAL(cChar6),16,2,"0")  + cChar5 + cChar7 + "."  +BCC
	
	If nHandle > 0
        OutChr(nHandle,@cFrame,LEN(cFrame))
	    Recebe(cChar1,"R","SB","W",cChar5,CTON(Alltrim(cChar7),16))  // função que recebe os valores de leitura cnet e carrega em variavel tipo array para cada maquina
	ENDIF
	

	
Return

******************************************************************************
Procedure Write_ModBus_Cnet()
******************************************************************************
local cFrame := ""
Local cChar1 := "02"  // ENDEREÇO
Local cChar2 := CHR(87) 
Local cChar3 := "SB" 
Local cChar4 := "" // quantidade de bolcos de variaiveis
Local cChar5 := "%DW05000"  // ENDEREÇO
Local cChar6 :=  ALLTRIM(STR(LEN(cChar5))) // TAMANHO CALCULADO DA VARIAVEL ENVIADA %MW100 = H06 = 6 CHAR
Local cChar7 := NTOC(VAL("20"),16,2,"0") // quantidades de variaiveis a enviar 
Local cChar8 := "" 
Local nCount := 0
	IF IsWindowActive(Form_Modbus_CNET)
		//cChar8 :=	NTOC(VAL(Form_Modbus_CNET.Text_8.value),16,4,"0")+NTOC(VAL(Form_Modbus_CNET.Text_9.value),16,4,"0")+NTOC(VAL(Form_Modbus_CNET.Text_10.value),16,4,"0")+NTOC(VAL(Form_Modbus_CNET.Text_11.value),16,4,"0")+NTOC(VAL(Form_Modbus_CNET.Text_12.value),16,4,"0")
	endif



	FOR nCount := 1 TO 20
		cChar8 := cChar8 + NTOC(VAL(aEnvia[nCount]),16,4,"0")
	NEXT  

	
cEnvia_1:= ""
cEnvia_2:= ""
cEnvia_3:= ""

//nFrame := ASC(ENQ) + CHR_DEC_SOMA( cChar1) + CHR_DEC_SOMA(cChar2) + CHR_DEC_SOMA(cChar3) + CHR_DEC_SOMA(cChar4) + CHR_DEC_SOMA(cChar5) + CHR_DEC_SOMA(cChar6)+ CHR_DEC_SOMA(cChar7) + ASC(EOT)
 nFrame := ASC(ENQ) + CHR_DEC_SOMA( cChar1) + CHR_DEC_SOMA(cChar2) + CHR_DEC_SOMA(cChar3) + CHR_DEC_SOMA(cChar4) + CHR_DEC_SOMA(cChar5) + CHR_DEC_SOMA(cChar6)+ CHR_DEC_SOMA(cChar7) +ASC(EOT)
 BCC := SUBSTR(NTOC(nFrame,16,4,"0"),3,4) // RETORNA EM HEXADECIMAL

 // ALLTRIM(ENQ) + cChar1 + cChar2=R + cChar3=SB + cChar4="" + NTOC(VAL(cChar5=cCHAR3),16,2,"0") + cChar6 + cChar7 + EOT + BCC // FUNCIONOU EM XGB
 cFrame := ALLTRIM(ENQ) + cChar1 + cChar2 + cChar3 + cChar4 + NTOC(VAL(cChar6),16,2,"0") + cChar5 + cChar7 + cChar8 + EOT + BCC // FUNCIONOU EM XGB
 cEnvia_1:= cFrame // mostra em decimal
 //cQuery := ALltrim(cFrame)
//MSGINFO(cFrame)	
cEnvia_3 :=  "." + ALLTRIM(cChar1) + cChar2 + cChar3 + cChar4 +  NTOC(VAL(cChar6),16,2,"0")  + cChar5 + cChar7 + cChar8+ "."  +BCC // mostra em ascii

    If nHandle > 0
		OutChr(nHandle,@cFrame,LEN(cFrame))
		//MILLISEC(100)
		//recebe(cChar1,"W","SB","W",cChar5,CTON(Alltrim(cChar8),16))
	endif

Return


*********************************************************************************************************************************************************************
Procedure Read_clock()
*********************************************************************************************************************************************************************
local nTime := 0
						IF IsWindowActive(Form_Modbus_CNET)
							Form_Modbus_CNET.Text_1.value := cEnvia_1
							Form_Modbus_CNET.Text_2.value := cEnvia_2
							Form_Modbus_CNET.Text_3.value := cEnvia_3	
						endif

				IF nHandle > 0
					Read_ModBus_Cnet()
					//passagem de paremtros somento tipo string numero nao aceita
					//hb_threadStart( @Temporizador(), "100" )
						MILLISEC(100)
					Write_ModBus_Cnet()
						MILLISEC(100)
					//hb_threadStart( @Temporizador(), "100" )
				endif


IF IsWindowActive(Form_Processo)
	

		
	  	IF estapas_processo_1 == .T.
		
				Form_Processo.Button_1.Enabled :=.F.
				Form_Processo.Button_2.Enabled :=.T.
				Form_Processo.Image_1.Picture := "CNX_ON"
		ENDIF
		
	  	IF estapas_processo_2 == .T.
		
				Form_Processo.Button_3.Enabled :=.F.
				Form_Processo.Button_4.Enabled :=.T.
				Form_Processo.Image_2.Picture := "CNX_ON"
		ENDIF	

	  	IF estapas_processo_3 == .T.
		
				Form_Processo.Button_5.Enabled :=.F.
				Form_Processo.Button_6.Enabled :=.T.
				Form_Processo.Image_3.Picture := "CNX_ON"
		ENDIF	

	  	IF estapas_processo_4 == .T.
		
				Form_Processo.Button_7.Enabled :=.F.
				Form_Processo.Button_8.Enabled :=.T.
				Form_Processo.Image_4.Picture := "CNX_ON"
		ENDIF	

	  	IF estapas_processo_5 == .T.
		
				Form_Processo.Button_9.Enabled :=.F.
				Form_Processo.Button_10.Enabled :=.T.
				Form_Processo.Image_5.Picture := "CNX_ON"
		ENDIF			
ENDIF



IF lCom_status == .T.


IF VAL(alltrim(aMaquina1[9])) >= 1 
		
		IF estapas_processo_1 == .T.
			DO CASE
				CASE VAL(alltrim(aMaquina1[9])) == 2
					aDados_Processo_Maq1[8] := "AGUARDANDO PRESSÃO"	
					if aEtapa_Maq1[2] == .F.
						aEtapa_Maq1[2] := .T.
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq1(2)
						endif
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 2 LUFERCO")
					endif
				CASE VAL(alltrim(aMaquina1[9])) == 3
					
						if aEtapa_Maq1[3] == .F. 
								aEtapa_Maq1[3] := .T.
								aDados_Processo_Maq1[8] := "PRÉ VACUO"	
								IF lGrava_sql == .F.	
									Grava_Dados_etapas_Mysql_Maq1(3)
								endif
						ENDIF

						//msginfo("GRAVANDO ETAPAS DE PROCESSO 3 LUFERCO")

					
				CASE VAL(alltrim(aMaquina1[9])) == 4
						
						if aEtapa_Maq1[4] == .F.
							aEtapa_Maq1[4] := .T.
							aDados_Processo_Maq1[8] := "AQUECIMENTO"
							IF lGrava_sql == .F.	
								Grava_Dados_etapas_Mysql_Maq1(4)
							endif
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 4 LUFERCO")

					
				CASE VAL(alltrim(aMaquina1[9])) == 5
					if aEtapa_Maq1[5] == .F.
						aEtapa_Maq1[5] := .T.
						aDados_Processo_Maq1[8] := "ESTERILIZAÇÃO"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq1(5)
						endif
					ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 5 LUFERCO")

				CASE VAL(alltrim(aMaquina1[9])) == 6
					if aEtapa_Maq1[6] == .F.
						aEtapa_Maq1[6] := .T.
						aDados_Processo_Maq1[8] := "DEPRESSAO"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq1(6)
						endif
					ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 6 LUFERCO")
				CASE VAL(alltrim(aMaquina1[9])) == 7
					if aEtapa_Maq1[7] == .F.
						aEtapa_Maq1[7] := .T.
						aDados_Processo_Maq1[8] := "SECAGEM"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq1(7)
						endif
					ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 7 LUFERCO")
				CASE VAL(alltrim(aMaquina1[9])) == 8
					if aEtapa_Maq1[8] == .F.
						aEtapa_Maq1[8] := .T.
						aDados_Processo_Maq1[8] := "PRESSÃO ZERO"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq1(8)
						endif
					ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 8 LUFERCO")
					aUltimo_passo[1] := .T.
					
			ENDCASE		

		ENDIF
	ENDIF


IF VAL(alltrim(aMaquina2[9])) >= 1 
		
		IF estapas_processo_2 == .T.
			DO CASE
				CASE VAL(alltrim(aMaquina2[9])) == 2
				
					aDados_Processo_Maq2[8] := "AGUARDANDO PRESSÃO"	
					if aEtapa_Maq2[2] == .F.
						aEtapa_Maq2[2] := .T.
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq2(2)
						endif
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 2 SERCON")
					endif
				
				CASE VAL(alltrim(aMaquina2[9])) == 3
					if aEtapa_Maq2[3] == .F.
						aEtapa_Maq2[3] := .T.
						aDados_Processo_Maq2[8] := "PRÉ VACUO"
						IF lGrava_sql == .F.							
							Grava_Dados_etapas_Mysql_Maq2(3)
						endif
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 3 SERCON")
					endif
				CASE VAL(alltrim(aMaquina2[9])) == 4
					if aEtapa_Maq2[4] == .F.
						aEtapa_Maq2[4] := .T. 
						aDados_Processo_Maq2[8] := "AQUECIMENTO"
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq2(4)
						endif
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 4 SERCON")
					endif
				CASE VAL(alltrim(aMaquina2[9])) == 5
					if aEtapa_Maq2[5] == .F.
						aEtapa_Maq2[5] := .T.
						aDados_Processo_Maq2[8] := "ESTERILIZAÇÃO"
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq2(5)
						endif
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 5 SERCON")
					endif
				CASE VAL(alltrim(aMaquina2[9])) == 6
					if aEtapa_Maq2[6] == .F.
						aEtapa_Maq2[6] := .T.
						aDados_Processo_Maq2[8] := "DEPRESSAO"
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq2(6)
						endif
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 6 SERCON")
					endif
					
				CASE VAL(alltrim(aMaquina2[9])) == 7
					if aEtapa_Maq2[7] == .F.
						aEtapa_Maq2[7] := .T.				
						aDados_Processo_Maq2[8] := "SECAGEM"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq2(7)
						endif
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 7 SERCON")
					endif
				CASE VAL(alltrim(aMaquina2[9])) == 8
					if aEtapa_Maq2[8] == .F.
						aEtapa_Maq2[8] := .T.
						aDados_Processo_Maq2[8] := "PRESSÃO ZERO"
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq2(8)
						endif
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 8 SERCON")
					endif
					aUltimo_passo[2] := .T.
			ENDCASE		

		ENDIF
	ENDIF



IF VAL(alltrim(aMaquina3[9])) >= 1 
		
		IF estapas_processo_3 == .T.
			DO CASE
				CASE VAL(alltrim(aMaquina3[9])) == 1
					if aEtapa_Maq3[1] == .F.
						aEtapa_Maq3[1] := .T. 
						aDados_Processo_Maq3[8] := "AQUECIMENTO"
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq3(1)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 4 SERCON")
					endif
				CASE VAL(alltrim(aMaquina3[9])) == 2
					if aEtapa_Maq3[2] == .F.
						aEtapa_Maq3[2] := .T.
						aDados_Processo_Maq3[8] := "ESTERILIZAÇÃO"
						IF lGrava_sql == .F.							
							Grava_Dados_etapas_Mysql_Maq3(2)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 5 SERCON")
					endif
				CASE VAL(alltrim(aMaquina3[9])) == 3
					if aEtapa_Maq3[3] == .F.
						aEtapa_Maq3[3] := .T.
						aDados_Processo_Maq3[8] := "RESFRIAMENTO"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq3(3)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 6 SERCON")
					endif
					aUltimo_passo[3] := .T.

			ENDCASE		

		ENDIF
	ENDIF



IF VAL(alltrim(aMaquina4[9])) >= 1 
		
		IF estapas_processo_4 == .T.
			DO CASE
				CASE VAL(alltrim(aMaquina4[9])) == 1
					if aEtapa_Maq4[1] == .F.
						aEtapa_Maq4[1] := .T. 
						aDados_Processo_Maq4[8] := "AQUECIMENTO"
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq4(1)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 4 SERCON")
					endif
				CASE VAL(alltrim(aMaquina4[9])) == 2
					if aEtapa_Maq4[2] == .F.
						aEtapa_Maq4[2] := .T.
						aDados_Processo_Maq4[8] := "ESTERILIZAÇÃO"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq4(2)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 5 SERCON")
					endif
				CASE VAL(alltrim(aMaquina4[9])) == 3
					if aEtapa_Maq4[3] == .F.
						aEtapa_Maq4[3] := .T.
						aDados_Processo_Maq4[8] := "RESFRIAMENTO"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq4(3)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 6 SERCON")
					endif
					aUltimo_passo[4] := .T.

			ENDCASE		

		ENDIF
	ENDIF


IF VAL(alltrim(aMaquina5[9])) >= 1 
		
		IF estapas_processo_5 == .T.
			DO CASE
				CASE VAL(alltrim(aMaquina5[9])) == 1
					if aEtapa_Maq5[1] == .F.
						aEtapa_Maq5[1] := .T. 
						aDados_Processo_Maq5[8] := "AQUECIMENTO"
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq5(1)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 4 SERCON")
					endif
				CASE VAL(alltrim(aMaquina5[9])) == 2
					if aEtapa_Maq5[2] == .F.
						aEtapa_Maq5[2] := .T.
						aDados_Processo_Maq5[8] := "ESTERILIZAÇÃO"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq5(2)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 5 SERCON")
					endif
				CASE VAL(alltrim(aMaquina5[9])) == 3
					if aEtapa_Maq5[3] == .F.
						aEtapa_Maq5[3] := .T.
						aDados_Processo_Maq5[8] := "RESFRIAMENTO"	
						IF lGrava_sql == .F.	
							Grava_Dados_etapas_Mysql_Maq5(3)
						ENDIF
						//msginfo("GRAVANDO ETAPAS DE PROCESSO 6 SERCON")
					endif
					aUltimo_passo[5] := .T.

			ENDCASE		

		ENDIF
	ENDIF
ENDIF


IF IsWindowActive(Form_Processo)

	IF VAL(alltrim(aMaquina1[9])) == 0 .AND. aUltimo_passo[1] == .T. 
		estapas_processo_1 := .F.
		AFILL( aEnvia, "0" ,1 , 4) 
		Form_Processo.Image_1.Picture := "CNX_OFF"
		Form_Processo.Button_1.Enabled :=.T.
		Form_Processo.Button_2.Enabled :=.F.	
		aDados_Processo_Maq1[8] := "FIM DE CICLO"	
		IF lGrava_sql == .F.	
			Grava_Dados_Mysql_Maq1(1)		
		ENDIF
		aUltimo_passo[1] := .F.
		AFILL( aEtapa_Maq1, .F. ,1, 10)
		AFILL( aDados_Processo_Maq1, "0" ,2, 20)
	ENDIF
	
	IF VAL(alltrim(aMaquina2[9])) == 0 .AND. aUltimo_passo[2] == .T.
		estapas_processo_2 := .F.
		AFILL( aEnvia, "0" , 5 , 4)
		//aEnvia[5] := "0" 
		Form_Processo.Image_2.Picture := "CNX_OFF"
		Form_Processo.Button_3.Enabled :=.T.
		Form_Processo.Button_4.Enabled :=.F.	
		aDados_Processo_Maq2[8] := "FIM DE CICLO"	
		IF lGrava_sql == .F.	
			Grava_Dados_Mysql_Maq2(1)		
		ENDIF
		aUltimo_passo[2] := .F.
		AFILL( aEtapa_Maq2, .F. ,1, 10)
		AFILL( aDados_Processo_Maq2, "0" ,2, 20)
	ENDIF	

	IF VAL(alltrim(aMaquina3[9])) == 0 .AND. aUltimo_passo[3] == .T. 
		estapas_processo_3 := .F.
		AFILL( aEnvia, "0" , 9 , 4)
		//aEnvia[5] := "0" 
		Form_Processo.Image_3.Picture := "CNX_OFF"
		Form_Processo.Button_5.Enabled :=.T.
		Form_Processo.Button_6.Enabled :=.F.	
		aDados_Processo_Maq3[8] := "FIM DE CICLO"
		IF lGrava_sql == .F.	
			Grava_Dados_Mysql_Maq3(1)		
		ENDIF
		aUltimo_passo[3] := .F.
		AFILL( aEtapa_Maq3, .F. ,1, 10)
		AFILL( aDados_Processo_Maq3, "0" ,2, 20)
	ENDIF		
	
	IF VAL(alltrim(aMaquina4[9])) == 0 .AND. aUltimo_passo[4] == .T. 
		estapas_processo_4 := .F.
		AFILL( aEnvia, "0" , 13 , 4)
		//aEnvia[5] := "0" 
		Form_Processo.Image_4.Picture := "CNX_OFF"
		Form_Processo.Button_7.Enabled :=.T.
		Form_Processo.Button_8.Enabled :=.F.	
		aDados_Processo_Maq4[8] := "FIM DE CICLO"	
		IF lGrava_sql == .F.	
			Grava_Dados_Mysql_Maq4(1)		
		ENDIF
		aUltimo_passo[4] := .F.
		AFILL( aEtapa_Maq4, .F. ,1, 10)
		AFILL( aDados_Processo_Maq4, "0" ,2, 20)
	ENDIF	

	IF VAL(alltrim(aMaquina5[9])) == 0 .AND. aUltimo_passo[5] == .T. 
		estapas_processo_5 := .F.
		AFILL( aEnvia, "0" , 17 , 4)
		//aEnvia[5] := "0" 
		Form_Processo.Image_5.Picture := "CNX_OFF"
		Form_Processo.Button_9.Enabled :=.T.
		Form_Processo.Button_10.Enabled :=.F.	
		aDados_Processo_Maq5[8] := "FIM DE CICLO"	
		IF lGrava_sql == .F.	
			Grava_Dados_Mysql_Maq5(1)		
		ENDIF
		aUltimo_passo[5] := .F.
		AFILL( aEtapa_Maq5, .F. ,1, 10)
		AFILL( aDados_Processo_Maq5, "0" ,2, 20)
	ENDIF		
ENDIF	
				
Return Nil

************************************************** ************************************
* Recebe Dados
***************************************************************************************
************************************************** ************************************
* Recebe Dados
***************************************************************************************
Procedure Recebe(cID,cComando,cTipoComando,cTipoDados,cDispositivo,nQt_Reg)
*************************************************************************************************************************************************************
local I := 0
Local cTemp := "" 
Local cTempHex := ""
Local cTemp_ASC := ""
aID := {}
aComando := {}
aTipoComando := {}

/*

Format name 	Header Station	No.		Command		Commandtype	Numberofblocks		Devicelength	Devicename 	Tail 	Framecheck
Ex. of frame 	ENQ 	H20 			R(r) 			SS 					H01 				H06 		%MW10 			EOT 	BCC
ASCII value 	H05 	H3230 			H52(72) 		H5353 				H3031 				H3036 		H254D57313030 	H04

Format name 	Header	Station No. 	Command	Commandtype	Numberofblocks		Numberofdata	data 	Tail	Framecheck
Ex. of frame 	ACK 		H20 		R(r) 		SS 					H01 				H02 		HA9F3 	ETX 	BCC
ASCII value H06 H3230 H52(72) H5353 H3031 H3032 H41394633 H04

***********************************************************************

Format name 	Header	Station	No.Command	Commandtype	Devicelength	Device 			Numberofdata(Max.128 Bytes)		Tail	Framecheck
Ex. of frame 	ENQ 	H10 			R(r) 		SB 				H06 		%MW100 			H05 								EOT 	BCC
ASCII value 	H05 	H3130 			H52(72) 	H5342 			H3036 		H254D57313030 	H3035 								H04

Format	name	Header	Station No.	Command	Command type	Number of blocks	Number of data		data 		Tail	FrameCheck
Ex. of frame	ACK 	H10				R(r)		SB 					H01					H02				H1122 		EOT		 BCC
ASCII value		H06		H3130 			H52(72) 	H5342 				H3031				H3134			H31313232 	H03

**********************************************************************
				// [06][30][31][52][53][53][30][31][30][31][30][31][03]
*/


aID := CHR_HEX_ARRAY(cID)
aComando := CHR_HEX_ARRAY(cComando)
aTipoComando := CHR_HEX_ARRAY(cTipoComando)


	nBytes := InbufSize(nHandle) // faz a leitura da porta
	if nBytes <= 0 // verifica se a porta desconectou e fecha a porta
		if lCom_status == .T.
			//fDesconecta(2)
			return nil
		endif
	endif
	
	cResposta := Space(nbytes)
	InChr(nHandle,nbytes,@cResposta) // carrega com dados lidos na porta serial

//CarregaDados(cID,cComando,cTipoComando,TipoDados,cDispositivo,cResposta,nQt_Reg)
CarregaDados(cID,cComando,cTipoComando,cTipoDados,cDispositivo,cResposta,nQt_Reg)	

// verifica se é o escravo correto que responder	
IF aID[1] == Alltrim(NTOC(ASC(SUBSTR(cResposta,2,1)),16,2,"0" ))
	IF aID[2] == Alltrim(NTOC(ASC(SUBSTR(cResposta,3,1)),16,2,"0" ))
		IF aComando[1] == Alltrim(NTOC(ASC(SUBSTR(cResposta,4,1)),16,2,"0" ))
			IF aTipoComando[1] == Alltrim(NTOC(ASC(SUBSTR(cResposta,5,1)),16,2,"0" ))
				IF aTipoComando[2] == Alltrim(NTOC(ASC(SUBSTR(cResposta,6,1)),16,2,"0" ))

			//Form_Modbus_CNET.Text_8.Value := "0"
			//Form_Modbus_CNET.Text_3.Value := "0"


		IF LEN(cResposta) > 0
		
		
			FOR I:= 1 TO LEN(cResposta)
				//Msginfo( "Dados recebidos  : " + STR(ASC(SUBSTR(cResposta,I,1))))
				cTemp :=  cTemp + "[" + Alltrim(STR(ASC(SUBSTR(cResposta,I,1)))) + "]"
				cTemp_ASC :=  cTemp_ASC + Alltrim(SUBSTR(cResposta,I,1))
				cTempHex  := cTempHex + "[" + Alltrim(NTOC(ASC(SUBSTR(cResposta,I,1)),16,2,"0" )) + "]"
				
				IF Alltrim(NTOC(ASC(SUBSTR(cResposta,I,1)),16,2,"0" )) == "03" 
						//Grava_DataTransfer(cID,cComando,cTipoComando,cDispositivo,cResposta)
				ENDIF
				
			NEXT
			IF IsWindowActive(Form_Modbus_CNET)		
				Form_Modbus_CNET.Text_4.value := ALLTRIM(cTemp)
				Form_Modbus_CNET.Text_6.value := ALLTRIM(cTempHex)
				Form_Modbus_CNET.Text_7.Value :=  cTemp_ASC
				Form_Modbus_CNET.Text_5.Value :=  STR(LEN(cResposta))
			ENDIF
		ENDIF

ENDIF		
ENDIF		
ENDIF
ENDIF
ENDIF  

Return(cResposta)

************************************************** ************************************
* Recebe Dados e atualiza na grade
************************************************** ******************************
************************************************** ************************************
* Recebe Dados e atualiza na grade
************************************************** ******************************
Function CarregaDados(cID,cComando,cTipoComando,TipoDados,cDispositivo,cResposta,nQt_Reg)
*************************************************************************************************************************************************************

Local nTotReg := nQt_Reg
Local aRecebe 	:= {}
Local Ibytes := 0
Local Ibytes2 := 0
Local Ibytes3 := 0
Local cBytes := ""
Local cBinario := ""
Local cBinario2 := ""
Local cValor := ""
Local nBytes := ASC(SUBSTR(cResposta,3,1))
Local cTempHex := ""


cTIPO_COMANDO := ALLTRIM(SUBSTR(cResposta,5,2))
//MSGINFO(cTIPO_COMANDO)

nMEM_1 := 0
nMEM_2 := 10000
nMEM_3 := 40000
nMEM_4 := 30000


//aRecebe  := Array(100)

//msginfo(alltrim(str(nQt_Reg)))

	IF IsControlDefined (Grid_1,Form_Modbus_CNET) 
		IF Form_Modbus_CNET.Grid_1.ItemCount >= 1
			//DELETE ITEM ALL FROM Grid_1 OF Form_Modbus_CNET
		ENDIF
	ENDIF


//IF cTIPO_COMANDO == "SB"

  FOR nIDados := 1 TO nTotReg

	Ibytes3 += 4 // qt de baytes para ser lido por variaves 2 bytes
			cValor := ALLTRIM(STR(CTON(Alltrim(SUBSTR(cResposta,7+Ibytes3,4)),16)))
			//msginfo(cValor + str(nIDados))
			Aadd( aRecebe ,  Alltrim(cValor)  )
			aRetorno := aRecebe

  NEXT  
 
  //msginfo(aRecebe[9])
  		IF lCom_status == .T.
			ACOPY(aRecebe,aMaquina1,1,10)  // copia os 8 items do array receber apartir do item 1 para o array amaquina1  8 VARIAVEIS TIPO D = D100 + DUAS D CONSECUTIVAS  D108 E D109 PARA PROCESSO
			ACOPY(aRecebe,aMaquina2,11,10) // copia os 8 items do array receber apartir do item 11 para o array amaquina2
			ACOPY(aRecebe,aMaquina3,21,10) // copia os 8 items do array receber apartir do item 21 para o array amaquina3
			ACOPY(aRecebe,aMaquina4,31,10) // copia os 8 items do array receber apartir do item 31 para o array amaquina4
			ACOPY(aRecebe,aMaquina5,41,10) // copia os 8 items do array receber apartir do item 41 para o array amaquina5
			Carregadados_processo()
		else


	//Sintaxe: AFILL( <vetor destino>, < valor>,<início>, <quantidade>).
			//Afill (vetor, 4) // resultado: vetor = {4, 4, 4, 4, 4}
			AFILL( aMaquina1,"0",1, 10)
			AFILL( aMaquina2,"0",1, 10)
			AFILL( aMaquina3,"0",1, 10)
			AFILL( aMaquina4,"0",1, 10)
			AFILL( aMaquina5,"0",1, 10)
		endif 
 //msginfo(alltrim(aRecebe[1])) 
 
 		Temp_Maq4[1] := escala1(aMaquina4[ aConfig_Maq4[1][9] ],aConfig_Maq4[1][5],aConfig_Maq4[1][4],aConfig_Maq4[1][3],aConfig_Maq4[1][2],,aConfig_Maq4[1][6]) //alltrim(aMaquina1[1])
		Temp_Maq4[2] := escala1(aMaquina4[ aConfig_Maq4[2][9] ],aConfig_Maq4[2][5],aConfig_Maq4[2][4],aConfig_Maq4[2][3],aConfig_Maq4[2][2],,aConfig_Maq4[2][6]) //alltrim(aMaquina1[1])
		Temp_Maq4[3] := escala1(aMaquina4[ aConfig_Maq4[3][9] ],aConfig_Maq4[3][5],aConfig_Maq4[3][4],aConfig_Maq4[3][3],aConfig_Maq4[3][2],,aConfig_Maq4[3][6]) //alltrim(aMaquina1[1])
		Temp_Maq4[4] := escala1(aMaquina4[ aConfig_Maq4[4][9] ],aConfig_Maq4[4][5],aConfig_Maq4[4][4],aConfig_Maq4[4][3],aConfig_Maq4[4][2],,aConfig_Maq4[4][6]) //alltrim(aMaquina1[1])
		Temp_Maq4[5] := escala1(aMaquina4[ aConfig_Maq4[5][9] ],aConfig_Maq4[5][5],aConfig_Maq4[5][4],aConfig_Maq4[5][3],aConfig_Maq4[5][2],,aConfig_Maq4[5][6]) //alltrim(aMaquina1[1])
		Temp_Maq4[6] := escala1(aMaquina4[ aConfig_Maq4[6][9] ],aConfig_Maq4[6][5],aConfig_Maq4[6][4],aConfig_Maq4[6][3],aConfig_Maq4[6][2],,aConfig_Maq4[6][6]) //alltrim(aMaquina1[1])	
		Temp_Maq4[7] := escala1(aMaquina4[ aConfig_Maq4[7][9] ],aConfig_Maq4[7][5],aConfig_Maq4[7][4],aConfig_Maq4[7][3],aConfig_Maq4[7][2],,aConfig_Maq4[7][6]) //alltrim(aMaquina1[1])	
		Temp_Maq4[8] := escala1(aMaquina4[ aConfig_Maq4[8][9] ],aConfig_Maq4[8][5],aConfig_Maq4[8][4],aConfig_Maq4[8][3],aConfig_Maq4[8][2],,aConfig_Maq4[8][6]) //alltrim(aMaquina1[1])	

 
 // msginfo(aMaquina1[9])	
 
 
	IF IsWindowActive(Form_Modbus_CNET)
		
		Form_Modbus_CNET.Text_20.Value := alltrim(aRecebe[1])  // D100
		Form_Modbus_CNET.Text_21.Value := alltrim(aRecebe[2])  // D101
		Form_Modbus_CNET.Text_22.Value := alltrim(aRecebe[3])  // D102
		Form_Modbus_CNET.Text_23.Value := alltrim(aRecebe[4])  // D103
		Form_Modbus_CNET.Text_24.Value := alltrim(aRecebe[5])  // D104
		Form_Modbus_CNET.Text_25.Value := alltrim(aRecebe[8])  // D107 pressao interna
		Form_Modbus_CNET.Text_26.Value := alltrim(aRecebe[7])  // D106 pressao externa
		
		Form_Modbus_CNET.Text_30.Value := alltrim(aRecebe[11])  // D110
		Form_Modbus_CNET.Text_31.Value := alltrim(aRecebe[12])  // D111
		Form_Modbus_CNET.Text_32.Value := alltrim(aRecebe[13])  // D112
		Form_Modbus_CNET.Text_33.Value := alltrim(aRecebe[14])  // D113
		Form_Modbus_CNET.Text_34.Value := alltrim(aRecebe[15])  // D114
		Form_Modbus_CNET.Text_35.Value := alltrim(aRecebe[18])  // D117 pressao interna
		Form_Modbus_CNET.Text_36.Value := alltrim(aRecebe[17])  // D116 pressao externa
		
		
		Form_Modbus_CNET.Text_40.Value := alltrim(aRecebe[21])  // D120
		Form_Modbus_CNET.Text_41.Value := alltrim(aRecebe[22])  // D121
		Form_Modbus_CNET.Text_42.Value := alltrim(aRecebe[23])  // D122
		Form_Modbus_CNET.Text_43.Value := alltrim(aRecebe[24])  // D123
		Form_Modbus_CNET.Text_44.Value := alltrim(aRecebe[25])  // D124
		Form_Modbus_CNET.Text_45.Value := alltrim(aRecebe[26])  // D125

		Form_Modbus_CNET.Text_50.Value := Alltrim(Temp_Maq4[1]) // alltrim(aRecebe[31])  // D130
		Form_Modbus_CNET.Text_51.Value := alltrim(aRecebe[32])  // D131
		Form_Modbus_CNET.Text_52.Value := alltrim(aRecebe[33])  // D132
		Form_Modbus_CNET.Text_53.Value := alltrim(aRecebe[34])  // D133
		Form_Modbus_CNET.Text_54.Value := alltrim(aRecebe[35])  // D134
		Form_Modbus_CNET.Text_55.Value := alltrim(aRecebe[36])  // D135

		Form_Modbus_CNET.Text_60.Value := alltrim(aRecebe[41])  // D140
		Form_Modbus_CNET.Text_61.Value := alltrim(aRecebe[42])  // D141
		Form_Modbus_CNET.Text_62.Value := alltrim(aRecebe[43])  // D142
		Form_Modbus_CNET.Text_63.Value := alltrim(aRecebe[44])  // D143
		Form_Modbus_CNET.Text_64.Value := alltrim(aRecebe[45])  // D144
		Form_Modbus_CNET.Text_65.Value := alltrim(aRecebe[46])  // D145
		
	
		
	endif
	
	
	
	
Return




******************************************************************************
Procedure fDesconecta(nTipo)
******************************************************************************


IF IsWindowActive(Form_Modbus_CNET)
		Form_Modbus_CNET.Button_1.Enabled :=.T.
		Form_Modbus_CNET.Button_2.Enabled :=.F.
		Form_Modbus_CNET.Combo_1.Enabled := .T.
		Form_Modbus_CNET.Combo_2.Enabled := .T.
		Form_Modbus_CNET.Combo_3.Enabled := .T.
		Form_Modbus_CNET.Combo_4.Enabled := .T.
		Form_Modbus_CNET.Combo_5.Enabled := .T.
		Form_Modbus_CNET.Combo_6.Enabled := .T.
endif

   if nTipo == 1 .AND. lCom_status == .T.
		UnInt_Port(nHandle)
   endif
   
   //Form_Main.Image_1.Picture := "CNX_OFF"
   //Form_Main.StatusBar.Item(4) := "CONEXÃO CLP: OFF"
   
   if nTipo == 2 
		Msginfo("Verifique a porta serial sem recepção de dados(resposta vazia)","hbcomm")
   endif
   
      if nTipo == 3 .AND. lCom_status == .T.
		UnInt_Port(nHandle)
	  endif

lCom_status := .f.
	  
 Return


******************************************************************************
Procedure Sair()
******************************************************************************
			Form_Modbus_CNET.Release
Return


******************************************************************************
Function Temporizador(cTempo)
******************************************************************************
						aDados_Processo_Maq1[8] := "AGUARDANDO PRESSÃO"
						Grava_Dados_Mysql_Maq1(1)
						MILLISEC(val(cTempo)) 
						aFim_Etapa_Maq1[1] := .F.
						msginfo("teste")
						
RETURN



**************************************************************************
Function CHR_HEX_ARRAY(DADOS) // Converte CHR para CODIGO HEX DA TABELA ASCII EM UM VETOR
**************************************************************************
local RET := ""
Local A := 0 
Local BH := "" 
Local BL := ""
Local ASC_CHAR := ""
Local BCD_CHAR := ""

lOCAL aASC := ARRAY(len( DADOS ))

FOR A := 1 to len( DADOS )
 BCD_CHAR := ASC( SUBSTR( DADOS, A, 1 ) )

  BH := NTOC(VAL(strzero( int( BCD_CHAR / 16 ), 2, 0 )),16,1) // RETORNA HEXADECIMAL
  BL := NTOC(VAL(strzero( mod( BCD_CHAR, 16 ), 2, 0 )),16,1) // RETORNA HEXADECIMAL

 aASC[A] := BH  + BL
NEXT

return(aASC) // ASC_CHAR 

**************************************************************************
Function CHR_DEC_ARRAY(DADOS) // CONVERTE CHR EM DECIMAL DA TABELA ASCII E RETORNA EM UM VETOR
**************************************************************************
local RET := ""
Local A := 0 

lOCAL aDEC := ARRAY(len( DADOS ))

FOR A := 1 to len( DADOS )
 
 aDEC[A] := ALLTRIM(STR(ASC( SUBSTR( DADOS, A, 1 ) )))

NEXT

return(aDEC) // ASC_CHAR 

**************************************************************************
Function CHR_HEX_SOMA(DADOS,nPad) // Converte CHARACTER para HEX
**************************************************************************
local RET := ""
Local A := 0 
Local ASC_CHAR := 0
Local BCD_CHAR := 0
 
FOR A := 1 to len( DADOS )
 BCD_CHAR := ASC( SUBSTR( DADOS, A, 1 ) )
 ASC_CHAR := ASC_CHAR + BCD_CHAR
NEXT
 RET := NTOC(ASC_CHAR,16,nPad,"0")
return RET


**************************************************************************
Function CHR_DEC_SOMA(DADOS) // Converte CHARACTER para DECIMAL
**************************************************************************
local RET := ""
Local A := 0 
Local ASC_CHAR := 0
Local BCD_CHAR := 0
 
FOR A := 1 to len( DADOS )
 BCD_CHAR := ASC( SUBSTR( DADOS, A, 1 ) )
 ASC_CHAR := ASC_CHAR + BCD_CHAR
NEXT
 
return ASC_CHAR

**************************************************************************
Function CHR_HEX(DADOS) // Converte CHR para CODIGO HEX DA TABELA ASCII EM UM VETOR
**************************************************************************
local RET := ""
Local A := 0 
Local BH := "" 
Local BL := ""
Local ASC_CHAR := ""
Local BCD_CHAR := ""

lOCAL aASC := ARRAY(len( DADOS ))

FOR A := 1 to len( DADOS )
 BCD_CHAR := ASC( SUBSTR( DADOS, A, 1 ) )

  BH := NTOC(VAL(strzero( int( BCD_CHAR / 16 ), 2, 0 )),16,1) // RETORNA HEXADECIMAL
  BL := NTOC(VAL(strzero( mod( BCD_CHAR, 16 ), 2, 0 )),16,1) // RETORNA HEXADECIMAL

 RET := RET + "["+BH+BL+"]" 
NEXT

return(RET) // ASC_CHAR




//****************************
#PRAGMA BEGINDUMP
//***************************
#define HB_API_MACROS
#include <windows.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

#include <stdlib.h>
#include <stdio.h>




// ******************************************************************************
HB_FUNC(CRC16_1)
// ******************************************************************************
{
	const UCHAR aucCRCHi[] = {
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 
    0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
    0x00, 0xC1, 0x81, 0x40
};

	const UCHAR aucCRCLo[] = {
    0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7,
    0x05, 0xC5, 0xC4, 0x04, 0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E,
    0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09, 0x08, 0xC8, 0xD8, 0x18, 0x19, 0xD9,
    0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD, 0x1D, 0x1C, 0xDC,
    0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3,
    0x11, 0xD1, 0xD0, 0x10, 0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32,
    0x36, 0xF6, 0xF7, 0x37, 0xF5, 0x35, 0x34, 0xF4, 0x3C, 0xFC, 0xFD, 0x3D,
    0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A, 0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38, 
    0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE, 0x2E, 0x2F, 0xEF,
    0x2D, 0xED, 0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26,
    0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0, 0xA0, 0x60, 0x61, 0xA1,
    0x63, 0xA3, 0xA2, 0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4,
    0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F, 0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 
    0x69, 0xA9, 0xA8, 0x68, 0x78, 0xB8, 0xB9, 0x79, 0xBB, 0x7B, 0x7A, 0xBA,
    0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5,
    0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0,
    0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97,
    0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C, 0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E,
    0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98, 0x88, 0x48, 0x49, 0x89,
    0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
    0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83,
    0x41, 0x81, 0x80, 0x40
};


UCHAR * pucFrame;
USHORT usLen;
UCHAR ucCRCHi = 0xFF;
UCHAR ucCRCLo = 0xFF;
int iIndex;

pucFrame = hb_parc(1);
usLen = hb_parni(2);

while( usLen-- )
{
iIndex = ucCRCLo ^ *( pucFrame++ );
ucCRCLo = ( UCHAR )( ucCRCHi ^ aucCRCHi[iIndex] );
ucCRCHi = aucCRCLo[iIndex];
}
		hb_retni (  ucCRCHi << 8 |ucCRCLo );
}

// ******************************************************************************
HB_FUNC(CRC16_2)
// ******************************************************************************
{

unsigned short crc_16_tab[] = {
  0x0000, 0xc0c1, 0xc181, 0x0140, 0xc301, 0x03c0, 0x0280, 0xc241,
  0xc601, 0x06c0, 0x0780, 0xc741, 0x0500, 0xc5c1, 0xc481, 0x0440,
  0xcc01, 0x0cc0, 0x0d80, 0xcd41, 0x0f00, 0xcfc1, 0xce81, 0x0e40,
  0x0a00, 0xcac1, 0xcb81, 0x0b40, 0xc901, 0x09c0, 0x0880, 0xc841,
  0xd801, 0x18c0, 0x1980, 0xd941, 0x1b00, 0xdbc1, 0xda81, 0x1a40,
  0x1e00, 0xdec1, 0xdf81, 0x1f40, 0xdd01, 0x1dc0, 0x1c80, 0xdc41,
  0x1400, 0xd4c1, 0xd581, 0x1540, 0xd701, 0x17c0, 0x1680, 0xd641,
  0xd201, 0x12c0, 0x1380, 0xd341, 0x1100, 0xd1c1, 0xd081, 0x1040,
  0xf001, 0x30c0, 0x3180, 0xf141, 0x3300, 0xf3c1, 0xf281, 0x3240,
  0x3600, 0xf6c1, 0xf781, 0x3740, 0xf501, 0x35c0, 0x3480, 0xf441,
  0x3c00, 0xfcc1, 0xfd81, 0x3d40, 0xff01, 0x3fc0, 0x3e80, 0xfe41,
  0xfa01, 0x3ac0, 0x3b80, 0xfb41, 0x3900, 0xf9c1, 0xf881, 0x3840,
  0x2800, 0xe8c1, 0xe981, 0x2940, 0xeb01, 0x2bc0, 0x2a80, 0xea41,
  0xee01, 0x2ec0, 0x2f80, 0xef41, 0x2d00, 0xedc1, 0xec81, 0x2c40,
  0xe401, 0x24c0, 0x2580, 0xe541, 0x2700, 0xe7c1, 0xe681, 0x2640,
  0x2200, 0xe2c1, 0xe381, 0x2340, 0xe101, 0x21c0, 0x2080, 0xe041,
  0xa001, 0x60c0, 0x6180, 0xa141, 0x6300, 0xa3c1, 0xa281, 0x6240,
  0x6600, 0xa6c1, 0xa781, 0x6740, 0xa501, 0x65c0, 0x6480, 0xa441,
  0x6c00, 0xacc1, 0xad81, 0x6d40, 0xaf01, 0x6fc0, 0x6e80, 0xae41,
  0xaa01, 0x6ac0, 0x6b80, 0xab41, 0x6900, 0xa9c1, 0xa881, 0x6840,
  0x7800, 0xb8c1, 0xb981, 0x7940, 0xbb01, 0x7bc0, 0x7a80, 0xba41,
  0xbe01, 0x7ec0, 0x7f80, 0xbf41, 0x7d00, 0xbdc1, 0xbc81, 0x7c40,
  0xb401, 0x74c0, 0x7580, 0xb541, 0x7700, 0xb7c1, 0xb681, 0x7640,
  0x7200, 0xb2c1, 0xb381, 0x7340, 0xb101, 0x71c0, 0x7080, 0xb041,
  0x5000, 0x90c1, 0x9181, 0x5140, 0x9301, 0x53c0, 0x5280, 0x9241,
  0x9601, 0x56c0, 0x5780, 0x9741, 0x5500, 0x95c1, 0x9481, 0x5440,
  0x9c01, 0x5cc0, 0x5d80, 0x9d41, 0x5f00, 0x9fc1, 0x9e81, 0x5e40,
  0x5a00, 0x9ac1, 0x9b81, 0x5b40, 0x9901, 0x59c0, 0x5880, 0x9841,
  0x8801, 0x48c0, 0x4980, 0x8941, 0x4b00, 0x8bc1, 0x8a81, 0x4a40,
  0x4e00, 0x8ec1, 0x8f81, 0x4f40, 0x8d01, 0x4dc0, 0x4c80, 0x8c41,
  0x4400, 0x84c1, 0x8581, 0x4540, 0x8701, 0x47c0, 0x4680, 0x8641,
  0x8201, 0x42c0, 0x4380, 0x8341, 0x4100, 0x81c1, 0x8081, 0x4040
};

unsigned char *buf;
unsigned int bsize;
unsigned short crc = 0xffff;
buf = hb_parc(1);
bsize = hb_parni(2);
	while (bsize--)
	{
		crc = (unsigned short)(crc >> 8) ^ crc_16_tab[(crc ^ *buf++) & 0xff];
	}
	hb_retni(crc);
}


#PRAGMA ENDDUMP


/*
<20120110093205.070 RX>
<ACK>02RSB01020000<ETX>
<ENQ>05WSB08%DW00001010000<EOT><ACK>05WSB<ETX>
<ENQ>02RSB08%MW0000006<EOT><ACK>02RSB010C400201000000000000000002<ETX>
<ENQ>01RSB08%PW0000001<EOT><ACK>01RSB010200C3<ETX>
<ENQ>06RSB08%DW0000001<EOT><ACK>06RSB01020092<ETX>
<ENQ>02WSB08%DW00010010092<EOT><ACK>02WSB<ETX>
<ENQ>06RSB08%DW0000201<EOT><ACK>06RSB01020917<ETX>
<ENQ>02RSB08%MW0000006<EOT><ACK>02RSB010C400201000000000000000002<ETX>
<ENQ>01RSB08%MW0000501<EOT><ACK>01RSB01020000<ETX>
<ENQ>02RSB08%DW0001101<EOT><ACK>02RSB01020000<ETX>
<ENQ>06WSB08%DW00001010000<EOT><ACK>06WSB<ETX>
<ENQ>02RSB08%MW0000006<EOT><ACK>02RSB010C400201000000000000000002<ETX>
<ENQ>01RSB08%FW0000001<EOT><ACK>01RSB01021011<ETX>
<ENQ>02RSB08%MW0000006<EOT><ACK>02RSB010C400201000000000000000002<ETX>
<ENQ>01RSB08%DW0000001<EOT><ACK>01RSB010200C3<ETX>
<ENQ>02WSB08%DW000000100C3<EOT><ACK>02WSB<ETX>
<ENQ>02RSB08%FW0000001<EOT><ACK>02RSB01021011<ETX>
<ENQ>02RSB08%MW0000006<EOT><ACK>02RSB010C400201000000000000000002<ETX>
<ENQ>02RSB08%DW0000101<EOT><ACK>02RSB01020000<ETX>
<ENQ>01WSB08%DW00
*/



