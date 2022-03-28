#include "Inkey.ch"
#include "MiniGui.ch"
#Include "F_Sistema.ch"
	
*---------------------------------------------------------------------------------------------------*
* Procedure CadastroGenerico | Cadastro Das Tabelas do Sistema    *
*---------------------------------------------------------------------------------------------------*

Procedure CadastroGenerico( cDataBase , oTabela , oTitulo, nSistema, cLabel1,cLabel2,cLabel3,cLabel4,cLabel5,cLabel6,cLabel7,LCombo1,LCombo2,LCombo3,LCombo4,LCombo5,aItems1,aItems2,aItems3,aItems4,aItems5)
		Private cTitulo		:= oTitulo		&& Titulo desta rotina, será mostrado em formulários
		Private CodigoAlt	:= 0			&& Guarda o Codigo Atual para reposicionár-lo ao sair deste Cadastro 
		Private nSis		:= nSistema		&& Titulo desta rotina, será mostrado em formulários
		Private cLb1		:= cLabel1		&& Titulo desta rotina, será mostrado em formulários
		Private cLb2		:= cLabel2		&& Titulo desta rotina, será mostrado em formulários
		Private cLb3		:= cLabel3		&& Titulo desta rotina, será mostrado em formulários
		Private cLb4		:= cLabel4		&& Titulo desta rotina, será mostrado em formulários
		Private cLb5		:= cLabel5		&& Titulo desta rotina, será mostrado em formulários
      Private cLb6		:= cLabel6		&& Titulo desta rotina, será mostrado em formulários
      Private cLb7		:= cLabel7  	&& Titulo desta rotina, será mostrado em formulários

    Private L_Combo1  := lCombo1
    Private L_Combo2  := lCombo2
    Private L_Combo3  := lCombo3
    Private L_Combo4  := lCombo4
    Private L_Combo5  := lCombo5

    Private aItens_Combo1 := {}
    Private aItens_Combo2 := {}
    Private aItens_Combo3 := {}
    Private aItens_Combo4 := {}
    Private aItens_Combo5 := {}


    aItens_Combo1 := aItems1
    aItens_Combo2 := aItems2
    aItens_Combo3 := aItems3
    aItens_Combo4 := aItems4
    aItens_Combo5 := aItems5

	

    
    
		Private lNovo		:= .F.			&& Variável para controlar se Está Incluindo ou alterando usuários
		Private cArea 		:= Lower(oTabela) && Variável usualizada para guardar a área/alias utilizada
		Private cSQLDataBase := cDataBase

	  GenericOpen( cSQLDataBase , oTabela )		&& Abre arquivo solicitado
// EncheArray( 2,@aEspecialidade,@aMaquina,@aC_Custo,@aManutentor,@aGRupo,@aTurno,@aConjunto,@aSubConjunto,@aTipoMan ,@aRequisitantes,@aContaContabil,@aGrupoEstoque,@aProjetos,@aEmpresas,@aFabricantes,@aUnidade_medidas,@aPrioridades,@aCidades, @aEstados,@aFrequencia,@aSolicitantes,@aManutentores,aDepartamento,aFuncao,aEquip_Improd)
// EncheArray_Setores( 2,aSetores,aGrupo_Funcao)
 //MSGINFO(Transform( L_Combo1 , "L"))
 

	  *** Cria Formulário
	IF !IsWindowDefined(Form_Cad_Generico)
		
       Load Window Form_Cad_Generico

	   ON KEY F2 OF Form_Cad_Generico ACTION  Bt_Novo_Generic(1) 
	   ON KEY F3 OF Form_Cad_Generico ACTION  Bt_Novo_Generic(2)
	   
           Form_Cad_Generico.Label_1.Visible :=  .F.
			  Form_Cad_Generico.Label_2.Visible :=  .F.
			  Form_Cad_Generico.Label_3.Visible :=  .F.
			  Form_Cad_Generico.Label_4.Visible :=  .F.
			  Form_Cad_Generico.Label_5.Visible :=  .F.
			  Form_Cad_Generico.Label_6.Visible :=  .F.
			  Form_Cad_Generico.Label_7.Visible :=  .F.

           
           Form_Cad_Generico.Text_1.Visible :=  .F.
			  Form_Cad_Generico.Text_2.Visible :=  .F.
			  Form_Cad_Generico.Text_3.Visible :=  .F.
			  Form_Cad_Generico.Text_4.Visible :=  .F.
			  Form_Cad_Generico.Text_5.Visible :=  .F.
          
			  Form_Cad_Generico.Combo_1.Visible :=  .F.
			  Form_Cad_Generico.Combo_2.Visible :=  .F.
           Form_Cad_Generico.Combo_3.Visible :=  .F.
           Form_Cad_Generico.Combo_4.Visible :=  .F.
           Form_Cad_Generico.Combo_5.Visible :=  .F.

           Form_Cad_Generico.DatePicker_2.Visible :=  .F.
			  Form_Cad_Generico.DatePicker_3.Visible :=  .F.

           
           
        			  
	   
	IF nSis == 0

			  Form_Cad_Generico.Label_1.Visible :=  .F.
			  Form_Cad_Generico.Label_2.Visible :=  .F.
			  Form_Cad_Generico.Label_3.Visible :=  .F.
			  Form_Cad_Generico.Label_4.Visible :=  .F.
			  Form_Cad_Generico.Label_5.Visible :=  .F.
			  Form_Cad_Generico.Label_6.Visible :=  .F.
			  Form_Cad_Generico.Label_7.Visible :=  .F.

			  
           Form_Cad_Generico.Text_1.Visible :=  .F.
			  Form_Cad_Generico.Text_2.Visible :=  .F.
			  Form_Cad_Generico.Text_3.Visible :=  .F.
			  Form_Cad_Generico.Text_4.Visible :=  .F.
			  Form_Cad_Generico.Text_5.Visible :=  .F.

			  Form_Cad_Generico.DatePicker_2.Visible :=  .F.
			  Form_Cad_Generico.DatePicker_3.Visible :=  .F.

			  
	ELSEIF nSis == 1
			   
        Form_Cad_Generico.Label_1.Visible :=  .T.
        Form_Cad_Generico.Label_1.Value :=  cLb1
	
			  
        IF L_Combo1 == .F.
          Form_Cad_Generico.Text_1.Visible :=  .T.
        ELSEIF L_Combo1 == .T. 
  			  Form_Cad_Generico.Combo_1.Visible :=  .T.
			  ENDIF



			  *--- Campo Descricao
				
	ELSEIF nSis == 2
	
				Form_Cad_Generico.Label_1.Visible :=  .T.
			  Form_Cad_Generico.Label_1.Value :=  cLb1
			  Form_Cad_Generico.Label_2.Visible :=  .T.
			  Form_Cad_Generico.Label_2.Value :=  cLb2
		  
        
			  
			  IF L_Combo1 == .F.
            Form_Cad_Generico.Text_1.Visible :=  .T.
        ELSEIF L_Combo1 == .T. 
			      Form_Cad_Generico.Combo_1.Visible :=  .T.
			  ENDIF
			  
        IF L_Combo2 == .F.
            Form_Cad_Generico.Text_2.Visible :=  .T.
			  ELSEIF L_Combo2 == .T.
            Form_Cad_Generico.Combo_2.Visible :=  .T.
        ENDIF
			  

	ELSEIF nSis == 3
	
				Form_Cad_Generico.Label_1.Visible :=  .T.
			  Form_Cad_Generico.Label_1.Value :=  cLb1
			  Form_Cad_Generico.Label_2.Visible :=  .T.
			  Form_Cad_Generico.Label_2.Value :=  cLb2
			  Form_Cad_Generico.Label_3.Visible :=  .T.
			  Form_Cad_Generico.Label_3.Value :=  cLb3
			  
			  IF L_Combo1 == .F.
            Form_Cad_Generico.Text_1.Visible :=  .T.
        ELSEIF L_Combo1 == .T. 
			      Form_Cad_Generico.Combo_1.Visible :=  .T.
			  ENDIF
			  
        IF L_Combo2 == .F.
            Form_Cad_Generico.Text_2.Visible :=  .T.
			  ELSEIF L_Combo2 == .T.
            Form_Cad_Generico.Combo_2.Visible :=  .T.
        ENDIF
        
        IF L_Combo3 == .F.
            Form_Cad_Generico.Text_3.Visible :=  .T.
			  ELSEIF L_Combo3 == .T.
            Form_Cad_Generico.Combo_3.Visible :=  .T.
        ENDIF
        


	ELSEIF nSis == 4
	
			Form_Cad_Generico.Label_1.Visible :=  .T.
			  Form_Cad_Generico.Label_1.Value :=  cLb1
			  Form_Cad_Generico.Label_2.Visible :=  .T.
			  Form_Cad_Generico.Label_2.Value :=  cLb2
			  Form_Cad_Generico.Label_3.Visible :=  .T.
			  Form_Cad_Generico.Label_3.Value :=  cLb3
			  Form_Cad_Generico.Label_4.Visible :=  .T.
			  Form_Cad_Generico.Label_4.Value :=  cLb4  

			  IF L_Combo1 == .F.
            Form_Cad_Generico.Text_1.Visible :=  .T.
        ELSEIF L_Combo1 == .T. 
			      Form_Cad_Generico.Combo_1.Visible :=  .T.
			  ENDIF
			  
        IF L_Combo2 == .F.
            Form_Cad_Generico.Text_2.Visible :=  .T.
			  ELSEIF L_Combo2 == .T.
            Form_Cad_Generico.Combo_2.Visible :=  .T.
        ENDIF
        
        IF L_Combo3 == .F.
            Form_Cad_Generico.Text_3.Visible :=  .T.
			  ELSEIF L_Combo3 == .T.
            Form_Cad_Generico.Combo_3.Visible :=  .T.
        ENDIF

        IF L_Combo4 == .F.
            Form_Cad_Generico.Text_4.Visible :=  .T.
			  ELSEIF L_Combo4 == .T.
            Form_Cad_Generico.Combo_4.Visible :=  .T.
        ENDIF


	

	ELSEIF nSis == 5
	
			  Form_Cad_Generico.Label_1.Visible :=  .T.
			  Form_Cad_Generico.Label_1.Value :=  cLb1
			  Form_Cad_Generico.Label_2.Visible :=  .T.
			  Form_Cad_Generico.Label_2.Value :=  cLb2
			  Form_Cad_Generico.Label_3.Visible :=  .T.
			  Form_Cad_Generico.Label_3.Value :=  cLb3
			  Form_Cad_Generico.Label_4.Visible :=  .T.
			  Form_Cad_Generico.Label_4.Value :=  cLb4
			  Form_Cad_Generico.Label_5.Visible :=  .T.
			  Form_Cad_Generico.Label_5.Value :=  cLb5

			  IF L_Combo1 == .F.
            Form_Cad_Generico.Text_1.Visible :=  .T.
        ELSEIF L_Combo1 == .T. 
			      Form_Cad_Generico.Combo_1.Visible :=  .T.
			  ENDIF
			  
        IF L_Combo2 == .F.
            Form_Cad_Generico.Text_2.Visible :=  .T.
			  ELSEIF L_Combo2 == .T.
            Form_Cad_Generico.Combo_2.Visible :=  .T.
        ENDIF
        
        IF L_Combo3 == .F.
            Form_Cad_Generico.Text_3.Visible :=  .T.
			  ELSEIF L_Combo3 == .T.
            Form_Cad_Generico.Combo_3.Visible :=  .T.
        ENDIF

        IF L_Combo4 == .F.
            Form_Cad_Generico.Text_4.Visible :=  .T.
			  ELSEIF L_Combo4 == .T.
            Form_Cad_Generico.Combo_4.Visible :=  .T.
        ENDIF
        
        IF L_Combo5 == .F.
            Form_Cad_Generico.Text_5.Visible :=  .T.
			  ELSEIF L_Combo5 == .T.
            Form_Cad_Generico.Combo_5.Visible :=  .T.
        ENDIF
        
     	   
	   
	ELSEIF nSis == 6
	
				Form_Cad_Generico.Label_1.Visible :=  .T.
			  Form_Cad_Generico.Label_1.Value :=  cLb1
			  Form_Cad_Generico.Label_2.Visible :=  .T.
			  Form_Cad_Generico.Label_2.Value :=  cLb2
			  Form_Cad_Generico.Label_3.Visible :=  .T.
			  Form_Cad_Generico.Label_3.Value :=  cLb3
			  Form_Cad_Generico.Label_4.Visible :=  .T.
			  Form_Cad_Generico.Label_4.Value :=  cLb4
			  Form_Cad_Generico.Label_5.Visible :=  .T.
			  Form_Cad_Generico.Label_5.Value :=  cLb5
			  Form_Cad_Generico.Label_6.Visible :=  .T.
			  Form_Cad_Generico.Label_6.Value :=  cLb6
      
			  IF L_Combo1 == .F.
            Form_Cad_Generico.Text_1.Visible :=  .T.
        ELSEIF L_Combo1 == .T. 
			      Form_Cad_Generico.Combo_1.Visible :=  .T.
			  ENDIF
			  
        IF L_Combo2 == .F.
            Form_Cad_Generico.Text_2.Visible :=  .T.
			  ELSEIF L_Combo2 == .T.
            Form_Cad_Generico.Combo_2.Visible :=  .T.
        ENDIF
        
        IF L_Combo3 == .F.
            Form_Cad_Generico.Text_3.Visible :=  .T.
			  ELSEIF L_Combo3 == .T.
            Form_Cad_Generico.Combo_3.Visible :=  .T.
        ENDIF

        IF L_Combo4 == .F.
            Form_Cad_Generico.Text_4.Visible :=  .T.
			  ELSEIF L_Combo4 == .T.
            Form_Cad_Generico.Combo_4.Visible :=  .T.
        ENDIF
        
        IF L_Combo5 == .F.
            Form_Cad_Generico.Text_5.Visible :=  .T.
			  ELSEIF L_Combo5 == .T.
            Form_Cad_Generico.Combo_5.Visible :=  .T.
        ENDIF
        
			  Form_Cad_Generico.DatePicker_2.Visible :=  .T.
      	   

	ELSEIF nSis == 7
	
				Form_Cad_Generico.Label_1.Visible :=  .T.
			  Form_Cad_Generico.Label_1.Value :=  cLb1
			  Form_Cad_Generico.Label_2.Visible :=  .T.
			  Form_Cad_Generico.Label_2.Value :=  cLb2
			  Form_Cad_Generico.Label_3.Visible :=  .T.
			  Form_Cad_Generico.Label_3.Value :=  cLb3
			  Form_Cad_Generico.Label_4.Visible :=  .T.
			  Form_Cad_Generico.Label_4.Value :=  cLb4
			  Form_Cad_Generico.Label_5.Visible :=  .T.
			  Form_Cad_Generico.Label_5.Value :=  cLb5
			  Form_Cad_Generico.Label_6.Visible :=  .T.
			  Form_Cad_Generico.Label_6.Value :=  cLb6
			  Form_Cad_Generico.Label_7.Visible :=  .T.
			  Form_Cad_Generico.Label_7.Value :=  cLb7

// MSGINFO(Transform( L_Combo1 , "L"))
 
 			  
			  IF L_Combo1 == .F.
            Form_Cad_Generico.Text_1.Visible :=  .T.
        ELSEIF L_Combo1 == .T. 
			      Form_Cad_Generico.Combo_1.Visible :=  .T.
			  ENDIF
			  
        IF L_Combo2 == .F.
            Form_Cad_Generico.Text_2.Visible :=  .T.
			  ELSEIF L_Combo2 == .T.
            Form_Cad_Generico.Combo_2.Visible :=  .T.
        ENDIF
        
        IF L_Combo3 == .F.
            Form_Cad_Generico.Text_3.Visible :=  .T.
			  ELSEIF L_Combo3 == .T.
            Form_Cad_Generico.Combo_3.Visible :=  .T.
        ENDIF

        IF L_Combo4 == .F.
            Form_Cad_Generico.Text_4.Visible :=  .T.
			  ELSEIF L_Combo4 == .T.
            Form_Cad_Generico.Combo_4.Visible :=  .T.
        ENDIF
        
        IF L_Combo5 == .F.
            Form_Cad_Generico.Text_5.Visible :=  .T.
			  ELSEIF L_Combo5 == .T.
            Form_Cad_Generico.Combo_5.Visible :=  .T.
        ENDIF
        
			  Form_Cad_Generico.DatePicker_2.Visible :=  .T.
			  Form_Cad_Generico.DatePicker_3.Visible :=  .T.
	  
	ENDIF   
	   
	Else
	    CENTER   WINDOW Form_Cad_Generico
      Restore WINDOW Form_Cad_Generico
      Return
  EndIf  
	
	/*  tabelas auxiliares MATERIAIS
	CadastroGenerico( cDatabase , "Maquinas" , "Modulo Maquinas" ,  1 , "C. Custo Nº")
	CadastroGenerico( cDatabase , "Requisitantes" , "Modulo Requisitantes" , 3 , "C. Ponto Nº" , "E-mail","Nome Completo","","","","",.F.,.F.,.F.,.F.,.F.,"","","","","")
	CadastroGenerico( cDatabase , "centro_custo_contabil" , "Modulo Centro de Custos de Maquinas" , 1 ,"C. Custo. Nº")
	CadastroGenerico( cDatabase , "Grupo_maquinas" , "Modulo Grupos de Maquinas" , 1 ,"Grupo Nº")
	CadastroGenerico( cDatabase , "Conta_contabil" , "Modulo Contas de Contabilidades" , 1 ,"C. Cont. Nº")
	CadastroGenerico( cDatabase , "Projetos" , "Modulo Projetos de Manutenção" , 1 , "C. Custo Nº")
	CadastroGenerico( cDatabase , "Empresas" , "Modulo Empresas" , 1 , "Cod. Nº")
	CadastroGenerico( cDatabase , "Fabricantes" , "Modulo Fabricantes" , 0 ,"")
	CadastroGenerico( cDatabase , "Grupo_estoque" , "Modulo Grupos de Estoque" , 1 ,"Grupo Nº")
	CadastroGenerico( cDatabase , "Unidade_Medida" , "Modulo Unidades de Medida para Estoque" , 1 ,"Unidade : ")
	
	*/

	/*  tabelas auxiliares PSM
	
	CadastroGenerico( cDatabase , "Especialidade" , "Modulo Especialidades" , 0 ,"")
	CadastroGenerico( cDatabase , "Maquinas" , "Modulo Maquinas" ,  1 , "C. Custo Nº")
	CadastroGenerico( cDatabase , "Conjunto" , "Modulo Conjunto de Maquinas" , 0 ,"")
	CadastroGenerico( cDatabase , "Manutentores" , "Modulo Manutententores" , 2 , "C. Ponto Nº","Função","Cadeado Nº")
	CadastroGenerico( cDatabase , "SubConjunto" , "Modulo SubConjunto de Maquinas" , 0 ,"")
	CadastroGenerico( cDatabase , "tipo_manutencao" , "Modulo Tipo de Manutenção" , 0 ,"")
	CadastroGenerico( cDatabase , "Turno" , "Modulo Turnos de Trabalho" , 1 ,"Periodo ")
	
	
	*/
	

	/*  tabelas auxiliares OS
	
	CadastroGenerico( cDatabase , "Especialidade" , "Modulo Especialidades" , 0 ,"")
	CadastroGenerico( cDatabase , "Maquinas" , "Modulo Maquinas" , 1 , "C. Custo Nº")
	CadastroGenerico( cDatabase , "centro_custo_contabil" , "Modulo Centro de Custos de Maquinas" , 1 ,"C. Custo. Nº")
	CadastroGenerico( cDatabase , "Manutentores" , "Modulo Manutententores" , 2 , "C. Ponto Nº","Função","Cadeado Nº")
	CadastroGenerico( cDatabase , "Requisitantes" , "Modulo Requisitantes" , 3 , "C. Ponto Nº" , "E-mail","Nome Completo","","","","",.F.,.F.,.F.,.F.,.F.,"","","","","")
	CadastroGenerico( cDatabase , "Grupo_maquinas" , "Modulo Grupos de Maquinas" , 1 ,"Grupo Nº")
	CadastroGenerico( cDatabase , "Prioridades" , "Modulo Prioridade de Execução de Serviços" , 0 ,"")
	
	*/
	
	/*  tabelas auxiliares PEDIDOS
	
	CadastroGenerico( cDatabase , "Grupo_maquinas" , "Modulo Grupos de Maquinas" , 1 ,"Grupo Nº")
	CadastroGenerico( cDatabase , "Conta_contabil" , "Modulo Contas de Contabilidades" , 1 ,"C. Cont. Nº")
	CadastroGenerico( cDatabase , "Maquinas" , "Modulo Maquinas" , 1 , "C. Custo Nº")
	CadastroGenerico( cDatabase , "Projetos" , "Modulo Projetos de Manutenção" , 1 , "C. Custo Nº")
	CadastroGenerico( cDatabase , "Empresas" , "Modulo Empresas" , 1 , "Cod. Nº")
	CadastroGenerico( cDatabase , "Manutentores" , "Modulo Manutententores" , 2 , "C. Ponto Nº","Função","Cadeado Nº")
	CadastroGenerico( cDatabase , "Fabricantes" , "Modulo Fabricantes" , 0 ,"")
	
	*/
	
	
	
	
	*** Posiciona o Foco no TextBox PesqGeneric
	Form_Cad_Generico.PesqGeneric.SetFocus

	*** Efetua pesquisa ao entrar no form para atualizar o Grid
	Renova_Pesquisa_Generic(" ")
	Form_Cad_Generico.Title := cTitulo

	*** Centraliza Janela
	CENTER   WINDOW Form_Cad_Generico

	*** Ativa Janela
	ACTIVATE WINDOW Form_Cad_Generico

	
Return Nil

*----------------------------------------------------------------------------------------------------*
*	nReg	= Recebe o Código do usuário utilizando a Função PegaValorDaColuna() - F_Funcoes.PRG
*	cStatus	= Variável para informar na barra de Titulos do Formulário  se está Incluindo ou Alterando
*----------------------------------------------------------------------------------------------------*

************************************************************************************************************************************
Function Bt_Novo_Generic(nTipo)
************************************************************************************************************************************
	local nHEIGHT_WINDOW :=  0 
	local nHEIGHT_FRAME  := 0 
	Local nReg	    := PegaValorDaColuna( "Grid_1P" , "Form_Cad_Generico" , 1 )
	Local cStatus	    := Iif(nTipo==1,"Incluindo Registro em "+cTitulo,"Alterando Registro em "+cTitulo)	
	Local oQuery := ""
	Local oRow   := {}
 
  SET NAVIGATION Extended
	Set Date to Brit
	Set Century On	  
	  
	*** Variavel Private que controla se está sendo efetuada uma inclusão ou uma alteração
	lNovo		    := Iif(nTipo==1,.T.,.F.)


	IF !IsWindowDefined(Form_Novo_Generic)
        Load Window Form_Novo_Generic
        
      Form_Novo_Generic.Label_3.Visible :=  .F.
		Form_Novo_Generic.Label_4.Visible :=  .F.
		Form_Novo_Generic.Label_5.Visible :=  .F.
		Form_Novo_Generic.Label_6.Visible :=  .F.
		Form_Novo_Generic.Label_7.Visible :=  .F.
		Form_Novo_Generic.Label_8.Visible :=  .F.
		Form_Novo_Generic.Label_9.Visible :=  .F.

      Form_Novo_Generic.Generic_Aux1.Visible :=  .F.
      Form_Novo_Generic.Generic_Aux2.Visible :=  .F.
		Form_Novo_Generic.Generic_Aux3.Visible :=  .F.
		Form_Novo_Generic.Generic_Aux4.Visible :=  .F.
		Form_Novo_Generic.Generic_Aux5.Visible :=  .F.

		Form_Novo_Generic.Combo_1.Visible :=  .F.
		Form_Novo_Generic.Combo_2.Visible :=  .F.
      Form_Novo_Generic.Combo_3.Visible :=  .F.
      Form_Novo_Generic.Combo_4.Visible :=  .F.
      Form_Novo_Generic.Combo_5.Visible :=  .F.

	  Form_Novo_Generic.DatePicker_2.Visible :=  .F.
	  Form_Novo_Generic.DatePicker_3.Visible :=  .F.


      
  EndIf  
	
    If  lNovo
		    Form_Novo_Generic.Generic_Codigo.Value		:= Alltrim( STR(GeraCodigo(cArea) ))
    Endif
	

	IF nSis == 0

			  Form_Novo_Generic.Label_3.Visible :=  .F.
			  Form_Novo_Generic.Label_4.Visible :=  .F.
			  Form_Novo_Generic.Label_5.Visible :=  .F.
			  Form_Novo_Generic.Label_6.Visible :=  .F.
			  Form_Novo_Generic.Label_7.Visible :=  .F.
			  Form_Novo_Generic.Label_8.Visible :=  .F.
			  Form_Novo_Generic.Label_9.Visible :=  .F.
			  
			  Form_Novo_Generic.Generic_Aux1.Visible :=  .F.
			  Form_Novo_Generic.Generic_Aux2.Visible :=  .F.
			  Form_Novo_Generic.Generic_Aux3.Visible :=  .F.
 			  Form_Novo_Generic.Generic_Aux4.Visible :=  .F.
			  Form_Novo_Generic.Generic_Aux5.Visible :=  .F.
			  Form_Novo_Generic.DatePicker_2.Enabled :=  .F.
			  Form_Novo_Generic.DatePicker_3.Visible :=  .F.



	ELSEIF nSis == 1
		      
			  Form_Novo_Generic.Label_3.Visible :=  .T.
			  Form_Novo_Generic.Label_3.Value :=  cLb1

        
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Visible :=  .T.
        ELSEIF L_Combo1 == .T. 
            Form_Novo_Generic.Combo_1.Visible := .T.
			  ENDIF

			  
			  *--- Campo Descricao
				
	ELSEIF nSis == 2

       	Form_Novo_Generic.Label_3.Visible :=  .T.
			  Form_Novo_Generic.Label_3.Value :=  cLb1
			  Form_Novo_Generic.Label_4.Visible :=  .T.
			  Form_Novo_Generic.Label_4.Value :=  cLb2
        
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Visible :=  .T.
        ELSEIF L_Combo1 == .T.
            Form_Novo_Generic.Combo_1.Visible := .T.            
        ENDIF
        
        IF L_Combo2 == .F. 
  			    Form_Novo_Generic.Generic_Aux2.Visible :=  .T.
        ELSEIF L_Combo2 == .T. 
            Form_Novo_Generic.Combo_2.Visible := .T.
        ENDIF


			  
			  
	ELSEIF nSis == 3

       	Form_Novo_Generic.Label_3.Visible :=  .T.
			  Form_Novo_Generic.Label_3.Value :=  cLb1
			  Form_Novo_Generic.Label_4.Visible :=  .T.
			  Form_Novo_Generic.Label_4.Value :=  cLb2
			  Form_Novo_Generic.Label_5.Visible :=  .T.
			  Form_Novo_Generic.Label_5.Value :=  cLb3


        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Visible :=  .T.
        ELSEIF L_Combo1 == .T.
            Form_Novo_Generic.Combo_1.Visible := .T.            
        ENDIF
        
        IF L_Combo2 == .F. 
  			    Form_Novo_Generic.Generic_Aux2.Visible :=  .T.
        ELSEIF L_Combo2 == .T. 
            Form_Novo_Generic.Combo_2.Visible := .T.
        ENDIF
        
        
        IF L_Combo3 == .F. 
  			    Form_Novo_Generic.Generic_Aux3.Visible :=  .T.
        ELSEIF L_Combo3 == .T. 
            Form_Novo_Generic.Combo_3.Visible := .T.
        ENDIF


				
	ELSEIF nSis == 4

			  Form_Novo_Generic.Label_3.Visible :=  .T.
			  Form_Novo_Generic.Label_3.Value   := cLb1
			  Form_Novo_Generic.Label_4.Visible :=  .T.
			  Form_Novo_Generic.Label_4.Value   := cLb2
			  Form_Novo_Generic.Label_5.Visible :=  .T.
			  Form_Novo_Generic.Label_5.Value   := cLb3
			  Form_Novo_Generic.Label_6.Visible :=  .T.
			  Form_Novo_Generic.Label_6.Value   := cLb4

	

			  
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Visible :=  .T.
        ELSEIF L_Combo1 == .T.
            Form_Novo_Generic.Combo_1.Visible := .T.            
        ENDIF
        
        IF L_Combo2 == .F. 
  			    Form_Novo_Generic.Generic_Aux2.Visible :=  .T.
        ELSEIF L_Combo2 == .T. 
            Form_Novo_Generic.Combo_2.Visible := .T.
        ENDIF
        
        
        IF L_Combo3 == .F. 
  			    Form_Novo_Generic.Generic_Aux3.Visible :=  .T.
        ELSEIF L_Combo3 == .T. 
            Form_Novo_Generic.Combo_3.Visible := .T.
        ENDIF
        
        IF L_Combo4 == .F. 
  			    Form_Novo_Generic.Generic_Aux4.Visible :=  .T.
        ELSEIF L_Combo4 == .T. 
            Form_Novo_Generic.Combo_4.Visible := .T.
        ENDIF

				                                                       
	ELSEIF nSis == 5

			  Form_Novo_Generic.Label_3.Visible :=  .T.
			  Form_Novo_Generic.Label_3.Value   := cLb1
			  Form_Novo_Generic.Label_4.Visible :=  .T.
			  Form_Novo_Generic.Label_4.Value   := cLb2
			  Form_Novo_Generic.Label_5.Visible :=  .T.
			  Form_Novo_Generic.Label_5.Value   := cLb3
			  Form_Novo_Generic.Label_6.Visible :=  .T.
			  Form_Novo_Generic.Label_6.Value   := cLb4
			  Form_Novo_Generic.Label_7.Visible :=  .T.
			  Form_Novo_Generic.Label_7.Value   := cLb5



			  
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Visible :=  .T.
        ELSEIF L_Combo1 == .T.
            Form_Novo_Generic.Combo_1.Visible := .T.            
        ENDIF
        
        IF L_Combo2 == .F. 
  			    Form_Novo_Generic.Generic_Aux2.Visible :=  .T.
        ELSEIF L_Combo2 == .T. 
            Form_Novo_Generic.Combo_2.Visible := .T.
        ENDIF
        
        
        IF L_Combo3 == .F. 
  			    Form_Novo_Generic.Generic_Aux3.Visible :=  .T.
        ELSEIF L_Combo3 == .T. 
            Form_Novo_Generic.Combo_3.Visible := .T.
        ENDIF
        
        IF L_Combo4 == .F. 
  			    Form_Novo_Generic.Generic_Aux4.Visible :=  .T.
        ELSEIF L_Combo4 == .T. 
            Form_Novo_Generic.Combo_4.Visible := .T.
        ENDIF
        
        IF L_Combo5 == .F. 
  			    Form_Novo_Generic.Generic_Aux5.Visible :=  .T.
        ELSEIF L_Combo5 == .T. 
            Form_Novo_Generic.Combo_5.Visible := .T.
        ENDIF
        
	  

	ELSEIF nSis == 6

			  Form_Novo_Generic.Label_3.Visible :=  .T.
			  Form_Novo_Generic.Label_3.Value   := cLb1
			  Form_Novo_Generic.Label_4.Visible :=  .T.
			  Form_Novo_Generic.Label_4.Value   := cLb2
			  Form_Novo_Generic.Label_5.Visible :=  .T.
			  Form_Novo_Generic.Label_5.Value   := cLb3
			  Form_Novo_Generic.Label_6.Visible :=  .T.
			  Form_Novo_Generic.Label_6.Value   := cLb4
			  Form_Novo_Generic.Label_7.Visible :=  .T.
			  Form_Novo_Generic.Label_7.Value   := cLb5
			  Form_Novo_Generic.Label_8.Visible :=  .T.
			  Form_Novo_Generic.Label_8.Value   := cLb6

 
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Visible :=  .T.
        ELSEIF L_Combo1 == .T.
            Form_Novo_Generic.Combo_1.Visible := .T.            
        ENDIF
        
        IF L_Combo2 == .F. 
  			    Form_Novo_Generic.Generic_Aux2.Visible :=  .T.
        ELSEIF L_Combo2 == .T. 
            Form_Novo_Generic.Combo_2.Visible := .T.
        ENDIF
        
        
        IF L_Combo3 == .F. 
  			    Form_Novo_Generic.Generic_Aux3.Visible :=  .T.
        ELSEIF L_Combo3 == .T. 
            Form_Novo_Generic.Combo_3.Visible := .T.
        ENDIF
        
        IF L_Combo4 == .F. 
  			    Form_Novo_Generic.Generic_Aux4.Visible :=  .T.
        ELSEIF L_Combo4 == .T. 
            Form_Novo_Generic.Combo_4.Visible := .T.
        ENDIF
        
        IF L_Combo5 == .F. 
  			    Form_Novo_Generic.Generic_Aux5.Visible :=  .T.
        ELSEIF L_Combo5 == .T. 
            Form_Novo_Generic.Combo_5.Visible := .T.
        ENDIF
        

			  
			  
	ELSEIF nSis == 7

			  Form_Novo_Generic.Label_3.Visible :=  .T.
			  Form_Novo_Generic.Label_3.Value   := cLb1
			  Form_Novo_Generic.Label_4.Visible :=  .T.
			  Form_Novo_Generic.Label_4.Value   := cLb2
			  Form_Novo_Generic.Label_5.Visible :=  .T.
			  Form_Novo_Generic.Label_5.Value   := cLb3
			  Form_Novo_Generic.Label_6.Visible :=  .T.
			  Form_Novo_Generic.Label_6.Value   := cLb4
			  Form_Novo_Generic.Label_7.Visible :=  .T.
			  Form_Novo_Generic.Label_7.Value   := cLb5
			  Form_Novo_Generic.Label_8.Visible :=  .T.
			  Form_Novo_Generic.Label_8.Value   := cLb6
			  Form_Novo_Generic.Label_9.Visible := .T.
			  Form_Novo_Generic.Label_9.Value   := cLb7
 
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Visible :=  .T.
        ELSEIF L_Combo1 == .T.
            Form_Novo_Generic.Combo_1.Visible := .T.            
        ENDIF
        
        IF L_Combo2 == .F. 
  			    Form_Novo_Generic.Generic_Aux2.Visible :=  .T.
        ELSEIF L_Combo2 == .T. 
            Form_Novo_Generic.Combo_2.Visible := .T.
        ENDIF
        
        
        IF L_Combo3 == .F. 
  			    Form_Novo_Generic.Generic_Aux3.Visible :=  .T.
        ELSEIF L_Combo3 == .T. 
            Form_Novo_Generic.Combo_3.Visible := .T.
        ENDIF
        
        IF L_Combo4 == .F. 
  			    Form_Novo_Generic.Generic_Aux4.Visible :=  .T.
        ELSEIF L_Combo4 == .T. 
            Form_Novo_Generic.Combo_4.Visible := .T.
        ENDIF
        
        IF L_Combo5 == .F. 
  			    Form_Novo_Generic.Generic_Aux5.Visible :=  .T.
        ELSEIF L_Combo5 == .T. 
            Form_Novo_Generic.Combo_5.Visible := .T.
        ENDIF
        
   
			  
				                                                       
	ENDIF
	  

	 *** Se a operação for de Alteração/Edição		
	If ! lNovo &&editando

				*----- Se operacao for 2 seleciona registro na Tabela Nomes e preenche variaveis
				Conecta_Banco_De_Dados( cSQLDataBase )

                  oQuery  := oServer:Query( "Select * From "+cArea+" WHERE Codigo = " + AllTrim( nReg )  )
                  If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado em (Operação) (): " + oQuery:Error())
                     Return Nil
                  Endif               
                 
				          oRow    := oQuery:GetRow(1)
                  cCodigo := Str( oRow:fieldGet(1) )
                  cDesc   := AllTrim( oRow:fieldGet(2) )
				          cAux1    := AllTrim( oRow:fieldGet(8) ) 
				          cAux2    := AllTrim( oRow:fieldGet(9) ) 
				          cAux3	:= AllTrim( oRow:fieldGet(10) ) 
				          cAux4	:= AllTrim( oRow:fieldGet(11) )
				          cAux5 	:= AllTrim( oRow:fieldGet(12) )
				          cdata1	:= oRow:fieldGet(13)
				          cdata2	:= oRow:fieldGet(14)
				          cdata3	:= oRow:fieldGet(5)
				          cdata4	:= oRow:fieldGet(6)
				  
                  
	

		*** Preenche campos do formulário com dados do Arquivo		
			Form_Novo_Generic.Generic_Codigo.Value := cCodigo
			Form_Novo_Generic.Generic_Descricao.Value := cDesc
			Form_Novo_Generic.DatePicker_1.Value := cdata3
			Form_Novo_Generic.DatePicker_4.Value := cdata4
			
 
			 nCodigo_Funcao1 	:= Busca_Generic( 1,"Combo_1", "Form_Novo_Generic",cAux1)
			 nCodigo_Funcao2 	:= Busca_Generic( 1,"Combo_2", "Form_Novo_Generic",cAux2 )
			 nCodigo_Funcao3 	:= Busca_Generic( 1,"Combo_3", "Form_Novo_Generic",cAux3 )
			 nCodigo_Funcao4 	:= Busca_Generic( 1,"Combo_4", "Form_Novo_Generic",cAux4 )
			 nCodigo_Funcao5 	:= Busca_Generic( 1,"Combo_5", "Form_Novo_Generic",cAux5 )
			 

			
			
		IF nSis == 1
    
        IF L_Combo1 == .F.
    	      Form_Novo_Generic.Generic_Aux1.Value := cAux1
        ENDIF
        
        IF L_Combo1 == .T. 
			      Form_Novo_Generic.Combo_1.Value :=  nCodigo_Funcao1
			  ENDIF
    

			Form_Novo_Generic.DatePicker_1.Value := cdata3
			Form_Novo_Generic.DatePicker_4.Value := cdata4
      
       
		ELSEIF nSis == 2

			Form_Novo_Generic.DatePicker_1.Value := cdata3
		

        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Value := cAux1
        ELSEIF L_Combo1 == .T.
			      Form_Novo_Generic.Combo_1.Value :=  nCodigo_Funcao1        
        ENDIF
        
        IF L_Combo2 == .F. 
            Form_Novo_Generic.Generic_Aux2.Value := cAux2
        ELSEIF L_Combo2 == .T. 
			      Form_Novo_Generic.Combo_2.Value :=  nCodigo_Funcao2
			  ENDIF
			  
		ELSEIF nSis == 3
			Form_Novo_Generic.DatePicker_1.Value := cdata3
			Form_Novo_Generic.DatePicker_4.Value := cdata4	

        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Value := cAux1
        ELSEIF L_Combo1 == .T.
			      Form_Novo_Generic.Combo_1.Value :=  nCodigo_Funcao1        
        ENDIF
        
        IF L_Combo2 == .F. 
            Form_Novo_Generic.Generic_Aux2.Value := cAux2
        ELSEIF L_Combo2 == .T. 
			      Form_Novo_Generic.Combo_2.Value :=  nCodigo_Funcao2
			  ENDIF
			  
			  IF L_Combo3 == .F. 
            Form_Novo_Generic.Generic_Aux3.Value := cAux3
        ELSEIF L_Combo3 == .T. 
			      Form_Novo_Generic.Combo_3.Value :=  nCodigo_Funcao3
			  ENDIF

			
		ELSEIF nSis == 4
			Form_Novo_Generic.DatePicker_1.Value := cData3
			Form_Novo_Generic.DatePicker_4.Value := cdata4
			
          
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Value := cAux1
        ELSEIF L_Combo1 == .T.
			      Form_Novo_Generic.Combo_1.Value :=  nCodigo_Funcao1        
        ENDIF
        
        IF L_Combo2 == .F. 
            Form_Novo_Generic.Generic_Aux2.Value := cAux2
        ELSEIF L_Combo2 == .T. 
			      Form_Novo_Generic.Combo_2.Value :=  nCodigo_Funcao2
			  ENDIF
			  
			  IF L_Combo3 == .F. 
            Form_Novo_Generic.Generic_Aux3.Value := cAux3
        ELSEIF L_Combo3 == .T. 
			      Form_Novo_Generic.Combo_3.Value :=  nCodigo_Funcao3
			  ENDIF
			  
 			  IF L_Combo4 == .F. 
            Form_Novo_Generic.Generic_Aux4.Value := cAux4
        ELSEIF L_Combo4 == .T. 
			      Form_Novo_Generic.Combo_4.Value :=  nCodigo_Funcao4
			  ENDIF
			

		ELSEIF nSis == 5
			Form_Novo_Generic.DatePicker_1.Value := cData3
			Form_Novo_Generic.DatePicker_4.Value := cdata4			
        
                
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Value := cAux1
        ELSEIF L_Combo1 == .T.
			      Form_Novo_Generic.Combo_1.Value :=  nCodigo_Funcao1        
        ENDIF
        
        IF L_Combo2 == .F. 
            Form_Novo_Generic.Generic_Aux2.Value := cAux2
        ELSEIF L_Combo2 == .T. 
			      Form_Novo_Generic.Combo_2.Value :=  nCodigo_Funcao2
			  ENDIF
			  
			  IF L_Combo3 == .F. 
            Form_Novo_Generic.Generic_Aux3.Value := cAux3
        ELSEIF L_Combo3 == .T. 
			      Form_Novo_Generic.Combo_3.Value :=  nCodigo_Funcao3
			  ENDIF
			  
 			  IF L_Combo4 == .F. 
            Form_Novo_Generic.Generic_Aux4.Value := cAux4
        ELSEIF L_Combo4 == .T. 
			      Form_Novo_Generic.Combo_4.Value :=  nCodigo_Funcao4
			  ENDIF
			  
 			  IF L_Combo5 == .F. 
            Form_Novo_Generic.Generic_Aux5.Value := cAux5
        ELSEIF L_Combo5 == .T. 
			      Form_Novo_Generic.Combo_5.Value :=  nCodigo_Funcao5
			  ENDIF


		ELSEIF nSis == 6
		
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Value := cAux1
        ELSEIF L_Combo1 == .T.
			      Form_Novo_Generic.Combo_1.Value :=  nCodigo_Funcao1        
        ENDIF
        
        IF L_Combo2 == .F. 
            Form_Novo_Generic.Generic_Aux2.Value := cAux2
        ELSEIF L_Combo2 == .T. 
			      Form_Novo_Generic.Combo_2.Value :=  nCodigo_Funcao2
			  ENDIF
			  
			  IF L_Combo3 == .F. 
            Form_Novo_Generic.Generic_Aux3.Value := cAux3
        ELSEIF L_Combo3 == .T. 
			      Form_Novo_Generic.Combo_3.Value :=  nCodigo_Funcao3
			  ENDIF
			  
 			  IF L_Combo4 == .F. 
            Form_Novo_Generic.Generic_Aux4.Value := cAux4
        ELSEIF L_Combo4 == .T. 
			      Form_Novo_Generic.Combo_4.Value :=  nCodigo_Funcao4
			  ENDIF
			  
 			  IF L_Combo5 == .F. 
            Form_Novo_Generic.Generic_Aux5.Value := cAux5
        ELSEIF L_Combo5 == .T. 
			      Form_Novo_Generic.Combo_5.Value :=  nCodigo_Funcao5
			  ENDIF

			Form_Novo_Generic.DatePicker_1.Value := cData3
			Form_Novo_Generic.DatePicker_4.Value := cdata4			
			Form_Novo_Generic.DatePicker_2.Value := cdata1
		ELSEIF nSis == 7
		
        IF L_Combo1 == .F.
            Form_Novo_Generic.Generic_Aux1.Value := cAux1
        ELSEIF L_Combo1 == .T.
			      Form_Novo_Generic.Combo_1.Value :=  nCodigo_Funcao1        
        ENDIF
        
        IF L_Combo2 == .F. 
            Form_Novo_Generic.Generic_Aux2.Value := cAux2
        ELSEIF L_Combo2 == .T. 
			      Form_Novo_Generic.Combo_2.Value :=  nCodigo_Funcao2
			  ENDIF
			  
			  IF L_Combo3 == .F. 
            Form_Novo_Generic.Generic_Aux3.Value := cAux3
        ELSEIF L_Combo3 == .T. 
			      Form_Novo_Generic.Combo_3.Value :=  nCodigo_Funcao3
			  ENDIF
			  
 			  IF L_Combo4 == .F. 
            Form_Novo_Generic.Generic_Aux4.Value := cAux4
        ELSEIF L_Combo4 == .T. 
			      Form_Novo_Generic.Combo_4.Value :=  nCodigo_Funcao4
			  ENDIF
			  
 			  IF L_Combo5 == .F. 
            Form_Novo_Generic.Generic_Aux5.Value := cAux5
        ELSEIF L_Combo5 == .T. 
			      Form_Novo_Generic.Combo_5.Value :=  nCodigo_Funcao5
			  ENDIF

			Form_Novo_Generic.DatePicker_1.Value := cData3
			Form_Novo_Generic.DatePicker_4.Value := cdata4
			Form_Novo_Generic.DatePicker_2.Value := cdata1
			Form_Novo_Generic.DatePicker_3.Value := cdata2
		ENDIF
		 
     

	EndIf

	*** Coloca na barra de Status do Formulário a variavel com informaç	ão de Alteração ou Inclusão
	Form_Novo_Generic.StatusBar.Item(1) := cStatus
	Form_Novo_Generic.Title := cTitulo

	*** Como o código é gerado pelo sistema, o campo código é desabilitado 
	 DISABLE CONTROL Generic_Codigo OF Form_Novo_Generic


	*** Pociociona o Cursor/Foco  no campo Descrição do Formulário
	Form_Novo_Generic.Generic_Descricao.SetFocus

	*** Centraliza Janela
	CENTER   WINDOW Form_Novo_Generic

	*** Ativa janela
	ACTIVATE WINDOW Form_Novo_Generic

Return NIL


************************************************************************************************************************************
Function Bt_Excluir_Generic()
************************************************************************************************************************************
    Local gCodigo     := AllTrim( PegaValorDaColuna(  "Grid_1P" , "Form_Cad_Generico" , 1 ) )
    Local gNome       := AllTrim( PegaValorDaColuna(  "Grid_1P" , "Form_Cad_Generico" , 2 ) )
    Local cQuery      := ""
    Local oQuery      :=""
                        
              If MsgYesNo( "Confirma Exclusão de: "+ gNome+ "??" ) 
                   cQuery     := "DELETE FROM "+cArea+"  WHERE CODIGO = " + AllTrim( gCodigo )         
                  oQuery  :=  oServer:Query( cQuery )
                   If oQuery:NetErr()												
                      MsgInfo("Erro na Exclusão (Delete): " + oQuery:Error())
                      Return Nil
                   EndIf
                   			 																			
                   MsgInfo(  "Registro Excluído !!" )
                   Renova_Pesquisa_Generic(Substr( gNome,1, 4)) 
             EndIf
	Return Nil

*----------------------------------------------------------------------------------------------------*
*	cPesq				= Recebe o valor do campo de pesquisa PesqGeneric sem espaços em branco
*	nTamanhoNomeParaPesquisa	= Guarda o tamanho da variável a ser pesquisada para comparar 
*	Local nQuantRegistrosProcessados	= Contador que controla quantos registros já foram lidos
*	Local nQuantMaximaDeRegistrosNoGrid = Limite de registros que serão mostrados no Grid
*----------------------------------------------------------------------------------------------------*
************************************************************************************************************************************
Function Pesquisa_Generic(nTipo)
************************************************************************************************************************************
			Local cPesq		:= ""
			Local cSel6		:= "Codigo"
      Local nContador	:= 0
      Local oRow     	:= {}
      Local oQuery    := ""
			Local cSelect   := ""
			Local cCampo 	:= Array(10)
      Local i         := 0
      Local QuantMaximaDeRegistrosNoGrid := 500 


	*** Exclui todos os Dados do Grid
	DELETE ITEM ALL FROM Grid_1P OF Form_Cad_Generico

		cCampo[1] := "Codigo"
		cCampo[2] := "descricao"
		cCampo[3] := "aux1"
		cCampo[4] := "aux2"
		cCampo[5] := "aux3"
		cCampo[6] := "dtcad"
		cCampo[7] := "aux4"
		cCampo[8] := "aux5"
		cCampo[9] := "data1"
		cCampo[10]:= "data2"
		
		
			*---- junta todos os campos separados por virgula
	for i:=1 to len(cCampo) 
		cSelect +=  cCampo[i] + ","
		//msginfo("Select " + cSelect )
	next
	*---- retira a ultima virgula adionada
	cSelect := Left(cSelect, Len(cSelect) -1)

//msginfo("Select comopleta" + cSelect )


				Conecta_Banco_De_Dados( cSQLDataBase )

IF nTipo == 1	
				      cPesq		:= ' "'+AllTrim(Form_Cad_Generico.PesqGeneric.Value )+'%" '&& cuidar espaços nas aspas com espaço map funciona "'/%"
      *----- Monta Objeto Query com Selecão
                oQuery := oServer:Query( "Select "+cSelect+" From "+ cArea +" WHERE Descricao LIKE "+cPesq+" Order By Descricao" ) 
				  			  
			*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado na tabela " +cArea+ +" - " + oQuery:Error())
                     //RELEASE WINDOW ALL
                     //Quit
					Endif
ENDIF
        	
IF nTipo == 2
				
 		    IF L_Combo1 == .F.
            cPesq	:= ' "'+AllTrim(Form_Cad_Generico.Text_1.Value )+'%" '&& cuidar espaços nas aspas com espaço map funciona "'/%"
        ELSEIF L_Combo1 == .T.
            IF  Alltrim(Form_Cad_Generico.Combo_1.DisplayValue) == "TODOS"
                cPesq := ' "%" ' 
            ELSE 
			          cPesq	:= ' "'+Alltrim(Form_Cad_Generico.Combo_1.DisplayValue)+'%" '
            ENDIF 
			  ENDIF

				       *----- Monta Objeto Query com Selecão
                oQuery := oServer:Query( "Select "+cSelect+" From "+ cArea +" WHERE aux1 LIKE "+cPesq+" Order By Descricao" ) 
				  			  
			*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado na tabela " +cArea+ +" - "  + oQuery:Error())
                     //RELEASE WINDOW ALL
                     //Quit
					Endif
ENDIF
				
IF nTipo == 3
				
 		    IF L_Combo2 == .F.
            cPesq		:= ' "'+AllTrim(Form_Cad_Generico.Text_2.Value )+'%" '&& cuidar espaços nas aspas com espaço map funciona "'/%"
        ELSEIF L_Combo2 == .T.
            IF  Alltrim(Form_Cad_Generico.Combo_2.DisplayValue) == "TODOS"
                cPesq := ' "%" ' 
            ELSE 
			          cPesq	:= ' "'+Alltrim(Form_Cad_Generico.Combo_2.DisplayValue)+'%" '
            ENDIF 
			  ENDIF

				       *----- Monta Objeto Query com Selecão
                oQuery := oServer:Query( "Select "+cSelect+" From "+ cArea +" WHERE aux2 LIKE "+cPesq+" Order By Descricao" ) 
				  			  
			*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado na tabela " +cArea+ +" - " + oQuery:Error())
                     //RELEASE WINDOW ALL
                     //Quit
					Endif
ENDIF
					
IF nTipo == 4
 		   
        IF L_Combo3 == .F.
            cPesq		:= ' "'+AllTrim(Form_Cad_Generico.Text_3.Value )+'%" '&& cuidar espaços nas aspas com espaço map funciona "'/%"
        ELSEIF L_Combo3 == .T. 
            IF  Alltrim(Form_Cad_Generico.Combo_3.DisplayValue) == "TODOS"
                cPesq := ' "%" ' 
            ELSE 
			          cPesq	:= ' "'+Alltrim(Form_Cad_Generico.Combo_3.DisplayValue)+'%" ' 
            ENDIF
			  ENDIF

				       *----- Monta Objeto Query com Selecão
                oQuery := oServer:Query( "Select "+cSelect+" From "+ cArea +" WHERE aux3 LIKE "+cPesq+" Order By Descricao" ) 
				  			  
			*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado na tabela " +cArea+ +" - " + oQuery:Error())
                     //RELEASE WINDOW ALL
                     //Quit
					Endif
ENDIF
				
IF nTipo == 5

        IF L_Combo4 == .F.
            cPesq		:= ' "'+AllTrim(Form_Cad_Generico.Text_4.Value )+'%" '&& cuidar espaços nas aspas com espaço map funciona "'/%"
        ELSEIF L_Combo4 == .T.
            IF  Alltrim(Form_Cad_Generico.Combo_4.DisplayValue) == "TODOS"
                cPesq := ' "%" ' 
            ELSE 
    			      cPesq	:= ' "'+Alltrim(Form_Cad_Generico.Combo_4.DisplayValue)+'%" '
            ENDIF 
			  ENDIF

				       *----- Monta Objeto Query com Selecão
                oQuery := oServer:Query( "Select "+cSelect+" From "+ cArea +" WHERE aux4 LIKE "+cPesq+" Order By Descricao" ) 
				  			  
			*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado na tabela " +cArea+ +" - " + oQuery:Error())
                     //RELEASE WINDOW ALL
                     //Quit
					Endif
ENDIF
					
IF nTipo == 6

        IF L_Combo5 == .F.
            cPesq		:= ' "'+AllTrim(Form_Cad_Generico.Text_5.Value )+'%" '&& cuidar espaços nas aspas com espaço map funciona "'/%"
        ELSEIF L_Combo5 == .T.
            IF  Alltrim(Form_Cad_Generico.Combo_5.DisplayValue) == "TODOS"
                cPesq := ' "%" ' 
            ELSE 
			          cPesq	:= ' "'+Alltrim(Form_Cad_Generico.Combo_5.DisplayValue)+'%" '
			      ENDIF
			  ENDIF

				       *----- Monta Objeto Query com Selecão
                oQuery := oServer:Query( "Select "+cSelect+" From "+ cArea +" WHERE aux5 LIKE "+cPesq+" Order By Descricao" ) 
				  			  
			*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado na tabela " +cArea+ +" - " + oQuery:Error())
                     //RELEASE WINDOW ALL
                     //Quit
					Endif
ENDIF
					
IF nTipo == 71
				
        cPesq1		:= ' "'+ Data_BRITISH_ANSI(Form_Cad_Generico.DatePicker_2.Value )+'" '&& cuidar espaços nas aspas com espaço map funciona "'/%"
				       *----- Monta Objeto Query com Selecão
                oQuery := oServer:Query( "Select "+cSelect+" From "+ cArea +" WHERE data1 = "+ cPesq1 +" Order By Descricao" ) 
				  			  
			*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado na tabela " +cArea+ +" - " + oQuery:Error())
                     //RELEASE WINDOW ALL
                     //Quit
					Endif
ENDIF
					
IF nTipo == 72
				cPesq2		:= ' "'+ Data_BRITISH_ANSI(Form_Cad_Generico.DatePicker_3.Value )+'" '&& cuidar espaços nas aspas com espaço map funciona "'/%"
				       *----- Monta Objeto Query com Selecão
                oQuery := oServer:Query( "Select "+cSelect+" From "+ cArea +" WHERE data2 = "+ cPesq2 +" Order By Descricao" ) 
				  			  
			*----- Verifica se ocorreu algum erro na Pesquisa
					If oQuery:NetErr()												
                     MsgInfo("Registro não Encontrado na tabela " +cArea+ +" - " + oQuery:Error())
                     //RELEASE WINDOW ALL
                     //Quit
					Endif
	ENDIF

               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
 
				*----- Adiciona Registros no Grid
				  //{"Código","Descrição",cLb1,cLb2,cLb3,cLb4,cLb5,cLb6,cLb7}
         ADD ITEM {  Str( oRow:fieldGet(1) , 8 )  , oRow:fieldGet(2), oRow:fieldGet(3), oRow:fieldGet(4), oRow:fieldGet(5),oRow:fieldGet(7),oRow:fieldGet(8) ,DTOC( oRow:fieldGet(9) ),DTOC( oRow:fieldGet(10) )   } TO Grid_1P Of  Form_Cad_Generico
                       
                        oQuery:Skip(1)
               Next

	MODIFY CONTROL Frame_1 OF Form_Cad_Generico Caption	'Itens :'+TransForm( nContador , "9999")
	       
	*** Pisiciona o cursor/Foco no campo PesqGeneric		
	Form_Cad_Generico.PesqGeneric.SetFocus
	Return Nil

*----------------------------------------------------------------------------------------------------*
*	Recebe um parâmetro com o nome a ser pesquisado, colocar os Dez primeiros caracteres no PesqGeneric e
*	retorna para a rotina Pesquisa_Generic()
*----------------------------------------------------------------------------------------------------*
************************************************************************************************************************************
Function Renova_Pesquisa_Generic(cNome)
************************************************************************************************************************************

	Form_Cad_Generico.PesqGeneric.Value := Substr(AllTrim(cNome),1,10)
	Form_Cad_Generico.PesqGeneric.SetFocus
	Pesquisa_Generic(1)
	Return Nil


************************************************************************************************************************************
Function Bt_Salvar_Generic()
************************************************************************************************************************************
	Local gCodigo := PegaValorDaColuna( "Grid_1P" , "Form_Cad_Generico" , 1 )
	Local aStruc := {}
	Local cValues := ""
	Local aUpdate := {}
	Local cUpdate := ""
	Local cCodigo := ""
  Local cQuery  := "" 
	Local cPesq	:= AllTrim( Form_Cad_Generico.PesqGeneric.Value )
	Local cAux1 :=""
	Local cAux2 :=""
	Local cAux3 :=""
	Local cAux4 :=""
	Local cAux5 :=""
	Local oQuery:=""
	lOCAL data1 := Date()
	lOCAL data2 := Date()
	lOCAL dtcad := Date()
	
	//msginfo(cArea)


	*** Se o campo Descricao não for informados, enviar mensagem e posiciona cursor/Foco no campo Generic_Descricao 
	If Empty( Form_Novo_Generic.Generic_Descricao.Value  )
		PlayExclamation()
		MSGINFO("Descrição não Informada !!","Operação Inválida")
		Form_Novo_Generic.Generic_Descricao.SetFocus
		Return Nil
	EndIf

If lNovo == .T.

IF nSis == 1

		      
		    IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
		
    ELSEIF nSis == 2
		    
        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF

		ELSEIF nSis == 3

        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF

		ELSEIF nSis == 4
        
        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo4 == .F.
            cAux4	:= Form_Novo_Generic.Generic_Aux4.Value
        ELSEIF L_Combo4 == .T. 
			      cAux4	:= Alltrim(Form_Novo_Generic.Combo_4.DisplayValue)
			  ENDIF

		ELSEIF nSis == 5
       
        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo4 == .F.
            cAux4	:= Form_Novo_Generic.Generic_Aux4.Value
        ELSEIF L_Combo4 == .T. 
			      cAux4	:= Alltrim(Form_Novo_Generic.Combo_4.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo5 == .F.
            cAux5	:= Form_Novo_Generic.Generic_Aux5.Value
        ELSEIF L_Combo5 == .T. 
			      cAux5	:= Alltrim(Form_Novo_Generic.Combo_5.DisplayValue)
			  ENDIF			  

		ELSEIF nSis == 6
        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo4 == .F.
            cAux4	:= Form_Novo_Generic.Generic_Aux4.Value
        ELSEIF L_Combo4 == .T. 
			      cAux4	:= Alltrim(Form_Novo_Generic.Combo_4.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo5 == .F.
            cAux5	:= Form_Novo_Generic.Generic_Aux5.Value
        ELSEIF L_Combo5 == .T. 
			      cAux5	:= Alltrim(Form_Novo_Generic.Combo_5.DisplayValue)
			  ENDIF		
			data1  := Form_Novo_Generic.DatePicker_2.Value
			
			
			
		ELSEIF nSis == 7
        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo4 == .F.
            cAux4	:= Form_Novo_Generic.Generic_Aux4.Value
        ELSEIF L_Combo4 == .T. 
			      cAux4	:= Alltrim(Form_Novo_Generic.Combo_4.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo5 == .F.
            cAux5	:= Form_Novo_Generic.Generic_Aux5.Value
        ELSEIF L_Combo5 == .T. 
			      cAux5	:= Alltrim(Form_Novo_Generic.Combo_5.DisplayValue)
			  ENDIF		
			data1 := Form_Novo_Generic.DatePicker_2.Value
			data2 := Form_Novo_Generic.DatePicker_3.Value
ENDIF

    aInsert  := Array(14)
		aInsert[1] := Alltrim( STR(GeraCodigo(cArea) ))
		aInsert[2] := Form_Novo_Generic.Generic_Descricao.Value
		aInsert[3] := ""
		aInsert[4] :="0"
		aInsert[5]  := Alltrim(Data_BRITISH_ANSI(Date() ))
		aInsert[6]  := Alltrim(Data_BRITISH_ANSI(Date() ))
		aInsert[7]  := db_apelido
		aInsert[8]  := cAux1
		aInsert[9]  := cAux2
		aInsert[10] := cAux3
		aInsert[11] := cAux4
		aInsert[12] := cAux5
		aInsert[13] := IIF(nSis == 6 .OR. nSis == 7, Alltrim(Data_BRITISH_ANSI(data1)),"0000-00-00")
		aInsert[14]:= IIF(nSis == 6 .OR. nSis == 7, Alltrim(Data_BRITISH_ANSI(data2)),"0000-00-00")
      
      
               aStruc  := Array(14)
               aStruc[1] := "codigo"
					aStruc[2] := "descricao"
					aStruc[3] := "tipo"
					aStruc[4] := "valor"
               aStruc[5] := "dtcad"
					aStruc[6] := "dtalt"
					aStruc[7] := "usuario"
					aStruc[8] := "aux1"
					aStruc[9] := "aux2"
					aStruc[10] := "aux3"
					aStruc[11] := "aux4"
					aStruc[12] := "aux5"
					aStruc[13] := "data1"
					aStruc[14] := "data2"
		

				Conecta_Banco_De_Dados( cSQLDataBase )

		
						cValues := MysqlQueryInsert(aInsert,aStruc)
                  cQuery:= "INSERT INTO "+ cArea +" " + cValues 
                  MSGExclamation("Inclusão Efetivada no "+cTitulo,"SISTEMA")
		
		*** Se for um Novo registro
		*** Verifica se Usuário tem permissão para Incluir Registros
		If ! NoInclui( db_status )
			MsgNo( "INCLUIR")
			Return Nil
		EndIf
		
		
Else   &&Se estiver alterando registro         
	
		*** Se estiver alterando registro
		*** Verifica se usuário atual tem permissão para Alterar registros
		If ! NoAltera( db_status )
			MsgNo( "ALTERAR")
			Return Nil
		EndIf


IF nSis == 1

		      
		    IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
		
    ELSEIF nSis == 2
		    IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF

		ELSEIF nSis == 3
		    IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF

		ELSEIF nSis == 4
		    IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF

 		    IF L_Combo4 == .F.
            cAux4	:= Form_Novo_Generic.Generic_Aux4.Value
        ELSEIF L_Combo4 == .T. 
			      cAux4	:= Alltrim(Form_Novo_Generic.Combo_4.DisplayValue)
			  ENDIF			  

		ELSEIF nSis == 5
		    
        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF

 		    IF L_Combo4 == .F.
            cAux4	:= Form_Novo_Generic.Generic_Aux4.Value
        ELSEIF L_Combo4 == .T. 
			      cAux4	:= Alltrim(Form_Novo_Generic.Combo_4.DisplayValue)
			  ENDIF
        
 		    IF L_Combo5 == .F.
            cAux5	:= Form_Novo_Generic.Generic_Aux5.Value
        ELSEIF L_Combo5 == .T. 
			      cAux5	:= Alltrim(Form_Novo_Generic.Combo_5.DisplayValue)
			  ENDIF	

		ELSEIF nSis == 6
        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF

 		    IF L_Combo4 == .F.
            cAux4	:= Form_Novo_Generic.Generic_Aux4.Value
        ELSEIF L_Combo4 == .T. 
			      cAux4	:= Alltrim(Form_Novo_Generic.Combo_4.DisplayValue)
			  ENDIF
        
 		    IF L_Combo5 == .F.
            cAux5	:= Form_Novo_Generic.Generic_Aux5.Value
        ELSEIF L_Combo5 == .T. 
			      cAux5	:= Alltrim(Form_Novo_Generic.Combo_5.DisplayValue)
			  ENDIF	
			data1  := Form_Novo_Generic.DatePicker_2.Value
			
			
			
		ELSEIF nSis == 7
        IF L_Combo1 == .F.
            cAux1	:= Form_Novo_Generic.Generic_Aux1.Value
        ELSEIF L_Combo1 == .T. 
			      cAux1	:= Alltrim(Form_Novo_Generic.Combo_1.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo2 == .F.
            cAux2	:= Form_Novo_Generic.Generic_Aux2.Value
        ELSEIF L_Combo2 == .T. 
			      cAux2	:= Alltrim(Form_Novo_Generic.Combo_2.DisplayValue)
			  ENDIF
			  
 		    IF L_Combo3 == .F.
            cAux3	:= Form_Novo_Generic.Generic_Aux3.Value
        ELSEIF L_Combo3 == .T. 
			      cAux3	:= Alltrim(Form_Novo_Generic.Combo_3.DisplayValue)
			  ENDIF

 		    IF L_Combo4 == .F.
            cAux4	:= Form_Novo_Generic.Generic_Aux4.Value
        ELSEIF L_Combo4 == .T. 
			      cAux4	:= Alltrim(Form_Novo_Generic.Combo_4.DisplayValue)
			  ENDIF
        
 		    IF L_Combo5 == .F.
            cAux5	:= Form_Novo_Generic.Generic_Aux5.Value
        ELSEIF L_Combo5 == .T. 
			      cAux5	:= Alltrim(Form_Novo_Generic.Combo_5.DisplayValue)
			  ENDIF	
			data1 := Form_Novo_Generic.DatePicker_2.Value
			data2 := Form_Novo_Generic.DatePicker_3.Value
ENDIF
		
    aUpdate  := Array(14)
		aUpdate[1] := Form_Novo_Generic.Generic_Codigo.Value
		aUpdate[2] := Form_Novo_Generic.Generic_Descricao.Value
		aUpdate[3] := ""
		aUpdate[4] := "0"
		aUpdate[5]  := Alltrim(Data_BRITISH_ANSI(Date() ))
		aUpdate[6]  := Alltrim(Data_BRITISH_ANSI(Date() ))
		aUpdate[7]  := db_apelido
		aUpdate[8]  := cAux1
		aUpdate[9]  := cAux2
		aUpdate[10] := cAux3
		aUpdate[11] := cAux4
		aUpdate[12] := cAux5
		aUpdate[13] := IIF(nSis == 6 .OR. nSis == 7, Alltrim(Data_BRITISH_ANSI(data1)),"0000-00-00")
		aUpdate[14] := IIF(nSis == 6 .OR. nSis == 7, Alltrim(Data_BRITISH_ANSI(data2)),"0000-00-00")
		

		//msginfo("ALTERANDO" )
      
               aStruc  := Array(14)
               aStruc[1] := "codigo"
					aStruc[2] := "descricao"
					aStruc[3] := "tipo"
					aStruc[4] := "valor"
               aStruc[5] := "dtcad"
					aStruc[6] := "dtalt"
					aStruc[7] := "usuario"
					aStruc[8] := "aux1"
					aStruc[9] := "aux2"
					aStruc[10] := "aux3"
					aStruc[11] := "aux4"
					aStruc[12] := "aux5"
					aStruc[13] := "data1"
					aStruc[14] := "data2"


               cUpdate := MysqlQueryUpDate(aUpdate,aStruc)
               cQuery := "UPDATE "+ cArea +" SET " + cUpdate + " WHERE CODIGO = " + AllTrim( gCodigo )
					MSGExclamation("Alteração Efetivada no "+cTitulo,"SISTEMA")				
					
		
EndIf
	
			//msginfo("testes  final " + cQuery )
              
	oQuery  :=  oServer:Query( cQuery )
			  
              If oQuery:NetErr()												
                 MsgInfo("Erro na Alteração (UpDate): " + oQuery:Error())
                 Return Nil
               Endif				

              // MsgInfo( Iif( lNovo == .T. , "Registro Incluído", "Registro Alterado!!" ) )
      IF lNovo == .T.
				*** Refresh Grid
				Renova_Pesquisa_Generic(Substr( aInsert[2],1,10))
      ELSE 
            Renova_Pesquisa_Generic(Substr( aUpdate[2],1,10))
            
      ENDIF
        Form_Cad_Generico.PesqGeneric.SetFocus
				*** Release no Form
				lNovo    := .F.				
				Form_Novo_Generic.Release

Return Nil

***************************************************************************************************************************
Function Bt_Generic_Sair()
***************************************************************************************************************************
  Form_Cad_Generico.Release
Return


***************************************************************************************************************************
Function GenericOpen( cSQLDataBase ,oTabela , LPack )
***************************************************************************************************************************

      Local i                     := 0
      Local aTabelasExistentes    := {}                                           
      Local aStruc      := {}      
      Local cQuery      :=""
      Local oQuery      :=""
			Local cPrimaryKey := NIL				&& E o campo que sera a chave primaria de indice 
			Local cUniqueKey  := NIL			&& E o campo que sera a unico 
			Local cAuto 	  := NIL				 	 
              

				Conecta_Banco_De_Dados( cSQLDataBase )
				
			  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!") ; Return Nil ; EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
                   aTabelasExistentes  := oServer:ListTables()

              *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("Erro verificando Lista de Tabelas / <TMySQLServer> " + oServer:Error(),"SISTEMA" )
                     Release Window ALL
                    Quit
                  Endif 
				
              *----- Verifica se na Array aTabelasExistentes tem a Tabela
                  If hb_AScan( aTabelasExistentes, Lower(oTabela),,,.T. ) != 0
                     //MsgINFO( "Tabela "+oTabela+" Já Existe!!")

                     Return Nil
                  EndIf 


		*** Se arquivo não existe, cria
			aStruc := array(14)
			astruc[1]  := { 'codigo'	 , 'N' , 05 , 0 }
			astruc[2]  := { 'descricao'	 , 'C' , 250, 0 }
			astruc[3]  := { 'tipo'		 , 'C' , 01 , 0 }
			astruc[4]  := { 'valor'		 , 'N' , 12 , 2 }
			astruc[5]  := { 'dtcad'		 , 'D' , 08 , 0 }
			astruc[6]  := { 'dtalt'		 , 'D' , 08 , 0 }
			astruc[7]  := { 'usuario'	 , 'C' , 100 , 0 }
			astruc[8]  := { 'aux1'       , 'C' , 250 , 0 }
			astruc[9]  := { 'aux2'       , 'C' , 250 , 0 }
			astruc[10] := { 'aux3'       , 'C' , 250 , 0 }
			astruc[11] := { 'aux4'       , 'C' , 250 , 0 }
			astruc[12] := { 'aux5'       , 'C' , 250 , 0 }
			astruc[13] := { 'data1'		 , 'D' , 08 , 0 }
			astruc[14] := { 'data2'		 , 'D' , 08 , 0 }
			
			oServer:CreateTable(oTabela, aStruc,cPrimaryKey,cUniqueKey,cAuto)
			
			  *-----  Verifica se ocorreu algum erro
                   If oServer:NetErr() 
                     MsGInfo("Erro Criando Tabela "+oTabela+" / <TMySQLServer> " + oServer:Error(),"SISTEMA" )
                     Release Window ALL		
                    Quit
                  Endif 

              *-----  Elimina Objeto Query
							
                  MsgInfo("Tabela [ "+oTabela+" ] Criada com Sucesso!!" )  
             
     
Return Nil     