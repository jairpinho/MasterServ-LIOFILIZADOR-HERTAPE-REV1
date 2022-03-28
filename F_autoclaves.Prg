#include <hmg.ch>
#include "F_Sistema.ch"

DECLARE WINDOW Form_Processo
DECLARE WINDOW Form_Autoclave_1
*************************************************************************************************************************************************************
Function  Inicio_autoclave1()
*************************************************************************************************************************************************************

PRIVATE cCarga := ""
PRIVATE cSetor:= ""
PRIVATE cLote := ""

		aCiclos_AC := EncheArray_Generic( 1,"ciclos_autoclaves", .T.) 
		aTempo_secagem_AC := EncheArray_Generic( 1,"tempo_secagem_autoclaves", .T.) 
		aTempo_esterelizacao_AC := EncheArray_Generic( 1,"tempo_esterelizacao_autoclaves", .T.) 


		
IF !IsWindowDefined(Form_Autoclave_1)	
        Load Window Form_Autoclave_1
		Form_Autoclave_1.Text_11.SetFocus
        Form_Autoclave_1.Center
        Form_Autoclave_1.Activate
ENDIF

Return

*************************************************************************************************************************************************************
Procedure Partida_autoclave1()
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
                  PadL("Buffer:3000",50," "), "SISTEMA-AUTOCLAVE AUTO09")
		
		
		RETURN
	ENDIF
	
	IF lCom_status == .T.
			IF VAL(alltrim(aMaquina1[10])) == 8
				Form_Processo.Button_1.Enabled :=.T.
				Form_Processo.Button_2.Enabled :=.F.
				Form_Processo.Image_1.Picture := "CNX_OFF"
				estapas_processo_1 := .F.
				MSGINFO("CHAVE SOFTWARE AUTO09 NA IHM NA POSIÇÃO OFF (MUDA A CHAVE PARA ON ) ")
				RETURN
			ELSEIF VAL(alltrim(aMaquina1[10])) == 9
				Form_Processo.Button_1.Enabled :=.T.
				Form_Processo.Button_2.Enabled :=.F.
				Form_Processo.Image_1.Picture := "CNX_OFF"
				estapas_processo_1 := .F.
				MSGINFO("CHAVE MANUAL/AUTO AUTO09 NA POSIÇÃO MANUAL NO PAINEL (MUDA A CHAVE PARA AUTO ) ")
				RETURN
			ENDIF
	ENDIF
//Form_Processo.Button_1.Enabled :=.F.
//Form_Processo.Button_2.Enabled :=.T.
IF Usuario() 
IF VAL(alltrim(aMaquina1[10])) == 0
aDados_Processo_Maq1[1] := Alltrim(STR(GeraCodigo(cTabela1)))
aDados_Processo_Maq1[2] := Form_Autoclave_1.Edit_1.Value //materiais
aDados_Processo_Maq1[3] := time()
aDados_Processo_Maq1[4] := Form_Autoclave_1.Text_13.Value //lote
aDados_Processo_Maq1[5] := Form_Autoclave_1.Text_12.Value  // carga
aDados_Processo_Maq1[6] := PGeneric( 1 , "aux1" , "ciclos_autoclaves" , "descricao" , ' "'+ Alltrim(Form_Autoclave_1.Combo_1.DisplayValue) +'" ' ) // temperaruta de ciclo
aDados_Processo_Maq1[7] := db_apelido
aDados_Processo_Maq1[8] := "MAQUINA LIVRE"  // dados do processo
aDados_Processo_Maq1[9] := PGeneric( 1 , "aux1" , "tempo_secagem_autoclaves" , "descricao" , ' "'+ Alltrim(Form_Autoclave_1.Combo_2.DisplayValue) +'" ' ) // tempo de secagem
aDados_Processo_Maq1[10] := PGeneric( 1 , "aux1" , "tempo_esterelizacao_autoclaves" , "descricao" , ' "'+ Alltrim(Form_Autoclave_1.Combo_3.DisplayValue) +'" ' ) // tempo de esterilização
aDados_Processo_Maq1[11] := Alltrim(Form_Autoclave_1.Text_11.Value) //Setor
Form_Processo.Text_24.Value := db_apelido // operador
Form_Processo.Text_14.Value := aDados_Processo_Maq1[11]   // setor
Form_Processo.Text_16.Value := time()  // inicio processso
Form_Processo.Text_22.Value := Form_Autoclave_1.Text_13.Value  //lote
Form_Processo.Text_23.Value := Form_Autoclave_1.Text_12.Value  // carga
Form_Processo.Text_20.Value := aDados_Processo_Maq1[6]  // ciclo
Form_Processo.Text_21.Value := aDados_Processo_Maq1[10] // tempo estelizacao

Form_Processo.Text_15.Value := aDados_Processo_Maq1[1] // TAG SEQUENCIAL
aEnvia[2]:= aDados_Processo_Maq1[6]  // temperaruta de ciclo D5001
aEnvia[3]:= aDados_Processo_Maq1[9]  // tempo de secagem D5002
aEnvia[4]:= aDados_Processo_Maq1[10]  // tempo de esterilização D5003

	estapas_processo_1 := .T.



IF IsWindowDefined(Form_Autoclave_1)
	Form_Autoclave_1.Release
endif

aEnvia[1]:= "1"  // MANDA SINAL DE LIGAR PARA O CLP EM D5000
Grava_Dados_Mysql_Maq1(1)
//Form_Processo.Text_11.Value := alltrim(aMaquina1[9])

ENDIF
ENDIF

Return


*************************************************************************************************************************************************************
Procedure  Aborta_autoclave1()
*************************************************************************************************************************************************************

IF Usuario()

aDados_Processo_Maq1[8] := "ABORTADO"	
if estapas_processo_1 == .T.
	Grava_Dados_Mysql_Maq1(1)
endif
//aEnvia[1] := "0" 

	
lWindow := .F.
estapas_processo_1 := .F.
if estapas_processo_1 ==  .F.
	AFILL( aDados_Processo_Maq1, "0" ,2, 20)
	AFILL( aEtapa_Maq1, .F. ,1, 10)
	AFILL( aEnvia, "0" ,1 , 4) 
endif

			Form_Processo.Button_1.Enabled :=.T.
			Form_Processo.Button_2.Enabled :=.F.
			Form_Processo.Image_1.Picture := "CNX_OFF"
			
lWindow := .T.
endif

Return


///************************Autoclae 2***********************************************************************************//

*************************************************************************************************************************************************************
Function  Inicio_autoclave2()
*************************************************************************************************************************************************************
		aCiclos_AC := EncheArray_Generic( 1,"ciclos_autoclaves", .T.) 
		aTempo_secagem_AC := EncheArray_Generic( 1,"tempo_secagem_autoclaves", .T.) 
		aTempo_esterelizacao_AC := EncheArray_Generic( 1,"tempo_esterelizacao_autoclaves", .T.) 
		
IF !IsWindowDefined(Form_Autoclave_2)	
        Load Window Form_Autoclave_2
		Form_Autoclave_2.Text_11.SetFocus
        Form_Autoclave_2.Center
        Form_Autoclave_2.Activate
ENDIF

Return

*************************************************************************************************************************************************************
Procedure Partida_autoclave2()
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
                  PadL("Buffer:3000",50," "), "SISTEMA-AUTOCLAVE AUTO10")
		RETURN
	ENDIF
	
	IF lCom_status == .T.
			IF VAL(alltrim(aMaquina2[10])) == 8
				Form_Processo.Button_3.Enabled :=.T.
				Form_Processo.Button_4.Enabled :=.F.
				Form_Processo.Image_2.Picture := "CNX_OFF"
				estapas_processo_2 := .F.
				MSGINFO("CHAVE SOFTWARE AUTO10 NA IHM NA POSIÇÃO OFF (MUDA A CHAVE PARA ON ) ")
				RETURN
			ELSEIF VAL(alltrim(aMaquina2[10])) == 9
				Form_Processo.Button_3.Enabled :=.T.
				Form_Processo.Button_4.Enabled :=.F.
				Form_Processo.Image_2.Picture := "CNX_OFF"
				estapas_processo_2 := .F.
				MSGINFO("CHAVE MANUAL/AUTO10 NA POSIÇÃO MANUAL NO PAINEL (MUDA A CHAVE PARA AUTO ) ")
				RETURN
			ENDIF
	ENDIF
//Form_Processo.Button_1.Enabled :=.F.
//Form_Processo.Button_2.Enabled :=.T.
IF Usuario() 
IF VAL(alltrim(aMaquina2[10])) == 0

aDados_Processo_Maq2[1] := Alltrim(STR(GeraCodigo(cTabela2)))
aDados_Processo_Maq2[2] := Form_Autoclave_2.Edit_1.Value //materiais
aDados_Processo_Maq2[3] := time()
aDados_Processo_Maq2[4] := Form_Autoclave_2.Text_13.Value //lote
aDados_Processo_Maq2[5] := Form_Autoclave_2.Text_12.Value  // carga
aDados_Processo_Maq2[6] := PGeneric( 1 , "aux1" , "ciclos_autoclaves" , "descricao" , ' "'+ Alltrim(Form_Autoclave_2.Combo_1.DisplayValue) +'" ' ) // temperaruta de ciclo
aDados_Processo_Maq2[7] := db_apelido
aDados_Processo_Maq2[8] := "MAQUINA LIVRE"  // dados do processo
aDados_Processo_Maq2[9] := PGeneric( 1 , "aux1" , "tempo_secagem_autoclaves" , "descricao" , ' "'+ Alltrim(Form_Autoclave_2.Combo_2.DisplayValue) +'" ' ) // tempo de secagem
aDados_Processo_Maq2[10] := PGeneric( 1 , "aux1" , "tempo_esterelizacao_autoclaves" , "descricao" , ' "'+ Alltrim(Form_Autoclave_2.Combo_3.DisplayValue) +'" ' ) // tempo de esterilização
aDados_Processo_Maq2[11] := Alltrim(Form_Autoclave_2.Text_11.Value) //Setor
Form_Processo.Text_50.Value := db_apelido // operador
Form_Processo.Text_39.Value := aDados_Processo_Maq2[11]   // setor
Form_Processo.Text_41.Value := time()  // inicio processso
Form_Processo.Text_48.Value := Form_Autoclave_2.Text_13.Value  //lote
Form_Processo.Text_49.Value := Form_Autoclave_2.Text_12.Value  // carga
Form_Processo.Text_46.Value := aDados_Processo_Maq2[6]  // ciclo
Form_Processo.Text_47.Value := aDados_Processo_Maq2[10] // tempo estelizacao




Form_Processo.Text_40.Value := aDados_Processo_Maq2[1] // TAG SEQUENCIAL
aEnvia[6]:= aDados_Processo_Maq2[6]  // temperaruta de ciclo D5005
aEnvia[7]:= aDados_Processo_Maq2[9]  // tempo de secagem D5006
aEnvia[8]:= aDados_Processo_Maq2[10]  // tempo de esterilização D5007

	estapas_processo_2 := .T.



IF IsWindowDefined(Form_Autoclave_2)
	Form_Autoclave_2.Release
endif

aEnvia[5]:= "1"  // MANDA SINAL DE LIGAR PARA O CLP EM D5004
Grava_Dados_Mysql_Maq2(1)
//Form_Processo.Text_11.Value := alltrim(aMaquina1[9])

ENDIF
endif

Return




*************************************************************************************************************************************************************
Function  Aborta_autoclave2()
*************************************************************************************************************************************************************
IF Usuario() 

aDados_Processo_Maq2[8] := "ABORTADO"	
if estapas_processo_2 == .T.
	Grava_Dados_Mysql_Maq2(1)
endif
//aEnvia[5] := "0" 
	AFILL( aEnvia, "0" , 5 , 4)
	
lWindow := .F.
estapas_processo_2 := .F.
if estapas_processo_2 ==  .F.
	AFILL( aDados_Processo_Maq2, "0" ,2, 20)
	AFILL( aEtapa_Maq2, .F. ,1, 10)
endif


			Form_Processo.Button_3.Enabled :=.T.
			Form_Processo.Button_4.Enabled :=.F.
			Form_Processo.Image_2.Picture := "CNX_OFF"
			
lWindow := .T.
endif

Return




************************************************************************************************************************************
Function Cria_Tabela_Autoclave_1()				
************************************************************************************************************************************
		Local cTabela				:= "dados_autoclave1"
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
Function Cria_Tabela_Autoclave_2()				
************************************************************************************************************************************
		Local cTabela				:= "dados_autoclave2"
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





