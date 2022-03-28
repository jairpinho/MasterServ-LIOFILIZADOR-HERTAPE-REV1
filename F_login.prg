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
	
If oServer != Nil  && sem conex�o n�o faz nada e retorn

Conecta_Banco_De_Dados( cDatabase )
Cria_Tabela_Acesso(cDatabase)
	// MSGINFO("teste de linaha 92: "+ cSenha)	
	*** Se o TextBox p_User n�o foi informado
	If Empty( cUsuario )
		MsgINFO("Usu�rio n�o informado!!","SISTEMA")
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
		MsgINFO("Senha n�o informada!!","SISTEMA")
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
                     MsgInfo("Registro n�o Encontrado em Verifica_Login()" + oQuery:Error())
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

				
	*** A fun��o Status do usu�rio coloca em uma Array as configura��es do usu�rio ( neste caso a array aStstusDoUsuario )
              aStatusDoUsuario := StatusDoUsuario( db_codigo ) && Status do Usu�rio Atual
// msginfo("Senha Vence em 1  : " + alltrim(aStatusDoUsuario[7] ))
	*** A Fun��o StatusDoUSuario est� em ( F_USUARIOS.PRG )
	*** Obs: a Array cont�m as configura��es na seguintre ordem
	*** 1� Posic�o: N�ivel do usu�rio: 0 �  9 - Somente os usu�rios de n�ve 0 podem acessar o cadastro de USUARIOS
	*** 2� Posi��o : Inclus�es  no Sistema			.T. ou .F.	 
	*** 3� Posi��o : Altera��es no Sistema			.T. ou .F.	 
	*** 4� Posi��o : Exclus�oes no Sistema			.T. ou .F.	 
	*** 5� Posi��o : Emiss�o de relat�rios			.T. ou .F.	 
	*** 6� Posi��o : Usu�rio Ativo ou Inativo		.T. ou .F.	 
	*** 7� Posi��o : Data de Validade da Senha      Cari�vel tipo Date	 
	// MSGINFO("teste de linaha 186 ")
   // msginfo("status 1   : " + alltrim(aStatusDoUsuario[1] ) )
   // msginfo("status 2   : " + alltrim(aStatusDoUsuario[2] ) )
   // msginfo("status 3   : " + alltrim(aStatusDoUsuario[3] ) )
   // msginfo("status 4   : " + alltrim(aStatusDoUsuario[4] ) )
   // msginfo("status 5   : " + alltrim(aStatusDoUsuario[5] ) )
   // msginfo("status 6   : " + alltrim(aStatusDoUsuario[6] ) )
	// msgdebug("Senha Vence em   : " + alltrim(aStatusDoUsuario[7] ) )
	*** Se Usu�rio estiver Inativo, envia mensagem para o usu�rio, limpa os campos do formulario  e posiicona o cursor em p_User 
              If aStatusDoUsuario[ 6 ]   
                 MsgInfo( "Usu�rio est� Inativo.. Imposs�vel Continuar!!" , SISTEMA )
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
	
	*** Muda o Status do Menu Usu�rios para Habilitado
        //MODIFY CONTROL Mn_Usuarios OF Form_Main ENABLED .T.
		//MSGINFO("teste de linaha 197 ")
        If aStatusDoUsuario[ 1 ] != "0"    && Somente usu�rios de N�vel "0" (Zero) Podem acessar cadastro de Usu�rios

			*** Se usu�rio atual n�o tem Nivel 0 (Zero) Desabilita o menu Usu�rios

			*** Se a data de validade � menor que a Data atual do sistema,  envia mensagem para o usu�rio, limpa os campos do formulario  e posiicona o cursor em p_User 
	        If CTOD(aStatusDoUsuario[7]) < Date() 
		                 MsgInfo( "Senha do Usu�rio est� Vencida!!. Imposs�vel Continuar!!" , SISTEMA )
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
						MSGExclamation( "para sua seguranca altere a senha padr�o," +QUEBRA+;
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
          
          	*** Coloca o Apelido do usu�rio atual na linha de Status do Menu



     
         && Usuario logado 
     lLogin := .T.
			Form_Main.StatusBar.Item(1) := "Base de Dados : " + cHostName + ":" + cPort + "\" + cDatabase
			Form_Main.StatusBar.Item(3) := "Usu�rio: " + db_usuario   
			

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

If oServer != Nil  && sem conex�o n�o faz nada e retorn

		cUsuario	:= AllTrim(Form_Login.Usuario.Value)
		cSenha	:= AllTrim(Form_Login.Senha.Value )

	// MSGINFO("teste de linaha 92: "+ cSenha)	
	*** Se o TextBox p_User n�o foi informado
	If Empty( cUsuario )
		MsgINFO("Usu�rio n�o informado!!","SISTEMA")
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
		MsgINFO("Senha n�o informada!!","SISTEMA")
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
                     MsgInfo("Registro n�o Encontrado em Verifica_Login()" + oQuery:Error())
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

				
	*** A fun��o Status do usu�rio coloca em uma Array as configura��es do usu�rio ( neste caso a array aStstusDoUsuario )
              aStatusDoUsuario := StatusDoUsuario( db_codigo ) && Status do Usu�rio Atual
// msginfo("Senha Vence em 1  : " + alltrim(aStatusDoUsuario[7] ))
	*** A Fun��o StatusDoUSuario est� em ( F_USUARIOS.PRG )
	*** Obs: a Array cont�m as configura��es na seguintre ordem
	*** 1� Posic�o: N�ivel do usu�rio: 0 �  9 - Somente os usu�rios de n�ve 0 podem acessar o cadastro de USUARIOS
	*** 2� Posi��o : Inclus�es  no Sistema			.T. ou .F.	 
	*** 3� Posi��o : Altera��es no Sistema			.T. ou .F.	 
	*** 4� Posi��o : Exclus�oes no Sistema			.T. ou .F.	 
	*** 5� Posi��o : Emiss�o de relat�rios			.T. ou .F.	 
	*** 6� Posi��o : Usu�rio Ativo ou Inativo		.T. ou .F.	 
	*** 7� Posi��o : Data de Validade da Senha      Cari�vel tipo Date	 
	// MSGINFO("teste de linaha 186 ")
   // msginfo("status 1   : " + alltrim(aStatusDoUsuario[1] ) )
   // msginfo("status 2   : " + alltrim(aStatusDoUsuario[2] ) )
   // msginfo("status 3   : " + alltrim(aStatusDoUsuario[3] ) )
   // msginfo("status 4   : " + alltrim(aStatusDoUsuario[4] ) )
   // msginfo("status 5   : " + alltrim(aStatusDoUsuario[5] ) )
   // msginfo("status 6   : " + alltrim(aStatusDoUsuario[6] ) )
	// msginfo("Senha Vence em   : " + alltrim(DtoC( aStatusDoUsuario[7] )) )
	*** Se Usu�rio estiver Inativo, envia mensagem para o usu�rio, limpa os campos do formulario  e posiicona o cursor em p_User 
              If aStatusDoUsuario[ 6 ]   
                 MsgInfo( "Usu�rio est� Inativo.. Imposs�vel Continuar!!" , SISTEMA )
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
	
	*** Muda o Status do Menu Usu�rios para Habilitado
        //MODIFY CONTROL Mn_Usuarios OF Form_Main ENABLED .T.
		//MSGINFO("teste de linaha 197 ")
        If aStatusDoUsuario[ 1 ] != "0"    && Somente usu�rios de N�vel "0" (Zero) Podem acessar cadastro de Usu�rios

			*** Se usu�rio atual n�o tem Nivel 0 (Zero) Desabilita o menu Usu�rios

			*** Se a data de validade � menor que a Data atual do sistema,  envia mensagem para o usu�rio, limpa os campos do formulario  e posiicona o cursor em p_User 
	        If CTOD(aStatusDoUsuario[7]) < Date() 
		                 MsgInfo( "Senha do Usu�rio est� Vencida!!. Imposs�vel Continuar!!" , SISTEMA )
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
						MSGExclamation( "para sua seguranca altere a senha padr�o," +QUEBRA+;
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
          
          	*** Coloca o Apelido do usu�rio atual na linha de Status do Menu


			
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
                   If oServer == Nil ; MsgInfo("Conex�o com MySql n�o foi Iniciada!!(Conecta Banco)") ; Return Nil ; EndIf
              
              *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     MsGInfo("Erro verificando Lista de base de Dados / <TMySQLServer> Conecta_Banco_De_Dados(L154)" + oServer:Error(),"SISTEMA" )
                  Endif               
              *-----  Antes de Conectar Verifica se a Base de Dados j� existe
                   aBaseDeDadosExistentes := oServer:ListDBs()



              *----- Verifica se na Array aBaseDeDadosExistentes tem a Base de Dados
                  If AScan( aBaseDeDadosExistentes, Lower( cSQLDataBase ) ) == 0
                     MsgINFO( "Base de Dados "+cSQLDataBase+" N�o Existe!!")
                     Return Nil
                  EndIf 

              *----- Conecta a Base De Dados
                  oServer:SelectDB( cSQLDataBase )
                  
                  If oServer:NetErr() 
                     MsGInfo("Erro Conectando � Base de Dados "+cSQLDataBase+" / <TMySQLServer> " + oServer:Error(),"SISTEMA" )
                  Endif 


              
              
              
 *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conex�o com MySql n�o foi Iniciada!!(TABELA USUARIOS)") ; Return Nil ; EndIf
              
              *-----  Antes de criar Verifica se a Tabela  j� existe
                   aTabelasExistentes  := oServer:ListTables()

              *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("Erro verificando Lista de Tabelas / <TMySQLServer> " + oServer:Error(),"SISTEMA" )
                  Endif 
				
              *----- Verifica se na Array aTabelasExistentes tem a Tabela
                  If AScan( aTabelasExistentes, Lower(cTabela) ) != 0
                     //MsgINFO( "Tabela "+cTabela+" J� Existe!!")
                     Return Nil
                  EndIf 

			aStruc := array(10)		
			*** Adciona na Array a estrutura do arquivo ACESSO.DBF que ser�  criado
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
                 

			*** Func�o Encripta est� no PRG F_Funcoes.Prg
			*** STATUS =  S�o seis posi�oes que podem ser 0 (Zero)  ou  1 (UM) - exceto a primeira que pode ir at� 09 (NOVE)
			*** 1� Posic�o: N�ivel do usu�rio: 0 �  9 - Somente os usu�rios de n�ve 0 podem acessar o cadastro de USUARIOS
			*** 2� Posi��o : Inclus�es  no Sistema		1 = SIM   0 = N�O.
			*** 3� Posi��o : Altera��es no Sistema		1 = SIM   0 = N�O
			*** 4� Posi��o : Exclus�oes no Sistema		1 = SIM   0 = N�O
			*** 5� Posi��o : Emiss�o de relat�rios		1 = SIM   0 = N�O
			*** 6� Posi��o : Usu�rio Ativo ou Inativo	1 = SIM   0 = N�O			 
			*** 7� Posi��o : Data de Validade da Senha  90 Dias ap�s a cria��o		


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
								MsgInfo("Erro (Opera��o) (): " + oQuery:Error())
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