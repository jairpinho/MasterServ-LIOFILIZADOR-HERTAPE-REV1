#include <hmg.ch>
#Include "minigui.ch"
#Include "Common.ch"
#Include "Fileio.CH"



/*

As fontes Base são 14 fontes internas do PDF e todos os aplicativos Viewer podem exibir essas fontes. Um aplicativo pode obter um identificador de fonte de uma fonte base14 a qualquer momento, invocando HPDF_GetFont () .
O tamanho dos arquivos pdf que usam fontes base14 se tornam menores do que aqueles que usam outros tipos de fontes. Além disso, um processamento que cria o arquivo PDF é rápido, pois não há sobrecarga que carrega a fonte.
No entanto, as fontes base14 estão disponíveis apenas para exibir o conjunto de caracteres latin1. Para usar outro conjunto de caracteres, um aplicativo precisa usar outro tipo de fonte.

As 14 fontes Base
Courie
Courier-Bold
Courier-Oblique
Courier-BoldOblique
helvética
Helvetica-Bold
Helvetica-Oblique
Helvetica BoldOblique
Times-Roman
Times-Bold
Times-Italic
Times-BoldItalic
Símbolo
ZapfDingbats

*/


/*	
	HPDF_RotateText( 50, 100, "ABCxyz123", Nil, Nil, 0 )
     HPDF_RotateText( 50, 100, "ABCxyz123", Nil, Nil, 45 )
   
     HPDF_RotateText( 50, 100, "Center Middle", Nil, Nil, 135 , , ,{0 , 0, 255} , 'cM' )
     HPDF_RotateText( 50, 100, "Top", Nil, Nil, 90 , , ,{255 , 0, 255} , 'T' ) // vertical top e bottom
     
     
     @ 80, 100 HPDFPRINT "RIGHT ALIGN" RIGHT
        
     HPDF_RotateText( 100, 100, "ABCxyz123", Nil, Nil, 0 , , ,{255 , 0, 0} , 'R' )
     HPDF_RotateText( 150, 120, "ABCxyz123hhhhh", Nil, Nil, 45 , , ,{255 , 0, 0} , 'r' )// qualquer angulo que nao seja 90 vertical "r" para alinhamento a direita
	 HPDF_RotateText( 150, 140, "ABCxyz123hh", Nil, Nil, 45 , , ,{255 , 0, 0} , 'r' )	// qualquer angulo que nao seja 90 vertical "r" para alinhamento a direita
	 HPDF_RotateText( 150, 160, "ABCxyz123", Nil, Nil, 45 , , ,{255 , 0, 0} , 'r' )		// qualquer angulo que nao seja 90 vertical "r" para alinhamento a direita
     

     @ 130, 100 HPDFPRINT "CENTER ALIGN" CENTER
     
     HPDF_RotateText( 150, 100, "ABCxyz123", Nil, Nil, 0 , , ,{0,255 , 0} , 'C' )
     HPDF_RotateText( 150, 100, "ABCxyz123", Nil, Nil, 45 , , ,{0,255 , 0} , 'c' )
	
	FOR i=100 TO 300 STEP 10
		@i,10 HPDFPRINt "Happy HMG"
	NEXT i

	FOR i=0 To 345 STEP 15
		@ i,_HMG_HPDF_Pixel2MM(150) HPDFPRINT LINE TO  150, 10 PENWIDTH 0.15 COLOR RED 	
		HPDF_RotateText( 150, 150, "Happy HMG", Nil, 10, i )
	NEXT i	
*/
*******************************
PROCEDURE HPDFPRINT_RotateText( nRow, nCol, cTxt, cFont, nFontSize, nAngle, lBold, lItalic, aColors, cAlign)
* Rotating text

   Local nRad, nTextWidth, oFont, cFnt
   
   Local hPdf        := _HMG_SYSDATA[ 150 ][ 1 ]
   Local hPage       := _HMG_SYSDATA[ 150 ][ 7 ]
   Local cPdfEnc     := _HMG_SYSDATA[ 150 ][ 10 ]

   Local nWidth      := _HMG_SYSDATA[ 150 ][ 4 ]
   Local nHeight     := _HMG_SYSDATA[ 150 ][ 5 ]
   Local nxPos       := _HMG_HPDF_MM2Pixel( nCol )
   Local nyPos       := nHeight - _HMG_HPDF_MM2Pixel( nRow )

   DEFAULT cFont       := "Helvetica"
   DEFAULT nFontSize   := 12   
   DEFAULT cTXt        := ""
   DEFAULT nAngle      := 0
   DEFAULT lBold       := .F.
   DEFAULT lItalic     := .F.
   DEFAULT aColors     := { 0, 0, 0}
   DEFAULT cAlign      :=""		//Empty - Left and bottom, R - Right, C - Center, T - Top, M - Middle

   If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
      _HMG_HPDF_Error( 3 )
      Return Nil
   endif

   If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      Return Nil
   endif

   
   IF VALTYPE(cAlign)#'C' 
      cAlign := ''		//Left as default
   ENDIF
   
   
   // set color
   If VALTYPE( aColors )#'A' .OR. LEN( aColors )#3 .OR. ;
      VALTYPE( aColors[1] )#'N' .OR. VALTYPE( aColors[2] )#'N' .OR. VALTYPE( aColors[3] )#'N' .OR. ;
      aColors[1]<0 .OR. aColors[1]>255 .OR. ;
      aColors[2]<0 .OR. aColors[2]>255 .OR. ;
      aColors[3]<0 .OR. aColors[3]>255
      
      aColors     := { 0, 0, 0}
   Endif 
   HPDF_Page_SetRGBFill( hPage, aColors[1]/255, aColors[2]/255, aColors[3]/255 )   

   // set font
   If HMG_LEN( AllTrim( cFont ) ) == 0
      cFont := _HMG_HPDF_SetFont( cFont, lBold, lItalic )
      oFont := HPDF_GetFont( hPdf, cFont, cPdfEnc )

   else

      cFont := AllTrim(_HMG_HPDF_SetFont( cFont, lBold, lItalic ))
    
      if HMG_UPPER (cFileExt (cFont)) == '.TTF' // load ttf font
   
         cFnt := HPDF_LOADTTFONTFROMFILE( hPdf, cFont, .t. )

         If HMG_LEN( Alltrim( cFnt ) ) == 0
            _HMG_HPDF_Error( 6 , cFont )
            Return Nil
         endif

         oFont := HPDF_GetFont( hPdf, cFnt, cPdfEnc )
     
      else
     
         If HMG_UPPER( alltrim( cFont ) ) == "SYMBOL" .or. HMG_UPPER( alltrim( cFont ) ) == "ZAPFDINGBATS"
            oFont := HPDF_GetFont( hPdf, cFont, Nil )
         else   
            oFont := HPDF_GetFont( hPdf, cFont, cPdfEnc )
         endIf
   
      endif

   endIf
   
   If oFont == Nil
      _HMG_HPDF_Error( 6 , cFont )
      Return Nil
   Endif

   HPDF_Page_SetFontAndSize( hPage, oFont, nFontSize )
   nTextWidth := HPDF_Page_TextWidth( hPage, cTxt )
   
   nRad := nAngle / 180 * 3.141592 	//radian value
   
   //calculate nxPos
   IF 'R'$HMG_UPPER(cAlign)		//Right
      nxPos:=nxPos - (nTextWidth* cos (nRad))
   ELSEIF 'C'$HMG_UPPER(cAlign)	//Center
   	 nxPos:=nxPos - ((nTextWidth* cos (nRad))/2)
   ENDIF
   
   //calculate nyPos
   IF 'T'$HMG_UPPER(cAlign)		//Top
      nyPos:=nyPos - (nTextWidth* sin (nRad))
   ELSEIF 'M'$HMG_UPPER(cAlign)	//Middle
   	 nyPos:=nyPos - ((nTextWidth* sin (nRad))/2)
   ENDIF
 
   HPDF_Page_BeginText( hPage )
   HPDF_Page_SetTextMatrix ( hPage, cos ( nRad ), sin ( nRad ), -sin ( nRad ), cos ( nRad ), nxPos , nyPos - nFontSize)
   HPDF_Page_ShowText( hPage, cTxt )
   HPDF_Page_EndText( hPage )

RETURN




***************************************************************************************************
PROCEDURE HPDFPRINT_SetDash( lStyle, nEspaco, nFase)
* Rotating text
/*
Corrigido. Eu adicionei atributos de fonte e cores.
Por sinal, encontrei um bug na fonte h_HMG_HPDF.Prg
Se você quiser usar o Bold e / ou atributos Itálico você precisa adicionar em h_HMG_HPDF.Prg na linha # 1812: cFnt: = Cfont (após "Caso contrário").
Caso contrário, a variável cFnt para cFont declarado: "Courier" e "Helvetica" é o valor Nil, o que resulta em um erro.
Após a mudança, é claro, você precisa reconstruir o HMG.
*/
   
   Local hPdf        := _HMG_SYSDATA[ 150 ][ 1 ]
   Local hPage       := _HMG_SYSDATA[ 150 ][ 7 ]
   Local cPdfEnc     := _HMG_SYSDATA[ 150 ][ 10 ]

   
   If _HMG_SYSDATA[ 150 ][ 1 ] == Nil // PDF object not found!
      _HMG_HPDF_Error( 3 )
      Return Nil
   endif

   If _HMG_SYSDATA[ 150 ][ 7 ] == Nil // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      Return Nil
   endif

   if lStyle == 0
	HPDF_Page_SetDash (hPage, NIL, 0, 0)
	elseif lStyle == 1
		HPDF_Page_SetDash (hPage, {3}, nEspaco, nFase)
	elseif lStyle == 2
		HPDF_Page_SetDash (hPage, {7,3}, nEspaco, nFase)
	elseif lStyle == 3
		HPDF_Page_SetDash (hPage, {8, 7, 2, 7}, nEspaco, nFase)
	endif
	
return


// nrow e ncol em pixel
*------------------------------------------------------------------------*
Function print_grid( nRow_pdf, nCol, height, width, nScaleLine_X, nScaleLine_Y, nScaleText_X, nScaleText_Y, nTag_x, nTag_Y,nMim,nMax )
*------------------------------------------------------------------------*
	Local  ofont, x , y , yMin_max, cLabel, nLabWidth
	Local Pdf        	:= _HMG_SYSDATA[ 150 ][ 1 ]
	Local Page       	:= _HMG_SYSDATA[ 150 ][ 7 ]  
	Local cEncoding 	:= _HMG_SYSDATA[ 150 ] [ 10 ]       //Value of "SET HPDFDOC ENCODING TO".   "SET HPDFDOC ENCODING TO" set _HMG_HPDF_SetEncoding
	Local nHeigth_pdf 	:= HPDF_Page_GetHeight (_HMG_SYSDATA[ 150 ][ 7 ])
	Local nCinza 		:= 0.90  // 1 igual a branco total
	Local nRow 			:= nHeigth_pdf - nRow_pdf
	Local nyPos       	:= 0
	
	Local cFont       := "Helvetica"
	Local nFontSize   	:= 8
	Local nFontSize2   	:= 6
  	Local lBold       := .F.
	Local  lItalic     := .F.
	Local  aColors     := { 0, 0, 0}
	Local  cAlign      :=""		//Empty - Left and bottom, R - Right, C - Center, T - Top, M - Middle
	
    

		ofont := HPDF_GetFont (Pdf, cFont, cEncoding)
		//HPDF_Page_SetFontAndSize (Page, ofont, nFontSize)
		
	HPDF_Page_SetGrayFill (page, 0.25)
    HPDF_Page_SetGrayStroke (page, nCinza)
	
	/*
		As cores são especificadas usando três números reais (ou seja, com um ponto decimal) na forma R G B onde cada número define a quantidade de vermelho (R), verde (G) e azul (B) em uma cor.
		Os números válidos são de 0,0 a 1,0 inclusive ou divide por 255 
		HPDF_Page_SetRGBFill( hPage, aColors[1]/255, aColors[2]/255, aColors[3]/255 )
	*/
	
    /* Draw horizontal lines */
	
    yMin_max := 0 // linhas de tolerancias 
	HPDF_Page_SetFontAndSize (Page, ofont, nFontSize2)
    while (yMin_max <= height )
	
		if yMin_max == nMim 
			HPDF_Page_SetLineWidth (page, 0.5)
			HPDF_Page_SetDash (page, {3}, 1, 1)
			//HPDF_Page_SetGrayStroke(page, 0,0,0)
			HPDF_Page_SetRGBStroke (page, 0 , 0 , 0 ) // (page, 0.0 , 255/255, 0.0 )
			
			HPDF_Page_MoveTo (page, nCol, yMin_max + nRow)
			HPDF_Page_LineTo (page, width + nCol, yMin_max + nRow)
			HPDF_Page_Stroke (page)	
			
			
			nAngle := 0
			nRad := nAngle / 180 * 3.141592 	//radian value
			nTextWidth := HPDF_Page_TextWidth( page ,"Mínimo: " +alltrim(str(nMim) ))
		   
		    nxPos:= 85  - (nTextWidth* cos (nRad))  // posição coluna do texto
			nyPos := nRow + nMim 
            HPDF_Page_BeginText (page)			
			HPDF_Page_SetTextMatrix ( page , cos ( nRad ), sin ( nRad ), -sin ( nRad ), cos ( nRad ), nxPos , nyPos  - nFontSize2/2 + .75 ) // nyPos = posicao Linha(Row)
			HPDF_Page_ShowText (page, "Mínimo: "+alltrim(str(nMim)))
            HPDF_Page_EndText (page)			
		
			
			HPDF_Page_SetDash (page, NIL, 0, 0)
			HPDF_Page_SetGrayStroke (page, nCinza)
			
		elseif yMin_max == nMax
		
			HPDF_Page_SetLineWidth (page, 0.5)
			HPDF_Page_SetDash (page, {3}, 1, 1)
			//HPDF_Page_SetGrayStroke(page, 0,0,0)
			HPDF_Page_SetRGBStroke (page, 0 , 0, 0 ) // (page, 0.0 , 255/255, 0.0 )
			
			HPDF_Page_MoveTo (page, nCol, yMin_max + nRow)
			HPDF_Page_LineTo (page, width + nCol, yMin_max + nRow)
			HPDF_Page_Stroke (page)	

		
			nAngle := 0
			nRad := nAngle / 180 * 3.141592 	//radian value
			nTextWidth := HPDF_Page_TextWidth( page , "Máximo: "+alltrim(str(nMax)))
		   
		    nxPos:= 85  - (nTextWidth* cos (nRad))  // // posição coluna do texto
			nyPos := nRow + nMax
            HPDF_Page_BeginText (page)			
			HPDF_Page_SetTextMatrix ( page , cos ( nRad ), sin ( nRad ), -sin ( nRad ), cos ( nRad ), nxPos , nyPos  - nFontSize2/2 + .75 ) // nyPos = posicao Linha(Row)
			HPDF_Page_ShowText (page, "Máximo: "+alltrim(str(nMax)))
            HPDF_Page_EndText (page)
		
			
			HPDF_Page_SetDash (page, NIL, 0, 0)
			HPDF_Page_SetGrayStroke (page, nCinza)

		endif
		
       yMin_max += 1
    End

    /* Draw horizontal lines */
    y := 0 // linhas da grid
    while (y <= height )
	
		if  y != nMim  // so cria linhas se for fora do limite de tolerancia
			if y != nMax
			
				if  (y % (nScaleLine_Y*2) == 0)  // resto igual a zero linha 0.5
					HPDF_Page_SetLineWidth (page, 0.5)
				else
					if (HPDF_Page_GetLineWidth (page) != 0.25)  // qualquer valor diferente da linha 0.25 
						HPDF_Page_SetLineWidth (page, 0.25)
					Endif
				Endif
				
				HPDF_Page_MoveTo (page, nCol, y + nRow)
				HPDF_Page_LineTo (page, width + nCol, y + nRow)
				HPDF_Page_Stroke (page)

			endif 
		endif

        //linha de tag 
		if (y % nTag_Y == 0 .and. y > 0) // resto igual a zero
		
			if y == nMim
				//HPDF_Page_SetGrayStroke (page, 0.0) se precisar mudar a cora da linha de tag
				HPDF_Page_SetGrayStroke (page, 0.5)

				HPDF_Page_MoveTo (page, nCol, y + nRow)
				HPDF_Page_LineTo (page, nScaleLine_Y + nCol , y + nRow)
				HPDF_Page_Stroke (page)

				HPDF_Page_SetGrayStroke (page, nCinza)
			ELSE 
				HPDF_Page_SetGrayStroke (page, 0.5)

				HPDF_Page_MoveTo (page, nCol, y + nRow)
				HPDF_Page_LineTo (page, nScaleLine_Y + nCol , y + nRow)
				HPDF_Page_Stroke (page)

				HPDF_Page_SetGrayStroke (page, nCinza)

			ENDIF
        Endif

        y += nScaleLine_Y
    End

    /* Draw vertical lines */



    x := 0 //distabcia inicio primeira linha
    while (x <= width)
        if (x % (nScaleLine_X*2) == 0) // resto igual a zero linha 0.5
            HPDF_Page_SetLineWidth (page, 0.5)
        else
            if (HPDF_Page_GetLineWidth (page) != 0.25)
                HPDF_Page_SetLineWidth (page, 0.25)
            Endif
        Endif


        HPDF_Page_MoveTo (page, x + nCol, nRow)
        HPDF_Page_LineTo (page, x + nCol, height + nRow)
        HPDF_Page_Stroke (page)



        x += nScaleLine_X
    End



    *** Draw horizontal text 

HPDF_Page_SetFontAndSize (Page, ofont, nFontSize)

    y := 0 //distabcia inicio texto
    while (y < height)
        if (y % (nScaleText_Y) == 0 .and. y > 0) // resto igual a zero
	    cLabel:=ltrim(str(y))
            HPDF_Page_BeginText (page)
            HPDF_Page_MoveTextPos (page, nScaleLine_Y + nCol, y + nRow - (nFontSize/2) + .75 )
            HPDF_Page_ShowText (page, cLabel)
            HPDF_Page_EndText (page)
        Endif

        y += nScaleText_Y
    End



    HPDF_Page_SetGrayFill (page, 0)
    HPDF_Page_SetGrayStroke (page, 0)
	
Return Nil

