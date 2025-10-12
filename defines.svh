`ifndef DEFINES_SVH       // защита от двойного подключения
`define DEFINES_SVH


`define lui_opcode    7'b0110111
`define addi_opcode   7'b0010011
`define jal_opcode    7'b1101111
`define beq_opcode    7'b1100011
`define bne_opcode    7'b1100011
`define R_type_opcode 7'b0110011


`define add  17'b00000000000110011
`define or_i 17'b00000001100110011
`define srl  17'b00000001010110011
`define sub  17'b01000000000110011
`define sltu 17'b00000000110110011
`define addi 17'b???????0000010011
`define lui  17'b??????????0110111
`define jal  17'b??????????1101111

`endif // DEFINES_SVH