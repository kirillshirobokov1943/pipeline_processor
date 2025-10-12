`include "defines.svh"
module offset_res 
(
   input logic [32-1:0] instr_reg,
	input logic [32-1:0] prev_pc,
	output logic [32-1:0] brench_pc
);

wire [6:0] opcode = instr_reg[6:0];
logic signed  [32-1:0]   offset;
always_comb 
   case (opcode)
    `beq_opcode: 
	   offset = { {19{instr_reg[31]}}, instr_reg[31], instr_reg[7], instr_reg[30:25], instr_reg[11:8], 1'b0};
	 `jal_opcode:
	   offset = {{11{instr_reg[31]}}, instr_reg[31], instr_reg[19:12], instr_reg[20], instr_reg[30:21],1'b0};
	default: 
	   offset = 32'd0;
	endcase

assign brench_pc = prev_pc + offset;
endmodule