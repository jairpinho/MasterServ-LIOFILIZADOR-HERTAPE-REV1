#include "minigui.ch"
#Include "F_Sistema.ch"
#include "hbthread.ch"
//DECLARE WINDOW &oForm_Main  // Form_Main.FMG
DECLARE Window Form_acesso
DECLARE Window Form_Main
DECLARE Window Form_Login


*************************************************************************************************************************************
Function AcessoAoSistema()          
*************************************************************************************************************************************
 
  Local cUsuario           := ""
  Local cSenha             := ""
  

    
        
	*** Define Janela do Login Principal ao Sistema
	IF !IsWindowDefined(Form_acesso)
      Load Window Form_acesso
      Form_acesso.HostName.Value  := cHostName
      Form_acesso.Text_1.Value    := cDatabase
      Form_acesso.Text_2.Value    := cUser 
	  Form_acesso.Text_3.Value    := cPassWord	  
      Form_acesso.Text_4.Value    := cPort

      Form_acesso.Title := "Acesso ao Sistema [" + cHostName + "]" + " | " + cDiretorio
		*** Coloca o Cursor no TEXTBOX p_user				
		Form_acesso.Usuario.SetFocus
   
		*** Ativa janela de Login 
Form_acesso.Row := 150
Form_acesso.Col := 300		
		Form_acesso.Activate

	Else

      Form_acesso.HostName.Value  := cHostName
      Form_acesso.Text_1.Value    := cDatabase
      Form_acesso.Text_2.Value    := cUser  
      Form_acesso.Text_3.Value    := cPassWord
      Form_acesso.Text_4.Value    := cPort
	

        Form_acesso.Center
            *** Ativa janela de Login 
        Form_acesso.Restore


	EndIf 

Return  Nil



*************************************************************************************************************************************
Function Verifica_Login()
*************************************************************************************************************************************

	Local Autorizado := .T.
	Local cUsuario	:= ""
	Local cSenha	:= ""
    Local oQuery :=""
    Local oRow := {}	
	Public db_codigo	:= ""
	Public db_usuario	:= ""
	Public db_c_ponto	:= ""
	Public db_senha		:= ""
	Public db_apelido	:= ""
	Public db_status	:= ""
	Public db_Email	:= ""
	Public db_Senha_Email	:= ""
	Public db_User_Email	:= ""
	DECLARE WINDOW Form_Main

IF IsWindowDefined(Form_acesso)
	cUsuario	:= AllTrim(Form_acesso.Usuario.Value)
	cSenha	:= AllTrim(Form_acesso.Senha.Value )
endif

IF IsWindowDefined(Form_Login)
	cUsuario	:= AllTrim(Form_Login.Usuario.Value)
	cSenha	:= AllTrim(Form_Login.Senha.Value )
endif
	
	Abre_conexao_MySql()
	
If oServer != Nil  && sem conexão não faz nada e retorn

Conecta_Banco_De_Dados( cDatabase )
Cria_Tabela_Acesso(cDatabase)
	// MSGINFO("teste de linaha 92: "+ cSenha)	
	*** Se o TextBox p_User não foi informado
	If Empty( cUsuario )
		MsgINFO("Usuário não informado!!","SISTEMA")
		IF IsWindowDefined(Form_acesso)
			Form_acesso.Usuario.SetFocus
		endif
		
		IF IsWindowDefined(Form_Login)
			Form_Login.Usuario.SetFocus
		endif
		
		Return Nil
	EndIf 
   
//MSGINFO("teste de linaha 133 ")	
	
	If Empty( cSenha )
		MsgINFO("Senha não informada!!","SISTEMA")
		IF IsWindowDefined(Form_acesso)
			Form_acesso.Senha.SetFocus
		endif
		
		IF IsWindowDefined(Form_Login)
			Form_Login.Senha.SetFocus
		endif		
		Return Nil
	EndIf   
	
	
oQuery := oServer:Query( "Select * From acesso WHERE apelido = " + '"'+cUsuario+'"' ) 

				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado em Verifica_Login()" + oQuery:Error())
					 Return
					Endif

	//msginfo(" usuario 1: " + cUsuario )
	
	oRow := oQuery:GetRow()
	db_codigo	:= Alltrim( STR( oRow:FieldGet(1) ) )
	db_usuario	:= Alltrim( oRow:FieldGet(2) )
	db_apelido	:= Alltrim( oRow:FieldGet(3) )
	db_senha	:= HB_Decrypt(Alltrim( oRow:FieldGet(4) ) ,cChave)
	db_acesso	:= Alltrim( oRow:FieldGet(5) )
	db_status	:= Alltrim( oRow:FieldGet(6) ) 
	db_Email	:= Alltrim( oRow:FieldGet(7) ) 
	db_Senha_Email	:= Alltrim( oRow:FieldGet(8) ) 
	db_user_Email	:= Alltrim( oRow:FieldGet(9) ) 
	db_c_ponto     := Alltrim( oRow:FieldGet(10) )
	//msginfo(" usuario : " + db_usuario )
	//msginfo(" apelido : " + db_apelido )
	//msginfo(" senha : " + db_senha )
	//msginfo(" status : " + db_status )
	
	If db_apelido == cUsuario 
		If db_senha == cSenha 
		
		Else
			MsgInfo("Senha Invalida" )
		IF IsWindowDefined(Form_acesso)
			Form_acesso.Senha.SetFocus
		endif
		
		IF IsWindowDefined(Form_Login)
			Form_Login.Senha.SetFocus
		endif	
			Return
		Endif
	
	
	Else
		MsgInfo("Usuario Invalido" )
		IF IsWindowDefined(Form_acesso)
			Form_acesso.Usuario.SetFocus
		endif
		
		IF IsWindowDefined(Form_Login)
			Form_Login.Usuario.SetFocus
		endif
		Return
	Endif

				
	*** A função Status do usuário coloca em uma Array as configurações do usuário ( neste caso a array aStstusDoUsuario )
              aStatusDoUsuario := StatusDoUsuario( db_codigo ) && Status do Usuário Atual
// msginfo("Senha Vence em 1  : " + alltrim(aStatusDoUsuario[7] ))
	*** A Função StatusDoUSuario está em ( F_USUARIOS.PRG )
	*** Obs: a Array contém as configurações na seguintre ordem
	*** 1º Posicão: Níivel do usuário: 0 à  9 - Somente os usuários de níve 0 podem acessar o cadastro de USUARIOS
	*** 2º Posição : Inclusões  no Sistema			.T. ou .F.	 
	*** 3º Posição : Alterações no Sistema			.T. ou .F.	 
	*** 4º Posição : Exclusãoes no Sistema			.T. ou .F.	 
	*** 5º Posição : Emissão de relatórios			.T. ou .F.	 
	*** 6º Posição : Usuário Ativo ou Inativo		.T. ou .F.	 
	*** 7º Posição : Data de Validade da Senha      Cariável tipo Date	 
	// MSGINFO("teste de linaha 186 ")
   // msginfo("status 1   : " + alltrim(aStatusDoUsuario[1] ) )
   // msginfo("status 2   : " + alltrim(aStatusDoUsuario[2] ) )
   // msginfo("status 3   : " + alltrim(aStatusDoUsuario[3] ) )
   // msginfo("status 4   : " + alltrim(aStatusDoUsuario[4] ) )
   // msginfo("status 5   : " + alltrim(aStatusDoUsuario[5] ) )
   // msginfo("status 6   : " + alltrim(aStatusDoUsuario[6] ) )
	// msgdebug("Senha Vence em   : " + alltrim(aStatusDoUsuario[7] ) )
	*** Se Usuário estiver Inativo, envia mensagem para o usuário, limpa os campos do formulario  e posiicona o cursor em p_User 
              If aStatusDoUsuario[ 6 ]   
                 MsgInfo( "Usuário está Inativo.. Impossível Continuar!!" , SISTEMA )
				 IF IsWindowDefined(Form_acesso)
					Form_acesso.Usuario.Value := ""
					Form_acesso.Senha.Value := ""
					Form_acesso.Usuario .SetFocus 
				 endif	
				 
				 IF IsWindowDefined(Form_Login)
					Form_Login.Usuario.Value := ""
					Form_Login.Senha.Value := ""
					Form_Login.Usuario .SetFocus 
				 endif					 
				     Return Nil
              EndIf  
	
	*** Muda o Status do Menu Usuários para Habilitado
        //MODIFY CONTROL Mn_Usuarios OF Form_Main ENABLED .T.
		//MSGINFO("teste de linaha 197 ")
        If aStatusDoUsuario[ 1 ] != "0"    && Somente usuários de Nível "0" (Zero) Podem acessar cadastro de Usuários

			*** Se usuário atual não tem Nivel 0 (Zero) Desabilita o menu Usuários

			*** Se a data de validade é menor que a Data atual do sistema,  envia mensagem para o usuário, limpa os campos do formulario  e posiicona o cursor em p_User 
	        If CTOD(aStatusDoUsuario[7]) < Date() 
		                 MsgInfo( "Senha do Usuário está Vencida!!. Impossível Continuar!!" , SISTEMA )
				 IF IsWindowDefined(Form_acesso)
					Form_acesso.Usuario.Value := ""
					Form_acesso.Senha.Value := ""
					Form_acesso.Usuario .SetFocus 
				 endif	
				 
				 IF IsWindowDefined(Form_Login)
					Form_Login.Usuario.Value := ""
					Form_Login.Senha.Value := ""
					Form_Login.Usuario .SetFocus 
				 endif	              
			  Return Nil
			EndIf 
		

        EndIf 



	*** Efetua Release no formulario de Login
	//MSGINFO("senha  : " + db_senha)
		
		If db_senha == "senha"
						MSGExclamation( "para sua seguranca altere a senha padrão," +QUEBRA+;
						"para alterar va no menu Usuarios Alterar Senha Usuario Atual", SISTEMA )
		ENDIF
			IF IsWindowDefined(Form_acesso)	
				Form_acesso.Release
			endif
			
			IF IsWindowDefined(Form_Login)	
				Form_Login.Release
			endif			

	*** Muda Status da linha de mensagens para Invisivel	
        //Form_Main.Label_Mensagens.Visible := .F. 
          
          	*** Coloca o Apelido do usuário atual na linha de Status do Menu



     
         && Usuario logado 
     lLogin := .T.
			Form_Main.StatusBar.Item(1) := "Base de Dados : " + cHostName + ":" + cPort + "\" + cDatabase
			Form_Main.StatusBar.Item(3) := "Usuário: " + db_usuario   
			

			If lConnected == .T.
					Form_Main.StatusBar.Item(2) := "Status BD: Conectado"
					//msginfo("conectado")
					
			else
				Form_Main.StatusBar.Item(2) := "Status : Desconectado"
			EndIf
	
			
EndIF

    If lLogin == .T.
	Operacoes()
	   
	Else
		aStatusDoUsuario := {}
    ENDIF 



	
Return(lLogin,aStatusDoUsuario)




*************************************************************************************************************************************
Function  Usuario(nTipo)
*************************************************************************************************************************************
local lReturn := .F.

nTipo_Login := nTipo // variavel local ntipo recebe parametro e adicina variavel privada

	*** Define Janela do Login Principal ao Sistema
	IF !IsWindowDefined(Form_Login)
      Load Window Form_Login
      Form_Login.Title := "Acesso ao Sistema [" + cHostName + "]" + " | " + cDiretorio
	  Form_Login.Usuario.SetFocus
		*** Ativa janela de Login 
		Form_Login.Activate

	Else

        Form_Login.Center
            *** Ativa janela de Login 
        Form_Login.Restore


	EndIf 	
	
		if lUsuario == .T.
			lReturn := .T.
		else
			lReturn := .F.
		endif

	
Return(lReturn)


*************************************************************************************************************************************
Function Verifica_Usuario()
*************************************************************************************************************************************
	Local Autorizado := .T.
	Local cUsuario	:= ""
	Local cSenha	:= ""
    Local oQuery :=""
    Local oRow := {}	

	
if Empty(nTipo_Login)
	nTipo_Login := 1
endif

If oServer != Nil  && sem conexão não faz nada e retorn

		cUsuario	:= AllTrim(Form_Login.Usuario.Value)
		cSenha	:= AllTrim(Form_Login.Senha.Value )

	// MSGINFO("teste de linaha 92: "+ cSenha)	
	*** Se o TextBox p_User não foi informado
	If Empty( cUsuario )
		MsgINFO("Usuário não informado!!","SISTEMA")
		IF IsWindowDefined(Form_Login)
			Form_Login.Usuario.SetFocus
		endif
		
		IF IsWindowDefined(Form_Login)
			Form_Login.Usuario.SetFocus
		endif
		
		Return Nil
	EndIf 
   
//MSGINFO("teste de linaha 133 ")	
	
	If Empty( cSenha )
		MsgINFO("Senha não informada!!","SISTEMA")
		IF IsWindowDefined(Form_Login)
			Form_Login.Senha.SetFocus
		endif
		
		IF IsWindowDefined(Form_Login)
			Form_Login.Senha.SetFocus
		endif		
		Return Nil
	EndIf   
	


	
oQuery := oServer:Query( "Select * From acesso WHERE apelido = " + '"'+cUsuario+'"' ) 

				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado em Verifica_Login()" + oQuery:Error())
					 Return
					Endif

	//msginfo(" usuario 1: " + cUsuario )
	
	oRow := oQuery:GetRow()
	db_codigo	:= Alltrim( STR( oRow:FieldGet(1) ) )
	db_usuario	:= Alltrim( oRow:FieldGet(2) )
	db_apelido	:= Alltrim( oRow:FieldGet(3) )
	db_senha	:= HB_Decrypt(Alltrim( oRow:FieldGet(4) ) ,cChave)
	db_acesso	:= Alltrim( oRow:FieldGet(5) )
	db_status	:= Alltrim( oRow:FieldGet(6) ) 
	db_Email	:= Alltrim( oRow:FieldGet(7) ) 
	db_Senha_Email	:= Alltrim( oRow:FieldGet(8) ) 
	db_user_Email	:= Alltrim( oRow:FieldGet(9) ) 
	db_c_ponto     := Alltrim( oRow:FieldGet(10) )
	//msginfo(" usuario : " + db_usuario )
	//msginfo(" apelido : " + db_apelido )
	//msginfo(" senha : " + db_senha )
	//msginfo(" status : " + db_status )
	
	If db_apelido == cUsuario 
		If db_senha == cSenha 
		
		Else
			MsgInfo("Senha Invalida" )
		IF IsWindowDefined(Form_Login)
			Form_Login.Senha.SetFocus
		endif
		
		IF IsWindowDefined(Form_Login)
			Form_Login.Senha.SetFocus
		endif	
			Return
		Endif
	
	
	Else
		MsgInfo("Usuario Invalido" )
		IF IsWindowDefined(Form_Login)
			Form_Login.Usuario.SetFocus
		endif
		
		IF IsWindowDefined(Form_Login)
			Form_Login.Usuario.SetFocus
		endif
		Return
	Endif

				
	*** A função Status do usuário coloca em uma Array as configurações do usuário ( neste caso a array aStstusDoUsuario )
              aStatusDoUsuario := StatusDoUsuario( db_codigo ) && Status do Usuário Atual
// msginfo("Senha Vence em 1  : " + alltrim(aStatusDoUsuario[7] ))
	*** A Função StatusDoUSuario está em ( F_USUARIOS.PRG )
	*** Obs: a Array contém as configurações na seguintre ordem
	*** 1º Posicão: Níivel do usuário: 0 à  9 - Somente os usuários de níve 0 podem acessar o cadastro de USUARIOS
	*** 2º Posição : Inclusões  no Sistema			.T. ou .F.	 
	*** 3º Posição : Alterações no Sistema			.T. ou .F.	 
	*** 4º Posição : Exclusãoes no Sistema			.T. ou .F.	 
	*** 5º Posição : Emissão de relatórios			.T. ou .F.	 
	*** 6º Posição : Usuário Ativo ou Inativo		.T. ou .F.	 
	*** 7º Posição : Data de Validade da Senha      Cariável tipo Date	 
	// MSGINFO("teste de linaha 186 ")
   // msginfo("status 1   : " + alltrim(aStatusDoUsuario[1] ) )
   // msginfo("status 2   : " + alltrim(aStatusDoUsuario[2] ) )
   // msginfo("status 3   : " + alltrim(aStatusDoUsuario[3] ) )
   // msginfo("status 4   : " + alltrim(aStatusDoUsuario[4] ) )
   // msginfo("status 5   : " + alltrim(aStatusDoUsuario[5] ) )
   // msginfo("status 6   : " + alltrim(aStatusDoUsuario[6] ) )
	// msginfo("Senha Vence em   : " + alltrim(DtoC( aStatusDoUsuario[7] )) )
	*** Se Usuário estiver Inativo, envia mensagem para o usuário, limpa os campos do formulario  e posiicona o cursor em p_User 
              If aStatusDoUsuario[ 6 ]   
                 MsgInfo( "Usuário está Inativo.. Impossível Continuar!!" , SISTEMA )
				 IF IsWindowDefined(Form_acesso)
					Form_acesso.Usuario.Value := ""
					Form_acesso.Senha.Value := ""
					Form_acesso.Usuario .SetFocus 
				 endif	
				 
				 IF IsWindowDefined(Form_Login)
					Form_Login.Usuario.Value := ""
					Form_Login.Senha.Value := ""
					Form_Login.Usuario .SetFocus 
				 endif					 
				     Return Nil
              EndIf  
	
	*** Muda o Status do Menu Usuários para Habilitado
        //MODIFY CONTROL Mn_Usuarios OF Form_Main ENABLED .T.
		//MSGINFO("teste de linaha 197 ")
        If aStatusDoUsuario[ 1 ] != "0"    && Somente usuários de Nível "0" (Zero) Podem acessar cadastro de Usuários

			*** Se usuário atual não tem Nivel 0 (Zero) Desabilita o menu Usuários

			*** Se a data de validade é menor que a Data atual do sistema,  envia mensagem para o usuário, limpa os campos do formulario  e posiicona o cursor em p_User 
	        If CTOD(aStatusDoUsuario[7]) < Date() 
		                 MsgInfo( "Senha do Usuário está Vencida!!. Impossível Continuar!!" , SISTEMA )
				 IF IsWindowDefined(Form_Login)
					Form_Login.Usuario.Value := ""
					Form_Login.Senha.Value := ""
					Form_Login.Usuario .SetFocus 
				 endif	
				 
				 IF IsWindowDefined(Form_Login)
					Form_Login.Usuario.Value := ""
					Form_Login.Senha.Value := ""
					Form_Login.Usuario .SetFocus 
				 endif	              
			  Return Nil
			EndIf 
		

        EndIf 



	*** Efetua Release no formulario de Login
	//MSGINFO("senha  : " + db_senha)
		
		If db_senha == "senha"
						MSGExclamation( "para sua seguranca altere a senha padrão," +QUEBRA+;
						"para alterar va no menu Usuarios Alterar Senha Usuario Atual", SISTEMA )
		ENDIF
		


			
		lUsuario := .T.
		
		if nTipo_Login == 1 
				msginfo("Autorizado")
		endif
		
		
		if nTipo_Login == 2 
				//msginfo("Autorizado")
				Fechar_Conexao_MySql()
		endif
		
		
			IF IsWindowDefined(Form_Login)	
				Form_Login.Release
			endif	
			
		if nTipo_Login == 3
				//msginfo("Autorizado")
				AcessoAoSistema()
		endif
			

	*** Muda Status da linha de mensagens para Invisivel	
        //Form_Main.Label_Mensagens.Visible := .F. 
          
          	*** Coloca o Apelido do usuário atual na linha de Status do Menu


			
EndIF
	
Return(lUsuario)


************************************************************************************************************************************
Function Cria_Tabela_Acesso(cSQLDataBase)				
************************************************************************************************************************************
      Local cTabela				:= "acesso"
		Local i                     := 0
      Local aBaseDeDadosExistentes := {}  
      Local aStruc      := {}      
      Local cQuery 	:=""
      Local oQuery  :=""
		Local cStatus	:= HB_Crypt( '011110'+DtoC( Date( )+90) ,cChave )
		Local cSenha	:= HB_Crypt( 'senha' ,cChave)
		Local cPrimaryKey := NIL				&& E o campo que sera a chave primaria de indice 
		Local cUniqueKey  := NIL				&& E o campo que sera a unico 
		Local cAuto 	  := NIL				&& E o campo que sera autoincrementado (numerico e sem casas decimais 
      Local cCodigo := ""
				
//msginfo("Senha Vencera em   :  " + alltrim(DtoC( Date( )+90)) )
	
              *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!(Conecta Banco)") ; Return Nil ; EndIf
              
              *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     MsGInfo("Erro verificando Lista de base de Dados / <TMySQLServer> Conecta_Banco_De_Dados(L154)" + oServer:Error(),"SISTEMA" )
                  Endif               
              *-----  Antes de Conectar Verifica se a Base de Dados já existe
                   aBaseDeDadosExistentes := oServer:ListDBs()



              *----- Verifica se na Array aBaseDeDadosExistentes tem a Base de Dados
                  If AScan( aBaseDeDadosExistentes, Lower( cSQLDataBase ) ) == 0
                     MsgINFO( "Base de Dados "+cSQLDataBase+" Não Existe!!")
                     Return Nil
                  EndIf 

              *----- Conecta a Base De Dados
                  oServer:SelectDB( cSQLDataBase )
                  
                  If oServer:NetErr() 
                     MsGInfo("Erro Conectando à Base de Dados "+cSQLDataBase+" / <TMySQLServer> " + oServer:Error(),"SISTEMA" )
                  Endif 


              
              
              
 *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!(TABELA USUARIOS)") ; Return Nil ; EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
                   aTabelasExistentes  := oServer:ListTables()

              *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("Erro verificando Lista de Tabelas / <TMySQLServer> " + oServer:Error(),"SISTEMA" )
                  Endif 
				
              *----- Verifica se na Array aTabelasExistentes tem a Tabela
                  If AScan( aTabelasExistentes, Lower(cTabela) ) != 0
                     //MsgINFO( "Tabela "+cTabela+" Já Existe!!")
                     Return Nil
                  EndIf 

			aStruc := array(10)		
			*** Adciona na Array a estrutura do arquivo ACESSO.DBF que será  criado
			aStruc[1] := { 'codigo'		, 'N' , 05 , 0 }
			aStruc[2] := { 'usuario'	, 'C' , 30 , 0 }
			aStruc[3] := { 'apelido'	, 'C' , 10 , 0 }
			aStruc[4] := { 'senha'		, 'M' ,0 , 0 }
			aStruc[5] := { 'acesso'		, 'C' ,250 , 0 }
			aStruc[6] := { 'status'		, 'M' ,0  , 0 }		
			aStruc[7] := { 'email'		, 'C' ,250  , 0 }		
			aStruc[8] := { 'senha_email', 'C' ,20  , 0 }		
			aStruc[9] := { 'usuario_email','C' ,250  , 0 }
         aStruc[10]:= { 'c_ponto'      ,'C' ,50  , 0 }		
                 

			*** Funcão Encripta está no PRG F_Funcoes.Prg
			*** STATUS =  São seis posiçoes que podem ser 0 (Zero)  ou  1 (UM) - exceto a primeira que pode ir até 09 (NOVE)
			*** 1º Posicão: Níivel do usuário: 0 à  9 - Somente os usuários de níve 0 podem acessar o cadastro de USUARIOS
			*** 2º Posição : Inclusões  no Sistema		1 = SIM   0 = NÃO.
			*** 3º Posição : Alterações no Sistema		1 = SIM   0 = NÃO
			*** 4º Posição : Exclusãoes no Sistema		1 = SIM   0 = NÃO
			*** 5º Posição : Emissão de relatórios		1 = SIM   0 = NÃO
			*** 6º Posição : Usuário Ativo ou Inativo	1 = SIM   0 = NÃO			 
			*** 7º Posição : Data de Validade da Senha  90 Dias após a criação		


			               *----- Cria a Tabela
				
				oServer:CreateTable(cTabela, aStruc,cPrimaryKey,cUniqueKey,cAuto) 											
              
              *-----  Verifica se ocorreu algum erro
                  If oServer:NetErr() 
                     MsGInfo("Erro Criando Tabela "+cTabela+" / <TMySQLServer> " + oServer:Error(),"SISTEMA" )
                     Release Window ALL		
                    Quit
                  Endif 
	
                  MsgInfo("Tabela [ "+cTabela+" ] Criada com Sucesso!!" )   	
			
        // MSGINFO(cSenha)
        
cCodigo := Alltrim( STR(GeraCodigo(cTabela) ))
         cQuery := "INSERT INTO acesso  VALUES ('"+cCodigo+"' , 'usuario' , 'usuario' , '"+cSenha+"','','"+cStatus+"','','','','' ) "	
				oQuery  :=  oServer:Query( cQuery )			  
											If oQuery:NetErr()												
								MsgInfo("Erro (Operação) (): " + oQuery:Error())
								Return Nil
							Endif  

Return Nil


************************************************************************************************************************************
Function Sair_login()
************************************************************************************************************************************
	lLogin := .F.
	IF IsWindowDefined(Form_Login)
		Form_Login.Release
	endif
return