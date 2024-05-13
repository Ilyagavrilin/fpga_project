# FPGA project for digital electrnics course
This project - case-study for implementing some opcodes and 7-segment indicator demo on Verilog language.
## Board and Tools
+ Board: OMDAZZ Cyclone iv
+ Primary tool: Quartus Prime
+ Additional: Icarus Verilog 

(Thanks to "Школа цифрового синтеза", Yadro)
## How to use
### Used interfaces 
+ 4-pin dip switch, duplicated with buttons set
+ reset button
+ 50MHz clock
+ 4 numbers 7 segment indicator with dots (muxed)

### Dip-switch scheme
|   |   |   |   |           Display           |
|:-:|:-:|:-:|:-:|:---------------------------:|
| 1 | 0 | * | * | display 1st register (reg1) |
| 0 | 1 | * | * | display 2nd register (reg2) |
| 1 | 1 | * | * |          deprecated         |
| 0 | 0 | 0 | 0 |             TBD             |
| 0 | 0 | 0 | 1 |     CLMUL RISC-V opcode     |
| 0 | 0 | 1 | 0 |      CLZ RISC-V opcode      |
| 0 | 0 | 1 | 1 |     cubic root from reg1    |

1 - switch pulled up (or button pressed) 

0 - switch pulled down (or button non pressed) 

\* - any condition  
