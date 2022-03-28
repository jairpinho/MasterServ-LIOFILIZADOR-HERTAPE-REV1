#Include "minigui.ch"
#Include "F_sistema.ch"
#Include "Common.ch"
#Include "Fileio.CH"
#Include "Directry.ch"
*********************************************************************************************************************************************************************
Function EncheArray_Generic( nTipo,cTabela,lCria,cSel_Campo,cWhe_Campo1 ,cVar1,cWhe_Campo2 ,cVar2,nOrder)
*********************************************************************************************************************************************************************
			Local nContador		:= 0
         Local oRow     		:= {}
         Local i           	:= 0
         Local oQuery      	:= "" 
         Local QuantMaximaDeRegistrosNoGrid := 10000
         Local aArray		:= {}
         Local aTabelasExistentes := {}
 
         IF empty(nOrder)
            nOrder := 2
         endif
         
         IF empty(cSel_Campo)
            cSel_Campo := "descricao"
         endif
			
		

	
			  *-----  Verifica se esta conectado ao MySql
               If oServer == Nil ; MsgInfo("Conexão com MySql não foi Iniciada!!")
						Return Nil 
				   EndIf
              
              *-----  Antes de criar Verifica se a Tabela  já existe
                   aTabelasExistentes  := oServer:ListTables()

*----------------------------------------------------------------------------------------------------*
*-- Monta Objeto Query com Selecão para cTBArray
*----------------------------------------------------------------------------------------------------*

// cTabela := AScan( aTabelasExistentes, Lower(cTabela) )
// msginfo("cTabela  " + str(cTabela)  )

If AScan( aTabelasExistentes, Lower(alltrim(cTabela)) ) != 0
  

   IF nTipo == 1  // SELECIONA TODOS OS CAMPOS E CARREGA OS DADOS DO CAMPO DESCRIÇÃO, CASO NÃO SEJA INFORMADO SERA DEFINIDO O CAMPO DESCRIÇÃO
      oQuery := oServer:Query( "Select * From "+ cTabela +" Order By " + Str(nOrder) ) 
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray Generic( " + cTabela + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
							*----- Adiciona Registros no Grid
							Aadd( aArray ,  oRow:fieldGet(cSel_Campo)  )
							oQuery:Skip(1)

               Next
   Endif


   IF nTipo == 2 //SELECIONA APENAS O CAMPO INFORMADO EM cSel_Campo COM A CONDIÇÃO cWhe_Campo1 FOR IGUAL A VARIAVEL cVar1
		      oQuery := oServer:Query( "Select "+ cSel_Campo +" From "+ cTabela +"  WHERE "+ cWhe_Campo1 +" = "+ AllTrim( cVar1)  )			
		  		  
	*----- Verifica se ocorreu algum erro na Pesquisa
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray ( " + cTabela + " ) " + oQuery:Error())
            Return Nil
		Endif
								
               For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
							*----- Adiciona Registros no Grid
							Aadd( aArray ,  oRow:fieldGet(cSel_Campo)  )
							oQuery:Skip(1)

               Next
   Endif
   
   IF nTipo == 3 ////SELECIONA APENAS O CAMPO INFORMADO EM cSel_Campo COM A CONDIÇÃO cWhe_Campo1 FOR IGUAL A VARIAVEL cVar1 AND cWhe_Campo2 FOR IGUAL A VARIAVEL cVar2

		      oQuery := oServer:Query( "Select "+ cSel_Campo +" From "+ cTabela +"  WHERE "+ cWhe_Campo1 +" = "+ AllTrim( cVar1) +" AND "+ cWhe_Campo2 +" = "+ AllTrim( cVar2)  )			
   
		If oQuery:NetErr()												
            MsgInfo("Registro não Encontrado em EncheArray Generic( " + cTabela + " ) " + oQuery:Error())
            Return Nil
		Endif
   
               
                     For i := 1 To oQuery:LastRec()
                        nContador += 1
                        If nContador ==  QuantMaximaDeRegistrosNoGrid
                           Exit
                        Endif                   
                        oRow := oQuery:GetRow(i)
							*----- Adiciona Registros no Grid
							Aadd( aArray ,  oRow:fieldGet(cSel_Campo)  )
							oQuery:Skip(1)

               Next
         
    Endif           
               
               
Else

      IF lCria 
         GenericOpen( cDatabase , cTabela )
      Endif

ENDIF
			
		
Return(aArray)
