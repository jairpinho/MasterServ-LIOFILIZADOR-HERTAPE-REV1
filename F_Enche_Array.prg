#include <hmg.ch>
DECLARE WINDOW Form_OS
DECLARE WINDOW Form_Novo_OS
DECLARE WINDOW  Form_Progresso
DECLARE WINDOW Form_Novo_Produto

*********************************************************************************************************************************************************************
Function EncheArray( nTipo,aEspecialidade,aMaquina,aC_Custo,aManutentor,aGRupo,aTurno,aConjunto,aSubConjunto,aTipoMan ,aRequisitantes,aContaContabil,aGrupoEstoque,aProjetos,aEmpresas,aFabricantes,aUnidade_medidas,aPrioridades, aCidades, aEstados, aFrequencia,aSolicitantes,aManutentores,aDepartamento,aFuncao,aEquip_Improd)
*********************************************************************************************************************************************************************
			Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid := 10000

            
			Local cTB_Especialidade		:= "especialidade"
			Local cTB_Maquina 	 		:= "maquinas"
			Local cTB_C_Custo			:= "centro_custo_contabil"
			Local cTB_Manutentor 		:= "manutentores"
			Local cTB_Grupo	 			:= "grupo_maquinas"
			Local cTB_Turno 	 		   := "turno"
			Local cTB_Conjunto 	 		:= "conjunto"
			Local cTB_Subconjunto 		:= "subconjunto"
			Local cTB_TipoMan	 		:= "tipo_manutencao"
			Local cTB_Requisitante 		:= "requisitantes"
			Local cTB_ContaContabil		:= "conta_contabil"
			Local cTB_GrupoEstoque 		:= "grupo_estoque"
			Local cTB_Projetos			:= "projetos"
			Local cTB_Empresas		 	:= "empresas"
			Local cTB_Fabricantes		:= "fabricantes"
			Local cTB_Unidade_medidas	:= "unidade_medida"
			Local cTB_Prioridades		:= "prioridades"
			Local cTB_Cidades			:= "cidades"
			Local cTB_Estados			:= "estados"
			Local cTB_Frequencia	      := "frequencia"
			Local cTB_Solicitantes     :="solicitantes"
			Local cTB_Departamento     :="departamento"
			Local cTB_Funcao          :="funcao"
			Local cTB_Equip_Improd     := "equip_improd"
			
			
			aManutentor	:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			aTurno		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			aMaquina		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			aConjunto		:= {}
			aSubConjunto	:= {}
			aEspecialidade	:= {}
			aTipoMan		:= {}
			aC_Custo		:= {}
			aGRupo			:= {}
			aRequisitantes	:= {}
			aContaContabil	:= {}
			aGrupoEstoque	:= {}
			aProjetos		:= {}
			aEmpresas		:= {}
			aFabricantes	:= {}
			aUnidade_medidas := {}
			aPrioridades 	:= {}
			aCidades 		:= {}
			aEstados	 	:= {}
			aFrequencia	 	:= {}
			aManutentores :={}
			aSolicitantes :={}
			aDepartamento := {}
			aFuncao       := {}
			aEquip_Improd := {}
			
				IF nTipo == 3
					DELETE ITEM ALL FROM Cb_Manutentor OF Form_OS
					DELETE ITEM ALL FROM Cb_Maquina OF Form_OS
					DELETE ITEM ALL FROM Cb_Requisitante OF Form_OS		
				Endif
				
				
			  *-----  Verifica se esta conectado ao MySql
          If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf

  
              *-----  Antes de criar Verifica se a Tabela  já existe
                   IF Empty(aTabelasExistentes)
                      aTabelasExistentes  := oServer:ListTables()
                      
                                    *-----  Verifica se ocorreu algum erro 
                      If oServer:NetErr() 
                        MsGInfo("verificando Lista de Tabelas EncheArray() " + oServer:Error(),"SISTEMA" )
					               return
                      Endif 
                  
                   ENDIF



*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Especialidade
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Especialidade) )
//msginfo("cTB_Especialidade  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Especialidade) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Especialidade +" Order By descricao" ) 
	*** Adciona um registro "TODOS"  caso o Usuário queira escolher todas as maquinas
	Aadd( aEspecialidade ,  "TODOS" )		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Especialidade + " ) " + oQuery:Error())
            Return Nil
		Endif
								
            For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aEspecialidade ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aEspecialidade ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
  				
			
ENDIF				

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Maquina
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Maquina) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Maquina +" Order By descricao" ) 
	
	*** Adciona um registro "TODOS"  caso o Usuário queira escolher todas as maquinas
	Aadd( aMaquina ,  "TODOS" )
	
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray(" + cTB_Maquina + " ) " + oQuery:Error())
            Return Nil
		Endif
						
							//MSGINFO("Maquinas " + STR(oQuery:LastRec()) )
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aMaquina ,  oRow:fieldGet(2)  )
									oQuery:Skip(1)
 
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aMaquina ,  oRow:fieldGet(2)  )
							//MSGINFO("Maquina " + aMaquina[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
  
ENDIF

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_C_Custo
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_C_Custo) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_C_Custo +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_C_Custo + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aC_Custo ,  oRow:fieldGet(2)  )
									oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aC_Custo ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        

ENDIF
			
*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Manutentor
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Manutentor) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Manutentor +" Order By descricao" ) 

	*** Adciona um registro "TODOS"  caso o Usuário queira escolher todas as maquinas
	Aadd( aManutentor ,  "TODOS" )
	Aadd( aManutentores ,  "TODOS" )

		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Manutentor + " ) " + oQuery:Error())
            Return Nil
		Endif

               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
							Aadd( aManutentor , oRow:fieldGet(2) )
							Aadd( aManutentores, oRow:fieldGet(10) )
							
							oQuery:Skip(1)
						Elseif nTipo ==2
							*----- Adiciona Registros no Grid
							Aadd( aManutentor , oRow:fieldGet(2) )
              Aadd( aManutentores, oRow:fieldGet(10) )
							

							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

              *-----  Elimina Objeto Query
        
		
ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Funcao
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Funcao) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Funcao +" Order By descricao" ) 

	*** Adciona um registro "TODOS"  caso o Usuário queira escolher todas as maquinas

	Aadd( aFuncao ,  "TODOS" )


		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Funcao + " ) " + oQuery:Error())
            Return Nil
		Endif

               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1

							Aadd( aFuncao, oRow:fieldGet(2) )

							
							oQuery:Skip(1)
						Elseif nTipo ==2
							*----- Adiciona Registros no Grid
							Aadd( aFuncao, oRow:fieldGet(2) )
 
							

							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

              *-----  Elimina Objeto Query
        
		
ENDIF

		
*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Grupo
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Grupo) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Grupo +" Order By descricao" ) 
	*** Adciona um registro "TODOS"  caso o Usuário queira escolher todas as maquinas
	Aadd( aGrupo ,  "TODOS" )
	  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Grupo + " ) " + oQuery:Error())
            Return Nil
		Endif
							
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
							Aadd( aGrupo ,  oRow:fieldGet(2)  )
              				oQuery:Skip(1)		
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aGrupo ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        	
		
ENDIF		
		

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Turno
*----------------------------------------------------------------------------------------------------*


If hb_Ascan( aTabelasExistentes, Lower(cTB_Turno) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Turno +" Order By descricao" ) 

	*** Adciona um registro "TODOS"  caso o Usuário queira escolher todas as maquinas
	Aadd( aTurno ,  "TODOS" )
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray(" + cTB_Turno + " ) "  + oQuery:Error())
            Return Nil
		Endif
							

               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aTurno ,  oRow:fieldGet(2)  )
              						oQuery:Skip(1) 
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aTurno ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

              *-----  Elimina Objeto Query
        
		
ENDIF




*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Conjunto
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Conjunto) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Conjunto +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Conjunto +" ) " + oQuery:Error())
			Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
								Aadd( aConjunto ,  oRow:fieldGet(2)  )
              					oQuery:Skip(1)	
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aConjunto ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        
ENDIF		
		
*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Subconjunto
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Subconjunto) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Subconjunto +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Subconjunto +" ) " + oQuery:Error())
        Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aSubConjunto ,  oRow:fieldGet(2)  )
              						oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aSubConjunto ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        
ENDIF
	

		
*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_TipoMan
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_TipoMan) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_TipoMan +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_TipoMan +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aTipoMan ,  oRow:fieldGet(2)  )
              						oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aTipoMan ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		

ENDIF

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Requisitantes
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Requisitante) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Requisitante +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Requisitante +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aRequisitantes ,  oRow:fieldGet(2)  )
              						oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aRequisitantes ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		

ENDIF		

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_ContaContabil
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_ContaContabil) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_ContaContabil +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_ContaContabil +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aContaContabil ,  oRow:fieldGet(2)  )
              						oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aContaContabil ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		
		
		
ENDIF		
		
*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_GrupoEstoque
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_GrupoEstoque) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_GrupoEstoque +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_GrupoEstoque +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aGrupoEstoque ,  oRow:fieldGet(2)  )
              						oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aGrupoEstoque ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		

ENDIF		
	

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Projetos
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Projetos) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Projetos +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Projetos +" ) "  + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aProjetos ,  oRow:fieldGet(2)  )
              						oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aProjetos ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		

		
ENDIF
	
*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Empresas
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Empresas) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Empresas +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Empresas +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
								Aadd( aEmpresas ,  oRow:fieldGet(2)  )
              					oQuery:Skip(1)	
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aEmpresas ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		

ENDIF		
		
*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Fabricantes
*----------------------------------------------------------------------------------------------------*
 
*----- Verifica se na Array aTabelasExistentes tem a Tabela
If hb_Ascan( aTabelasExistentes, Lower(cTB_Fabricantes) ,,,.T.) != 0
 
	oQuery := oServer:Query( "Select * From "+ cTB_Fabricantes +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Fabricantes +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
								Aadd( aFabricantes ,  oRow:fieldGet(2)  )
              					oQuery:Skip(1)	
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aFabricantes ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		

Endif
*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Unidade_medidas
*----------------------------------------------------------------------------------------------------*

If hb_Ascan( aTabelasExistentes, Lower(cTB_Unidade_medidas) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Unidade_medidas +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Unidade_medidas +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
								Aadd( aUnidade_medidas ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)		
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aUnidade_medidas ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		

ENDIF

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Prioridades
*----------------------------------------------------------------------------------------------------*


				
*----- Verifica se na Array aTabelasExistentes tem a Tabela
If hb_Ascan( aTabelasExistentes, Lower(cTB_Prioridades) ,,,.T.) != 0
                     
                  
    
	oQuery := oServer:Query( "Select * From "+ cTB_Prioridades +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Prioridades +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aPrioridades ,  oRow:fieldGet(2)  )
									oQuery:Skip(1)	
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aPrioridades ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		
Endif
		
*----- Verifica se na Array aTabelasExistentes tem a Tabela
If hb_Ascan( aTabelasExistentes, Lower(cTB_Cidades) ,,,.T.) != 0
                     
                  
    
	oQuery := oServer:Query( "Select * From "+ cTB_Cidades +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Cidades +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aCidades ,  oRow:fieldGet(2)  )
									oQuery:Skip(1)	
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aCidades ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aCidades[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		
Endif		
		
*----- Verifica se na Array aTabelasExistentes tem a Tabela
If hb_Ascan( aTabelasExistentes, Lower(cTB_Estados) ,,,.T.) != 0
                     
                  
    
	oQuery := oServer:Query( "Select * From "+ cTB_Estados +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Estados +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aEstados ,  oRow:fieldGet(2)  )
									oQuery:Skip(1)	
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aEstados ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        		
Endif		
		
		
*----- Verifica se na Array aTabelasExistentes tem a Tabela
If hb_Ascan( aTabelasExistentes, Lower(cTB_Frequencia) ,,,.T.) != 0
                     
                  
    
	oQuery := oServer:Query( "Select * From "+ cTB_Frequencia +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Frequencia +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aFrequencia ,  oRow:fieldGet(2)  )
									oQuery:Skip(1)	
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd(aFrequencia ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aFrequencia_Preventiva[i] )
							oQuery:Skip(1)
						Endif
               Next

Endif

If hb_Ascan( aTabelasExistentes, Lower(cTB_Solicitantes) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Solicitantes +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Erro de Pesquisa (Grid) (Select): EncheArray( " + cTB_Solicitantes + " ) " + oQuery:Error())
            Return Nil
		Endif

               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
							Aadd( aSolicitantes , oRow:fieldGet(2) )
							//Aadd( aManutentores, oRow:fieldGet(10) )
							oQuery:Skip(1)
						Elseif nTipo ==2
							*----- Adiciona Registros no Grid
							Aadd( aSolicitantes , oRow:fieldGet(2) )
						//	Aadd( aManutentores, oRow:fieldGet(10) )
						//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		
ENDIF		

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Departamento
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Departamento) )
//msginfo("cTB_Departamento  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Departamento) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Departamento +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Departamento + " ) " + oQuery:Error())
            Return Nil
		Endif
		Aadd( aDepartamento ,  "TODOS" )							
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aDepartamento ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aDepartamento ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

 ENDIF
**---------------------------------------------------------------------------------------------------------------------**		

		IF nTipo ==3
			Form_OS.Cb_Manutentor.Value := 1
			Form_OS.Cb_Maquina.Value := 1
			Form_OS.Cb_Requisitante.Value := 1
		Endif


*----- Verifica se na Array aTabelasExistentes tem a Tabela
If hb_Ascan( aTabelasExistentes, Lower(cTB_Equip_Improd) ,,,.T.) != 0
                     
                  
    
	oQuery := oServer:Query( "Select * From "+ cTB_Equip_Improd +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Erro de Pesquisa (Grid) (Select): EncheArray( " + cTB_Equip_Improd +" ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
									Aadd( aEquip_Improd ,  oRow:fieldGet(2)  )
									oQuery:Skip(1)	
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aEquip_Improd ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

Endif	



Return


*********************************************************************************************************************************************************************
Function EncheArray_Clientes( nTipo,aClientes)
*********************************************************************************************************************************************************************
		Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid := 10000
		Local cTB_Clientes		:= "clientes"
 
			
			aClientes   := {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
              IF Empty(aTabelasExistentes)              
                   aTabelasExistentes  := oServer:ListTables()
                   
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas EncheArray_Clientes / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
              ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Clientes
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Clientes) )
//msginfo("cTB_Clientes  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Clientes) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Clientes +" Order By nome" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Clientes + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aClientes ,  oRow:fieldGet(3)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aClientes ,  oRow:fieldGet(3)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next
		*-----  Elimina Objeto Query

ENDIF			
			

Return


*********************************************************************************************************************************************************************
Function EncheArray_EletroEletronicos( nTipo,aArmario)
*********************************************************************************************************************************************************************
			Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid := 10000
			Local cTB_Armario		:= "armarios"
		                
			aArmario	:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			

		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
                IF Empty(aTabelasExistentes)              
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                   
                ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Armario
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Armario )
//msginfo("cTB_Armarioo  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Armario) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Armario +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Armario + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aArmario ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aArmario ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        				
			
ENDIF			
			

Return


*********************************************************************************************************************************************************************
Function EncheArray_Produtos( nTipo,aMateriais)
*********************************************************************************************************************************************************************
		Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid := 10000
			Local cTB_Materiais		:= "materiais"
 
			
			aMateriais		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
                IF Empty(aTabelasExistentes)
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas EncheArray_Materiais / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
                ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Clientes
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Clientes) )
//msginfo("cTB_Clientes  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Materiais) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Materiais +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Materiais + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						        IF nTipo ==1
                    		Aadd( aMateriais , Alltrim(oRow:fieldGet(2)) )
								        oQuery:Skip(1)
						        Elseif nTipo == 2
							           *----- Adiciona Registros no Grid
              					Aadd( aMateriais , Alltrim(oRow:fieldGet(2)) )
							           //MSGINFO("MANUTENTOR " + aManutentor[i] )
							           oQuery:Skip(1)
						        Endif
               Next

		*-----  Elimina Objeto Query
        				
			
ENDIF			
			

Return

*********************************************************************************************************************************************************************
Function EncheArray_Componentes(nTipo,aComponentes)
*********************************************************************************************************************************************************************
			Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid :=10000
			Local cTB_Componentes		:= "componentes_maquina"
 
			
			aComponentes		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
          If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              

              *-----  Antes de criar Verifica se a Tabela  já existe
               IF Empty(aTabelasExistentes)    
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                  If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas componentes / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
              ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Clientes
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Clientes) )
//msginfo("cTB_Clientes  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Componentes) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Componentes + " Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray componentes( " + cTB_Componentes + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						        IF nTipo ==1
              					Aadd( aComponentes ,  oRow:fieldGet(9)  )
								        oQuery:Skip(1)
						        Elseif nTipo == 2
							           *----- Adiciona Registros no Grid
							           Aadd( aComponentes ,  oRow:fieldGet(9)  )
							           //MSGINFO("MANUTENTOR " + aManutentor[i] )
							           oQuery:Skip(1)
						        Endif
               Next

		*-----  Elimina Objeto Query
ENDIF			
			

Return


*********************************************************************************************************************************************************************
Function EncheArray_Eletrodomesticos( nTipo,aEletrodomestico)
*********************************************************************************************************************************************************************
			Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid :=10000
			Local cTB_Eletrodomesticos		:= "eletrodomesticos"
 
			
			aEletrodomestico		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
               IF Empty(aTabelasExistentes)    
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
               ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Clientes
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Clientes) )
//msginfo("cTB_Clientes  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Eletrodomesticos) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Eletrodomesticos +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Eletrodomesticos + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aEletrodomestico ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aEletrodomestico ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        				
			
ENDIF			
			

Return


*********************************************************************************************************************************************************************
Function EncheArray_Setores( nTipo,aSetores,aGrupo_Funcao)
*********************************************************************************************************************************************************************
			Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid :=10000
			Local cTB_Setores		:= "setores"
			Local cTB_Grupo_Funcao		:= "grupo_funcao"
 
			
			aSetores		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
               IF Empty(aTabelasExistentes)    
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
               ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Clientes
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Clientes) )
//msginfo("cTB_Clientes  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Setores) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Setores +" Order By descricao" ) 
	
  	Aadd( aSetores ,  "TODOS" )		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Setores + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aSetores ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aSetores ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        				
			
ENDIF	
 
			aGrupo_Funcao		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
               IF Empty(aTabelasExistentes)    
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
               ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Clientes
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Clientes) )
//msginfo("cTB_Clientes  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Grupo_Funcao) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Grupo_Funcao +" Order By descricao" ) 
	
  	Aadd( aGrupo_Funcao ,  "TODOS" )		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Grupo_Funcao + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aGrupo_Funcao ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aGrupo_Funcao ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        				
			
ENDIF		
			

Return



*********************************************************************************************************************************************************************
Function EncheArray_Modulos( nTipo,aModulos)
*********************************************************************************************************************************************************************
	  Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid :=10000
	  Local cTB_Modulos		:= "modulos"
 
			
			aModulos		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
               IF Empty(aTabelasExistentes)    
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
               ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Clientes
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Clientes) )
//msginfo("cTB_Clientes  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Modulos) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Modulos +" Order By descricao" ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Modulos + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aModulos ,  oRow:fieldGet(8)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aModulos ,  oRow:fieldGet(8)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        				
			
ENDIF			
			

Return

*********************************************************************************************************************************************************************
Function EncheArray_Contatos( nTipo,aCargos,aCategorias)
*********************************************************************************************************************************************************************
		Local nContador		:= 0
      Local oRow     		:= {}
      Local i           	:= 0
      Local oQuery      	:= "" 
      Local QuantMaximaDeRegistrosNoGrid :=10000
		Local cTB_Cargos		:= "cargos"
		Local cTB_Categorias		:= "categorias"
 
			
			aSetores		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
               IF Empty(aTabelasExistentes)    
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
               ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para  cTB_Cargos
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower( cTB_Cargos) )
//msginfo(" cTB_Cargos  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Cargos) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Cargos +" Order By descricao" ) 
	
  	Aadd( aCargos ,  "TODOS" )		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Cargos + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aCargos ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aCargos ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        				
			
ENDIF	
 
			aGrupo_Funcao		:= {}	&&serve para esvaziar o array casa seja nescessario chamar a funcao novamente
			
			
		  *-----  Verifica se esta conectado ao MySql
                   If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
               IF Empty(aTabelasExistentes)    
                   aTabelasExistentes  := oServer:ListTables()
                                 *-----  Verifica se ocorreu algum erro 
                   If oServer:NetErr() 
                     MsGInfo("verificando Lista de Tabelas / <TMySQLServer> EncheArray() " + oServer:Error(),"SISTEMA" )
					           return
                  Endif 
                  
               ENDIF


*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTB_Categorias
*----------------------------------------------------------------------------------------------------*
//cTabela := hb_Ascan( aTabelasExistentes, Lower(cTB_Categorias) )
//msginfo("cTB_Categorias  " + str(cTabela)  )
 
If hb_Ascan( aTabelasExistentes, Lower(cTB_Categorias) ,,,.T.) != 0
    
	oQuery := oServer:Query( "Select * From "+ cTB_Categorias +" Order By descricao" ) 
	
  	Aadd( aCategorias ,  "TODOS" )		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray( " + cTB_Categorias + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
						IF nTipo ==1
              					Aadd( aCategorias ,  oRow:fieldGet(2)  )
								oQuery:Skip(1)
						Elseif nTipo == 2
							*----- Adiciona Registros no Grid
							Aadd( aCategorias ,  oRow:fieldGet(2)  )
							//MSGINFO("MANUTENTOR " + aManutentor[i] )
							oQuery:Skip(1)
						Endif
               Next

		*-----  Elimina Objeto Query
        				
			
ENDIF		
			

Return

