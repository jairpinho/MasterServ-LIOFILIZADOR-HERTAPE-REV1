/*
 * Harbour 3.2.0dev (r1601151502)
 * MinGW GNU C 4.6.1 (32-bit)
 * Generated C source from "E:\@Prog-Xbase\@Projetos\@MySQL\SISTEMAS\ESTERELIZACAO_CENTRAL_HERTAPE\MasterServ-EST-CENTRAL-HERTAPE-REV2\temporizador\Main.Prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( MAIN );
HB_FUNC_EXTERN( __MVPRIVATE );
HB_FUNC_EXTERN( _DEFINEWINDOW );
HB_FUNC_EXTERN( _DEFINELABEL );
HB_FUNC( THREAD_RELOGIO1 );
HB_FUNC_EXTERN( _DEFINEBUTTON );
HB_FUNC_EXTERN( _DEFINEIMAGEBUTTON );
HB_FUNC_EXTERN( _DEFINEMIXEDBUTTON );
HB_FUNC_EXTERN( _DEFINETIMER );
HB_FUNC( RELOGIO );
HB_FUNC( THREAD_TEMPO2 );
HB_FUNC( THREAD_TEMPO3 );
HB_FUNC_EXTERN( _ENDWINDOW );
HB_FUNC_EXTERN( DOMETHOD );
HB_FUNC_EXTERN( SETPROPERTY );
HB_FUNC_EXTERN( TIME );
HB_FUNC_EXTERN( HB_THREADSTART );
HB_FUNC( SHOW_TIME );
HB_FUNC( TEMPO1 );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( MILLISEC );
HB_FUNC_EXTERN( VAL );
HB_FUNC( TEMPO2 );
HB_FUNC_EXTERN( ERRORSYS );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_MAIN )
{ "MAIN", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( MAIN )}, NULL },
{ "LCOUNT_OK", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "__MVPRIVATE", {HB_FS_PUBLIC}, {HB_FUNCNAME( __MVPRIVATE )}, NULL },
{ "_HMG_SYSDATA", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_DEFINEWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINEWINDOW )}, NULL },
{ "_DEFINELABEL", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINELABEL )}, NULL },
{ "THREAD_RELOGIO1", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( THREAD_RELOGIO1 )}, NULL },
{ "_DEFINEBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINEBUTTON )}, NULL },
{ "_DEFINEIMAGEBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINEIMAGEBUTTON )}, NULL },
{ "_DEFINEMIXEDBUTTON", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINEMIXEDBUTTON )}, NULL },
{ "_DEFINETIMER", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINETIMER )}, NULL },
{ "RELOGIO", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( RELOGIO )}, NULL },
{ "THREAD_TEMPO2", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( THREAD_TEMPO2 )}, NULL },
{ "THREAD_TEMPO3", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( THREAD_TEMPO3 )}, NULL },
{ "_ENDWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( _ENDWINDOW )}, NULL },
{ "DOMETHOD", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOMETHOD )}, NULL },
{ "SETPROPERTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETPROPERTY )}, NULL },
{ "TIME", {HB_FS_PUBLIC}, {HB_FUNCNAME( TIME )}, NULL },
{ "HB_THREADSTART", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_THREADSTART )}, NULL },
{ "SHOW_TIME", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( SHOW_TIME )}, NULL },
{ "TEMPO1", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TEMPO1 )}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "MILLISEC", {HB_FS_PUBLIC}, {HB_FUNCNAME( MILLISEC )}, NULL },
{ "VAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( VAL )}, NULL },
{ "TEMPO2", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( TEMPO2 )}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_MAIN, "E:\\@Prog-Xbase\\@Projetos\\@MySQL\\SISTEMAS\\ESTERELIZACAO_CENTRAL_HERTAPE\\MasterServ-EST-CENTRAL-HERTAPE-REV2\\temporizador\\Main.Prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_MAIN
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_MAIN )
   #include "hbiniseg.h"
#endif

HB_FUNC( MAIN )
{
	static const HB_BYTE pcode[] =
	{
		36,10,0,9,176,2,0,108,1,20,1,81,1,0,
		36,12,0,106,5,77,97,105,110,0,98,3,0,93,
		214,0,2,36,4,0,176,4,0,100,106,16,69,88,
		69,77,80,76,79,32,84,72,32,82,69,65,68,0,
		93,120,2,93,113,1,93,180,1,93,94,1,9,9,
		9,9,9,9,106,1,0,90,4,100,6,90,4,100,
		6,90,4,100,6,90,4,100,6,90,4,100,6,90,
		4,100,6,100,90,4,100,6,9,9,120,100,9,100,
		100,100,100,90,4,100,6,90,4,100,6,90,4,100,
		6,100,100,90,4,100,6,90,4,100,6,90,4,100,
		6,90,4,100,6,90,4,100,6,90,4,100,6,9,
		90,4,100,6,90,4,100,6,100,9,90,4,100,6,
		100,100,100,100,100,100,100,100,9,20,56,36,6,0,
		106,8,76,97,98,101,108,95,49,0,98,3,0,93,
		160,1,2,100,98,3,0,93,161,1,2,100,98,3,
		0,93,176,1,2,100,98,3,0,93,175,1,2,100,
		98,3,0,93,178,1,2,100,98,3,0,93,164,1,
		2,100,98,3,0,93,165,1,2,100,98,3,0,93,
		166,1,2,100,98,3,0,93,167,1,2,9,98,3,
		0,93,203,1,2,9,98,3,0,93,204,1,2,9,
		98,3,0,93,205,1,2,9,98,3,0,93,206,1,
		2,9,98,3,0,93,207,1,2,100,98,3,0,93,
		201,1,2,100,98,3,0,93,202,1,2,100,98,3,
		0,93,163,1,2,100,98,3,0,93,173,1,2,9,
		98,3,0,93,174,1,2,9,98,3,0,93,156,1,
		2,9,98,3,0,93,157,1,2,9,98,3,0,93,
		158,1,2,9,98,3,0,93,159,1,2,100,98,3,
		0,93,168,1,2,9,98,3,0,93,184,1,2,9,
		98,3,0,93,153,1,2,9,98,3,0,93,137,1,
		2,9,98,3,0,93,25,1,2,9,98,3,0,93,
		131,1,2,36,7,0,92,120,98,3,0,93,175,1,
		2,36,8,0,92,60,98,3,0,93,176,1,2,36,
		9,0,92,100,98,3,0,93,164,1,2,36,10,0,
		92,20,98,3,0,93,165,1,2,36,11,0,106,4,
		45,45,45,0,98,3,0,93,178,1,2,36,12,0,
		106,6,65,114,105,97,108,0,98,3,0,93,166,1,
		2,36,13,0,92,14,98,3,0,93,167,1,2,36,
		14,0,106,1,0,98,3,0,93,168,1,2,36,15,
		0,9,98,3,0,93,156,1,2,36,16,0,9,98,
		3,0,93,157,1,2,36,17,0,9,98,3,0,93,
		159,1,2,36,18,0,9,98,3,0,93,158,1,2,
		36,19,0,100,98,3,0,93,173,1,2,36,20,0,
		9,98,3,0,93,174,1,2,36,21,0,9,98,3,
		0,93,207,1,2,36,22,0,90,4,100,6,98,3,
		0,93,163,1,2,36,23,0,9,98,3,0,93,153,
		1,2,36,24,0,100,98,3,0,93,201,1,2,36,
		25,0,100,98,3,0,93,202,1,2,36,26,0,120,
		98,3,0,93,137,1,2,36,27,0,176,5,0,98,
		3,0,93,160,1,1,98,3,0,93,161,1,1,98,
		3,0,93,176,1,1,98,3,0,93,175,1,1,98,
		3,0,93,178,1,1,98,3,0,93,164,1,1,98,
		3,0,93,165,1,1,98,3,0,93,166,1,1,98,
		3,0,93,167,1,1,98,3,0,93,156,1,1,98,
		3,0,93,203,1,1,98,3,0,93,204,1,1,98,
		3,0,93,205,1,1,98,3,0,93,206,1,1,98,
		3,0,93,207,1,1,98,3,0,93,201,1,1,98,
		3,0,93,202,1,1,98,3,0,93,163,1,1,98,
		3,0,93,168,1,1,98,3,0,93,173,1,1,98,
		3,0,93,174,1,1,98,3,0,93,157,1,1,98,
		3,0,93,159,1,1,98,3,0,93,158,1,1,98,
		3,0,93,153,1,1,98,3,0,93,184,1,1,98,
		3,0,93,137,1,1,98,3,0,93,25,1,1,98,
		3,0,93,131,1,1,20,29,36,29,0,106,9,66,
		117,116,116,111,110,95,49,0,98,3,0,93,160,1,
		2,100,98,3,0,93,161,1,2,100,98,3,0,93,
		176,1,2,100,98,3,0,93,175,1,2,100,98,3,
		0,93,162,1,2,100,98,3,0,93,163,1,2,100,
		98,3,0,93,164,1,2,100,98,3,0,93,165,1,
		2,100,98,3,0,93,166,1,2,100,98,3,0,93,
		167,1,2,100,98,3,0,93,168,1,2,9,98,3,
		0,93,169,1,2,100,98,3,0,93,170,1,2,100,
		98,3,0,93,171,1,2,9,98,3,0,93,172,1,
		2,100,98,3,0,93,173,1,2,9,98,3,0,93,
		174,1,2,100,98,3,0,93,175,1,2,100,98,3,
		0,93,176,1,2,100,98,3,0,93,177,1,2,120,
		98,3,0,93,207,1,2,9,98,3,0,93,156,1,
		2,9,98,3,0,93,157,1,2,9,98,3,0,93,
		158,1,2,9,98,3,0,93,97,1,2,9,98,3,
		0,93,159,1,2,36,30,0,93,230,0,98,3,0,
		93,175,1,2,36,31,0,92,40,98,3,0,93,176,
		1,2,36,32,0,92,100,98,3,0,93,164,1,2,
		36,33,0,92,28,98,3,0,93,165,1,2,36,34,
		0,90,8,176,6,0,12,0,6,98,3,0,93,163,
		1,2,36,35,0,106,10,84,72,32,82,69,65,68,
		45,49,0,98,3,0,93,162,1,2,36,36,0,106,
		6,65,114,105,97,108,0,98,3,0,93,166,1,2,
		36,37,0,92,9,98,3,0,93,167,1,2,36,38,
		0,106,1,0,98,3,0,93,168,1,2,36,39,0,
		9,98,3,0,93,156,1,2,36,40,0,9,98,3,
		0,93,157,1,2,36,41,0,9,98,3,0,93,159,
		1,2,36,42,0,9,98,3,0,93,158,1,2,36,
		43,0,90,4,100,6,98,3,0,93,170,1,2,36,
		44,0,90,4,100,6,98,3,0,93,171,1,2,36,
		45,0,100,98,3,0,93,173,1,2,36,46,0,9,
		98,3,0,93,169,1,2,36,47,0,9,98,3,0,
		93,172,1,2,36,48,0,9,98,3,0,93,174,1,
		2,36,49,0,9,98,3,0,93,207,1,2,36,50,
		0,9,98,3,0,93,97,1,2,36,51,0,100,98,
		3,0,93,177,1,2,36,52,0,106,4,84,79,80,
		0,98,3,0,93,125,1,2,36,53,0,98,3,0,
		93,177,1,1,100,8,29,165,0,176,7,0,98,3,
		0,93,160,1,1,98,3,0,93,161,1,1,98,3,
		0,93,176,1,1,98,3,0,93,175,1,1,98,3,
		0,93,162,1,1,98,3,0,93,163,1,1,98,3,
		0,93,164,1,1,98,3,0,93,165,1,1,98,3,
		0,93,166,1,1,98,3,0,93,167,1,1,98,3,
		0,93,168,1,1,98,3,0,93,170,1,1,98,3,
		0,93,171,1,1,98,3,0,93,169,1,1,98,3,
		0,93,172,1,1,98,3,0,93,173,1,1,98,3,
		0,93,174,1,1,98,3,0,93,156,1,1,98,3,
		0,93,157,1,1,98,3,0,93,159,1,1,98,3,
		0,93,158,1,1,98,3,0,93,97,1,1,20,22,
		26,63,1,98,3,0,93,162,1,1,100,8,28,126,
		176,8,0,98,3,0,93,160,1,1,98,3,0,93,
		161,1,1,98,3,0,93,176,1,1,98,3,0,93,
		175,1,1,106,1,0,98,3,0,93,163,1,1,98,
		3,0,93,164,1,1,98,3,0,93,165,1,1,98,
		3,0,93,177,1,1,98,3,0,93,168,1,1,98,
		3,0,93,170,1,1,98,3,0,93,171,1,1,98,
		3,0,93,169,1,1,98,3,0,93,207,1,1,68,
		98,3,0,93,173,1,1,98,3,0,93,174,1,1,
		98,3,0,93,172,1,1,20,17,26,184,0,176,9,
		0,98,3,0,93,160,1,1,98,3,0,93,161,1,
		1,98,3,0,93,176,1,1,98,3,0,93,175,1,
		1,98,3,0,93,162,1,1,98,3,0,93,163,1,
		1,98,3,0,93,164,1,1,98,3,0,93,165,1,
		1,98,3,0,93,166,1,1,98,3,0,93,167,1,
		1,98,3,0,93,168,1,1,98,3,0,93,170,1,
		1,98,3,0,93,171,1,1,98,3,0,93,169,1,
		1,98,3,0,93,172,1,1,98,3,0,93,173,1,
		1,98,3,0,93,174,1,1,98,3,0,93,156,1,
		1,98,3,0,93,157,1,1,98,3,0,93,159,1,
		1,98,3,0,93,158,1,1,98,3,0,93,177,1,
		1,98,3,0,93,125,1,1,98,3,0,93,97,1,
		1,98,3,0,93,207,1,1,68,20,25,36,55,0,
		176,10,0,106,8,84,105,109,101,114,95,49,0,100,
		93,250,0,90,8,176,11,0,12,0,6,20,4,36,
		57,0,106,9,66,117,116,116,111,110,95,50,0,98,
		3,0,93,160,1,2,100,98,3,0,93,161,1,2,
		100,98,3,0,93,176,1,2,100,98,3,0,93,175,
		1,2,100,98,3,0,93,162,1,2,100,98,3,0,
		93,163,1,2,100,98,3,0,93,164,1,2,100,98,
		3,0,93,165,1,2,100,98,3,0,93,166,1,2,
		100,98,3,0,93,167,1,2,100,98,3,0,93,168,
		1,2,9,98,3,0,93,169,1,2,100,98,3,0,
		93,170,1,2,100,98,3,0,93,171,1,2,9,98,
		3,0,93,172,1,2,100,98,3,0,93,173,1,2,
		9,98,3,0,93,174,1,2,100,98,3,0,93,175,
		1,2,100,98,3,0,93,176,1,2,100,98,3,0,
		93,177,1,2,120,98,3,0,93,207,1,2,9,98,
		3,0,93,156,1,2,9,98,3,0,93,157,1,2,
		9,98,3,0,93,158,1,2,9,98,3,0,93,97,
		1,2,9,98,3,0,93,159,1,2,36,58,0,93,
		230,0,98,3,0,93,175,1,2,36,59,0,93,160,
		0,98,3,0,93,176,1,2,36,60,0,92,100,98,
		3,0,93,164,1,2,36,61,0,92,28,98,3,0,
		93,165,1,2,36,62,0,90,8,176,12,0,12,0,
		6,98,3,0,93,163,1,2,36,63,0,106,10,84,
		72,32,82,69,65,68,45,50,0,98,3,0,93,162,
		1,2,36,64,0,106,6,65,114,105,97,108,0,98,
		3,0,93,166,1,2,36,65,0,92,9,98,3,0,
		93,167,1,2,36,66,0,106,1,0,98,3,0,93,
		168,1,2,36,67,0,9,98,3,0,93,156,1,2,
		36,68,0,9,98,3,0,93,157,1,2,36,69,0,
		9,98,3,0,93,159,1,2,36,70,0,9,98,3,
		0,93,158,1,2,36,71,0,90,4,100,6,98,3,
		0,93,170,1,2,36,72,0,90,4,100,6,98,3,
		0,93,171,1,2,36,73,0,100,98,3,0,93,173,
		1,2,36,74,0,9,98,3,0,93,169,1,2,36,
		75,0,9,98,3,0,93,172,1,2,36,76,0,9,
		98,3,0,93,174,1,2,36,77,0,9,98,3,0,
		93,207,1,2,36,78,0,9,98,3,0,93,97,1,
		2,36,79,0,100,98,3,0,93,177,1,2,36,80,
		0,106,4,84,79,80,0,98,3,0,93,125,1,2,
		36,81,0,98,3,0,93,177,1,1,100,8,29,165,
		0,176,7,0,98,3,0,93,160,1,1,98,3,0,
		93,161,1,1,98,3,0,93,176,1,1,98,3,0,
		93,175,1,1,98,3,0,93,162,1,1,98,3,0,
		93,163,1,1,98,3,0,93,164,1,1,98,3,0,
		93,165,1,1,98,3,0,93,166,1,1,98,3,0,
		93,167,1,1,98,3,0,93,168,1,1,98,3,0,
		93,170,1,1,98,3,0,93,171,1,1,98,3,0,
		93,169,1,1,98,3,0,93,172,1,1,98,3,0,
		93,173,1,1,98,3,0,93,174,1,1,98,3,0,
		93,156,1,1,98,3,0,93,157,1,1,98,3,0,
		93,159,1,1,98,3,0,93,158,1,1,98,3,0,
		93,97,1,1,20,22,26,63,1,98,3,0,93,162,
		1,1,100,8,28,126,176,8,0,98,3,0,93,160,
		1,1,98,3,0,93,161,1,1,98,3,0,93,176,
		1,1,98,3,0,93,175,1,1,106,1,0,98,3,
		0,93,163,1,1,98,3,0,93,164,1,1,98,3,
		0,93,165,1,1,98,3,0,93,177,1,1,98,3,
		0,93,168,1,1,98,3,0,93,170,1,1,98,3,
		0,93,171,1,1,98,3,0,93,169,1,1,98,3,
		0,93,207,1,1,68,98,3,0,93,173,1,1,98,
		3,0,93,174,1,1,98,3,0,93,172,1,1,20,
		17,26,184,0,176,9,0,98,3,0,93,160,1,1,
		98,3,0,93,161,1,1,98,3,0,93,176,1,1,
		98,3,0,93,175,1,1,98,3,0,93,162,1,1,
		98,3,0,93,163,1,1,98,3,0,93,164,1,1,
		98,3,0,93,165,1,1,98,3,0,93,166,1,1,
		98,3,0,93,167,1,1,98,3,0,93,168,1,1,
		98,3,0,93,170,1,1,98,3,0,93,171,1,1,
		98,3,0,93,169,1,1,98,3,0,93,172,1,1,
		98,3,0,93,173,1,1,98,3,0,93,174,1,1,
		98,3,0,93,156,1,1,98,3,0,93,157,1,1,
		98,3,0,93,159,1,1,98,3,0,93,158,1,1,
		98,3,0,93,177,1,1,98,3,0,93,125,1,1,
		98,3,0,93,97,1,1,98,3,0,93,207,1,1,
		68,20,25,36,83,0,106,9,66,117,116,116,111,110,
		95,51,0,98,3,0,93,160,1,2,100,98,3,0,
		93,161,1,2,100,98,3,0,93,176,1,2,100,98,
		3,0,93,175,1,2,100,98,3,0,93,162,1,2,
		100,98,3,0,93,163,1,2,100,98,3,0,93,164,
		1,2,100,98,3,0,93,165,1,2,100,98,3,0,
		93,166,1,2,100,98,3,0,93,167,1,2,100,98,
		3,0,93,168,1,2,9,98,3,0,93,169,1,2,
		100,98,3,0,93,170,1,2,100,98,3,0,93,171,
		1,2,9,98,3,0,93,172,1,2,100,98,3,0,
		93,173,1,2,9,98,3,0,93,174,1,2,100,98,
		3,0,93,175,1,2,100,98,3,0,93,176,1,2,
		100,98,3,0,93,177,1,2,120,98,3,0,93,207,
		1,2,9,98,3,0,93,156,1,2,9,98,3,0,
		93,157,1,2,9,98,3,0,93,158,1,2,9,98,
		3,0,93,97,1,2,9,98,3,0,93,159,1,2,
		36,84,0,93,230,0,98,3,0,93,175,1,2,36,
		85,0,93,24,1,98,3,0,93,176,1,2,36,86,
		0,92,100,98,3,0,93,164,1,2,36,87,0,92,
		28,98,3,0,93,165,1,2,36,88,0,90,8,176,
		13,0,12,0,6,98,3,0,93,163,1,2,36,89,
		0,106,10,84,72,32,82,69,65,68,45,51,0,98,
		3,0,93,162,1,2,36,90,0,106,6,65,114,105,
		97,108,0,98,3,0,93,166,1,2,36,91,0,92,
		9,98,3,0,93,167,1,2,36,92,0,106,1,0,
		98,3,0,93,168,1,2,36,93,0,9,98,3,0,
		93,156,1,2,36,94,0,9,98,3,0,93,157,1,
		2,36,95,0,9,98,3,0,93,159,1,2,36,96,
		0,9,98,3,0,93,158,1,2,36,97,0,90,4,
		100,6,98,3,0,93,170,1,2,36,98,0,90,4,
		100,6,98,3,0,93,171,1,2,36,99,0,100,98,
		3,0,93,173,1,2,36,100,0,9,98,3,0,93,
		169,1,2,36,101,0,9,98,3,0,93,172,1,2,
		36,102,0,9,98,3,0,93,174,1,2,36,103,0,
		9,98,3,0,93,207,1,2,36,104,0,9,98,3,
		0,93,97,1,2,36,105,0,100,98,3,0,93,177,
		1,2,36,106,0,106,4,84,79,80,0,98,3,0,
		93,125,1,2,36,107,0,98,3,0,93,177,1,1,
		100,8,29,165,0,176,7,0,98,3,0,93,160,1,
		1,98,3,0,93,161,1,1,98,3,0,93,176,1,
		1,98,3,0,93,175,1,1,98,3,0,93,162,1,
		1,98,3,0,93,163,1,1,98,3,0,93,164,1,
		1,98,3,0,93,165,1,1,98,3,0,93,166,1,
		1,98,3,0,93,167,1,1,98,3,0,93,168,1,
		1,98,3,0,93,170,1,1,98,3,0,93,171,1,
		1,98,3,0,93,169,1,1,98,3,0,93,172,1,
		1,98,3,0,93,173,1,1,98,3,0,93,174,1,
		1,98,3,0,93,156,1,1,98,3,0,93,157,1,
		1,98,3,0,93,159,1,1,98,3,0,93,158,1,
		1,98,3,0,93,97,1,1,20,22,26,63,1,98,
		3,0,93,162,1,1,100,8,28,126,176,8,0,98,
		3,0,93,160,1,1,98,3,0,93,161,1,1,98,
		3,0,93,176,1,1,98,3,0,93,175,1,1,106,
		1,0,98,3,0,93,163,1,1,98,3,0,93,164,
		1,1,98,3,0,93,165,1,1,98,3,0,93,177,
		1,1,98,3,0,93,168,1,1,98,3,0,93,170,
		1,1,98,3,0,93,171,1,1,98,3,0,93,169,
		1,1,98,3,0,93,207,1,1,68,98,3,0,93,
		173,1,1,98,3,0,93,174,1,1,98,3,0,93,
		172,1,1,20,17,26,184,0,176,9,0,98,3,0,
		93,160,1,1,98,3,0,93,161,1,1,98,3,0,
		93,176,1,1,98,3,0,93,175,1,1,98,3,0,
		93,162,1,1,98,3,0,93,163,1,1,98,3,0,
		93,164,1,1,98,3,0,93,165,1,1,98,3,0,
		93,166,1,1,98,3,0,93,167,1,1,98,3,0,
		93,168,1,1,98,3,0,93,170,1,1,98,3,0,
		93,171,1,1,98,3,0,93,169,1,1,98,3,0,
		93,172,1,1,98,3,0,93,173,1,1,98,3,0,
		93,174,1,1,98,3,0,93,156,1,1,98,3,0,
		93,157,1,1,98,3,0,93,159,1,1,98,3,0,
		93,158,1,1,98,3,0,93,177,1,1,98,3,0,
		93,125,1,1,98,3,0,93,97,1,1,98,3,0,
		93,207,1,1,68,20,25,36,109,0,106,8,76,97,
		98,101,108,95,50,0,98,3,0,93,160,1,2,100,
		98,3,0,93,161,1,2,100,98,3,0,93,176,1,
		2,100,98,3,0,93,175,1,2,100,98,3,0,93,
		178,1,2,100,98,3,0,93,164,1,2,100,98,3,
		0,93,165,1,2,100,98,3,0,93,166,1,2,100,
		98,3,0,93,167,1,2,9,98,3,0,93,203,1,
		2,9,98,3,0,93,204,1,2,9,98,3,0,93,
		205,1,2,9,98,3,0,93,206,1,2,9,98,3,
		0,93,207,1,2,100,98,3,0,93,201,1,2,100,
		98,3,0,93,202,1,2,100,98,3,0,93,163,1,
		2,100,98,3,0,93,173,1,2,9,98,3,0,93,
		174,1,2,9,98,3,0,93,156,1,2,9,98,3,
		0,93,157,1,2,9,98,3,0,93,158,1,2,9,
		98,3,0,93,159,1,2,100,98,3,0,93,168,1,
		2,9,98,3,0,93,184,1,2,9,98,3,0,93,
		153,1,2,9,98,3,0,93,137,1,2,9,98,3,
		0,93,25,1,2,9,98,3,0,93,131,1,2,36,
		110,0,92,120,98,3,0,93,175,1,2,36,111,0,
		93,240,0,98,3,0,93,176,1,2,36,112,0,92,
		120,98,3,0,93,164,1,2,36,113,0,92,24,98,
		3,0,93,165,1,2,36,114,0,106,4,45,45,45,
		0,98,3,0,93,178,1,2,36,115,0,106,6,65,
		114,105,97,108,0,98,3,0,93,166,1,2,36,116,
		0,92,14,98,3,0,93,167,1,2,36,117,0,106,
		1,0,98,3,0,93,168,1,2,36,118,0,9,98,
		3,0,93,156,1,2,36,119,0,9,98,3,0,93,
		157,1,2,36,120,0,9,98,3,0,93,159,1,2,
		36,121,0,9,98,3,0,93,158,1,2,36,122,0,
		100,98,3,0,93,173,1,2,36,123,0,9,98,3,
		0,93,174,1,2,36,124,0,9,98,3,0,93,207,
		1,2,36,125,0,90,4,100,6,98,3,0,93,163,
		1,2,36,126,0,9,98,3,0,93,153,1,2,36,
		127,0,100,98,3,0,93,201,1,2,36,128,0,100,
		98,3,0,93,202,1,2,36,129,0,120,98,3,0,
		93,137,1,2,36,130,0,176,5,0,98,3,0,93,
		160,1,1,98,3,0,93,161,1,1,98,3,0,93,
		176,1,1,98,3,0,93,175,1,1,98,3,0,93,
		178,1,1,98,3,0,93,164,1,1,98,3,0,93,
		165,1,1,98,3,0,93,166,1,1,98,3,0,93,
		167,1,1,98,3,0,93,156,1,1,98,3,0,93,
		203,1,1,98,3,0,93,204,1,1,98,3,0,93,
		205,1,1,98,3,0,93,206,1,1,98,3,0,93,
		207,1,1,98,3,0,93,201,1,1,98,3,0,93,
		202,1,1,98,3,0,93,163,1,1,98,3,0,93,
		168,1,1,98,3,0,93,173,1,1,98,3,0,93,
		174,1,1,98,3,0,93,157,1,1,98,3,0,93,
		159,1,1,98,3,0,93,158,1,1,98,3,0,93,
		153,1,1,98,3,0,93,184,1,1,98,3,0,93,
		137,1,1,98,3,0,93,25,1,1,98,3,0,93,
		131,1,1,20,29,36,132,0,176,14,0,20,0,36,
		13,0,176,15,0,106,5,77,97,105,110,0,106,7,
		67,101,110,116,101,114,0,20,2,36,14,0,176,15,
		0,106,5,77,97,105,110,0,106,9,65,99,116,105,
		118,97,116,101,0,20,2,36,16,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( RELOGIO )
{
	static const HB_BYTE pcode[] =
	{
		36,19,0,176,16,0,106,5,77,97,105,110,0,106,
		8,76,97,98,101,108,95,49,0,106,6,86,97,108,
		117,101,0,176,17,0,12,0,20,4,36,20,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( THREAD_RELOGIO1 )
{
	static const HB_BYTE pcode[] =
	{
		36,27,0,176,18,0,122,108,19,20,2,36,28,0,
		9,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( THREAD_TEMPO2 )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,32,0,106,5,51,48,48,48,0,80,
		1,36,35,0,176,18,0,108,20,106,5,51,48,48,
		48,0,20,2,36,37,0,109,1,0,120,8,28,30,
		36,38,0,176,21,0,106,18,84,72,95,82,69,65,
		68,32,70,73,78,65,76,73,90,79,85,0,20,1,
		36,40,0,9,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( THREAD_TEMPO3 )
{
	static const HB_BYTE pcode[] =
	{
		36,44,0,176,18,0,106,7,84,69,77,80,79,50,
		0,20,1,36,45,0,9,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( SHOW_TIME )
{
	static const HB_BYTE pcode[] =
	{
		36,54,0,176,16,0,106,5,77,97,105,110,0,106,
		9,98,117,116,116,111,110,95,49,0,106,8,101,110,
		97,98,108,101,100,0,9,20,4,36,61,0,176,16,
		0,106,5,77,97,105,110,0,106,8,108,97,98,101,
		108,95,50,0,106,6,118,97,108,117,101,0,176,17,
		0,12,0,20,4,36,64,0,176,22,0,93,244,1,
		20,1,25,207,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TEMPO1 )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,71,0,9,83,1,0,36,72,0,176,
		22,0,176,23,0,95,1,12,1,20,1,36,73,0,
		176,21,0,106,15,84,72,82,69,65,68,32,84,69,
		77,80,79,32,49,0,20,1,36,74,0,120,83,1,
		0,36,75,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( TEMPO2 )
{
	static const HB_BYTE pcode[] =
	{
		36,79,0,176,22,0,93,136,19,20,1,36,80,0,
		176,21,0,106,15,84,72,82,69,65,68,32,84,69,
		77,80,79,32,50,0,20,1,36,82,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}

