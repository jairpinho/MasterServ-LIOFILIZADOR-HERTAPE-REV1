#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"

*************************************************************************************************************************************
Procedure Usuarios()	
*************************************************************************************************************************************

	  Private cUser	:= ""	&& Guarda o Codigo do Usu�rio Atual para reposicion�r-lo ao sair deste Cadastro
	  Private CodigoAlt	:= 0			&& Vari�vel utilizada para verificar qual o codigo foi alterado
	  Private cTitulo	:= "Cadastro de Usuarios"	&& Titulo desta rotina, ser� mostrado em formul�rios
	  Private lNovo	:= .F. 			&& Vari�vel para controlar se Est� Incluindo ou alterando usu�rios


if Usuario()	  
	  
	  
	  *** Carrega Formul�rio Principal
	  *** Define Janela .FMG
	IF !IsWindowDefined(Form_Usuarios)

        Load Window Form_Usuarios
		cUser	:= db_codigo
		Form_Usuarios.StatusBar.Item(1) := "Usu�rio Atual : " + db_usuario


			*** Centraliza Janela
		Form_Usuarios.Center
			*** Ativa Janela
    Form_Usuarios.Activate
  Else
    Form_Usuarios.Center
    Form_Usuarios.Restore
    Return
		
  EndIf  
endif	 
	Return Nil


************************************************************************************************************************************
Function Bt_Novo_Usuario(nTipo)
************************************************************************************************************************************
	 Local cReg	    := PegaValorDaColuna( "Grid_Usuarios" , "Form_Usuarios" , 1 )
	 Local cStatus	    := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)	
	 Local aStatus	    := {  "9"  ,  .F. ,  .F. ,  .F.  , .F. , .F. }
	 Local cTabela	:= "acesso"
	 Local oQuery :=""
	 Local oRow :={}


	 *** Variavel Private que controla se est� sendo efetuada uma inclus�o ou uma altera��o
	 lNovo		    := Iif(nTipo==1,.T.,.F.)
	//cria o mesmo codigo q ira criar la em salvar usuarios apenas para saber o codigo antes de apertar o salvar usuario
	

	IF !IsWindowDefined(Form_Novo_Usuario)
		*** Carrega a Janela
        Load Window Form_Novo_Usuario
	EndIF 

		
	*** Se Tipo for 2, o usu�rio est� Alterando/Editando um Registro
	 If nTipo == 2			
	//	msginfo("Altera dados do Usuario", "Aviso")
		
		*** Se o usu�rio estiver editando/alterando um registro e a vari�vel cReg estiver vazia � porque o grid n�o foi clicado
		*** Esta vari�vel recebeu (veja cima) o valor do Grid em PegavalorDaColuna() 
		If Empty(cReg)

			MsgExclamation("Nenhum Registro Informado para Edi��o!!","SISTEMA")
			Return Nil

		Else			
			
			oQuery  := oServer:Query( "Select * From "+cTabela+" WHERE Codigo = " + AllTrim( cReg )  )
                  If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Opera��o) (): " + oQuery:Error())
                     Return Nil
                  Endif               
                 
					oRow := oQuery:GetRow()
				 	CodigoAlt	:= Alltrim( STR( oRow:FieldGet(1) ) )
					usuario	:= Alltrim( oRow:FieldGet(2) )
					apelido	:= Alltrim( oRow:FieldGet(3) )
					senha	:= Alltrim( oRow:FieldGet(4) )
					acesso	:= Alltrim( oRow:FieldGet(5) )
					email	:= Alltrim( oRow:FieldGet(7) )
					senha_email	:= Alltrim( oRow:FieldGet(8) )
					user_email	:= Alltrim( oRow:FieldGet(9) )
					cartao_ponto:= Alltrim( oRow:FieldGet(10) )
	
					IF nTipo == 2 
						dDT_Cad  := oRow:fieldGet(5)
					ELSE
						dDT_Cad := DATE()
					ENDIF
        oQuery:Destroy()
		EndIf
		*** Preeenche o Status Atual do Usu�rio que ser� alterado
		aStatus := StatusDoUsuario(cReg)
		
		*** Coloca nos objetos do Formul�rio os dados do usu�rio a ser alterado
		Form_Novo_Usuario.TxtCodigo.Value	:= CodigoAlt
		Form_Novo_Usuario.Combo_1.Value	 	:= Val(Alltrim(aStatus[ 1 ]))+1
		Form_Novo_Usuario.TxtNOME.Value	 	:= usuario
		Form_Novo_Usuario.TxtAPELIDO.Value	:= apelido
		Form_Novo_Usuario.Text_1.Value		  := email
		Form_Novo_Usuario.Text_2.Value		  := senha_email
		Form_Novo_Usuario.Text_3.Value		  := user_email
		Form_Novo_Usuario.Text_4.Value		  := cartao_ponto
		Form_Novo_Usuario.Linclui.Value		:= aStatus[ 2 ]
		Form_Novo_Usuario.LAltera.Value		:= aStatus[ 3 ]
		Form_Novo_Usuario.LExclui.Value		:= aStatus[ 4 ]
		Form_Novo_Usuario.LRel.Value		 	:= aStatus[ 5 ]
		Form_Novo_Usuario.LInativo.Value		:= aStatus[ 6 ]
		Form_Novo_Usuario.DtVencto.Value	 	:= CTOD(aStatus[ 7 ])

	EndIf



	If nTipo == 1

		//msginfo("Adicionando Novo Usuario","Aviso")
		
		*** Preeenche o Status Atual do Usu�rio
		aStatus := StatusDoUsuario(db_codigo)
		
		*** Caso a opera��o seja de inclus�o, coloca valor default 9 para N�vel do Usu�rio, Data de vencimento da Senha
		*** 90 dias � partir da data do sistema, desabilita bot�o Excluir e Salvar. 
		*** O Bot�o Excluir nunca ser� habilitado porque est� sendo Inclu�do um novo registro
		*** O Bot�o salvar s� � habilitado quando o nome do usu�rio � digitado e o cursor/Foco vai
		*** para o campo apelido e executa a 		Cl�usula  ON LOSTFOCUS Form_Novo_Usuario.BSalvar.Enabled := .T.

		Form_Novo_Usuario.TxtCodigo.Value	 := Alltrim( STR(GeraCodigo(cTabela) ))
		Form_Novo_Usuario.Combo_1.Value	:= 10		
		Form_Novo_Usuario.DtVencto.Value	:= Date() + 90		
		Form_Novo_Usuario.BExcluir.Enabled	:= .F.
		Form_Novo_Usuario.BSalvar.Enabled	:= .F.		

	EndIf				

	*** Coloca na barra de Status do Formul�rio a variavel com informa�	�o de Altera��o ou Inclus�o
//	Form_Novo_Usuario.StatusBar.Item(1) := cStatus
//Form_Novo_Usuario.TxtCODIGO.Enabled := .F.


*** Centraliza Janela
Form_Novo_Usuario.Center
*** Ativa Janela
Form_Novo_Usuario.Activate
		
Return NIL



*************************************************************************************************************************************
Function Pesquisa_Usuario()
*************************************************************************************************************************************
	Local cPesq						:= ' "'+AllTrim(Form_Usuarios.TxtPesquisa.Value)+'%" '  && cuidar espa�os nas aspas com espa�o map funciona ,"'/%" 
	Local nTamanhoNomeParaPesquisa	:= Len(cPesq)
	Local nQuantRegistrosProcessados	:= 0
	Local nQuantMaximaDeRegistrosNoGrid := 200
	Local i           					:= 0
	Local oRow     						:= {}
  Local oQuery     					:= "" 
	
	*** Exclui todos registros do Grid		
	DELETE ITEM ALL FROM Grid_Usuarios OF Form_Usuarios


		*----- Monta Objeto Query com Selec�o"+cData+" 
                oQuery := oServer:Query( "Select * From acesso WHERE apelido LIKE " + cPesq + " Order By apelido" ) 

				//MSGINFO("total : " + str(oQuery:LastRec()) )
				  			  
				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa Usuario 1 (Grid) (Select): " + oQuery:Error())
					Endif
	
               For i:= 1 To oQuery:LastRec()
                        nQuantRegistrosProcessados += 1
                        If nQuantRegistrosProcessados ==  nQuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						*----- Adiciona Registros no Grid
						ADD ITEM {  Alltrim(Str( oRow:fieldGet(1) , 8 ))  , Alltrim(oRow:fieldGet(3) ) , Alltrim(oRow:fieldGet(2)) } TO Grid_Usuarios OF Form_Usuarios
                        oQuery:Skip(1)
               Next

              *-----  Elimina Objeto Query
                  oQuery:Destroy()
				  MODIFY CONTROL Frame_1 OF Form_Usuarios CAPTION "Usu�rios : " + Alltrim(STR(nQuantRegistrosProcessados))

	*** Pisiciona o cursor/Foco no campo TxtPesquisa		
	Form_Usuarios.TxtPesquisa.SetFocus

	Return Nil


*************************************************************************************************************************************
Function Renova_Pesquisa_Usuario(cNome) && Recebe um par�metro com o nome a ser pesquisado, colocar os Dez primeiros caracteres no TxtPesquisa e retorna para a rotina Pesquisa_Usuario()
*************************************************************************************************************************************
	Form_Usuarios.TxtPesquisa.Value := Substr(AllTrim(cNome),1,10)
	Form_Usuarios.TxtPesquisa.SetFocus
	Pesquisa_Usuario()
	Return Nil

*************************************************************************************************************************************
Function Bt_Salvar_Usuarios()  && Salva Dados do Formul�rio de Cadastro
*************************************************************************************************************************************
	Local aStatus := {  "9"  ,  .F. ,  .F. ,  .F.  , .F. , .F. }
	Local cStatus := CriptografaStatusDoUsuario()
	Local cValues := ""
	Local aStruc  := {}
	Local aUpdate := {}
   Local aInsert := {}
	Local cUpdate := ""
	Local cQuery  := "" 
	//Local cModulos := CriptografaModulosDoUsuario()
    Local oQuery  :="" 
	Local cTabela	:= "acesso"
	
	*** Se o campo Nome ou Apelido n�o  forem informados, enviar mensagem e posiciona cursor/Foco no campo TxtNome
	If Empty( Form_Novo_Usuario.TxtNome.Value  )   .Or.  Empty( Form_Novo_Usuario.TxtApelido.Value  )
		PlayExclamation()
		MsgInfo("Nome ou Apelido n�o Informado !!","Opera��o Inv�lida")
		Form_Novo_Usuario.txtNOME.SetFocus
		Return Nil
	EndIf

	//msginfo( cStatus)
	*** Se for um Novo registro
	If lNovo	  


		*** Grava os outros dados do Registro
			aInsert  := Array(10)
			aInsert[1]:= Alltrim( STR(GeraCodigo(cTabela) ))
			aInsert[2]:= AllTrim( Form_Novo_Usuario.TxtNome.Value )
			aInsert[3]:= AllTrim( Form_Novo_Usuario.TxtApelido.Value )
			aInsert[4]:= HB_Crypt("senha",cChave,cChave)
			aInsert[5]:= "OFF"
			aInsert[6]:= cStatus
			aInsert[7]:= AllTrim( Form_Novo_Usuario.Text_1.Value )
			aInsert[8]:= AllTrim( Form_Novo_Usuario.Text_2.Value )
			aInsert[9]:= AllTrim( Form_Novo_Usuario.Text_3.Value )
			aInsert[10]:= AllTrim( Form_Novo_Usuario.Text_4.Value )
			
			
					aStruc := Array(10)
					aStruc[1] := "codigo"
               aStruc[2] := "usuario"
					aStruc[3] := "apelido"
					aStruc[4] := "senha"
               aStruc[5] := "acesso"
					aStruc[6] := "status"
					aStruc[7] := "email"
					aStruc[8] := "senha_email"
					aStruc[9] := "usuario_email"
					aStruc[10] := "c_ponto"
                  
						cValues := MysqlQueryInsert(aInsert,aStruc)
						cQuery:= "INSERT INTO acesso " + cValues 
                        
					
		PlayExclamation()
		MSGExclamation("Inclus�o Efetivada no "+cTitulo + QUEBRA+;
						"sua Senha inicial � (senha) para alterar" +QUEBRA+;
						"menu Usuarios Alterar Senha Usuario Atual",  ,"SISTEMA" )

	Else	         	
			aUpdate  := Array(10)
			aUpdate[1]:= "OFF"
			aUpdate[2]:= AllTrim( Form_Novo_Usuario.TxtNome.Value )
			aUpdate[3]:= AllTrim( Form_Novo_Usuario.TxtApelido.Value )
			aUpdate[4]:= "OFF"
			aUpdate[5]:= "OFF"
			aUpdate[6]:= cStatus
			aUpdate[7]:= AllTrim( Form_Novo_Usuario.Text_1.Value )
			aUpdate[8]:= AllTrim( Form_Novo_Usuario.Text_2.Value )
			aUpdate[9]:= AllTrim( Form_Novo_Usuario.Text_3.Value )
			aUpdate[10]:= AllTrim( Form_Novo_Usuario.Text_4.Value )

			
		
					aStruc := Array(10)
               aStruc[1] := "codigo"
					aStruc[2] := "usuario"
					aStruc[3] := "apelido"
               aStruc[4] := "senha"					
               aStruc[5] := "acesso"
					aStruc[6] := "status"
					aStruc[7] := "email"
					aStruc[8] := "senha_email"
					aStruc[9] := "usuario_email"
					aStruc[10]:= "c_ponto"

               cUpdate := MysqlQueryUpDate(aUpdate,aStruc)
					cQuery := "UPDATE acesso SET " + cUpdate + " WHERE CODIGO = " + AllTrim( CodigoAlt )
					MSGExclamation("Altera��o Efetivada no "+cTitulo,"SISTEMA")
               

				
	EndIf
	
	
							oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Opera��oxx) (): " + oQuery:Error())
								Return Nil
							Endif  
							
					
	*** Se for um Novo registro
	If lNovo
		*** Marca variavel lNovo como FALSE
		lNovo    := .F.	
  		*** envia para a Rotina de Pesquisa os Dez Primeiros caracteres do Novo Apelido
		Renova_Pesquisa_Usuario(Substr( aInsert[3],1,10))
   Else
  		*** envia para a Rotina de Pesquisa os Dez Primeiros caracteres do Novo Apelido
		Renova_Pesquisa_Usuario(Substr( aUpdate[3],1,10))

   ENDIF
		*** Release Formul�rio de Cadastro
		Form_Novo_Usuario.Release
		
	Return Nil


*************************************************************************************************************************************
Function CriptografaStatusDoUsuario()  && Criptografa Status do Usu�rio - gera Sequ�ncia para gravar no Campo STATUS 
*************************************************************************************************************************************
	Local cSeq	:= ""
   Local cRet	:= ""
   Local cRet2	:= ""
	
	cSeq	:= Alltrim(STR( Form_Novo_Usuario.Combo_1.Value - 1 ))
	cSeq	+= Iif( Form_Novo_Usuario.lInclui.Value  , "1" ,  "0"  )
	cSeq	+= Iif( Form_Novo_Usuario.lAltera.Value , "1" ,  "0"  )
	cSeq	+= Iif( Form_Novo_Usuario.lExclui.Value , "1" ,  "0"  )
	cSeq	+= Iif( Form_Novo_Usuario.lRel.Value    , "1" ,  "0"  )
	cSeq	+= Iif( Form_Novo_Usuario.lInativo.Value, "1" ,  "0"  )
	cSeq    += DtoC( 	Form_Novo_Usuario.DtVencto.Value )
	//msginfo(" sequencia : "  + cSeq  )

   
   
	cRet	:= HB_Crypt( cSeq, cChave)
   cRet2	:= HB_Decrypt( cRet, cChave)
   
  // msginfo(" decrypt : "  + cRet2  )
   
Return(cRet)
   

   

/*
	Esta fun��o recebe o Par�metro nGrid -  1 Se a exclus�o foi solicitada do Grid   e  2 se
	exclus�o foi solicitada pressionando o Bot�o excluir no formulario de cadastro
	cReg		= Recebe o C�digo do usu�rio utilizando a Fun��o PegaValorDaColuna() 
*/


*************************************************************************************************************************************
Function StatusDoUsuario(cCodigo)
*************************************************************************************************************************************
	Local aAmb	:= "" 
	Local aAcesso	:= {}
	Local oQuery :=""
	Local oRow :={}
	
   //msginfo(cCodigo)
	oQuery := oServer:Query( "Select status From acesso WHERE codigo = " + '"'+cCodigo+'"' ) 

				*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Grid) (Select):111 " + oQuery:Error())
					 Return
					Endif

	//msginfo(" usuario 1: " + cUser )
	
	oRow := oQuery:GetRow()
	cRet	:= HB_Decrypt( Alltrim( oRow:FieldGet(1) ) ,cChave)
	//msginfo(" status: " + cRet )

/*jair

&& Niveis de Usu�rio
Nivel = 0 acesso total com cadastro de usuarios
Nivel = 1 acesso total sem cadastro de usuarios
Nivel = 2 acesso Analistas
Nivel = 3 acesso modulo 1
Nivel = 4 acesso modulo 2
Nivel = 5 acesso modulo 3
Nivel = 6 acesso modulo 4
Nivel = 7 acesso modulo 5
Nivel = 8 acesso modulo 6
Nivel = 9 acesso simples 
*/	
  
  Aadd( aAcesso , 	 Substr( cRet , 1 , 1)	) && Nivel do Usu�rio
	Aadd( aAcesso , Iif( Substr( cRet , 2 , 1) == "1" , .T. , .F.  )) && Inclus�es
	Aadd( aAcesso , Iif( Substr( cRet , 3 , 1) == "1" , .T. , .F.  )) && Alteracoes
	Aadd( aAcesso , Iif( Substr( cRet , 4 , 1) == "1" , .T. , .F.  )) && Exclus�es
	Aadd( aAcesso , Iif( Substr( cRet , 5 , 1) == "1" , .T. , .F.  )) && Relat�rios
	Aadd( aAcesso , Iif( Substr( cRet , 6 , 1) == "1" , .T. , .F.  )) && Ativo
	Aadd( aAcesso , ALLTRIM(Substr( cRet , 7 , 10 ))  ) && Data de Vencimento da Senha

  oQuery:Destroy()
Return( aAcesso )



*************************************************************************************************************************************
Function CriptografaModulosDoUsuario()  && Criptografa Modulos do Usu�rio - gera Sequ�ncia para gravar no Campo STATUS 
*************************************************************************************************************************************
	
	
	Local cSeq	:= REPLICATE("0",100)
	

				For nPos = 1 TO Form_Novo_Usuario.Grid_1.ItemCount	&& pega o total de item na grid
					aLinha:=GetProperty ( 'Form_Novo_Usuario' , 'Grid_1' , 'ITEM' , nPos )
					nCodigo := VAL(SUBSTR(aLinha[1],4,3))
					cTipo := SUBSTR(aLinha[1],7,1)
					//msginfo(" tipo - "  + ALLTRIM(cTipo) )
					cSeq := STUFF(cSeq,nCodigo,1,"1")	 
				NEXT

	//msginfo(" sequencia : "  + ALLTRIM(cSeq) )

	Return(HB_Crypt( cSeq + Time()+Time()+Time()+Time()),cChave)

/*
	Esta fun��o recebe o Par�metro nGrid -  1 Se a exclus�o foi solicitada do Grid   e  2 se
	exclus�o foi solicitada pressionando o Bot�o excluir no formulario de cadastro
	cReg		= Recebe o C�digo do usu�rio utilizando a Fun��o PegaValorDaColuna() 
*/


************************************************************************************************************************************
Function  Bt_Excluir_Usuario( nWindow )
************************************************************************************************************************************
              Local gCodigo     := AllTrim( PegaValorDaColuna(  "Grid_Usuarios" , "Form_Usuarios" , 1 ) )
              Local gNome       := AllTrim( PegaValorDaColuna(  "Grid_Usuarios" , "Form_Usuarios" , 3 ) )
              Local cQuery      :=""
              Local oQuery      :=""
			  
			  
			  	gCodigo := Iif( nWindow == 1 , gCodigo ,  Form_Novo_Usuario.txtCodigo.Value )

			*** *** Se o codigo n�o foi localizado no Arquivo, houve um erro de pesquisa
			If Empty(gCodigo)
				MsgExclamation("Nenhum Registro Informado para Exclus�o!!","SISTEMA")
				Return Nil
			Else
                        
				If MsgYesNo( "Confirma Exclus�o de: "+ gNome ) 
                   cQuery     := "DELETE FROM ACESSO  WHERE CODIGO = " + AllTrim( gCodigo )         
                   oQuery      := oQuery  :=  oServer:Query( cQuery )
                   If oQuery:NetErr()												
                      MsgInfo("Erro na Exclus�o (Delete): " + oQuery:Error())
                      Return Nil
                   EndIf
                   oQuery:Destroy()			 																			
                   MsgInfo(  "Registro Exclu�do !!" )
                   Renova_Pesquisa_Usuario(" ")
				EndIf
				
			Endif
			
			
Return Nil    


*************************************************************************************************************************************
Function Bt_Sair_Usuario()	
*************************************************************************************************************************************
	Form_Usuarios.Release
	Return Nil



*************************************************************************************************************************************
Function NivelAtual()	&&  Fun��o que retorna o Nivel Atual do Usuario	
*************************************************************************************************************************************
	Return( Substr( HB_Decrypt( db_status ) , 1 , 1),cChave )


*************************************************************************************************************************************
Function NoInclui()	 && Func�o que retorna  .T.  ou  .F.  para Inclus�es
*************************************************************************************************************************************
	Return( Iif( Substr( HB_Decrypt( db_status ,cChave) , 2 , 1) == "1" , .T. , .F.  ) )	


*************************************************************************************************************************************
Function NoAltera()  &&  Func�o que retorna  .T.  ou  .F.  para Altera��es
*************************************************************************************************************************************
	Return( Iif( Substr( HB_Decrypt( db_status,cChave ) , 3 , 1) == "1" , .T. , .F.  ) )	


*************************************************************************************************************************************
Function NoExclui()	  && Func�o que retorna  .T.  ou  .F.  para Exclus�es
*************************************************************************************************************************************
	Return( Iif( Substr( HB_Decrypt( db_status,cChave ) , 4 , 1) == "1" , .T. , .F.  ) )	


*************************************************************************************************************************************
Function NoRelat() && 	Func�o que retorna  .T.  ou  .F.  para Emiss�o de relat�rios
*************************************************************************************************************************************
	Return( Iif( Substr( HB_Decrypt( db_status,cChave ) , 5 , 1) == "1" , .T. , .F.  ) )	


*************************************************************************************************************************************
Function NoAtivo()  &&  Func�o que retorna  .T.  ou  .F.  para Usu�rio Ativo ou Inativo
*************************************************************************************************************************************
	Return( Iif( Substr( HB_Decrypt( db_status ,cChave) , 6 , 1) == "1" , .T. , .F.  ) )	


*************************************************************************************************************************************
Function DataExpira()  &&  Func�o que retorna  Data em que a senha do Usu�rio atual expira
*************************************************************************************************************************************
	Return( CtoD( Substr( HB_Decrypt( db_status,cChave ) , 7 , 10 ) ) )	


*************************************************************************************************************************************
Function MsgNO(cMsg)  && Func�o de mensagens de Bloqueio  msgNo( cMsg ) =>  cMsg  =  "INCLUIR"  ,  "ALTERAR"  ,  "EXCLUIR"
*************************************************************************************************************************************
	MsgINFO( "Usu�rio [ "+ AllTrim( db_apelido ) +" ] sem permiss�o para "+cMsg+" Registros" , SISTEMA )
	Return Nil		

/*
	Esta fun��o � executa quando ocorre o release do Form_Usuarios  ( ON RELEASE Back_Old_User( cUser ) )
	Posiciona na �rea/Alias  "Acesso"  no registro do Usu�rio que entrou no sistema.
*/
*************************************************************************************************************************************
Function Back_Old_User( cCodigo )			
*************************************************************************************************************************************
	Local aAmb := ""

	Return Nil

*************************************************************************************************************************************
Function AlteraSenha()  && Altera��o de Senhas Senhas 
*************************************************************************************************************************************
              Local cUser		:= db_apelido
              Local cPassWord		:= "" 
              Local NewPassWord	:= ""     
              Local ConfirmPassWord	:= ""     

	*** Cria Form Nova_senha
	DEFINE WINDOW Form_Nova_senha ;
		AT 0,0 ;
		WIDTH 280 HEIGHT 235 ;
		TITLE 'Altera��o de Senha de Acesso'   MODAL NOSYSMENU //BACKCOLOR BLUE                                                          

		@010,030 LABEL Label_User	;
			 VALUE "Usu�rio Atual"	;
			 WIDTH 120		;
			 HEIGHT 35		;
			 FONT "Arial" SIZE 09	
                                           //BACKCOLOR BLUE	;
                                           //FONTCOLOR WHITE BOLD

	 	 @045,030 LABEL Label_Password	;
			   VALUE "Senha Atual"	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	
                                             //BACKCOLOR BLUE 	;
                                            // FONTCOLOR WHITE BOLD	

	 	 @080,030 LABEL Label_NewPassword;
			   VALUE "Nova Senha      "	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	
                                             //BACKCOLOR BLUE 	;
                                             //FONTCOLOR WHITE BOLD	

	 	 @115,030 LABEL Label_ConfirmPassword;
			   VALUE "Confirme Nova Senha"	;
			   WIDTH 120		;
			   HEIGHT 35		;
			   FONT "Arial" SIZE 09	
                                             //BACKCOLOR BLUE 	;
                                             //FONTCOLOR WHITE BOLD	

                             @013,120 TEXTBOX  p_User	;
                                            HEIGHT 25		;                           
                                            VALUE cUser		;                       
                                            WIDTH 120		;                           
                                            FONT "Arial" SIZE 09	;
		       FONTCOLOR BLACK BOLD
                             @048,120 TEXTBOX  p_password	;
                                            VALUE cPassWord	;          
                                            PASSWORD		;                         
                                            FONT "Arial" SIZE 09	;             
                                            TOOLTIP "Senha de Acesso";
 			  MAXLENGTH 08		;	
			  ON ENTER  Cheka_Senha() 

                             @083,120 TEXTBOX  Newpassword	;
			   VALUE ""                         ;                      
                                            PASSWORD		;                         
                                            FONT "Arial" SIZE 09	;             
                                            TOOLTIP "Digite sua nova senha";
			  MAXLENGTH 08		;	
			  ON ENTER  Iif( ! Empty( Form_Nova_senha.newpassword.Value ) ,  Form_Nova_senha.ConfirmPassword.SetFocus,  Form_Nova_senha.NewPassword.SetFocus )

                             @118,120 TEXTBOX  Confirmpassword;
                                            VALUE ""		;          
                                            PASSWORD		;                         
                                            FONT "Arial" SIZE 09	;             
                                            TOOLTIP "Confirma s senha digitada";
  			  MAXLENGTH 08		;	
			  ON ENTER  Iif( ! Empty( Form_Nova_senha.ConfirmPassword.Value )  ,  Form_Nova_senha.Bt_Confirma.SetFocus,  Form_Nova_senha.ConfirmPassword.SetFocus )

                             @ 160,030 BUTTON Bt_Confirma	;
                                            CAPTION '&Confirma'	;
                                            ACTION Confirma_Troca()	;
                                            FONT "MS Sans Serif" SIZE 09 FLAT

                             @ 160,143 BUTTON Bt_Cancela                   ;
                                             CAPTION '&Cancela'                 ;
			   ACTION Form_Nova_senha.Release	      ;
                                             FONT "MS Sans Serif" SIZE 09 FLAT

	END WINDOW

	*** Desabilita o TextBox p_user que cont�m o apelido do usu�rio ativo
	Form_Nova_senha.p_User.Enabled := .F.

	*** Posiciona o Cursor/Foco no textBox p_passWord
	Form_Nova_senha.p_password.SetFocus

	*** Centraliza janela
	CENTER WINDOW Form_Nova_senha

	*** Ativa Janela
	ACTIVATE WINDOW Form_Nova_senha

	Return Nil

*************************************************************************************************************************************
Function Confirma_Troca()
*************************************************************************************************************************************
  Local oQuery :=""
  Local cQuery :=""
	*** Confirma��o da Nova Senha Digitada
	
	
	If Empty( Form_Nova_senha.p_password.value )  &&  verifica se a senha atual esta vazia
		MsgINFO("Senha Atual n�o informada!!","SISTEMA")
		Form_Nova_senha.p_password.SetFocus
		Return Nil
	
	ElseIf empty(Form_Nova_senha.NewPassword.Value) && verifica se a nova senha esta vazia
		MsgINFO("Nova Senha n�o informada!!","SISTEMA")
		Form_Nova_senha.NewPassword.SetFocus
		Return Nil
	
	
	Elseif Empty(Form_Nova_senha.ConfirmPassword.Value)  && verifica se a confirma��o de senha esta vazia
		MsgINFO("Senha de confirma��o n�o informada!!","SISTEMA")
		Form_Nova_senha.ConfirmPassword.SetFocus
		Return Nil
	
	Else
		If Form_Nova_senha.NewPassword.Value == Form_Nova_senha.ConfirmPassword.Value
			
			If MsgYesNo( "Confirma Altera��o de sua Senha de Acesso?" , SISTEMA )
						
						cNovaSenha := HB_Crypt(  Form_Nova_Senha.NewPassword.Value ,cChave )
						
						cUpdate := "senha			= " + "'" + cNovaSenha + "'"

							cQuery := "update acesso set " + cUpdate + " WHERE codigo = " + db_codigo
							oQuery  :=  oServer:Query( cQuery )
						
							If oQuery:NetErr()												
								MsgInfo("Erro (Opera��o) (): " + oQuery:Error())
								Return Nil
							Endif  
							
							oQuery:Destroy()
							
						*** Envia Mensagem ao Usu�rio
						MsgInfo("Sua senha foi atualizada!!" , SISTEMA )
			
				
			EndIf

		Else
			MsgInfo("Senha de Confirma��o Inv�lida... Redigite!!","Erro na Confirma��o da Senha")
			Form_Nova_senha.NewPassword.Value := ""	
			Form_Nova_senha.ConfirmPassword.Value      := ""
			Form_Nova_senha.NewPassword.SetFocus
			Return Nil
		Endif
	EndIf


	*** Solicita ao usu�rio que confirme a altera��o da Senha
	
	** Efetua Release no Form Nova_Senha
	Form_Nova_Senha.Release

	Return Nil


*************************************************************************************************************************************
Function Cheka_Senha()
*************************************************************************************************************************************
	
		Local lRet := .T.
	

		*** Decripta a Senha do arquivo e compara a Senha do usu�rio com a senha Digitada
		If HB_Decrypt( alltrim(db_senha) , cChave ) == Form_Nova_senha.p_password.Value
			Return lRet 	
		Else
			MsgInfo("Senha de acesso Atual Inv�lida!!","SISTEMA")
			Form_Nova_senha.p_password.SetFocus 		
			lRet := .F.	  
		EndIf		

*************************************************************************************************************************************
Function Lembrar_Senha()
*************************************************************************************************************************************
	 Local cReg	    := PegaValorDaColuna( "Grid_Usuarios" , "Form_Usuarios" , 1 )
	 Local cTabela	:= "acesso"
	 Local oQuery :=""
	 Local oRow :={}
	 
	 
			oQuery  := oServer:Query( "Select * From "+cTabela+" WHERE Codigo = " + AllTrim( cReg )  )
                  If oQuery:NetErr()												
                     MsgInfo("Erro de Pesquisa (Opera��o) (): " + oQuery:Error())
                     Return Nil
                  Endif               
                 
					oRow        := oQuery:GetRow()
				 	CodigoAlt	  := Alltrim( STR( oRow:FieldGet(1) ) )
					cUsuario	    := Alltrim( oRow:FieldGet(2) ) 
					cApelido	    :=  Alltrim( oRow:FieldGet(3) )
					cSenha	      := HB_Decrypt( Alltrim( oRow:FieldGet(4) ) , cChave )
					acesso	    := Alltrim( oRow:FieldGet(5) )
					email	      := Alltrim( oRow:FieldGet(7) )
					senha_email	:= Alltrim( oRow:FieldGet(8) )
					user_email	:= Alltrim( oRow:FieldGet(9) )

					
					
	oQuery:Destroy()
	
		//Envia_email_Usuario(email,senha)	
	         MsgINFO (PadC("Dados do Usu�rio",60)+QUEBRA+;
				  PadC("Usu�rio : " + cUsuario,60)+QUEBRA+;
                  PadC("Apelido : " + cApelido,30)+QUEBRA+;
                  PadC("Senha : "+cSenha,30) , SISTEMA)	
		
		
Return

					
					
*************************************************************************************************************************************
Function Envia_email_Usuario(Email_requisitante,Senha_Usuario)
*************************************************************************************************************************************
local cAssunto   := ""
Local cFrom  	 := {}
local aTo        := {}
local aTo_dp     := {}
local aCC        := {}
local aBCC       := {}
local aFiles       := {}
local cServerIp  := "smtp.techworks.net.br" //cServer_Email // WKODAMA01.sevenboys.com.br" //"wkodama01.sevenboys.com.br"
Local cSenha_Usuario := Senha_Usuario
Local nPort  := 587 && 25 porta padrao//465 //993 gmail imap //587 //YAHOO //gmail 465
Local cCorpoMsg := ""
Local cPopServer := ""  // opcional "pop.gmail.com:465"
Local cSMTPPassword:= ""
Local lRead := .F.
Local lTrace := .T.
Local lNoAuth := .F.
Local nPriority := 3
Local lPopAuth := .F.	// logowanie do serwera POP
Local nTimeOut := 20000  && default 20000 -> 20s
Local cReplyTo := ""
Local lTLS := .f.  	//nie przestawia�, bo wywala b��d
Local cCharset := "windows-1250"
Local cEncoding := ""





//nPriority := 3  // "NORMAL 3 " - "BAIXA 5 " - "ALTA 1 "

aTo      := StringToArray( Email_requisitante, "," )
//aCC		:= StringToArray( cEmail_copia , "," )

//msginfo("email1 " + Email_requisitante + "email2 " + user + "senha "+ Senha_User)
msginfo("email1 " + Email_requisitante )

	cAssunto   := "Lembrete de Senha"
	cCorpoMsg := ("Solicita��o de lembrete de senha: " +QUEBRA+;
				  " "+QUEBRA+;
				  "Sua senha Atual � : " + HB_Decrypt( alltrim(cSenha_Usuario) ,cChave ) + QUEBRA +;
				  " "+QUEBRA+;
				  " "+QUEBRA+;
				  " "+QUEBRA+;
				  " "+QUEBRA+;
				  " "+QUEBRA+;
                  " Desenvolvido com HMG 3.0.28 (MiniGUI Distribution-GPL) 2010.04.03"+QUEBRA+;
                  " Copyright 1999-2003, http://www.harbour-project.org/"+QUEBRA+;
                  " "+QUEBRA+;
                  "Minigui/HmgIDE/ Roberto Lopez / Arqentina")
				  
If MsgYesNO("Enviar Email !")

	IF hb_SendMail(cServerIP,nPort,Email_Automail,aTo,NIL,{},cCorpoMsg,cAssunto, aFiles, User_Automail , Senha_Automail, cPopServer, nPriority , lRead, lTrace,.F.,lNoAuth)
	//hb_SendMail( cServer, nPort, cFrom, xTo, xCC, xBCC, cBody, cSubject, aFiles, cUser, cPass, cPopServer, nPriority, lRead, bTrace, lPopAuth, lNoAuth, nTimeOut, cReplyTo, lTLS, cSMTPPass, cCharset, cEncoding )


			Msginfo("Email enviado com sucesso")
	Else
		Msginfo("Falha2 no envio de Email, Verique usuario e senha e ou Conex�es de Redes")
	Endif

EndIF
return


Function Adiciona_Modulo()

aCodigo_Modulo := PGeneric( 4 , "" , "modulos" , "aux1" , ' "'+ Alltrim(Form_Novo_Usuario.Combo_2.DisplayValue) +'" ' )


						ADD ITEM {aCodigo_Modulo[8],aCodigo_Modulo[2],aCodigo_Modulo[1]} TO Grid_1 OF Form_Novo_Usuario



// {"M�dulo","Descri��o","Codigo"}
*/


Return 

					



	 