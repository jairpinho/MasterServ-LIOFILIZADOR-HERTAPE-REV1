*/
*
*	Retorna o Nome do Mês em Extenso 
*
*/
Function MesExtenso( dData )
	 Local nMes  := Month(dData)
	 Local MesEx := ''
	 If	nMes== 1
		MesEx := "Janeiro"
	 ElseIf nMes== 2
		MesEx := "Fevereiro"
	 ElseIf nMes== 3
		MesEx := "Março"
	 ElseIf nMes== 4
		MesEx := "Abril"
	 ElseIf nMes== 5
		MesEx := "Maio"
	 ElseIf nMes== 6
		MesEx := "Junho"
	 ElseIf nMes== 7
		MesEx := "Julho"
	 ElseIf nMes== 8
		MesEx := "Agosto"
	 ElseIf nMes== 9
		MesEx := "Setembro"
	 ElseIf nMes== 10
		MesEx := "Outubro"
	 ElseIf nMes== 11
		MesEx := "Novembro"
	 ElseIf nMes== 12
		MesEx := "Dezembro"
	 Endif
	 Return(MesEx)
/*
*	Retorna o Dia da Semana
*/
Function DiaExtenso( dData )
	 Local DiaEx := ''
	 If	Upper(Cdow(dData)) == "SUNDAY"
		DiaEx := "Domingo"
	 ElseIf Upper(Cdow(dData)) == "MONDAY"
		DiaEx := "Segunda-Feira"
	 ElseIf Upper(Cdow(dData)) == "TUESDAY"
		DiaEx := "Terça-Feira"
	 ElseIf Upper(Cdow(dData)) == "WEDNESDAY"
		DiaEx := "Quarta-Feira"
	 ElseIf Upper(Cdow(dData)) == "THURSDAY"
		DiaEx := "Quinta-Feira"
	 ElseIf Upper(Cdow(dData)) == "FRIDAY"
		DiaEx := "Sexta-Feira"
	 ElseIf Upper(Cdow(dData)) == "SATURDAY"
		DiaEx := "Sábado"
	 Endif
	 Return(DiaEx)
/*
* Retona o Intervalo (em dias)  entre duas datas
*/
Function Intervalo( DataInicial , DataFinal )
	 Local intervalo := DataFinal - DataInicial
	 Local ct	 := DataInicial
	 Local nDias	 := -1
	 Do While ct <= DataFinal
	    nDias++
	    ct += 1
	EndDo
	Return( nDias )
/*
*	Retorna Verdadeiro de o Ano for Bissexto
*	Sintaxe:  isBissexto( 1999 ) => .T.  .or.  .F.				
*
*/
Function IsBissexto( nYear )
	 If ! Empty( CtoD( "29/02/"+StrZero( nYear , 4 ) ) )
	    Return .T.
	 Endif
	 Return .F.
/*
* Retorna uma string com data do dia por extenso
* Ex: Hoje é Sexta-Feira, 30 de Maio de 2003
*/
Function DataDoDia()
	 Return("Hoje é "+AllTrim(DiaExtenso(Date()))+" "+StrZero(Day(Date()),2)+" de "+AllTrim(MesExtenso(Date()))+" de "+Str(Year(Date()),4))
	 
	 
*********************************************************************************************************************************************************************
&& DESCOBRIR O ULTIMO DIA DO MES
Function DIASMES( pDATA, pTIPO )
*********************************************************************************************************************************************************************
/*
	&&& maneiras de pegar o ultimo dia do mês &&&
	msginfo(cDia) // por uma funcao que conta os dias
	msginfo( str( Day( EOM() ) ) ) funcao do harbour que retorna a data do último dia de um mês.
	msginfo( str( EOM(Date() ) ) ) funcao do harbour que retorna a data do último dia de um mês.
	msginfo( str( DaysInMonth( month(Date() )  ) ) funcao do harbour que retorna o número de dias em um mês.
	msginfo( str( LastDayoM( Date() ) )funcao do harbour que retorna o número de dias em um mês.
*/


   Private aDATA := pDATA
 
   While Month( aDATA ) = Month( pDATA )
 
     aDATA ++
   EndDo
   aDATA --
 //msginfo(str(Day( aDATA ) ))
Return If( pTIPO='D', aDATA, Day( aDATA ) )
*********************************************************************************************************************************************************************
Function Formata_Data( cChar, dData )
*********************************************************************************************************************************************************************
Local cData := ""
Local nMes := MONTH(dData)
Local nDia := DAY(dData)
Local nAno := YEAR(dData)

cData := ALLTRIM(STRzero(nDia,2,0)) + ALLTRIM(cChar) + ALLTRIM(STRzero(nMes,2,0)) + ALLTRIM(cChar) + ALLTRIM(STR(nAno)) 
Return(cData)





