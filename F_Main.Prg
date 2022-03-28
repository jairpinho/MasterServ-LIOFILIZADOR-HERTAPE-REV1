#include <minigui.ch>
#include "common.ch"
#Include "Fileio.ch"
#include "F_Sistema.ch"


//#include "hbthread.ch"
//#define HB_THREAD_INHERIT_PUBLIC 1  // // NECESSARIO para manipular objetos da janela que chama

REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_UTF8
REQUEST HB_CODEPAGE_PT850
REQUEST HB_CODEPAGE_PT860
REQUEST HB_CODEPAGE_PTISO

/*

inicialização
Cria_File_Ini()
BEGIN INI FILE "Config.ini"
F_login.prg ->	Abre_conexao_MySql()
F_Login.prg -> Ambiente inicial()
Ambiente Inicial -> Operações()


///////////////////////////////////////////////////////////////////////////////
// PDF CONFIGURATION CONSTANTS
///////////////////////////////////////////////////////////////////////////////


* Orientation

#define HPDF_ORIENT_PORTRAIT   1
#define HPDF_ORIENT_LANDSCAPE  2


* Paper Size

#define HPDF_PAPER_FIRST                DMPAPER_LETTER
#define HPDF_PAPER_LETTER               1  // Letter 8 1/2 x 11 in               
#define HPDF_PAPER_LETTERSMALL          2  // Letter Small 8 1/2 x 11 in         
#define HPDF_PAPER_TABLOID              3  // Tabloid 11 x 17 in                 
#define HPDF_PAPER_LEDGER               4  // Ledger 17 x 11 in                  
#define HPDF_PAPER_LEGAL                5  // Legal 8 1/2 x 14 in                
#define HPDF_PAPER_STATEMENT            6  // Statement 5 1/2 x 8 1/2 in         
#define HPDF_PAPER_EXECUTIVE            7  // Executive 7 1/4 x 10 1/2 in        
#define HPDF_PAPER_A3                   8  // A3 297 x 420 mm                    
#define HPDF_PAPER_A4                   9  // A4 210 x 297 mm                    
#define HPDF_PAPER_A4SMALL             10  // A4 Small 210 x 297 mm              
#define HPDF_PAPER_A5                  11  // A5 148 x 210 mm                    
#define HPDF_PAPER_B4                  12  // B4 (JIS) 250 x 354                 
#define HPDF_PAPER_B5                  13  // B5 (JIS) 182 x 257 mm              
#define HPDF_PAPER_FOLIO               14  // Folio 8 1/2 x 13 in                
#define HPDF_PAPER_QUARTO              15  // Quarto 215 x 275 mm                
#define HPDF_PAPER_10X14               16  // 10x14 in                           
#define HPDF_PAPER_11X17               17  // 11x17 in                           
#define HPDF_PAPER_NOTE                18  // Note 8 1/2 x 11 in                 
#define HPDF_PAPER_ENV_9               19  // Envelope #9 3 7/8 x 8 7/8          
#define HPDF_PAPER_ENV_10              20  // Envelope #10 4 1/8 x 9 1/2         
#define HPDF_PAPER_ENV_11              21  // Envelope #11 4 1/2 x 10 3/8        
#define HPDF_PAPER_ENV_12              22  // Envelope #12 4 \276 x 11           
#define HPDF_PAPER_ENV_14              23  // Envelope #14 5 x 11 1/2            
#define HPDF_PAPER_CSHEET              24  // C size sheet                       
#define HPDF_PAPER_DSHEET              25  // D size sheet                       
#define HPDF_PAPER_ESHEET              26  // E size sheet                       
#define HPDF_PAPER_ENV_DL              27  // Envelope DL 110 x 220mm            
#define HPDF_PAPER_ENV_C5              28  // Envelope C5 162 x 229 mm           
#define HPDF_PAPER_ENV_C3              29  // Envelope C3  324 x 458 mm          
#define HPDF_PAPER_ENV_C4              30  // Envelope C4  229 x 324 mm          
#define HPDF_PAPER_ENV_C6              31  // Envelope C6  114 x 162 mm          
#define HPDF_PAPER_ENV_C65             32  // Envelope C65 114 x 229 mm          
#define HPDF_PAPER_ENV_B4              33  // Envelope B4  250 x 353 mm          
#define HPDF_PAPER_ENV_B5              34  // Envelope B5  176 x 250 mm          
#define HPDF_PAPER_ENV_B6              35  // Envelope B6  176 x 125 mm          
#define HPDF_PAPER_ENV_ITALY           36  // Envelope 110 x 230 mm              
#define HPDF_PAPER_ENV_MONARCH         37  // Envelope Monarch 3.875 x 7.5 in    
#define HPDF_PAPER_ENV_PERSONAL        38  // 6 3/4 Envelope 3 5/8 x 6 1/2 in    
#define HPDF_PAPER_FANFOLD_US          39  // US Std Fanfold 14 7/8 x 11 in      
#define HPDF_PAPER_FANFOLD_STD_GERMAN  40  // German Std Fanfold 8 1/2 x 12 in   
#define HPDF_PAPER_FANFOLD_LGL_GERMAN  41  // German Legal Fanfold 8 1/2 x 13 in 
#define HPDF_PAPER_ISO_B4              42  // B4 (ISO) 250 x 353 mm              
#define HPDF_PAPER_JAPANESE_POSTCARD   43  // Japanese Postcard 100 x 148 mm     
#define HPDF_PAPER_9X11                44  // 9 x 11 in                          
#define HPDF_PAPER_10X11               45  // 10 x 11 in                         
#define HPDF_PAPER_15X11               46  // 15 x 11 in                         
#define HPDF_PAPER_ENV_INVITE          47  // Envelope Invite 220 x 220 mm       
#define HPDF_PAPER_RESERVED_48         48  // RESERVED--DO NOT USE               
#define HPDF_PAPER_RESERVED_49         49  // RESERVED--DO NOT USE               
#define HPDF_PAPER_LETTER_EXTRA        50  // Letter Extra 9 \275 x 12 in        
#define HPDF_PAPER_LEGAL_EXTRA         51  // Legal Extra 9 \275 x 15 in         
#define HPDF_PAPER_TABLOID_EXTRA       52  // Tabloid Extra 11.69 x 18 in        
#define HPDF_PAPER_A4_EXTRA            53  // A4 Extra 9.27 x 12.69 in           
#define HPDF_PAPER_LETTER_TRANSVERSE   54  // Letter Transverse 8 \275 x 11 in   
#define HPDF_PAPER_A4_TRANSVERSE       55  // A4 Transverse 210 x 297 mm         
#define HPDF_PAPER_LETTER_EXTRA_TRANSVERSE 56 // Letter Extra Transverse 9\275 x 12 in 
#define HPDF_PAPER_A_PLUS              57  // SuperA/SuperA/A4 227 x 356 mm      
#define HPDF_PAPER_B_PLUS              58  // SuperB/SuperB/A3 305 x 487 mm      
#define HPDF_PAPER_LETTER_PLUS         59  // Letter Plus 8.5 x 12.69 in         
#define HPDF_PAPER_A4_PLUS             60  // A4 Plus 210 x 330 mm               
#define HPDF_PAPER_A5_TRANSVERSE       61  // A5 Transverse 148 x 210 mm         
#define HPDF_PAPER_B5_TRANSVERSE       62  // B5 (JIS) Transverse 182 x 257 mm   
#define HPDF_PAPER_A3_EXTRA            63  // A3 Extra 322 x 445 mm              
#define HPDF_PAPER_A5_EXTRA            64  // A5 Extra 174 x 235 mm              
#define HPDF_PAPER_B5_EXTRA            65  // B5 (ISO) Extra 201 x 276 mm        
#define HPDF_PAPER_A2                  66  // A2 420 x 594 mm                    
#define HPDF_PAPER_A3_TRANSVERSE       67  // A3 Transverse 297 x 420 mm         
#define HPDF_PAPER_A3_EXTRA_TRANSVERSE 68  // A3 Extra Transverse 322 x 445 mm   
#define HPDF_PAPER_DBL_JAPANESE_POSTCARD 69 // Japanese Double Postcard 200 x 148 mm 
#define HPDF_PAPER_A6                  70  // A6 105 x 148 mm                 
#define HPDF_PAPER_JENV_KAKU2          71  // Japanese Envelope Kaku #2       
#define HPDF_PAPER_JENV_KAKU3          72  // Japanese Envelope Kaku #3       
#define HPDF_PAPER_JENV_CHOU3          73  // Japanese Envelope Chou #3       
#define HPDF_PAPER_JENV_CHOU4          74  // Japanese Envelope Chou #4       
#define HPDF_PAPER_LETTER_ROTATED      75  // Letter Rotated 11 x 8 1/2 11 in 
#define HPDF_PAPER_A3_ROTATED          76  // A3 Rotated 420 x 297 mm         
#define HPDF_PAPER_A4_ROTATED          77  // A4 Rotated 297 x 210 mm         
#define HPDF_PAPER_A5_ROTATED          78  // A5 Rotated 210 x 148 mm         
#define HPDF_PAPER_B4_JIS_ROTATED      79  // B4 (JIS) Rotated 364 x 257 mm   
#define HPDF_PAPER_B5_JIS_ROTATED      80  // B5 (JIS) Rotated 257 x 182 mm   
#define HPDF_PAPER_JAPANESE_POSTCARD_ROTATED 81 // Japanese Postcard Rotated 148 x 100 mm 
#define HPDF_PAPER_DBL_JAPANESE_POSTCARD_ROTATED 82 // Double Japanese Postcard Rotated 148 x 200 mm 
#define HPDF_PAPER_A6_ROTATED          83  // A6 Rotated 148 x 105 mm         
#define HPDF_PAPER_JENV_KAKU2_ROTATED  84  // Japanese Envelope Kaku #2 Rotated 
#define HPDF_PAPER_JENV_KAKU3_ROTATED  85  // Japanese Envelope Kaku #3 Rotated 
#define HPDF_PAPER_JENV_CHOU3_ROTATED  86  // Japanese Envelope Chou #3 Rotated 
#define HPDF_PAPER_JENV_CHOU4_ROTATED  87  // Japanese Envelope Chou #4 Rotated 
#define HPDF_PAPER_B6_JIS              88  // B6 (JIS) 128 x 182 mm           
#define HPDF_PAPER_B6_JIS_ROTATED      89  // B6 (JIS) Rotated 182 x 128 mm   
#define HPDF_PAPER_12X11               90  // 12 x 11 in                      
#define HPDF_PAPER_JENV_YOU4           91  // Japanese Envelope You #4        
#define HPDF_PAPER_JENV_YOU4_ROTATED   92  // Japanese Envelope You #4 Rotated
#define HPDF_PAPER_P16K                93  // PRC 16K 146 x 215 mm            
#define HPDF_PAPER_P32K                94  // PRC 32K 97 x 151 mm             
#define HPDF_PAPER_P32KBIG             95  // PRC 32K(Big) 97 x 151 mm        
#define HPDF_PAPER_PENV_1              96  // PRC Envelope #1 102 x 165 mm    
#define HPDF_PAPER_PENV_2              97  // PRC Envelope #2 102 x 176 mm    
#define HPDF_PAPER_PENV_3              98  // PRC Envelope #3 125 x 176 mm    
#define HPDF_PAPER_PENV_4              99  // PRC Envelope #4 110 x 208 mm    
#define HPDF_PAPER_PENV_5              100 // PRC Envelope #5 110 x 220 mm    
#define HPDF_PAPER_PENV_6              101 // PRC Envelope #6 120 x 230 mm    
#define HPDF_PAPER_PENV_7              102 // PRC Envelope #7 160 x 230 mm    
#define HPDF_PAPER_PENV_8              103 // PRC Envelope #8 120 x 309 mm    
#define HPDF_PAPER_PENV_9              104 // PRC Envelope #9 229 x 324 mm    
#define HPDF_PAPER_PENV_10             105 // PRC Envelope #10 324 x 458 mm   
#define HPDF_PAPER_P16K_ROTATED        106 // PRC 16K Rotated                 
#define HPDF_PAPER_P32K_ROTATED        107 // PRC 32K Rotated                 
#define HPDF_PAPER_P32KBIG_ROTATED     108 // PRC 32K(Big) Rotated            
#define HPDF_PAPER_PENV_1_ROTATED      109 // PRC Envelope #1 Rotated 165 x 102 mm 
#define HPDF_PAPER_PENV_2_ROTATED      110 // PRC Envelope #2 Rotated 176 x 102 mm 
#define HPDF_PAPER_PENV_3_ROTATED      111 // PRC Envelope #3 Rotated 176 x 125 mm 
#define HPDF_PAPER_PENV_4_ROTATED      112 // PRC Envelope #4 Rotated 208 x 110 mm 
#define HPDF_PAPER_PENV_5_ROTATED      113 // PRC Envelope #5 Rotated 220 x 110 mm 
#define HPDF_PAPER_PENV_6_ROTATED      114 // PRC Envelope #6 Rotated 230 x 120 mm 
#define HPDF_PAPER_PENV_7_ROTATED      115 // PRC Envelope #7 Rotated 230 x 160 mm 
#define HPDF_PAPER_PENV_8_ROTATED      116 // PRC Envelope #8 Rotated 309 x 120 mm 
#define HPDF_PAPER_PENV_9_ROTATED      117 // PRC Envelope #9 Rotated 324 x 229 mm 
#define HPDF_PAPER_PENV_10_ROTATED     118 // PRC Envelope #10 Rotated 458 x 324 mm 
*/



/*
MAIN: como o próprio nome diz, esta será a janela principal.

CHILD: é a janela "filha" da MAIN. Apesar de ficar sobre a janela MAIN, você pode acessar as opções (Menu) da janela MAIN. Se a janela MAIN for minimizada,
ela será minimizada também.

MODAL: esta é igual a CHILD, mas ela retém todo o foco do programa para ela, não permite acessar as opções da janela MAIN que a criou, até que ela seja fechada.

SPLITCHILD: esta também é uma janela "filha" da MAIN, mas você não pode mover ela para fora dos limites da janela MAIN que a criou.

STANDARD: esta janela fica livre no programa, pode tanto sobrepor como pode ser sobreposta por outras janelas.
*/
//DECLARE WINDOW Form_MAIN
//DECLARE WINDOW Form_Modbus_CNET

DECLARE WINDOW Form_Main
DECLARE WINDOW Form_Modbus_CNET
DECLARE WINDOW Form_Processo

************************************************************************************************************************************
Function Main()
************************************************************************************************************************************
LOCAL CINZA:= {192,192,192}
public cIniFile := (DiskName()+ ":\"+CurDir() + "\Config.ini") 
Public cChave := "JMT13"
PUBLIC lConnected  := .F.
Public lOcupado   := .F.
PUBLIC thID
Public cResposta := ""
Public cRecibe    := ""
Public buffer     := 0
Public cTemp      := ""
Public aByte := {}
Public aComandType := {}
Public aComand := {}
Public nHandle   := 0
Public lRead_clock := .F.
Public lWrite_clock := .F.
Public lCom_status	 := .F.
Private lWindow  := .F.
Private lGrava_sql  := .F.
Private  aTabelasExistentes  := {}
Public nRead_count   := 0



Private  aStatusDoUsuario := array(10)
Private oServer      := Nil 
Private lLogin       := .F.
Private lUsuario       := .F.
Private nTipo_Login	:=  0
Private cDatabase   := ""
Private cHostName   := ""
Private cUser       := ""
Private cPassWord   := ""
Private cPort   := "3306"
Private cREv   := "Rev. 1"
Private aRetorno 	:= {} //  carrega dados de leitura da porta
Private aEnvia 		:= Array(100) //  envia dados de leitura da porta
Public aArray	:= Array(50)
Private  aUltimo_passo := Array(5)

Private  aConfig_Rel1 := Array(6)
Private  aConfig_Rel2 := Array(6)

Private BJC := BROWSE_JTFY_CENTER
Private BJL := BROWSE_JTFY_LEFT
Private BJR := BROWSE_JTFY_RIGHT
Private cDirBaseLogo := ""
PRIVATE cDiretorio     := DiskName()+":\"+CurDir() + "\"

PRIVATE bBackColor_Grid:={ || 234,244,255 }
PRIVATE bColor_Nil := {|| NIL }
PRIVATE bColor_RED := { || RED }

Private aColor [10]

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


  REQUEST HB_LANG_PT  
  HB_LANGSELECT( "PT" )
  SET CENTURY ON
  SET DELETED ON
  SET DATE TO BRITISH
   SET NAVIGATION EXTENDED // ADICIONA A TECLA ENTER PARA TROCAR DE CAMPOS IGUAL TAB
      SET MULTIPLE OFF WARNING
	  SET DECIMALS TO 3
  //Cria_File_ini()  
HB_LANGSELECT("PT")
HB_SETCODEPAGE( "PTISO" )


 
// SET DATE FRENCH
//  SET PATH TO C:\LAHER
//thID := hb_threadStart(HB_THREAD_INHERIT_PUBLIC, @Read_clock())
//thID := hb_threadStart(HB_THREAD_INHERIT_MEMVARS, @Read_clock() ) 
//thID := hb_threadDetach(hb_threadStart(HB_THREAD_INHERIT_MEMVARS, @Read_clock() , SECONDS() ))
//thID := hb_threadStart( HB_THREAD_INHERIT_MEMVARS , Read_clock() )

   	Cria_File_Ini()

	BEGIN INI FILE "Config.ini"
		GET cHostName 	SECTION  "Host" ENTRY "Servidor Host"
		GET cUser 		SECTION  "Host" ENTRY "Usuario do servidor"
		GET cPassWord 	SECTION  "Host" ENTRY "Senha do servidor"
		GET cDatabase 	SECTION  "Host" ENTRY "Banco de Dados"
		GET cPort 		SECTION  "Host" ENTRY "Porta"
	END INI


	
IF !IsWindowDefined(Form_Main)	
        Load Window Form_Main
		
		Form_Main.Label_2.value := "Liofilizador FIC50 " + cREv
		Form_Main.Frame_1.Caption := "SISTEMA " + cREv + " - SQL"

			IF lCom_status == .F.
				Form_Main.StatusBar.Item(4) := "CONEXÃO CLP: OFF"
				Form_Main.Image_1.Picture := "CNX_OFF"
			Endif
			
Form_Main.Row := 10
Form_Main.Col := 10

//SetProperty( "Form_Main" , "Row" , 100 ) 

        Form_Main.Activate

		//hb_threadDetach(hb_threadStart(HB_THREAD_INHERIT_MEMVARS, @Read_clock(), SECONDS() ))		
ENDIF


************************************************************************************************************************************
Function Confirmar_Saida()
************************************************************************************************************************************
	If MSGYesNo( "Confirma Saída do Sistema??" , SISTEMA )
	    IF IsWindowActive(Form_Main)
		//Autobackup()
		Fechar_Conexao_MySql()
          Form_MAIN.Release
       ENDIF
	EndIf
Return Nil


************************************************************************************************************************************
Function Confirmar_Saida_Main()
************************************************************************************************************************************
		IF IsWindowActive(Form_Main)
				//Autobackup()
			Fechar_Conexao_MySql()
          Form_MAIN.Release
		EndIf
Return Nil
************************************************************************************************************************************
Function Sobre_o_Sistema()
************************************************************************************************************************************
         PlayExclamation()
         MsgINFO (PadC("*** Cadastro de Oredem de Servico V.1.0 ***",60)+QUEBRA+;
                  PadC(" Desenvolvido por SulTeck Informatica",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(" Jair Abreu de Pinho  jairpinho@sulteck.com.br",60)+QUEBRA+;
                  PadC(" www.sulteck.com.br",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(" Desenvolvido com Harbour Compiler (MiniGUI Distribution) 2003.05.03 (Flex)",60)+QUEBRA+;
                  PadC(" Copyright 1999-2003, http://www.harbour-project.org/",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC("Harbour MiniGUI R.62a Copyright 2002-2003",60)+QUEBRA+;
                  PadC("Minigui / Jair / Brasil",60), SISTEMA)
Return NIL



************************************************************************************************************************************
Procedure Grava_Mysql()
************************************************************************************************************************************
 Grava_Dados_Mysql_Maq1(0)
 Grava_Dados_Mysql_Maq2(0)
 Grava_Dados_Mysql_Maq3(0)
 Grava_Dados_Mysql_Maq4(0)
 Grava_Dados_Mysql_Maq5(0)


Return



************************************************************************************************************************************
Procedure Grava_Dados_etapas_Mysql_Maq1(nSituacao)
************************************************************************************************************************************

IF aEtapa_Maq1[nSituacao] == .T.
	Grava_Dados_Mysql_Maq1(1,nSituacao)
	//msginfo("GRAVANDO SQL ETAPAS DE PROCESSO - " + STR(nSituacao)+ " LUFERCO")
ENDIF

Return


************************************************************************************************************************************
Procedure Grava_Dados_etapas_Mysql_Maq2(nSituacao)
************************************************************************************************************************************
	IF aEtapa_Maq2[nSituacao] == .T.
		Grava_Dados_Mysql_Maq2(1,nSituacao)
		//msginfo("GRAVANDO SQL ETAPAS DE PROCESSO - " + STR(nSituacao) + " SERCON")
	ENDIF
Return

************************************************************************************************************************************
Procedure Grava_Dados_etapas_Mysql_Maq3(nSituacao)
************************************************************************************************************************************
	IF aEtapa_Maq3[nSituacao] == .T.
		Grava_Dados_Mysql_Maq3(1,nSituacao)
		//msginfo("GRAVANDO SQL ETAPAS DE PROCESSO - " + STR(nSituacao) + " SERCON")
	ENDIF
Return

************************************************************************************************************************************
Procedure Grava_Dados_etapas_Mysql_Maq4(nSituacao)
************************************************************************************************************************************
	IF aEtapa_Maq4[nSituacao] == .T.
			Grava_Dados_Mysql_Maq4(1,nSituacao)
		//msginfo("GRAVANDO SQL ETAPAS DE PROCESSO - " + STR(nSituacao) + " SERCON")
	ENDIF
Return

************************************************************************************************************************************
Procedure Grava_Dados_etapas_Mysql_Maq5(nSituacao)
************************************************************************************************************************************
	IF aEtapa_Maq5[nSituacao] == .T.
		Grava_Dados_Mysql_Maq5(1,nSituacao)
		//msginfo("GRAVANDO SQL ETAPAS DE PROCESSO - " + STR(nSituacao) + " SERCON")
	ENDIF
Return


************************************************************************************************************************************
Procedure Grava_Dados_Mysql_Maq1(nGrava,nSituacao)
************************************************************************************************************************************
	Local cValues 	:= ""
	Local aStruc1 	:= {}
	Local aInsert1 	:= {}
	Local oQuery 	:=  ""
	Local cQuery 	:= ""
	
	
DECLARE WINDOW Form_Processo


if oServer != Nil  	

IF lCom_status == .T.
lGrava_sql := .T.
//msginfo(str(escala1(aMaquina1[1],0,4000,-100,250,1)))
// AUTOCLAVE 1

IF estapas_processo_1 ==  .T. .OR. nGrava == 1
			aInsert1   :=     Array(30)
			aInsert1[1]:=	VAL(aDados_Processo_Maq1[1] )
			aInsert1[2]:=	aDados_Processo_Maq1[11]
			aInsert1[3]:=	Data_BRITISH_ANSI( Date() )
			aInsert1[4]:=	aDados_Processo_Maq1[7]
			aInsert1[5]:=	aDados_Processo_Maq1[4]
			aInsert1[6]:=	aDados_Processo_Maq1[6]
			aInsert1[7]:=	aDados_Processo_Maq1[5]
			aInsert1[8]:=	aDados_Processo_Maq1[10]
			aInsert1[9]:=	"OFF"
			aInsert1[10]:=	time()
			aInsert1[11]:=	aDados_Processo_Maq1[8]
			aInsert1[12]:=	escala1(aMaquina1[6],0,4000,-100,250,1)
			aInsert1[13]:=	"OFF" // IIF(estapas_processo_1 ==  .T. , CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[14]:=	escala1(aMaquina1[2],0,4000,-100,250,1)
			aInsert1[15]:= 	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[2],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[16]:=	escala1(aMaquina1[3],0,4000,-100,250,1)
			aInsert1[17]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[3],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[18]:=	escala1(aMaquina1[4],0,4000,-100,250,1)
			aInsert1[19]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[4],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[20]:=	escala1(aMaquina1[5],0,4000,-100,250,1)
			aInsert1[21]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[5],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[22]:=  IIF(escala1(aMaquina1[1],0,4000,-100,250,1) < 0 , 0 , escala1(aMaquina1[1],0,4000,-100,250,1) )
			aInsert1[23]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[24]:=	 escala1(aMaquina1[7],0,4000,-1,5,1)
			aInsert1[25]:= 	 escala1(aMaquina1[8],0,4000,-1,5,1)
			aInsert1[26]:= 	 aDados_Processo_Maq1[2]
			aInsert1[27]:=	"OFF"
			aInsert1[28]:=	aDados_Processo_Maq1[3]
			aInsert1[29]:=	IIF(nGrava == 1 .AND. nSituacao == 5, TIME(),"OFF")
			aInsert1[30]:=	IIF(nGrava == 1 .AND. nSituacao == 6 , TIME(),"OFF")
			
			
			aStruc1 := array(30)	
			aStruc1[1]  := 'codigo'
			aStruc1[2]  := 'setor'
			aStruc1[3]  := 'data'
			aStruc1[4]  := 'operador'
			aStruc1[5]  := 'lote'
			aStruc1[6]  := 'setpoint'
			aStruc1[7]  := 'carga'
			aStruc1[8]  := 'tempo_esterili'
			aStruc1[9]  := 'temp_variacao'
			aStruc1[10]  := 'hora'
			aStruc1[11]  := 'Situacao'
			aStruc1[12]  := 't1'
			aStruc1[13]  := 'f0_1'
			aStruc1[14]  := 't2'
			aStruc1[15]  := 'f0_2'
			aStruc1[16]  := 't3'
			aStruc1[17]  := 'f0_3'
			aStruc1[18]  := 't4'
			aStruc1[19]  := 'f0_4'
			aStruc1[20]  := 't5'
			aStruc1[21]  := 'f0_5'
			aStruc1[22]  := 't6'
			aStruc1[23]  := 'f0_6'
			aStruc1[24]  := 'pressao_ext'
			aStruc1[25]  := 'pressao_interna'
			aStruc1[26]  := 'materiais'
			aStruc1[27]  := 'etapa_processo'
			aStruc1[28]  := 'inicio_processo'			
			aStruc1[29]  := 'inicio_esteril'			
			aStruc1[30]  := 'fim_esteril'			



						cValues := MysqlQueryInsert(aInsert1,aStruc1)
						cQuery := "INSERT INTO " + cTabela1 + cValues 
                        oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operação) (): " + oQuery:Error())
							Endif 	
							
							
IF IsWindowActive(Form_Processo)							
			Pesquisa_Maquina1()
ENDIF

ENDIF



ENDIF	
ENDIF						
lGrava_sql := .F.
							
RETURN


************************************************************************************************************************************
Procedure Grava_Dados_Mysql_Maq2(nGrava,nSituacao)
************************************************************************************************************************************
	Local cValues 	:= ""
	Local aStruc1 	:= {}
	Local aInsert1 	:= {}
	Local oQuery 	:=  ""
	Local cQuery 	:= ""
	
	
DECLARE WINDOW Form_Processo


IF oServer != Nil  	

IF lCom_status == .T.
lGrava_sql := .T.
//msginfo(str(escala1(aMaquina1[1],0,4000,-100,250,1)))

// AUTOCLAVE 2

IF estapas_processo_2 ==  .T. .OR. nGrava == 1
			aInsert1   :=     Array(30)
			aInsert1[1]:=	VAL(aDados_Processo_Maq2[1] )
			aInsert1[2]:=	aDados_Processo_Maq2[11]
			aInsert1[3]:=	Data_BRITISH_ANSI( Date() )
			aInsert1[4]:=	aDados_Processo_Maq2[7]
			aInsert1[5]:=	aDados_Processo_Maq2[4]
			aInsert1[6]:=	aDados_Processo_Maq2[6]
			aInsert1[7]:=	aDados_Processo_Maq2[5]
			aInsert1[8]:=	aDados_Processo_Maq2[10]
			aInsert1[9]:=	"OFF"
			aInsert1[10]:=	time()
			aInsert1[11]:=	aDados_Processo_Maq2[8]
			aInsert1[12]:=	escala1(aMaquina2[1],0,4000,-100,250,1)
			aInsert1[13]:=	"OFF" // IIF(estapas_processo_1 ==  .T. , CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[14]:=	escala1(aMaquina2[2],0,4000,-100,250,1)
			aInsert1[15]:= 	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[2],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[16]:=	escala1(aMaquina2[5],0,4000,-100,250,1)
			aInsert1[17]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[3],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[18]:=	escala1(aMaquina2[4],0,4000,-100,250,1,10)
			aInsert1[19]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[4],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[20]:=	escala1(aMaquina2[6],0,4000,-100,250,1)
			aInsert1[21]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[5],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[22]:=  IIF(escala1(aMaquina2[3],0,4000,-100,250,1) < 0 , 0 , escala1(aMaquina2[3],0,4000,-100,250,1) )
			aInsert1[23]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[24]:=	 escala1(aMaquina2[7],0,4000,-1,5,1)
			aInsert1[25]:= 	 escala1(aMaquina2[8],0,4000,-1,5,1)
			aInsert1[26]:= 	 aDados_Processo_Maq2[2]
			aInsert1[27]:=	"OFF"
			aInsert1[28]:=	aDados_Processo_Maq2[3]
			aInsert1[29]:=	IIF(nGrava == 1 .AND. nSituacao == 5, TIME(),"OFF")
			aInsert1[30]:=	IIF(nGrava == 1 .AND. nSituacao == 6 , TIME(),"OFF")
			
			
			aStruc1 := array(30)	
			aStruc1[1]  := 'codigo'
			aStruc1[2]  := 'setor'
			aStruc1[3]  := 'data'
			aStruc1[4]  := 'operador'
			aStruc1[5]  := 'lote'
			aStruc1[6]  := 'setpoint'
			aStruc1[7]  := 'carga'
			aStruc1[8]  := 'tempo_esterili'
			aStruc1[9]  := 'temp_variacao'
			aStruc1[10]  := 'hora'
			aStruc1[11]  := 'Situacao'
			aStruc1[12]  := 't1'
			aStruc1[13]  := 'f0_1'
			aStruc1[14]  := 't2'
			aStruc1[15]  := 'f0_2'
			aStruc1[16]  := 't3'
			aStruc1[17]  := 'f0_3'
			aStruc1[18]  := 't4'
			aStruc1[19]  := 'f0_4'
			aStruc1[20]  := 't5'
			aStruc1[21]  := 'f0_5'
			aStruc1[22]  := 't6'
			aStruc1[23]  := 'f0_6'
			aStruc1[24]  := 'pressao_ext'
			aStruc1[25]  := 'pressao_interna'
			aStruc1[26]  := 'materiais'
			aStruc1[27]  := 'etapa_processo'
			aStruc1[28]  := 'inicio_processo'			
			aStruc1[29]  := 'inicio_esteril'			
			aStruc1[30]  := 'fim_esteril'			



						cValues := MysqlQueryInsert(aInsert1,aStruc1)
						cQuery := "INSERT INTO " + cTabela2 + cValues 
                        oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operação) (): " + oQuery:Error())
							Endif 	
							
							
IF IsWindowActive(Form_Processo)
			Pesquisa_Maquina2()
endif

ENDIF


ENDIF	
ENDIF						
lGrava_sql := .F.							
RETURN



************************************************************************************************************************************
Procedure Grava_Dados_Mysql_Maq3(nGrava,nSituacao)
************************************************************************************************************************************
	Local cValues 	:= ""
	Local aStruc1 	:= {}
	Local aInsert1 	:= {}
	Local oQuery 	:=  ""
	Local cQuery 	:= ""
	
	
DECLARE WINDOW Form_Processo


IF oServer != Nil  	

IF lCom_status == .T.
lGrava_sql := .T.
//msginfo(str(escala1(aMaquina1[1],0,4000,-100,250,1)))

// AUTOCLAVE 2

IF estapas_processo_3 ==  .T. .OR. nGrava == 1
			aInsert1   :=     Array(30)
			aInsert1[1]:=	VAL(aDados_Processo_Maq3[1])
			aInsert1[2]:=	aDados_Processo_Maq3[11]
			aInsert1[3]:=	Data_BRITISH_ANSI( Date() )
			aInsert1[4]:=	aDados_Processo_Maq3[7]
			aInsert1[5]:=	aDados_Processo_Maq3[4]
			aInsert1[6]:=	aDados_Processo_Maq3[6]
			aInsert1[7]:=	aDados_Processo_Maq3[5]
			aInsert1[8]:=	aDados_Processo_Maq3[10]
			aInsert1[9]:=	"OFF"
			aInsert1[10]:=	time()
			aInsert1[11]:=	aDados_Processo_Maq3[8]
			aInsert1[12]:=	escala1(aMaquina3[1],0,4000,0,400,1)
			aInsert1[13]:=	"OFF" // IIF(estapas_processo_1 ==  .T. , CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[14]:=	escala1(aMaquina3[2],0,4000,0,400,1)
			aInsert1[15]:= 	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[2],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[16]:=	escala1(aMaquina3[7],0,4000,0,400,1)
			aInsert1[17]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[3],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[18]:=	escala1(aMaquina3[8],0,4000,0,400,1)
			aInsert1[19]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[4],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[20]:=	escala1(aMaquina3[5],0,4000,0,400,1)
			aInsert1[21]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[5],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[22]:=  escala1(aMaquina3[6],0,4000,0,400,1) // IIF(escala1(aMaquina3[6],0,4000,-100,250,1) < 0 , 0 , escala1(aMaquina3[3],0,4000,-100,250,1) )
			aInsert1[23]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[24]:=	 "OFF" // escala1(aMaquina3[7],0,4000,0,10,1)
			aInsert1[25]:= 	 "OFF" // escala1(aMaquina3[8],0,4000,-1,5,1)
			aInsert1[26]:= 	 aDados_Processo_Maq3[2]
			aInsert1[27]:=	"OFF"
			aInsert1[28]:=	aDados_Processo_Maq3[3]
			aInsert1[29]:=	IIF(nGrava == 1 .AND. nSituacao == 5, TIME(),"OFF")
			aInsert1[30]:=	IIF(nGrava == 1 .AND. nSituacao == 6 , TIME(),"OFF")
			
			
			aStruc1 := array(30)	
			aStruc1[1]  := 'codigo'
			aStruc1[2]  := 'setor'
			aStruc1[3]  := 'data'
			aStruc1[4]  := 'operador'
			aStruc1[5]  := 'lote'
			aStruc1[6]  := 'setpoint'
			aStruc1[7]  := 'carga'
			aStruc1[8]  := 'tempo_esterili'
			aStruc1[9]  := 'temp_variacao'
			aStruc1[10]  := 'hora'
			aStruc1[11]  := 'Situacao'
			aStruc1[12]  := 't1'
			aStruc1[13]  := 'f0_1'
			aStruc1[14]  := 't2'
			aStruc1[15]  := 'f0_2'
			aStruc1[16]  := 't3'
			aStruc1[17]  := 'f0_3'
			aStruc1[18]  := 't4'
			aStruc1[19]  := 'f0_4'
			aStruc1[20]  := 't5'
			aStruc1[21]  := 'f0_5'
			aStruc1[22]  := 't6'
			aStruc1[23]  := 'f0_6'
			aStruc1[24]  := 'pressao_ext'
			aStruc1[25]  := 'pressao_interna'
			aStruc1[26]  := 'materiais'
			aStruc1[27]  := 'etapa_processo'
			aStruc1[28]  := 'inicio_processo'			
			aStruc1[29]  := 'inicio_esteril'			
			aStruc1[30]  := 'fim_esteril'			



						cValues := MysqlQueryInsert(aInsert1,aStruc1)
						cQuery := "INSERT INTO " + cTabela3 + cValues 
                        oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operação) (): " + oQuery:Error())
							Endif 	
							
							
IF IsWindowActive(Form_Processo)							
			Pesquisa_Maquina3()
endif

ENDIF
ENDIF	
ENDIF						
lGrava_sql := .F.							
RETURN


************************************************************************************************************************************
Procedure Grava_Dados_Mysql_Maq4(nGrava,nSituacao)
************************************************************************************************************************************
	Local cValues 	:= ""
	Local aStruc1 	:= {}
	Local aInsert1 	:= {}
	Local oQuery 	:=  ""
	Local cQuery 	:= ""
	
	
DECLARE WINDOW Form_Processo


IF oServer != Nil  	

IF lCom_status == .T.
lGrava_sql := .T.
//msginfo(str(escala1(aMaquina1[1],0,4000,-100,250,1)))

// AUTOCLAVE 2

IF estapas_processo_4 ==  .T. .OR. nGrava == 1
			aInsert1   :=     Array(30)
			aInsert1[1]:=	VAL(aDados_Processo_Maq4[1] )
			aInsert1[2]:=	aDados_Processo_Maq4[11]
			aInsert1[3]:=	Data_BRITISH_ANSI( Date() )
			aInsert1[4]:=	aDados_Processo_Maq4[7]
			aInsert1[5]:=	aDados_Processo_Maq4[4]
			aInsert1[6]:=	aDados_Processo_Maq4[6]
			aInsert1[7]:=	aDados_Processo_Maq4[5]
			aInsert1[8]:=	aDados_Processo_Maq4[10]
			aInsert1[9]:=	"OFF"
			aInsert1[10]:=	time()
			aInsert1[11]:=	aDados_Processo_Maq4[8]
			aInsert1[12]:=	VAL(Alltrim(Temp_Maq4[1]))
			aInsert1[13]:=	"OFF" // IIF(estapas_processo_1 ==  .T. , CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[14]:=	VAL(Alltrim(Temp_Maq4[2]))
			aInsert1[15]:= 	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[2],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[16]:=	VAL(Alltrim(Temp_Maq4[3]))
			aInsert1[17]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[3],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[18]:=	VAL(Alltrim(Temp_Maq4[4]))
			aInsert1[19]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[4],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[20]:=	VAL(Alltrim(Temp_Maq4[5]))
			aInsert1[21]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[5],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[22]:=  VAL(Alltrim(Temp_Maq4[6])) // IIF(escala1(aMaquina4[3],0,4000,-100,250,1) < 0 , 0 , escala1(aMaquina4[3],0,4000,-100,250,1) )
			aInsert1[23]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[24]:=	"OFF" // escala1(aMaquina4[7],0,4000,0,10,1)
			aInsert1[25]:= 	"OFF" // escala1(aMaquina4[8],0,4000,-1,5,1)
			aInsert1[26]:= 	aDados_Processo_Maq4[2]
			aInsert1[27]:=	"OFF"
			aInsert1[28]:=	aDados_Processo_Maq4[3]
			aInsert1[29]:=	IIF(nGrava == 1 .AND. nSituacao == 5, TIME(),"OFF")
			aInsert1[30]:=	IIF(nGrava == 1 .AND. nSituacao == 6 , TIME(),"OFF")
			
			
			aStruc1 := array(30)	
			aStruc1[1]  := 'codigo'
			aStruc1[2]  := 'setor'
			aStruc1[3]  := 'data'
			aStruc1[4]  := 'operador'
			aStruc1[5]  := 'lote'
			aStruc1[6]  := 'setpoint'
			aStruc1[7]  := 'carga'
			aStruc1[8]  := 'tempo_esterili'
			aStruc1[9]  := 'temp_variacao'
			aStruc1[10]  := 'hora'
			aStruc1[11]  := 'Situacao'
			aStruc1[12]  := 't1'
			aStruc1[13]  := 'f0_1'
			aStruc1[14]  := 't2'
			aStruc1[15]  := 'f0_2'
			aStruc1[16]  := 't3'
			aStruc1[17]  := 'f0_3'
			aStruc1[18]  := 't4'
			aStruc1[19]  := 'f0_4'
			aStruc1[20]  := 't5'
			aStruc1[21]  := 'f0_5'
			aStruc1[22]  := 't6'
			aStruc1[23]  := 'f0_6'
			aStruc1[24]  := 'pressao_ext'
			aStruc1[25]  := 'pressao_interna'
			aStruc1[26]  := 'materiais'
			aStruc1[27]  := 'etapa_processo'
			aStruc1[28]  := 'inicio_processo'			
			aStruc1[29]  := 'inicio_esteril'			
			aStruc1[30]  := 'fim_esteril'			



						cValues := MysqlQueryInsert(aInsert1,aStruc1)
						cQuery := "INSERT INTO " + cTabela4 + cValues 
                        oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operação) (): " + oQuery:Error())
							Endif 	
							
							
IF IsWindowActive(Form_Processo)							
			Pesquisa_Maquina4()
endif

ENDIF
ENDIF	
ENDIF						
lGrava_sql := .F.							
RETURN

************************************************************************************************************************************
Procedure Grava_Dados_Mysql_Maq5(nGrava,nSituacao)
************************************************************************************************************************************
	Local cValues 	:= ""
	Local aStruc1 	:= {}
	Local aInsert1 	:= {}
	Local oQuery 	:=  ""
	Local cQuery 	:= ""
	
	
DECLARE WINDOW Form_Processo


IF oServer != Nil  	

IF lCom_status == .T.
lGrava_sql := .T.
//msginfo(str(escala1(aMaquina1[1],0,4000,-100,250,1)))

// AUTOCLAVE 2

IF estapas_processo_5 ==  .T. .OR. nGrava == 1
			aInsert1   :=     Array(30)
			aInsert1[1]:=	VAL(aDados_Processo_Maq5[1] )
			aInsert1[2]:=	aDados_Processo_Maq5[11]
			aInsert1[3]:=	Data_BRITISH_ANSI( Date() )
			aInsert1[4]:=	aDados_Processo_Maq5[7]
			aInsert1[5]:=	aDados_Processo_Maq5[4]
			aInsert1[6]:=	aDados_Processo_Maq5[6]
			aInsert1[7]:=	aDados_Processo_Maq5[5]
			aInsert1[8]:=	aDados_Processo_Maq5[10]
			aInsert1[9]:=	"OFF"
			aInsert1[10]:=	time()
			aInsert1[11]:=	aDados_Processo_Maq5[8]
			aInsert1[12]:=	escala1(aMaquina5[1],0,4000,-100,250,1)
			aInsert1[13]:=	"OFF" // IIF(estapas_processo_1 ==  .T. , CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[14]:=	escala1(aMaquina5[6],0,4000,-100,250,1)
			aInsert1[15]:= 	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[2],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[16]:=	escala1(aMaquina5[3],0,4000,-100,250,1)
			aInsert1[17]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[3],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[18]:=	escala1(aMaquina5[4],0,4000,-100,250,1)
			aInsert1[19]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[4],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[20]:=	"OFF" //escala1(aMaquina5[5],0,4000,-100,250,1)
			aInsert1[21]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[5],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[22]:=  "OFF" // IIF(escala1(aMaquina5[3],0,4000,-100,250,1) < 0 , 0 , escala1(aMaquina5[3],0,4000,-100,250,1) )
			aInsert1[23]:=	"OFF" // IIF(estapas_processo_1 ==  .T. ,CALCULA_F0(escala1(aMaquina1[6],0,4000,-100,250,1),aDados_Processo_Maq1[6],10), 0 )
			aInsert1[24]:=	"OFF" // escala1(aMaquina5[7],0,4000,0,10,1)
			aInsert1[25]:= 	"OFF" // escala1(aMaquina5[8],0,4000,-1,5,1)
			aInsert1[26]:= 	 aDados_Processo_Maq5[2]
			aInsert1[27]:=	"OFF"
			aInsert1[28]:=	aDados_Processo_Maq5[3]
			aInsert1[29]:=	IIF(nGrava == 1 .AND. nSituacao == 5, TIME(),"OFF")
			aInsert1[30]:=	IIF(nGrava == 1 .AND. nSituacao == 6 , TIME(),"OFF")
			
			
			aStruc1 := array(30)	
			aStruc1[1]  := 'codigo'
			aStruc1[2]  := 'setor'
			aStruc1[3]  := 'data'
			aStruc1[4]  := 'operador'
			aStruc1[5]  := 'lote'
			aStruc1[6]  := 'setpoint'
			aStruc1[7]  := 'carga'
			aStruc1[8]  := 'tempo_esterili'
			aStruc1[9]  := 'temp_variacao'
			aStruc1[10]  := 'hora'
			aStruc1[11]  := 'Situacao'
			aStruc1[12]  := 't1'
			aStruc1[13]  := 'f0_1'
			aStruc1[14]  := 't2'
			aStruc1[15]  := 'f0_2'
			aStruc1[16]  := 't3'
			aStruc1[17]  := 'f0_3'
			aStruc1[18]  := 't4'
			aStruc1[19]  := 'f0_4'
			aStruc1[20]  := 't5'
			aStruc1[21]  := 'f0_5'
			aStruc1[22]  := 't6'
			aStruc1[23]  := 'f0_6'
			aStruc1[24]  := 'pressao_ext'
			aStruc1[25]  := 'pressao_interna'
			aStruc1[26]  := 'materiais'
			aStruc1[27]  := 'etapa_processo'
			aStruc1[28]  := 'inicio_processo'			
			aStruc1[29]  := 'inicio_esteril'			
			aStruc1[30]  := 'fim_esteril'			



						cValues := MysqlQueryInsert(aInsert1,aStruc1)
						cQuery := "INSERT INTO " + cTabela5 + cValues 
                        oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Operação) (): " + oQuery:Error())
							Endif 	
							
							
IF IsWindowActive(Form_Processo)							
			Pesquisa_Maquina5()
endif

ENDIF
ENDIF	
ENDIF						
lGrava_sql := .F.							
RETURN

*************************************************************************************************************************************
Function Pesquisa_Maquina1()
*************************************************************************************************************************************
	Local cPesq	:= Alltrim(aDados_Processo_Maq1[1])
	Local i           					:= 0
	Local oRow     						:= {}
	Local oRow1     						:= {}	
	Local oQuery      				:= "" 

IF IsWindowActive(Form_Processo)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_1 OF Form_Processo

				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela1 + " WHERE codigo = " + cPesq + " Order By data DESC, hora DESC" ) 
				
				//MSGINFO("total : " + str(oQuery:LastRec()) )
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
               For i:= 1 To oQuery:LastRec()
               
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(1)) )  ,;
						DTOC( oRow:fieldGet(3) ) ,;
						Alltrim(oRow:fieldGet(10) ),;
						"Autoclave Luferco" ,;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(STR(oRow:fieldGet(12) )),;
						Alltrim(STR(oRow:fieldGet(14) )),;
						Alltrim(STR(oRow:fieldGet(16) )),;
						Alltrim(STR(oRow:fieldGet(18) )),;
						Alltrim(STR(oRow:fieldGet(20) )),;
						Alltrim(STR(oRow:fieldGet(22) )),;
						Alltrim(STR(oRow:fieldGet(25) )),;
						Alltrim(STR(oRow:fieldGet(24) )),;
						Alltrim(oRow:fieldGet(11) )} TO Grid_1 OF Form_Processo
                        oQuery:Skip(1)
						
						
               Next

oRow1 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Processo.Text_24.Value := Alltrim(oRow1:fieldGet(4) )  // operador
Form_Processo.Text_16.Value := Alltrim(oRow1:fieldGet(28) )  // inicio processo
Form_Processo.Text_22.Value := Alltrim(oRow1:fieldGet(5) )  //lote
Form_Processo.Text_23.Value := Alltrim(oRow1:fieldGet(7) )  // carga
Form_Processo.Text_20.Value := Alltrim(oRow1:fieldGet(6) )  // ciclo
Form_Processo.Text_15.Value := aDados_Processo_Maq1[1] // tag sequencial
Form_Processo.Text_18.Value := "" // cInicio_est // inicio esterilizacao
Form_Processo.Text_19.Value := "" // cFinal_est // final esterilizacao
 			   
			   
endif





	Return Nil

*************************************************************************************************************************************
Function Pesquisa_Maquina2()
*************************************************************************************************************************************
	Local cPesq	:= Alltrim(aDados_Processo_Maq2[1])
	Local i           					:= 0
	Local oRow     						:= {}
	Local oRow1     						:= {}
	Local oQuery      					:= "" 

IF IsWindowActive(Form_Processo)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_2 OF Form_Processo

				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela2 + " WHERE codigo = " + cPesq + " Order By data DESC, hora DESC" ) 
				
				//MSGINFO("total : " + str(oQuery:LastRec()) )
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
               For i:= 1 To oQuery:LastRec()
               
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(1)) )  ,;
						DTOC( oRow:fieldGet(3) ) ,;
						Alltrim(oRow:fieldGet(10) ),;
						"Autoclave Sercon" ,;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(STR(oRow:fieldGet(12) )),;
						Alltrim(STR(oRow:fieldGet(14) )),;
						Alltrim(STR(oRow:fieldGet(16) )),;
						Alltrim(STR(oRow:fieldGet(18) )),;
						Alltrim(STR(oRow:fieldGet(20) )),;
						Alltrim(STR(oRow:fieldGet(22) )),;
						Alltrim(STR(oRow:fieldGet(25) )),;
						Alltrim(STR(oRow:fieldGet(24) )),;
						Alltrim(oRow:fieldGet(11) )} TO Grid_2 OF Form_Processo
                        oQuery:Skip(1)
				
						
               Next

oRow1 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Processo.Text_50.Value := Alltrim(oRow1:fieldGet(4) )  // operador
Form_Processo.Text_41.Value := Alltrim(oRow1:fieldGet(28) )  // inicio processo
Form_Processo.Text_48.Value := Alltrim(oRow1:fieldGet(5) )  //lote
Form_Processo.Text_49.Value := Alltrim(oRow1:fieldGet(7) )  // carga
Form_Processo.Text_46.Value := Alltrim(oRow1:fieldGet(6) )  // ciclo
Form_Processo.Text_40.Value := aDados_Processo_Maq2[1] // tag sequencial
Form_Processo.Text_44.Value := "" // cInicio_est // inicio esterilizacao
Form_Processo.Text_45.Value := "" // cFinal_est // final esterilizacao
 			   
			   
endif





	Return Nil
	
*************************************************************************************************************************************
Function Pesquisa_Maquina3()
*************************************************************************************************************************************
	Local cPesq	:= Alltrim(aDados_Processo_Maq3[1])
	Local i           					:= 0
	Local oRow     						:= {}
	Local oRow1     						:= {}
	Local oQuery      					:= "" 

IF IsWindowActive(Form_Processo)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_3 OF Form_Processo

				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela3 + " WHERE codigo = " + cPesq + " Order By data DESC, hora DESC" ) 
				
				//MSGINFO("total : " + str(oQuery:LastRec()) )
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
               For i:= 1 To oQuery:LastRec()
               
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(1)) )  ,;
						DTOC( oRow:fieldGet(3) ) ,;
						Alltrim(oRow:fieldGet(10) ),;
						"Estufa 28" ,;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(STR(oRow:fieldGet(12) )),;
						Alltrim(STR(oRow:fieldGet(14) )),;
						Alltrim(STR(oRow:fieldGet(16) )),;
						Alltrim(STR(oRow:fieldGet(18) )),;
						Alltrim(STR(oRow:fieldGet(20) )),;
						Alltrim(STR(oRow:fieldGet(22) )),;
						Alltrim(oRow:fieldGet(11) )} TO Grid_3 OF Form_Processo
                        oQuery:Skip(1)
				
						
               Next

oRow1 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Processo.Text_70.Value := Alltrim(oRow1:fieldGet(4) )  // operador
Form_Processo.Text_60.Value := Alltrim(oRow1:fieldGet(28) )  // inicio processo
Form_Processo.Text_68.Value := Alltrim(oRow1:fieldGet(5) )  //lote
Form_Processo.Text_69.Value := Alltrim(oRow1:fieldGet(7) )  // carga
Form_Processo.Text_66.Value := Alltrim(oRow1:fieldGet(6) )  // ciclo
Form_Processo.Text_59.Value := aDados_Processo_Maq3[1] // tag sequencial
Form_Processo.Text_64.Value := "" // cInicio_est // inicio esterilizacao
Form_Processo.Text_65.Value := "" // cFinal_est // final esterilizacao
 			   
			   
endif


*************************************************************************************************************************************
Function Pesquisa_Maquina4()
*************************************************************************************************************************************
	Local cPesq	:= Alltrim(aDados_Processo_Maq4[1])
	Local i           					:= 0
	Local oRow     						:= {}
	Local oRow1     						:= {}
	Local oQuery      					:= "" 

IF IsWindowActive(Form_Processo)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_4 OF Form_Processo

				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela4 + " WHERE codigo = " + cPesq + " Order By data DESC, hora DESC" ) 
				
				//MSGINFO("total : " + str(oQuery:LastRec()) )
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
               For i:= 1 To oQuery:LastRec()
               
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(1)) )  ,;
						DTOC( oRow:fieldGet(3) ) ,;
						Alltrim(oRow:fieldGet(10) ),;
						"Estufa 26" ,;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(STR(oRow:fieldGet(12) )),;
						Alltrim(STR(oRow:fieldGet(14) )),;
						Alltrim(STR(oRow:fieldGet(16) )),;
						Alltrim(STR(oRow:fieldGet(18) )),;
						Alltrim(STR(oRow:fieldGet(20) )),;
						Alltrim(STR(oRow:fieldGet(22) )),;
						Alltrim(oRow:fieldGet(11) )} TO Grid_4 OF Form_Processo
                        oQuery:Skip(1)
				
						
               Next

oRow1 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Processo.Text_90.Value := Alltrim(oRow1:fieldGet(4) )  // operador
Form_Processo.Text_80.Value := Alltrim(oRow1:fieldGet(28) )  // inicio processo
Form_Processo.Text_88.Value := Alltrim(oRow1:fieldGet(5) )  //lote
Form_Processo.Text_89.Value := Alltrim(oRow1:fieldGet(7) )  // carga
Form_Processo.Text_86.Value := Alltrim(oRow1:fieldGet(6) )  // ciclo
Form_Processo.Text_79.Value := aDados_Processo_Maq4[1] // tag sequencial
Form_Processo.Text_84.Value := "" // cInicio_est // inicio esterilizacao
Form_Processo.Text_85.Value := "" // cFinal_est // final esterilizacao
 			   
			   
endif


*************************************************************************************************************************************
Function Pesquisa_Maquina5()
*************************************************************************************************************************************
	Local cPesq	:= Alltrim(aDados_Processo_Maq5[1])
	Local i           					:= 0
	Local oRow     						:= {}
	Local oRow1     						:= {}
	Local oQuery      					:= "" 

IF IsWindowActive(Form_Processo)
	*** Exclui todos os registros do Grid
	DELETE ITEM ALL FROM Grid_5 OF Form_Processo

				*----- Monta Objeto Query com Selecão"+cData+" 
                oQuery := oServer:Query( "Select * From " + cTabela5 + " WHERE codigo = " + cPesq + " Order By data DESC, hora DESC" ) 
				
				//MSGINFO("total : " + str(oQuery:LastRec()) )
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select): " + oQuery:Error())
					Endif
//{"SEQ.","DATA","HORA","EQUIPAMENTO","CICLO","T1","T2","T3","T4","T5","T6","P. INT.","P. EXT.", SITUAÇÃO}
               For i:= 1 To oQuery:LastRec()
               
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(STR(oRow:fieldGet(1)) )  ,;
						DTOC( oRow:fieldGet(3) ) ,;
						Alltrim(oRow:fieldGet(10) ),;
						"Estufa 29" ,;
						Alltrim(oRow:fieldGet(6) ),;
						Alltrim(STR(oRow:fieldGet(12) )),;
						Alltrim(STR(oRow:fieldGet(14) )),;
						Alltrim(STR(oRow:fieldGet(16) )),;
						Alltrim(STR(oRow:fieldGet(18) )),;
						Alltrim(STR(oRow:fieldGet(20) )),;
						Alltrim(STR(oRow:fieldGet(22) )),;
						Alltrim(oRow:fieldGet(11) )} TO Grid_5 OF Form_Processo
                        oQuery:Skip(1)
				
						
               Next

oRow1 := oQuery:GetRow(1)  // pega os dados do PRIMEIRO registro
Form_Processo.Text_120.Value := Alltrim(oRow1:fieldGet(4) )  // operador
Form_Processo.Text_110.Value := Alltrim(oRow1:fieldGet(28) )  // inicio processo
Form_Processo.Text_118.Value := Alltrim(oRow1:fieldGet(5) )  //lote
Form_Processo.Text_119.Value := Alltrim(oRow1:fieldGet(7) )  // carga
Form_Processo.Text_116.Value := Alltrim(oRow1:fieldGet(6) )  // ciclo
Form_Processo.Text_109.Value := aDados_Processo_Maq5[1] // tag sequencial
Form_Processo.Text_114.Value := "" // cInicio_est // inicio esterilizacao
Form_Processo.Text_115.Value := "" // cFinal_est // final esterilizacao
 			   
			   
endif
	
	
