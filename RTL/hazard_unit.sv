`include "defines.svh"

module hazard_unit 
(
   input logic              clk, 
	input logic              arstn,
	input logic              en,
	input logic  [32-1:0] input_instr,
	output logic             m1,
	output logic [1:0]       m2,
	output logic             m3
); 

//кольцевой буфер для хранения инструкций

logic [32-1:0] instr [1:0];
logic ptr;
always_ff @(posedge clk, negedge arstn)
   if (~arstn) ptr<=0;	
	else if (en) ptr <= ~ptr;
	
always_ff @(posedge clk)
   if (en) instr[ptr] <= input_instr;
	
//куда указывает ptr, там и вторая инструкция (на этапе вычисления)

wire [4:0] rs1 = instr[~ptr][19:15]; // регистры из которых читает 
wire [4:0] rs2 = instr[~ptr][24:20]; // 1-ая инструкция
wire [4:0] rd =  instr [ptr][11:7]; //регистр в который записывает 2-ая инст.
wire [6:0] opcode1 = instr[~ptr][6:0];

//логика мультиплексоров
always_comb 
   if (rs1===rd) m1 = 1;
	else m1 = 0;
	
always_comb
        if (opcode1 === `jal_opcode)   m2 = 3;
   else if ( (opcode1 === `addi_opcode) || (opcode1 === `lui_opcode) ) m2 = 2;
	else if (rs2 === rd) m2 = 1;
	else  m2 = 0;
	
always_comb
   if (opcode1 === `jal_opcode) m3 = 1;
	else m3 = 0;
	
endmodule
	
	
	
	
	
	
	
	