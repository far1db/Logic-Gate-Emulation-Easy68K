# Logic-Gate-Emulation-Easy68K
An emulator that reproduces logical functions (AND, OR, XOR, NAND, NOR, XNOR and NOT) using assembly on the Easy68K simulator

![Screenshot](https://github.com/far1db/Logic-Gate-Emulation-Easy68K/blob/master/screenshot.png)

## How it works
At the start of the programme, a menu is shown using the TRAP tasks (INPUT/OUTPUT and Graphic interrupts) then the programme asks the user to choose from the available options from the menu. If the user inputs an option not present in the menu (invalid choice number), an error is displayed and the user is asked to choose from the menu again. A subroutine is called depending on the user input. One subroutine for each logic gate (AND, OR, XOR, NAND, NOR, XNOR and NOT) and the STP subroutine in charge of exiting the programme. When a logic gate is chosen its subroutine draws a graphical representation for this logic gate and asks the user to enter binary inputs.

## Flowchart
![Flowchart](https://github.com/far1db/Logic-Gate-Emulation-Easy68K/blob/master/flowchart.png)
