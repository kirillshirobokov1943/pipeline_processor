`include "defines.svh"
module brench_logic 
(
   input logic [32-1:0] instr_reg,
	input logic [32-1:0] R1,
	input logic [32-1:0] R2,
	output logic brench
);

wire [6:0] opcode = instr_reg[6:0];
wire eq = (R1==R2);
always_comb
   if      (opcode == `jal_opcode )      brench = 1'b1;
	else if (opcode == `beq_opcode)       brench = eq ^^ instr_reg[12];	
	else                                  brench = 0;
endmodule
	   
	