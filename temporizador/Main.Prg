#include <hmg.ch>
#include <minigui.ch>
#include "hbthread.ch" 


#define HB_THREAD_INHERIT_PUBLIC 1  // // NECESSARIO para manipular objetos da janela que chama


Function Main
PRIVATE lCount_ok := .F.

        Load Window Main
        Main.Center
        Main.Activate

Return

function relogio()
	   Main.Label_1.Value := time()
return




PROCEDURE thread_relogio1()
// inserir no prg #include "hbthread.ch"
hb_threadStart( HB_THREAD_INHERIT_PUBLIC , @Show_Time() ) // possivel manipular objetos da janela que chama
RETURN .f.

PROCEDURE thread_tempo2()
// inserir no prg #include "hbthread.ch"
Local cTime := "3000"

	//passagem de paremtros somento tipo string numero nao aceita
	 hb_threadStart( @TEMPO1(), "3000" ) 	 // nao é possivel manipular objetos da janela que chama

	IF lCount_ok == .T. 
		msginfo("TH_READ FINALIZOU")
	ENDIF
RETURN .f.

PROCEDURE thread_tempo3()
// inserir no prg #include "hbthread.ch"
	hb_threadStart( "TEMPO2" )  // nao é possivel manipular objetos da janela que chama
RETURN .f.



FUNCTION Show_Time()
LOCAL cTime

   * disable 'Start Thread' button to avoid accidentally start a new thread!

   main.button_1.enabled := .f. 

   * please note that this function will NEVER return the control!
   * but do not 'locks' the user interface since it is running in a separate thread 
   // se quiser habilitar o loop apos iniciar a thread use abaixo

   DO WHILE .T.
      main.label_2.value := Time()
      ** FUNCIONA COM OS DOIS TIPOS DE ESPERA hb_idleSleep() OU  millisec()
	  //hb_idleSleep( 1 )
	  millisec(500) 
   ENDDO

	
RETURN nil

FUNCTION tempo1(cTime)
lCount_ok := .F.
	millisec(val(cTime)) 
	msginfo("THREAD TEMPO 1")
lCount_ok := .T.
RETURN


FUNCTION tempo2()
	millisec(5000) 
	msginfo("THREAD TEMPO 2")
	
RETURN nil