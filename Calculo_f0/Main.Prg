#include <hmg.ch>
#include <minigui.ch>
#include "common.ch"
#Include "Fileio.ch"
Function Main

        Load Window Main
        Main.Center
        Main.Activate

Return





FUNCTION CALCULA_F0()

Local nResultado ,nTemperatura,nSet_Point_Temp ,nZ_Set_Point
local naux1 := 0
local naux2 := 0

SET DECIMALS TO 9
nTemperatura := Main.Text_1.value
nSet_Point_Temp :=  Main.Text_2.value 
 nZ_Set_Point  := Main.Text_3.value

naux1 := nTemperatura-nSet_Point_Temp
naux2 := naux1/nZ_Set_Point
nResultado := 10^naux2
Main.Text_4.value := nResultado
RETURN
