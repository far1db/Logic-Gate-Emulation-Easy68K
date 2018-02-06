*-----------------------------------------------------------
* Title       :  Logic Gates Emulation
* Description :  
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    BSR GO

STP    SIMHALT             ; halt simulator

* Put variables and constants here

HT  EQU  $09   ; Tab (horizontal 5 characters)
LF  EQU  $0A   ; New line (line feed)
CR  EQU  $0D   ; Carriage Return


GO  MOVE.W #$FF00,D1    ; Clear Screen
    MOVE.B #11,D0   ; Loading the Clear Screen task
    TRAP #15    ; Execution of the task that clears the screen
        
    BSR UI  ; Branch to the subroutine that displays the user interface

* Menu subroutine in charge of displaying the user interface *
UI  LEA MENUTXT,A1  ; Loading the text to the A1 address
    MOVE.B #14,D0   ; Setting the TRAP task (14) to display a string
    TRAP #15        ; Displaying the text
    
    * Drawing the graphics
    
    
    * The borders of the menu
    MOVE.W #20,D1
    MOVE.W #15,D2
    MOVE.W #410,D3
    MOVE.W #135,D4
    
    MOVE.W #90,D0
    TRAP #15
       
    BSR CLEARDR ; Clear the data registers 0 to 4 (graphical issues may occur otherwise)
    
        * Ask the user to choose from one of the above options
CHOICE      LEA ASKCHOICE,A1  
            MOVE.B #18,D0               
            TRAP #15
            
            * Comparing the choice of the user with the available options
            CMP.L #1,D1 ; Choice 1 AND LOGIC GATE
            BEQ AND
            
            CMP.L #2,D1 ; Choice 1 OR LOGIC GATE
            BEQ OR 
            
            CMP.L #3,D1 ; Choice 1 XOR LOGIC GATE
            BEQ XOR
            
            CMP.L #4,D1 ; Choice 1 NAND LOGIC GATE
            BEQ NAND
            
            CMP.L #5,D1 ; Choice 1 NOR LOGIC GATE
            BEQ NOR
            
            CMP.L #6,D1 ; Choice 1 XNOR LOGIC GATE
            BEQ XNOR
            
            CMP.L #7,D1 ; Choice 1 NOT LOGIC GATE
            BEQ NOT
           
            CMP.L #0,D1 ; Choice 1 AND LOGIC GATE
            BEQ STP

            BSR ERROR
            BSR CHOICE                               

* Set the font colour to RED     
REDFONT MOVE.L #$000000FF,D1
        MOVE.B #21,D0
        TRAP #15
        RTS
        
* Set the font colour to WHITE
WHITEFONT MOVE.L #$00FFFFFF,D1
        MOVE.B #21,D0
        TRAP #15
        RTS
* Set the font colour to GREEN
GREENFONT MOVE.L #$0000FF00,D1
        MOVE.B #21,D0
        TRAP #15
        RTS
        
        
* The output is stored in D6 (1 for HIGH and 0 for LOW)
   
* AND Logic Gate SUBROUTINE
AND * Updated the UI according to the user's choice
    
    BSR WHITEFILL ; Set the fill colour to white in order to draw a filled rectangle
    
    * Draw a rectangle in front of this specific choice in the menu to show the current logic gate
    MOVE.L #25,D1
    MOVE.L #63,D2
    MOVE.L #34,D3
    MOVE.L #71,D4
    
    MOVE.B #87,D0
    TRAP #15
    
    BSR BLACKFILL   ; Set the fill colour to default in order to not disturb the next graphic elements such as the text output
    
    BSR CLEARDR     ; Clear the data registers (graphic glitches may occur otherwise)
    
    BSR DRAW2GATE   ; Call the subroutine in charge of drawing the representation of the 2 inputs logic gate

    * Display the word AND in the logic gate (graphical representation)
    LEA ANDTXT,A1
    MOVE.L #502,D1  ; x
    MOVE.L #68,D2   ; y
    MOVE.B #95,D0   ; display A at x,y
    TRAP #15
    BSR CLEARDR ; clear data registers

    BSR INPUT2 ; The subroutine INPUT2 is in charge of asking the user for the 2 inputs (A and B) of the logic gate
    
    MULS D5,D6  ; Multiplying A and B to get the output of the AND logic gate (1*0=0 and 1*1=1 which give us the exact output of the AND gate)
    CMP.L #1,D6
    BLE OUTPUT
    
    BSR ERROR   ; Display an error in case the user input is not 1 or 0
    
    BSR AND     ; Ask again for the two inputs in case of invalid inputs
    
* OR Logic Gate SUBROUTINE
OR * Updated the UI according to the user's choice
    
    BSR WHITEFILL   ; Set the fill colour to white in order to draw a filled rectangle
    
    * Draw a rectangle in front of this specific choice in the menu to show the current logic gate
    MOVE.L #25,D1
    MOVE.L #78,D2
    MOVE.L #34,D3
    MOVE.L #86,D4
    
    MOVE.B #87,D0
    TRAP #15
    
    BSR BLACKFILL   ; Set the fill colour to default in order to not disturb the next graphic elements such as the text output
    
    BSR CLEARDR     ; Clear the data registers (graphic glitches may occur otherwise)
    
    BSR DRAW2GATE   ; Call the subroutine in charge of drawing the representation of the 2 inputs logic gate
    
    * Display the word XOR in the logic gate (graphical representation)
    LEA ORTXT,A1
    MOVE.L #506,D1  ; x
    MOVE.L #68,D2   ; y
    MOVE.B #95,D0   ; display A at x,y
    TRAP #15
    BSR CLEARDR ; clear data registers

    BSR INPUT2 ; The subroutine INPUT2 is in charge of asking the user for the 2 inputs (A and B) of the logic gate
    
    ADD.B D5,D6  ; Adding A and B to get the output of the OR logic gate (0+0=0 1+0=1 and (1+1=2 the subroutine ORCALCULATE is in charge of this case))
    
    CMP.L #1,D6   ; if the result is 1 or 0 display it as the output
    BLE OUTPUT
    
    CMP.L #2,D6   ; if the result is 2 call the subroutine ORCALCULATE that sets the output to high
    BEQ SETTRUE     ; * IN CASE THE USER INPUT IS 1 | 1 (D6=2) OUTPUT HIGH
    
    BSR ERROR   ; Display an error in case the user input is not 1 or 0
    
    BSR OR     ; Ask again for the two inputs in case of invalid inputs


* XOR Logic Gate SUBROUTINE    
XOR * Updated the UI according to the user's choice
    
    BSR WHITEFILL   ; Set the fill colour to white in order to draw a filled rectangle
    
    * Draw a rectangle in front of this specific choice in the menu to show the current logic gate
    MOVE.L #25,D1
    MOVE.L #93,D2
    MOVE.L #34,D3
    MOVE.L #101,D4
    
    MOVE.B #87,D0
    TRAP #15
    
    BSR BLACKFILL ; Set the fill colour to default in order to not disturb the next graphic elements such as the text output
    
    BSR CLEARDR     ; Clear the data registers (graphic glitches may occur otherwise)
    
    BSR DRAW2GATE   ; Call the subroutine in charge of drawing the representation of the 2 inputs logic gate
    
    * Display the word XOR in the logic gate (graphical representation)
    LEA XORTXT,A1
    MOVE.L #502,D1  ; x
    MOVE.L #68,D2   ; y
    MOVE.B #95,D0   ; display A at x,y
    TRAP #15
    BSR CLEARDR ; clear data registers

    BSR INPUT2 ; The subroutine INPUT2 is in charge of asking the user for the 2 inputs (A and B) of the logic gate
    
    ADD.B D5,D6  ; Adding A and B to get the output of the XOR logic gate (1+0=1 and 0+0=0 which give us the exact output of the OR gate, BUT 1+1=2 is LOW)
    CMP.L #1,D6  ; 
    BLE OUTPUT  
    
    CMP.L #2,D6   ; When A=1 and B=1 the output is LOW so the SETFALSE subroutine is called 
    BEQ SETFALSE
    
    BSR ERROR   ; Display an error in case the user input is not 1 or 0
    
    BSR XOR     ; Ask again for the two inputs in case of invalid inputs
    
        
* NAND Logic Gate SUBROUTINE
NAND * Updated the UI according to the user's choice
    
    BSR WHITEFILL   ; Set the fill colour to white in order to draw a filled rectangle
    
    * Draw a rectangle in front of this specific choice in the menu to show the current logic gate
    MOVE.L #25,D1
    MOVE.L #108,D2
    MOVE.L #34,D3
    MOVE.L #116,D4
    
    MOVE.B #87,D0
    TRAP #15
    
    BSR BLACKFILL ; Set the fill colour to default in order to not disturb the next graphic elements such as the text output
    
    BSR CLEARDR     ; Clear the data registers (graphic glitches may occur otherwise) 
    
    BSR DRAW2GATE   ; Call the subroutine in charge of drawing the representation of the 2 inputs logic gate
    
    * Display the word AND in the logic gate (graphical representation)
    LEA NANDTXT,A1
    MOVE.L #499,D1  ; x
    MOVE.L #68,D2   ; y
    MOVE.B #95,D0   ; display A at x,y
    TRAP #15
    BSR CLEARDR ; clear data registers

    BSR INPUT2 ; The subroutine INPUT2 is in charge of asking the user for the 2 inputs (A and B) of the logic gate
    
    MULS D5,D6  ; Multiplying A and B to get the output of the AND logic gate (1*0=0 and 1*1=1 which give us the exact output of the AND gate)
    ADD.B #1,D6 ; Adding 1 to the output of the AND gate to get the output of a NOT AND gate
    CMP.L #1,D6
    BLE OUTPUT
    
    * In case the user input is A=1 and B=1 the output is set to false by the subroutine SETFALSE
    CMP.L #2,D6
    BEQ SETFALSE
    
    BSR ERROR   ; Display an error in case the user input is not 1 or 0
    
    BSR NAND     ; Ask again for the two inputs in case of invalid inputs
    

* NOR Logic Gate SUBROUTINE
NOR * Updated the UI according to the user's choice
    
    BSR WHITEFILL ; Set the fill colour to white in order to draw a filled rectangle
    
    * Draw a rectangle in front of this specific choice in the menu to show the current logic gate
    MOVE.L #208,D1
    MOVE.L #63,D2
    MOVE.L #217,D3
    MOVE.L #71,D4
    
    MOVE.B #87,D0
    TRAP #15
    
    BSR BLACKFILL   ; Set the fill colour to default in order to not disturb the next graphic elements such as the text output
    
    BSR CLEARDR     ; Clear the data registers (graphic glitches may occur otherwise) 
    
    BSR DRAW2GATE   ; Call the subroutine in charge of drawing the representation of the 2 inputs logic gate
    
    * Display the word AND in the logic gate (graphical representation)
    LEA NORTXT,A1
    MOVE.L #502,D1  ; x
    MOVE.L #68,D2   ; y
    MOVE.B #95,D0   ; display A at x,y
    TRAP #15
    BSR CLEARDR ; clear data registers
    
    BSR INPUT2 ; The subroutine INPUT2 is in charge of asking the user for the 2 inputs (A and B) of the logic gate
    
    ADD.B D5,D6  ; Adding A and B to get the output of the OR logic gate THEN inversing the output 
    
    CMP.L #0,D6  ; If A=0 and B=0 output HIGH
    BEQ SETTRUE
    CMP.L #2,D6  ;  if A+B is 1 or 2 output LOW
    BLE SETFALSE
    
    
    BSR ERROR   ; Display an error in case the user input is not 1 or 0
    
    BSR NOR     ; Ask again for the two inputs in case of invalid inputs
    
         
* XNOR Logic Gate SUBROUTINE
XNOR * Updated the UI according to the user's choice
    
    BSR WHITEFILL ; Set the fill colour to white in order to draw a filled rectangle
    
    * Draw a rectangle in front of this specific choice in the menu to show the current logic gate
    MOVE.L #208,D1
    MOVE.L #78,D2
    MOVE.L #217,D3
    MOVE.L #86,D4
    
    MOVE.B #87,D0
    TRAP #15
    
    BSR BLACKFILL   ; Set the fill colour to default in order to not disturb the next graphic elements such as the text output
    
    BSR CLEARDR     ; Clear the data registers (graphic glitches may occur otherwise)   
    
    BSR DRAW2GATE   ; Call the subroutine in charge of drawing the representation of the 2 inputs logic gate
    
    * Display the word AND in the logic gate (graphical representation)
    LEA XNORTXT,A1
    MOVE.L #499,D1  ; x
    MOVE.L #68,D2   ; y
    MOVE.B #95,D0   ; display A at x,y
    TRAP #15
    BSR CLEARDR ; clear data registers

    BSR INPUT2 ; The subroutine INPUT2 is in charge of asking the user for the 2 inputs (A and B) of the logic gate
    
    ADD.B D5,D6  ; Adding A to B (if A+B=0 or A+B=2 output HIGH | A+B=1 output LOW | Display error otherwise)
    
    CMP.L #0,D6 ; If A=0 and B=0 output HIGH
    BEQ SETTRUE
    CMP.L #2,D6 ; If A=1 and B=1 output HIGH
    BEQ SETTRUE
    CMP.L #1,D6 ; Output LOW when A+B=1
    BEQ SETFALSE 
    
    BSR ERROR   ; Display an error in case the user input is not 1 or 0
    
    BSR XNOR    ; Ask again for the two inputs in case of invalid inputs
    
         
* NOT Logic Gate SUBROUTINE
NOT * Updated the UI according to the user's choice
    
    BSR WHITEFILL ; Set the fill colour to white in order to draw a filled rectangle
    
    * Draw a rectangle in front of this specific choice in the menu to show the current logic gate
    MOVE.L #208,D1
    MOVE.L #93,D2
    MOVE.L #217,D3
    MOVE.L #101,D4
    
    MOVE.B #87,D0
    TRAP #15
    
    BSR BLACKFILL   ; Set the fill colour to default in order to not disturb the next graphic elements such as the text output
    
    BSR CLEARDR     ; Clear the data registers (graphic glitches may occur otherwise) 

    BSR DRAWNOT     ; Call the subroutine in charge of drawing the representation of the NOT gate

    BSR INPUT1
    
    CMP.L #0,D5 ; if the input is LOW call the subroutine SETTRUE
    BEQ SETTRUE
    
    CMP.L #1,D5 ; if the input is HIGH call the subroutine SETTRUE
    BEQ SETFALSE
    
    BSR ERROR
    
    BSR NOT
    
SETTRUE MOVE.B #1,D6    ; set D6 (the output) to HIGH (FROM LOW TO HIGH)
        BSR OUTPUT      ; display the output to the user

SETFALSE MOVE.B #0,D6   ; set D6 (the output) to LOW (FROM HIGH TO LOW)
         BSR OUTPUT     ; display the output to the user
         

* Subroutine that displays an error (in red) in case of an invalid inputs
      
ERROR BSR REDFONT   ; Branch to the REDFONT subroutine that changes the fond colour to red
      
        * The error message is displayed
        LEA ERRORMSG,A1  
        MOVE.B #14,D0               
        TRAP #15
 
      BSR WHITEFONT ; Branch to the WHITEFONT subroutine that sets back the font colour to white
      RTS

* Subroutine asking the user for the 2 inputs of the logic gate
INPUT2  CLR.L D1  ; Clearing the data registers to avoid incorrect values  
        CLR.L D5
        CLR.L D6

        * Highlight the input A in green
        BSR GREENFONT
        BSR DISPLAYA
        BSR WHITEFONT
        
        LEA INPUTA,A1   
        MOVE.B #18,D0   ; Using task 18 to display a string AND ask the user for a number
        TRAP #15
        MOVE.L D1,D5    ; Storing the A input in D5 because we need D1 to store the B input
        
        
        BSR DISPLAYA    ; Reset the graphics to default (set back the input A to white;not highlighted)
        * Highlight the input B in green
        BSR GREENFONT
        BSR DISPLAYB
        BSR WHITEFONT
    
        LEA INPUTB,A1
        MOVE.B #18,D0
        TRAP #15
        MOVE.L D1,D6    ; Storing the B input in D6 because D1 is used and thus avoid losing B by overwriting D1 
        
        BSR DISPLAYB    ; Reset the graphics to default (set back the input B to white;not highlighted)
        
        RTS
        
INPUT1 CLR.L D1 ; Clearing the data registers to avoid incorrect values
       CLR.L D5

       LEA INPUTNOT,A1
       MOVE.B #18,D0
       TRAP #15
       MOVE.L D1,D5
       
       RTS
        

* Subroutine in charge of displaying the output of the logic gate to the user
OUTPUT  LEA OUTPUTTXT,A1
        MOVE.B #14,D0
        TRAP #15
        
        CMP.L #1,D6 ; If the output is 1 (HIGH)
        BEQ TRUE    ; Branch to subroutine TRUE to display the output
        
        CMP.L #0,D6 ; If the output is 0 (LOW)
        BEQ FALSE
        
TRUE    LEA TRUETXT,A1
        BSR GREENFONT   ; Use a green font to display the TRUE output
        MOVE.B #14,D0
        TRAP #15
        
        BSR DRAW1   ; Display 1 in the output of the logic gate (graphical representation)
        
        BSR WHITEFONT   ; Setting back the font colour to default
        
        BSR AGAIN
        
FALSE   LEA FALSETXT,A1
        BSR REDFONT   ; Use a RED font to display the FALSE output
        MOVE.B #14,D0
        TRAP #15
        
        BSR DRAW0

        BSR WHITEFONT   ; Setting back the font colour to default
        
        BSR AGAIN


* Subroutine asking the user to either to exit the programme or to start again
AGAIN   LEA AGAINTXT,A1
        MOVE.B #18,D0
        TRAP #15
        
        CMP.L #1,D1
        BEQ GO  ; RESTART THE PROGRAMME
        
        BSR STP ; CALL SIMHALT TO STOP THE PROGRAMME IF ANY KEY OTHER THAN 1 IS PRESSED

* Clear the data registers D0 to D4        
CLEARDR     CLR.L D0
            CLR.L D1
            CLR.L D2
            CLR.L D2
            CLR.L D3
            CLR.L D4
            RTS
* Drawing the representation of the logic gates            
DRAW2GATE  * Borders the right rectangle
            MOVE.L #420,D1
            MOVE.L #15,D2
            MOVE.L #620,D3
            MOVE.L #135,D4
    
            MOVE.B #90,D0
            TRAP #15
                        
            BSR DISPLAYB ; Display B in the second input of the logic gate ; I do not call the DISPLAYA subroutine because it is called in INPUT2 to display A in Green
            
            * Display the two lines that connect the inputs to the logic gate
            MOVE.L #455,D1
            MOVE.L #62,D2
            MOVE.L #480,D3
            MOVE.L #62,D4
            MOVE.B #84,D0
            TRAP #15
            
            MOVE.L #455,D1
            MOVE.L #88,D2
            MOVE.L #480,D3
            MOVE.L #88,D4
            MOVE.B #84,D0
            TRAP #15
            
            * Display the rectangle which represents the logic gate
            MOVE.L #480,D1
            MOVE.L #42,D2
            MOVE.L #550,D3
            MOVE.L #104,D4
    
            MOVE.B #90,D0
            TRAP #15
            * Draw the line that goes to the output of the gate
            MOVE.L #550,D1
            MOVE.L #75,D2
            MOVE.L #585,D3
            MOVE.L #75,D4
            MOVE.B #84,D0
            TRAP #15
            
            BSR CLEARDR ; Clear the data registers 0 to 4 (graphical issues may occur otherwise)
            RTS
            
* Draw the representation of the NOT gate 
DRAWNOT * Borders the right rectangle
            MOVE.L #420,D1
            MOVE.L #15,D2
            MOVE.L #620,D3
            MOVE.L #135,D4
    
            MOVE.B #90,D0
            TRAP #15
            
            BSR CLEARDR     ; Clear data register to avoid graphical issues
            BSR GREENFONT   ; Change font colour to GREEN
            
            * Display A in green
            LEA A,A1
            MOVE.L #440,D1  ; x
            MOVE.L #68,D2   ; y
            MOVE.B #95,D0   ; display A at x,y
            TRAP #15
            
            BSR CLEARDR     ; Clear data register to avoid graphical issues
            BSR WHITEFONT   ; Change back font colour to WHITE
            
            * Display the line that connect the input to the NOT gate
            MOVE.L #455,D1
            MOVE.L #75,D2
            MOVE.L #480,D3
            MOVE.L #75,D4
            MOVE.B #84,D0
            TRAP #15
            * Draw the NOT logic gate
            ** Draw the vertical line
            MOVE.L #480,D1
            MOVE.L #40,D2
            MOVE.L #480,D3
            MOVE.L #110,D4
            MOVE.B #84,D0
            TRAP #15
            ** Draw the line coming from the top to the middle
            MOVE.L #480,D1
            MOVE.L #40,D2
            MOVE.L #550,D3
            MOVE.L #75,D4
            MOVE.B #84,D0
            TRAP #15
            ** Draw the line coming from the bottom to the middle
            MOVE.L #480,D1
            MOVE.L #110,D2
            MOVE.L #550,D3
            MOVE.L #75,D4
            MOVE.B #84,D0
            TRAP #15
            ** Draw the circle
            MOVE.L #550,D1
            MOVE.L #70,D2
            MOVE.L #560,D3
            MOVE.L #80,D4
            MOVE.B #88,D0
            TRAP #15
            * Display the line that goes to the output of the NOT gate
            MOVE.L #560,D1
            MOVE.L #75,D2
            MOVE.L #585,D3
            MOVE.L #75,D4
            MOVE.B #84,D0
            TRAP #15
                      
            BSR CLEARDR ; clear data registers
            
            RTS
           
* Draw 1 in the output of the graphical representation of the logic gate
DRAW1   LEA ONE,A1
        MOVE.L #595,D1  ; x
        MOVE.L #68,D2   ; y
        MOVE.B #95,D0   ; display A at x,y
        TRAP #15
        BSR CLEARDR ; clear data registers
        RTS
        
* Draw 0 in the output of the graphical representation of the logic gate
DRAW0   LEA ZERO,A1
        MOVE.L #595,D1  ; x
        MOVE.L #68,D2   ; y
        MOVE.B #95,D0   ; display A at x,y
        TRAP #15
        BSR CLEARDR ; clear data registers
        RTS


DISPLAYA    * Display the input A of the logic gate
            LEA A,A1
            MOVE.L #440,D1  ; x
            MOVE.L #55,D2   ; y
            MOVE.B #95,D0   ; display A at x,y
            TRAP #15
            BSR CLEARDR ; clear data registers
            RTS
            
DISPLAYB * Display the input B of the logic gate
            LEA B,A1
            MOVE.L #440,D1  ; x
            MOVE.L #81,D2   ; y
            MOVE.B #95,D0   ; display B at x,y
            TRAP #15
            BSR CLEARDR ; clear data registers
            RTS
            
* Set fill colour to WHITE
WHITEFILL   MOVE.L #$00FFFFFF,D1
            MOVE.B #81,D0
            TRAP #15
            RTS
* Set fill colour to BLACK (DEFAULT)
BLACKFILL   MOVE.L #$00000000,D1
            MOVE.B #81,D0
            TRAP #15
            RTS 

* Constant that stores the menu text    
MENUTXT DC.B CR,LF,CR,LF,HT,HT,' ---- Logic Gates Emulation ----',CR,LF,CR,LF
        DC.B HT,'1. AND Logic Gate',HT,' 5. NOR Logic Gate',CR,LF
        DC.B HT,'2. OR Logic Gate',HT,'  6. XNOR Logic Gate',CR,LF
        DC.B HT,'3. XOR Logic Gate',HT,' 7. NOT Logic Gate',CR,LF
        DC.B HT,'4. NAND Logic Gate',HT,'0. Exit the programme',CR,LF,CR,LF,0
        
ASKCHOICE DC.B CR,LF,'Please choose one option from the menu above : ',0

ERRORMSG DC.B 'Error : You have entered an invalid number !',CR,LF,CR,LF,0


INPUTA DC.B 'Please enter the first input (A) of the logic gate (1=High or 0=Low) : ',0
INPUTB DC.B 'Please enter the second input (B) of the logic gate (1=High or 0=Low) : ',0

INPUTNOT DC.B 'Please enter the input of the NOT gate (1=High or 0=Low) : ',0

OUTPUTTXT DC.B ' => The output of the logic gate is : ',0

TRUETXT DC.B '1 (HIGH)',0
FALSETXT DC.B '0 (LOW)',0

AGAINTXT DC.B CR,LF,CR,LF,'Please enter 1 to start again or any other key to exit : ',0

A DC.B 'A',0
B DC.B 'B',0

ONE DC.B '1',0
ZERO DC.B '0',0

ANDTXT DC.B 'AND',0
XORTXT DC.B 'XOR',0
ORTXT DC.B 'OR',0
NANDTXT DC.B 'NAND',0
NORTXT DC.B 'NOR',0
XNORTXT DC.B 'XNOR',0


    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
