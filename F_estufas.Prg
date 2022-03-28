#include <hmg.ch>
#include "F_Sistema.ch"
DECLARE WINDOW Form_Processo
DECLARE WINDOW Form_Estufa_26
DECLARE WINDOW Form_Estufa_28
DECLARE WINDOW Form_Estufa_29


*************************************************************************************************************************************************************
Function  Inicio_Estufa28()
*************************************************************************************************************************************************************

aCiclos_ES := EncheArray_Generic( 1,"ciclos_estufas", .T.) 
aTempo_esterelizacao_ES := EncheArray_Generic( 1,"tempo_esterelizacao_es", .T.) 
	
IF !IsWindowDefined(Form_Estufa_28)	
        Load Window Form_Estufa_28
		Form_Estufa_28.Text_11.SetFocus
        Form_Estufa_28.Center
        Form_Estufa_28.Activate
ENDIF

Return

*************************************************************************************************************************************************************
Procedure Partida_Estufa_28()
*************************************************************************************************************************************************************


	IF lCom_status == .F.
		//MSGINFO("SISTEMA NãO CONECAdO COM O CLP ( MENU CONFIGURAÇÃO/CONEXÃO/CONECTAR) ")
		         MsgINFO (PadC(" ATENÇÃO ",50,"*") +QUEBRA+;
                  PadC("SISTEMA NãO CONECTAdO COM O CLP",50," ")+QUEBRA+;
                  PadC("MENU CONFIGURAÇÃO/CONEXÃO/CONECTAR",50," ")+QUEBRA+;
                  PadL("PORTA COM:COM3",50," ")+QUEBRA+;
                  PadL("BaudRate:115200",50," ")+QUEBRA+;
                  PadL("DataBits:8",50," ")+QUEBRA+;
                  PadL("Paridade:1",50," ")+QUEBRA+;
                  PadL("StopBits:0",50," ")+QUEBRA+;
                  PadL("Buffer:3000",50," "), "SISTEMA-ESTUFA 29")
		RETURN
	ENDIF
	
	IF lCom_status == .T.
			IF VAL(alltrim(aMaquina3[10])) == 8
				Form_Processo.Button_5.Enabled :=.T.
				Form_Processo.Button_6.Enabled :=.F.
				Form_Processo.Image_3.Picture := "CNX_OFF"
				estapas_processo_3 := .F.
				MSGINFO("CHAVE SOFTWARE ESTUFA 28 NA IHM NA POSIÇÃO OFF (MUDA A CHAVE PARA ON ) ")
				RETURN
			ELSEIF VAL(alltrim(aMaquina3[10])) == 9
				Form_Processo.Button_5.Enabled :=.T.
				Form_Processo.Button_6.Enabled :=.F.
				Form_Processo.Image_3.Picture := "CNX_OFF"
				estapas_processo_3 := .F.
				MSGINFO("CHAVE MANUAL/AUTO ESTUFA 28 NA POSIÇÃO MANUAL NO PAINEL (MUDA A CHAVE PARA AUTO ) ")
				RETURN
			ENDIF
	ENDIF
//Form_Processo.Button_1.Enabled :=.F.
//Form_Processo.Button_2.Enabled :=.T.
IF Usuario() 
IF VAL(alltrim(aMaquina3[10])) == 0

aDados_Processo_Maq3[1] := Alltrim(STR(GeraCodigo(cTabela3)))
aDados_Processo_Maq3[2] := Form_Estufa_28.Edit_1.Value //materiais
aDados_Processo_Maq3[3] := time()
aDados_Processo_Maq3[4] := Form_Estufa_28.Text_13.Value //lote
aDados_Processo_Maq3[5] := Form_Estufa_28.Text_12.Value  // carga
aDados_Processo_Maq3[6] := PGeneric( 1 , "aux1" , "ciclos_estufas" , "descricao" , ' "'+ Alltrim(Form_Estufa_28.Combo_1.DisplayValue) +'" ' ) // temperaruta de ciclo
aDados_Processo_Maq3[7] := db_apelido
aDados_Processo_Maq3[8] := "MAQUINA LIVRE"  // dados do processo
aDados_Processo_Maq3[9] := "" // PGeneric( 1 , "aux1" , "tempo_secagem_estufas" , "descricao" , ' "'+ Alltrim(Form_Estufa_29.Combo_2.DisplayValue) +'" ' ) // tempo de secagem
aDados_Processo_Maq3[10] := PGeneric( 1 , "aux1" , "tempo_esterelizacao_es" , "descricao" , ' "'+ Alltrim(Form_Estufa_28.Combo_3.DisplayValue) +'" ' ) // tempo de esterilização
aDados_Processo_Maq3[11] := Alltrim(Form_Estufa_28.Text_11.Value) //Setor
Form_Processo.Text_70.Value := db_apelido // operador
Form_Processo.Text_58.Value := aDados_Processo_Maq3[11]   // setor
Form_Processo.Text_60.Value := time()  // inicio processso
Form_Processo.Text_68.Value := Form_Estufa_28.Text_13.Value  //lote
Form_Processo.Text_69.Value := Form_Estufa_28.Text_12.Value  // carga
Form_Processo.Text_66.Value := aDados_Processo_Maq3[6]  // ciclo
Form_Processo.Text_67.Value := aDados_Processo_Maq3[10] // tempo estelizacao




Form_Processo.Text_59.Value := aDados_Processo_Maq3[1] // TAG SEQUENCIAL
aEnvia[10]:= aDados_Processo_Maq3[6]  // temperaruta de ciclo D5005
aEnvia[11]:= aDados_Processo_Maq3[9]  // tempo de secagem D5006
aEnvia[12]:= aDados_Processo_Maq3[10]  // tempo de esterilização D5007

	estapas_processo_3 := .T.



IF IsWindowDefined(Form_Estufa_28)
	Form_Estufa_28.Release
endif

aEnvia[9]:= "1"  // MANDA SINAL DE LIGAR PARA O CLP EM D5004
Grava_Dados_Mysql_Maq3(1)
//Form_Processo.Text_11.Value := alltrim(aMaquina1[9])

ENDIF
endif

Return




*************************************************************************************************************************************************************
Function  Aborta_Estufa_28()
*************************************************************************************************************************************************************
IF Usuario() 

aDados_Processo_Maq3[8] := "ABORTADO"	
if estapas_processo_3 == .T.
	Grava_Dados_Mysql_Maq3(1)
endif
//aEnvia[5] := "0" 
	
lWindow := .F.
estapas_processo_3 := .F.
if estapas_processo_3 ==  .F.
	AFILL( aDados_Processo_Maq3, "0" ,2, 20)
	AFILL( aEtapa_Maq3, .F. ,1, 10)
	AFILL( aEnvia, "0" , 9 , 4)

endif
			Form_Processo.Button_5.Enabled :=.T.
			Form_Processo.Button_6.Enabled :=.F.
			Form_Processo.Image_3.Picture := "CNX_OFF"
			
lWindow := .T.
endif

Return



*************************************************************************************************************************************************************
Function  Inicio_Estufa26()
*************************************************************************************************************************************************************

aCiclos_ES := EncheArray_Generic( 1,"ciclos_estufas", .T.) 
aTempo_esterelizacao_ES := EncheArray_Generic( 1,"tempo_esterelizacao_es", .T.) 

IF !IsWindowDefined(Form_Estufa_26)	
        Load Window Form_Estufa_26
		Form_Estufa_26.Text_11.SetFocus
        Form_Estufa_26.Center
        Form_Estufa_26.Activate
ENDIF

Return


*************************************************************************************************************************************************************
Procedure Partida_Estufa_26()
*************************************************************************************************************************************************************


	IF lCom_status == .F.
		//MSGINFO("SISTEMA NãO CONECAdO COM O CLP ( MENU CONFIGURAÇÃO/CONEXÃO/CONECTAR) ")
		         MsgINFO (PadC(" ATENÇÃO ",50,"*") +QUEBRA+;
                  PadC("SISTEMA NãO CONECTAdO COM O CLP",50," ")+QUEBRA+;
                  PadC("MENU CONFIGURAÇÃO/CONEXÃO/CONECTAR",50," ")+QUEBRA+;
                  PadL("PORTA COM:COM3",50," ")+QUEBRA+;
                  PadL("BaudRate:115200",50," ")+QUEBRA+;
                  PadL("DataBits:8",50," ")+QUEBRA+;
                  PadL("Paridade:1",50," ")+QUEBRA+;
                  PadL("StopBits:0",50," ")+QUEBRA+;
                  PadL("Buffer:3000",50," "), "SISTEMA-ESTUFA 26")
		RETURN
	ENDIF
	
	IF lCom_status == .T.
			IF VAL(alltrim(aMaquina4[10])) == 8
				Form_Processo.Button_7.Enabled :=.T.
				Form_Processo.Button_8.Enabled :=.F.
				Form_Processo.Image_4.Picture := "CNX_OFF"
				estapas_processo_4 := .F.
				MSGINFO("CHAVE SOFTWARE ESTUFA 26 NA IHM NA POSIÇÃO OFF (MUDA A CHAVE PARA ON ) ")
				RETURN
			ELSEIF VAL(alltrim(aMaquina4[10])) == 9
				Form_Processo.Button_7.Enabled :=.T.
				Form_Processo.Button_8.Enabled :=.F.
				Form_Processo.Image_4.Picture := "CNX_OFF"
				estapas_processo_4 := .F.
				MSGINFO("CHAVE MANUAL/AUTO ESTUFA 26 NA POSIÇÃO MANUAL NO PAINEL (MUDA A CHAVE PARA AUTO ) ")
				RETURN
			ENDIF
	ENDIF
//Form_Processo.Button_1.Enabled :=.F.
//Form_Processo.Button_2.Enabled :=.T.
IF Usuario() 
IF VAL(alltrim(aMaquina4[10])) == 0

aDados_Processo_Maq4[1] := Alltrim(STR(GeraCodigo(cTabela4)))
aDados_Processo_Maq4[2] := Form_Estufa_26.Edit_1.Value //materiais
aDados_Processo_Maq4[3] := time()
aDados_Processo_Maq4[4] := Form_Estufa_26.Text_13.Value //lote
aDados_Processo_Maq4[5] := Form_Estufa_26.Text_12.Value  // carga
aDados_Processo_Maq4[6] := PGeneric( 1 , "aux1" , "ciclos_estufas" , "descricao" , ' "'+ Alltrim(Form_Estufa_26.Combo_1.DisplayValue) +'" ' ) // temperaruta de ciclo
aDados_Processo_Maq4[7] := db_apelido
aDados_Processo_Maq4[8] := "MAQUINA LIVRE"  // dados do processo
aDados_Processo_Maq4[9] := "" // PGeneric( 1 , "aux1" , "tempo_secagem_estufas" , "descricao" , ' "'+ Alltrim(Form_Estufa_29.Combo_2.DisplayValue) +'" ' ) // tempo de secagem
aDados_Processo_Maq4[10] := PGeneric( 1 , "aux1" , "tempo_esterelizacao_es" , "descricao" , ' "'+ Alltrim(Form_Estufa_26.Combo_3.DisplayValue) +'" ' ) // tempo de esterilização
aDados_Processo_Maq4[11] := Alltrim(Form_Estufa_26.Text_11.Value) //Setor
Form_Processo.Text_90.Value := db_apelido // operador
Form_Processo.Text_78.Value := aDados_Processo_Maq4[11]   // setor
Form_Processo.Text_80.Value := time()  // inicio processso
Form_Processo.Text_88.Value := Form_Estufa_26.Text_13.Value  //lote
Form_Processo.Text_89.Value := Form_Estufa_26.Text_12.Value  // carga
Form_Processo.Text_86.Value := aDados_Processo_Maq4[6]  // ciclo
Form_Processo.Text_87.Value := aDados_Processo_Maq4[10] // tempo estelizacao



Form_Processo.Text_79.Value := aDados_Processo_Maq4[1] // TAG SEQUENCIAL
aEnvia[14]:= aDados_Processo_Maq4[6]  // temperaruta de ciclo D5005
aEnvia[15]:= aDados_Processo_Maq4[9]  // tempo de secagem D5006
aEnvia[16]:= aDados_Processo_Maq4[10]  // tempo de esterilização D5007

	estapas_processo_4 := .T.



IF IsWindowDefined(Form_Estufa_26)
	Form_Estufa_26.Release
endif

aEnvia[13]:= "1"  // MANDA SINAL DE LIGAR PARA O CLP EM D5004
Grava_Dados_Mysql_Maq4(1)
//Form_Processo.Text_11.Value := alltrim(aMaquina1[9])

ENDIF
endif

Return




*************************************************************************************************************************************************************
Function  Aborta_Estufa_26()
*************************************************************************************************************************************************************
IF Usuario() 

aDados_Processo_Maq4[8] := "ABORTADO"	
if estapas_processo_4 == .T.
	Grava_Dados_Mysql_Maq4(1)
endif
//aEnvia[5] := "0" 
	
lWindow := .F.
estapas_processo_4 := .F.
if estapas_processo_4 ==  .F.
	AFILL( aDados_Processo_Maq4, "0" ,2, 20)  // APARTIR DO ARQUIVO 2 DA ARRAY PARA NAO APAGAR O CODIGO ATUAL NO FINAL DE CICLO FAZER A PESQUISA
	AFILL( aEtapa_Maq4, .F. ,1, 10)
	AFILL( aEnvia, "0" , 13 , 4)

endif


			Form_Processo.Button_7.Enabled :=.T.
			Form_Processo.Button_8.Enabled :=.F.
			Form_Processo.Image_4.Picture := "CNX_OFF"
			
lWindow := .T.
endif



Return

*************************************************************************************************************************************************************
Function  Inicio_Estufa29()
*************************************************************************************************************************************************************

aCiclos_ES := EncheArray_Generic( 1,"ciclos_estufas", .T.) 
aTempo_esterelizacao_ES := EncheArray_Generic( 1,"tempo_esterelizacao_es", .T.) 


IF !IsWindowDefined(Form_Estufa_29)	
        Load Window Form_Estufa_29
		Form_Estufa_29.Text_11.SetFocus
        Form_Estufa_29.Center
        Form_Estufa_29.Activate
ENDIF

Return

*************************************************************************************************************************************************************
Procedure Partida_Estufa_29()
*************************************************************************************************************************************************************


	IF lCom_status == .F.
		//MSGINFO("SISTEMA NãO CONECAdO COM O CLP ( MENU CONFIGURAÇÃO/CONEXÃO/CONECTAR) ")
		         MsgINFO (PadC(" ATENÇÃO ",50,"*") +QUEBRA+;
                  PadC("SISTEMA NãO CONECTAdO COM O CLP",50," ")+QUEBRA+;
                  PadC("MENU CONFIGURAÇÃO/CONEXÃO/CONECTAR",50," ")+QUEBRA+;
                  PadL("PORTA COM:COM3",50," ")+QUEBRA+;
                  PadL("BaudRate:115200",50," ")+QUEBRA+;
                  PadL("DataBits:8",50," ")+QUEBRA+;
                  PadL("Paridade:1",50," ")+QUEBRA+;
                  PadL("StopBits:0",50," ")+QUEBRA+;
                  PadL("Buffer:3000",50," "), "SISTEMA-ESTUFA 28")
		RETURN
	ENDIF
	
	IF lCom_status == .T.
			IF VAL(alltrim(aMaquina5[10])) == 8
				Form_Processo.Button_9.Enabled :=.T.
				Form_Processo.Button_10.Enabled :=.F.
				Form_Processo.Image_5.Picture := "CNX_OFF"
				estapas_processo_5 := .F.
				MSGINFO("CHAVE SOFTWARE ESTUFA 29 NA IHM NA POSIÇÃO OFF (MUDA A CHAVE PARA ON ) ")
				RETURN
			ELSEIF VAL(alltrim(aMaquina5[10])) == 9
				Form_Processo.Button_9.Enabled :=.T.
				Form_Processo.Button_10.Enabled :=.F.
				Form_Processo.Image_5.Picture := "CNX_OFF"
				estapas_processo_5 := .F.
				MSGINFO("CHAVE MANUAL/AUTO ESTUFA 29 NA POSIÇÃO MANUAL NO PAINEL (MUDA A CHAVE PARA AUTO ) ")
				RETURN
			ENDIF
	ENDIF
//Form_Processo.Button_1.Enabled :=.F.
//Form_Processo.Button_2.Enabled :=.T.
IF Usuario() 
IF VAL(alltrim(aMaquina5[10])) == 0

aDados_Processo_Maq5[1] := Alltrim(STR(GeraCodigo(cTabela5)))
aDados_Processo_Maq5[2] := Form_Estufa_29.Edit_1.Value //materiais
aDados_Processo_Maq5[3] := time()
aDados_Processo_Maq5[4] := Form_Estufa_29.Text_13.Value //lote
aDados_Processo_Maq5[5] := Form_Estufa_29.Text_12.Value  // carga
aDados_Processo_Maq5[6] := PGeneric( 1 , "aux1" , "ciclos_estufas" , "descricao" , ' "'+ Alltrim(Form_Estufa_29.Combo_1.DisplayValue) +'" ' ) // temperaruta de ciclo
aDados_Processo_Maq5[7] := db_apelido
aDados_Processo_Maq5[8] := "MAQUINA LIVRE"  // dados do processo
aDados_Processo_Maq5[9] := "" // PGeneric( 1 , "aux1" , "tempo_secagem_estufas" , "descricao" , ' "'+ Alltrim(Form_Estufa_29.Combo_2.DisplayValue) +'" ' ) // tempo de secagem
aDados_Processo_Maq5[10] := PGeneric( 1 , "aux1" , "tempo_esterelizacao_es" , "descricao" , ' "'+ Alltrim(Form_Estufa_29.Combo_3.DisplayValue) +'" ' ) // tempo de esterilização
aDados_Processo_Maq5[11] := Alltrim(Form_Estufa_29.Text_11.Value) //Setor
Form_Processo.Text_120.Value := db_apelido // operador
Form_Processo.Text_108.Value := aDados_Processo_Maq5[11]   // setor
Form_Processo.Text_110.Value := time()  // inicio processso
Form_Processo.Text_118.Value := Form_Estufa_29.Text_13.Value  //lote
Form_Processo.Text_119.Value := Form_Estufa_29.Text_12.Value  // carga
Form_Processo.Text_116.Value := aDados_Processo_Maq5[6]  // ciclo
Form_Processo.Text_117.Value := aDados_Processo_Maq5[10] // tempo estelizacao



Form_Processo.Text_109.Value := aDados_Processo_Maq5[1] // TAG SEQUENCIAL
aEnvia[18]:= aDados_Processo_Maq5[6]  // temperaruta de ciclo D5005
aEnvia[19]:= aDados_Processo_Maq5[9]  // tempo de secagem D5006
aEnvia[20]:= aDados_Processo_Maq5[10]  // tempo de esterilização D5007

	estapas_processo_5 := .T.



IF IsWindowDefined(Form_Estufa_29)
	Form_Estufa_29.Release
endif

aEnvia[17]:= "1"  // MANDA SINAL DE LIGAR PARA O CLP EM D5004
Grava_Dados_Mysql_Maq5(1)
//Form_Processo.Text_11.Value := alltrim(aMaquina1[9])

ENDIF
endif

Return




*************************************************************************************************************************************************************
Function  Aborta_Estufa_29()
*************************************************************************************************************************************************************
IF Usuario() 

aDados_Processo_Maq5[8] := "ABORTADO"	
if estapas_processo_5 == .T.
	Grava_Dados_Mysql_Maq5(1)
endif
//aEnvia[5] := "0" 
	
lWindow := .F.
estapas_processo_5 := .F.
if estapas_processo_5 ==  .F.
	AFILL( aDados_Processo_Maq5, "0" ,2, 20)
	AFILL( aEtapa_Maq5, .F. ,1, 10)
	AFILL( aEnvia, "0" , 17 , 4)
endif


			Form_Processo.Button_9.Enabled :=.T.
			Form_Processo.Button_10.Enabled :=.F.
			Form_Processo.Image_5.Picture := "CNX_OFF"
			
lWindow := .T.
endif

Return


************************************************************************************************************************************
Function Cria_Tabela_estufa_1()				
************************************************************************************************************************************
		Local cTabela				:= "dados_estufa1"
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
                  If AScan( aTabelasExistentes, Lower(cTabela) ) != 0
                     //MsgINFO( "Tabela "+cTabela+" Já Existe!!")
                     Return Nil
                  EndIf 
	
			aStruc := array(30)	
			aStruc[1]  := { 'codigo'			    , 'N' , 05 , 0 } 
			aStruc[2]  := { 'setor'				, 'C' , 200 , 0 } 
			aStruc[3]  := { 'data'				, 'D' , 08 , 0 } 
			aStruc[4]  := { 'operador'		    , 'C' , 200 , 0 } 
			aStruc[5]  := { 'lote'		    	, 'C' , 100 , 0 } 
			aStruc[6]  := { 'setpoint'		    , 'C' , 10 , 0 } 
			aStruc[7]  := { 'carga'			    , 'C' , 20 , 0 } 
			aStruc[8]  := { 'tempo_esterili'	    , 'C' , 10 , 0 } 
			aStruc[9]  := { 'temp_variacao'		, 'C' , 10 , 0 } 
			aStruc[10]  := { 'hora'				, 'C' , 08 , 0 } 
			aStruc[11]  := { 'Situacao'			, 'C' , 100 , 0 } 
			aStruc[12]  := { 't1'					, 'N' , 5 , 2 } 			
			aStruc[13]  := { 'f0_1'				, 'N' , 5 , 2 } 			
			aStruc[14]  := { 't2'					, 'N' , 5 , 2 } 			
			aStruc[15]  := { 'f0_2'				, 'N' , 5 , 2 } 			
			aStruc[16]  := { 't3'					, 'N' , 5 , 2 } 			
			aStruc[17]  := { 'f0_3'				, 'N' , 5 , 2 } 			
			aStruc[18]  := { 't4'					, 'N' , 5 , 2 } 			
			aStruc[19]  := { 'f0_4'				, 'N' , 5 , 2 } 			
			aStruc[20]  := { 't5'					, 'N' , 5 , 2 } 			
			aStruc[21]  := { 'f0_5'				, 'N' , 5 , 2 } 			
			aStruc[22]  := { 't6'					, 'N' , 5 , 2 } 			
			aStruc[23]  := { 'f0_6'				, 'N' , 5 , 2 } 			
			aStruc[24]  := { 'pressao_ext'		, 'N' , 5 , 2 } 			
			aStruc[25]  := { 'pressao_interna'	, 'N' , 5 , 2 } 		
			aStruc[26]  := { 'materiais'				, 'M' , 50 , 0 } 			
			aStruc[27]  := { 'etapa_processo'	, 'C' , 10 , 0 } 		
			aStruc[28]  := { 'inicio_processo'	, 'C' , 10 , 0 } 				
			aStruc[29]  := { 'inicio_esteril'	, 'C' , 10 , 0 } 				
			aStruc[30]  := { 'fim_esteril'		, 'C' , 10 , 0 } 				

					

               *----- Cria a Tabela
                 oServer:CreateTable(cTabela, aStruc ,cPrimaryKey,cUniqueKey,cAuto) 										
              
              *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     MsGInfo("Erro Criando Tabela "+cTabela+" / <TMySQLServer> Cria_Tabela_OS_eletrica() " + oServer:Error(),"SISTEMA" )
                     Release Window ALL		
                    Quit
                  Endif 

                  MsgInfo("Tabela [ "+cTabela+" ] Criada com Sucesso!!" )   	    
                  
Return


************************************************************************************************************************************
Function Cria_Tabela_estufa_2()				
************************************************************************************************************************************
		Local cTabela				:= "dados_estufa2"
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
                  If AScan( aTabelasExistentes, Lower(cTabela) ) != 0
                     //MsgINFO( "Tabela "+cTabela+" Já Existe!!")
                     Return Nil
                  EndIf 
	
			aStruc := array(30)	
			aStruc[1]  := { 'codigo'			    , 'N' , 05 , 0 } 
			aStruc[2]  := { 'setor'				, 'C' , 200 , 0 } 
			aStruc[3]  := { 'data'				, 'D' , 08 , 0 } 
			aStruc[4]  := { 'operador'		    , 'C' , 200 , 0 } 
			aStruc[5]  := { 'lote'		    	, 'C' , 100 , 0 } 
			aStruc[6]  := { 'setpoint'		    , 'C' , 10 , 0 } 
			aStruc[7]  := { 'carga'			    , 'C' , 20 , 0 } 
			aStruc[8]  := { 'tempo_esterili'	    , 'C' , 10 , 0 } 
			aStruc[9]  := { 'temp_variacao'		, 'C' , 10 , 0 } 
			aStruc[10]  := { 'hora'				, 'C' , 08 , 0 } 
			aStruc[11]  := { 'Situacao'			, 'C' , 100 , 0 } 
			aStruc[12]  := { 't1'					, 'N' , 5 , 2 } 			
			aStruc[13]  := { 'f0_1'				, 'N' , 5 , 2 } 			
			aStruc[14]  := { 't2'					, 'N' , 5 , 2 } 			
			aStruc[15]  := { 'f0_2'				, 'N' , 5 , 2 } 			
			aStruc[16]  := { 't3'					, 'N' , 5 , 2 } 			
			aStruc[17]  := { 'f0_3'				, 'N' , 5 , 2 } 			
			aStruc[18]  := { 't4'					, 'N' , 5 , 2 } 			
			aStruc[19]  := { 'f0_4'				, 'N' , 5 , 2 } 			
			aStruc[20]  := { 't5'					, 'N' , 5 , 2 } 			
			aStruc[21]  := { 'f0_5'				, 'N' , 5 , 2 } 			
			aStruc[22]  := { 't6'					, 'N' , 5 , 2 } 			
			aStruc[23]  := { 'f0_6'				, 'N' , 5 , 2 } 			
			aStruc[24]  := { 'pressao_ext'		, 'N' , 5 , 2 } 			
			aStruc[25]  := { 'pressao_interna'	, 'N' , 5 , 2 } 		
			aStruc[26]  := { 'materiais'				, 'M' , 50 , 0 } 			
			aStruc[27]  := { 'etapa_processo'	, 'C' , 10 , 0 } 			
			aStruc[28]  := { 'inicio_processo'	, 'C' , 10 , 0 } 				
			aStruc[29]  := { 'inicio_esteril'	, 'C' , 10 , 0 } 				
			aStruc[30]  := { 'fim_esteril'		, 'C' , 10 , 0 } 				

					

               *----- Cria a Tabela
                 oServer:CreateTable(cTabela, aStruc ,cPrimaryKey,cUniqueKey,cAuto) 										
              
              *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     MsGInfo("Erro Criando Tabela "+cTabela+" / <TMySQLServer> Cria_Tabela_OS_eletrica() " + oServer:Error(),"SISTEMA" )
                     //elease Window ALL		
                    Quit
                  Endif 

                  MsgInfo("Tabela [ "+cTabela+" ] Criada com Sucesso!!" )   	    
                  
Return


************************************************************************************************************************************
Function Cria_Tabela_estufa_3()				
************************************************************************************************************************************
		Local cTabela				:= "dados_estufa3"
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
                     //Release Window ALL
                    Quit
                  Endif 
				
              *----- Verifica se na Array aTabelasExistentes tem a Tabela
                  If AScan( aTabelasExistentes, Lower(cTabela) ) != 0
                     //MsgINFO( "Tabela "+cTabela+" Já Existe!!")
                     Return Nil
                  EndIf 
	
			aStruc := array(30)	
			aStruc[1]  := { 'codigo'			    , 'N' , 05 , 0 } 
			aStruc[2]  := { 'setor'				, 'C' , 200 , 0 } 
			aStruc[3]  := { 'data'				, 'D' , 08 , 0 } 
			aStruc[4]  := { 'operador'		    , 'C' , 200 , 0 } 
			aStruc[5]  := { 'lote'		    	, 'C' , 100 , 0 } 
			aStruc[6]  := { 'setpoint'		    , 'C' , 10 , 0 } 
			aStruc[7]  := { 'carga'			    , 'C' , 20 , 0 } 
			aStruc[8]  := { 'tempo_esterili'	    , 'C' , 10 , 0 } 
			aStruc[9]  := { 'temp_variacao'		, 'C' , 10 , 0 } 
			aStruc[10]  := { 'hora'				, 'C' , 08 , 0 } 
			aStruc[11]  := { 'Situacao'			, 'C' , 100 , 0 } 
			aStruc[12]  := { 't1'					, 'N' , 5 , 2 } 			
			aStruc[13]  := { 'f0_1'				, 'N' , 5 , 2 } 			
			aStruc[14]  := { 't2'					, 'N' , 5 , 2 } 			
			aStruc[15]  := { 'f0_2'				, 'N' , 5 , 2 } 			
			aStruc[16]  := { 't3'					, 'N' , 5 , 2 } 			
			aStruc[17]  := { 'f0_3'				, 'N' , 5 , 2 } 			
			aStruc[18]  := { 't4'					, 'N' , 5 , 2 } 			
			aStruc[19]  := { 'f0_4'				, 'N' , 5 , 2 } 			
			aStruc[20]  := { 't5'					, 'N' , 5 , 2 } 			
			aStruc[21]  := { 'f0_5'				, 'N' , 5 , 2 } 			
			aStruc[22]  := { 't6'					, 'N' , 5 , 2 } 			
			aStruc[23]  := { 'f0_6'				, 'N' , 5 , 2 } 			
			aStruc[24]  := { 'pressao_ext'		, 'N' , 5 , 2 } 			
			aStruc[25]  := { 'pressao_interna'	, 'N' , 5 , 2 } 			
			aStruc[26]  := { 'obs'				, 'M' , 50 , 0 } 			
			aStruc[27]  := { 'etapa_processo'	, 'C' , 10 , 0 } 			
			aStruc[28]  := { 'inicio_processo'	, 'C' , 10 , 0 } 				
			aStruc[29]  := { 'inicio_esteril'	, 'C' , 10 , 0 } 				
			aStruc[30]  := { 'fim_esteril'		, 'C' , 10 , 0 } 				

					

               *----- Cria a Tabela
                 oServer:CreateTable(cTabela, aStruc ,cPrimaryKey,cUniqueKey,cAuto) 										
              
              *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     MsGInfo("Erro Criando Tabela "+cTabela+" / <TMySQLServer> Cria_Tabela_OS_eletrica() " + oServer:Error(),"SISTEMA" )
                     //Release Window ALL		
                    Quit
                  Endif 

                  MsgInfo("Tabela [ "+cTabela+" ] Criada com Sucesso!!" )   	    
                  
Return
