`include "defines.svh"

module my_ALU 
(
   input logic  [32-1:0] x1,
	input logic  [32-1:0] x2,
	input logic  [16:0]      control_ALU,
	output logic [32-1:0] ALU_out
);
always_comb 
   casez (control_ALU)
	   `add: ALU_out = x1 + x2;
		`or_i: ALU_out = x1|x2;
		`srl: ALU_out = x1 >> x2[4:0];
		`sub: ALU_out = x1 - x2;
		`sltu: ALU_out = (x1<x2)?32'b1:32'b0;
		`addi: ALU_out = x1 + x2;
		`lui: ALU_out = x2;
		`jal: ALU_out = x2;
		default: ALU_out = 'd0;
	endcase
endmodule
		
		
	   