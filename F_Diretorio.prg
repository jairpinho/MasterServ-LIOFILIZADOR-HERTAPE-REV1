#Include "Directry.ch"
#include "MiniGui.ch"
/*
*--------------------------------------------------------*
FUNCTION NewFolder()
*--------------------------------------------------------*
LOCAL cPath := GetFull(), cName := ""

	cName := Alltrim( InputBox2 ( 'New directory', PROGRAM, cName, 120000, "" ) )

	IF !EMPTY(cName)
		CreateFolder( cPath +'\'+ cName )
		ReReadFolder()
	ENDIF

RETURN NIL
*/
*--------------------------------------------------------*
FUNCTION Cria_Diretorio(cNAME)
*--------------------------------------------------------*
Local cDirBase     := HB_DirBase()
LOCAL cValue := ""
	IF  HB_DirExists(cDirBase + cName)
			cValue := cDirBase + cName +"\"
			Return(cValue)
	else	
		MsgInfo("Novo Diretório criado " + cName , "SISTEMA" )
		CreateFolder( cDirBase + cName )
		cValue := cDirBase + cName +"\"
	ENDIF
//msginfo(cValue)
Return(cValue)


*-------------------------------------------
* Lê o arquivo Config.ini e retorna a Base De Dados
Function BaseDeDados(Diretorio)
*-------------------------------------------
	Local cValue := ""
	Local cDirBase     :=DiskName()+":\"+CurDir() + "\"
	Local cDiretorio1	:= "Base\"
	Local cDiretorio2	:= "Relatorios-PSM\"
	Local cDiretorio3	:= "PSM\"
	Local cDiretorio4	:= "Pedidos\"
	Local cDiretorio5	:= "Materiais\"
	Local cDiretorio6	:= "Contatos\"
	Local cDiretorio7	:= "DB_Backup\"
	

IF Diretorio == "DIR1"
	
	//msginfo("teste base de dados")
	If ! File(DiskName()+":\"+CurDir()+"\Config.INI")
	   MsgStop("Arquivo Config.ini não encontrado!!" , "SISTEMA" )
	   ExitProcess(0)
	EndIf

	BEGIN INI FILE "Config.Ini"
				SET SECTION "Base de Dados" 	ENTRY "Base de Dados" To DiskName()+":\"+CurDir()+"\BASE\" 
				//MSGINFO("Caminho Restaurado no Arquivo Config.ini ","Sistema")
				//msginfo("teste base de dados: " + cValue)
	END INI
	
	IF ! File(cDirBase+cDiretorio1+"\*.*")
			MsgInfo("Diretório da Base de Dados Nao foi Localizado, Novo Diretório sera criado" , "SISTEMA" )		
			CreateFolder( cDirBase+cDiretorio1 )
			cValue := cDirBase + cDiretorio1
	ELSE
			cValue := cDirBase + cDiretorio1
	ENDIF
	
//MsgInfo("Diretório da Base de Dados :" + cValue , "SISTEMA" )		
		
Endif


IF Diretorio == "DIR2"
	
	IF ! File(cDirBase+cDiretorio2+"\*.*")
			//MsgInfo("Diretório da Base de Dados Nao foi Localizado, Novo Diretório sera criado" , "SISTEMA" )		
			CreateFolder( cDirBase+cDiretorio2 )
			cValue := cDirBase + cDiretorio2
	ELSE
			cValue := cDirBase + cDiretorio2

	ENDIF

ENDIF


IF Diretorio == "DIR3"
	
	IF ! File(cDirBase+cDiretorio3+"\*.*")
			//MsgInfo("Diretório da Base de Dados Nao foi Localizado, Novo Diretório sera criado" , "SISTEMA" )		
			CreateFolder( cDirBase+cDiretorio3 )
			cValue := cDirBase + cDiretorio3
	ELSE
			cValue := cDirBase + cDiretorio3
	ENDIF
	
ENDIF

IF Diretorio == "DIR4"
	
	IF ! File(cDirBase+cDiretorio4+"\*.*")
			//MsgInfo("Diretório da Base de Dados Nao foi Localizado, Novo Diretório sera criado" , "SISTEMA" )		
			CreateFolder( cDirBase+cDiretorio4 )
			cValue := cDirBase + cDiretorio4
	ELSE
			cValue := cDirBase + cDiretorio4
	ENDIF
	
ENDIF	

IF Diretorio == "DIR5"
	
	IF ! File(cDirBase+cDiretorio5+"\*.*")
			//MsgInfo("Diretório da Base de Dados Nao foi Localizado, Novo Diretório sera criado" , "SISTEMA" )		
			CreateFolder( cDirBase+cDiretorio5 )
			cValue := cDirBase + cDiretorio5
	ELSE
			cValue := cDirBase + cDiretorio5
	ENDIF
	
ENDIF

IF Diretorio == "DIR6"
	
	IF ! File(cDirBase+cDiretorio6+"\*.*")
			//MsgInfo("Diretório da Base de Dados Nao foi Localizado, Novo Diretório sera criado" , "SISTEMA" )		
			CreateFolder( cDirBase+cDiretorio6 )
			cValue := cDirBase + cDiretorio6
	ELSE
			cValue := cDirBase + cDiretorio6
	ENDIF

ENDIF

IF Diretorio == "DIR7"
	
	IF ! File(cDirBase+cDiretorio7+"\*.*")
			//MsgInfo("Diretório da Base de Dados Nao foi Localizado, Novo Diretório sera criado" , "SISTEMA" )		
			CreateFolder( cDirBase+cDiretorio7 )
			cValue := cDirBase + cDiretorio7
	ELSE
			cValue := cDirBase + cDiretorio7
	ENDIF

ENDIF


Return Upper( cValue )