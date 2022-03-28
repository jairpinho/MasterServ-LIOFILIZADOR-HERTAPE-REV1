#include "Inkey.ch"
#include "minigui.ch"
#Include "F_sistema.ch"

DECLARE WINDOW Form_OS
DECLARE WINDOW Form_Main
DECLARE WINDOW Form_Conexao
REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_UTF8

************************************************************************************************************************************
Function Operacoes()
************************************************************************************************************************************
        Private cServidor        := cHostName 
        Private cUsuario         := cUser 
        Private cSenha          := cPassWord                             
        Private BaseDeDados     := cDatabase
              

    
If oServer != Nil              
				*----- Conecta com o Banco de Dados CADASTROS
		Conecta_Banco_De_Dados( cDatabase )		    
				*----- Cria Tabela de NOMES na Base de Dados CADASTROS
	
       // GenericOpen( cDatabase , "manutentores" )

   
        //Cria_Tabela_Produtos()



  IF  lConnected == .T. 
      
      IF IsWindowDefined(Form_Main)



		Cria_Tabela_Config()
		Cria_Tabela_Config_Relatorios()
        //Pesquisa_Lonas_Master()
      ENDIF				

ENDIF

    Return Nil
Endif							  

Return(Nil)


************************************************************************************************************************************
Procedure Abre_conexao_MySql(nTipo)                            
************************************************************************************************************************************				
IF cPort == "0"
	cPort := "3306"
ENDIF
Fechar_Conexao_MySql()

              *----- Abre Conexao com MySql  
                 oServer := TMySQLServer():New(cHostName, cUser, cPassWord,cPort )
			
              
			  *----- Verifica se ocorreu algum erro na Conexão
              If oServer:NetErr() 
                MsgINFO (PadC("*** Erro de Conexão com Servidor ***",80)+QUEBRA+;
                    PadC(" Verifique Informações do Servidor",80)+QUEBRA+;
                    PadC(" ",30)+QUEBRA+;
                    PadC("Host",60)+QUEBRA+;
                    PadC("Usuário",60)+QUEBRA+;
                    PadC("Senha",60), SISTEMA)                 
                    oServer  := Nil
                    Return
                    
              Else
  		            
							Conecta_Banco_De_Dados( cDatabase )
					
					IF oServer  != Nil
						lConnected := .T.
						//msginfo("conecado em mysql")
						IF !IsWindowDefined(Form_Conexao)
                           Load Window Form_Conexao
                           Form_Conexao.CENTER
                           Form_Conexao.ACTIVATE
                        Else
                           Form_Conexao.Restore
                        Endif 
						
					else
							//MsGInfo("Erro Conectando à Base de Dados " +cDatabase ,"SISTEMA" )
					Endif
					

              Endif 

   

				// MsgInfo("Conexão  Concluida","SISTEMA")
				// MsgInfo("Conexão Com Servidor MySql Completada!!","SISTEMA")
              *** Obs: a Variável oServer será sempre a referência em todo o sistema para qualquer tipo de operação
Return(oServer)


************************************************************************************************************************************
Function Espera_Conexao()
************************************************************************************************************************************
DECLARE WINDOW Form_Conexao
//MsGInfo("espera")

IF IsWindowActive(Form_Conexao)

      Form_Conexao.Label_1.Value := "Conectando...." 	                
      Form_Conexao.Label_2.Value := alltrim("Servidor : ") + Alltrim(cHostName)
      Form_Conexao.Image_1.Picture := "svr_off"                                
   
      Espera(2) 
      If lConnected == .T.
          Form_Conexao.Label_1.Value:= "Conexão Completada!!"
          Form_Conexao.Image_1.Picture := "svr_on"
      ENDIF 
                      
      Espera(2)
      If lConnected == .T.
        Form_Conexao.Release
      ENDIF
endif
Return


************************************************************************************************************************************
Function Conecta_Banco_De_Dados( cBaseDeDados )
************************************************************************************************************************************
              Local i                      := 0
              Local aBaseDeDadosExistentes := {}                                           
			  Local lSetExac := SET(_SET_EXACT, .t. ) // pega o set exact atual e seta novo exact
			   cBaseDeDados                 := Lower(cBaseDeDados)
			 // Private cTabela_Atual		   := select database()
			  //Msginfo(cTabela_Atual)
			               
              *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!(Conecta Banco)") ; Return Nil ; EndIf
              
              *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     //MsGInfo("Erro verificando Lista de base de Dados / <TMySQLServer> Conecta_Banco_De_Dados(L154)" + oServer:Error(),"SISTEMA" )
                  Endif               
              *-----  Antes de Conectar Verifica se a Base de Dados já existe
                   aBaseDeDadosExistentes := oServer:ListDBs()


		//msginfo(str(AScan( aBaseDeDadosExistentes, Lower( cBaseDeDados ) )))
              *----- Verifica se na Array aBaseDeDadosExistentes tem a Base de Dados
                  If AScan( aBaseDeDadosExistentes, Lower( cBaseDeDados ) ) == 0
                     MsgINFO( "Base de Dados "+cBaseDeDados+" Não Existe!!")
					 oServer  := Nil
                     Return Nil
                  EndIf 

              *----- Conecta a Base De Dados

                  If oServer:NetErr() 
                     MsGInfo("Erro Conectando à Base de Dados "+cBaseDeDados+" / <TMySQLServer> " + oServer:Error(),"SISTEMA" )
					 oServer  := Nil
					 Return Nil
                  Endif 
				  
				IF oServer  != Nil
                  oServer:SelectDB( cBaseDeDados )
                endif				  

                 // MsgInfo("Banco de Dados "+cBaseDeDados+" Aberto!!" )  

					SET(_SET_EXACT, lSetExac)  // seta SET EXACT anterior
                  
Return (oServer)

************************************************************************************************************************************
Function Desconecta_Banco_De_Dados( cBaseDeDados )
************************************************************************************************************************************
     Conecta_Banco_De_Dados( cTabela_Atual )
                  
Return (oServer)





************************************************************************************************************************************
Function Fechar_Conexao_MySql()                              
************************************************************************************************************************************
              if oServer != Nil                     
                 oServer:Destroy()
                 oServer := Nil
				 lConnected := .F.
				 Form_Main.StatusBar.Item(2) := "Status : Desconectado"
				 
              EndIf

Return



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

**************************************************************************************************************
FUNCTION Autobackup()
**************************************************************************************************************
 *Constantes
 #define SW_HIDE 0
 #define SW_SHOWNORMAL 1
 #define SW_NORMAL 1
 #define SW_SHOWMINIMIZED 2
 #define SW_SHOWCenterD 3
 #define SW_Center 3
 #define SW_SHOWNOACTIVATE 4
 #define SW_SHOW 5
 #define SW_MINIMIZE 6
 #define SW_SHOWMINNOACTIVE 7
 #define SW_SHOWNA 8
 #define SW_RESTORE 9
 #define SW_SHOWDEFAULT 10
 #define SW_MAX 10
 #define HIDE_WINDOW 0


    LOCAL cDia	:=alltrim( str(Day(Date() )) )
	LOCAL cMes	:= alltrim( str(month(Date() )) )
	LOCAL cAno	:= alltrim( str( year( date() )))
	LOCAL dDataForm_Main1:= cDia + "-" + cMes + "-" + cAno
    Local cDestino := Cria_Diretorio("DB_Backup")
    Local oPtion := ""
	Local cHora := PAD( STRTRAN( TIME(), ":", ""), 6)
 //msginfo(cHora)
IF lConnected == .T. 

        cTxtArchivo := cDestino +"\" + "DB_"+ cDatabase + "_" + dDataForm_Main1 +"_"+ cHora +".sql"
        oPtion := "/C mysqldump.EXE -u" + cUser + " -p" + cPassword + " --host=" + cHostname + " " + cDatabase + " > " + cTxtArchivo
        IF shellexecute(0,'OPEN' ,'CMD.EXE',oPtion,Nil, 0 ) > 31
                  Msginfo("Backup Efetuado com Sucesso !")
        ENDIF

 ENDIF
 
RETURN
