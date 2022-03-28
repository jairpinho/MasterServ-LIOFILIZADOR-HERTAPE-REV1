#include <hmg.ch>

Function Main

        Load Window Main
        Main.Center
        Main.Activate

Return


Function tempo()

Local nTime := seconds() + 2 
      Main.label_1.value := str(nTime)
Return


Function segundos()
      Main.label_2.value := seconds()
return