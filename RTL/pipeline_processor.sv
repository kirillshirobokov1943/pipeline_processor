`include "defines.svh"
module pipeline_processor
(
   input logic clk_50,  //вход 50MHz с кварцевого генератора
	input logic arstn, 
	output logic [31:0] out
);
logic clk; //основной тактовый сигнал частотой 80MHz (с PLL)
//ввод PLL для генерации тактового сигнала 80MHz
PLL_80MHz pll_inst
(
   .inclk0(clk_50),
	.c0(clk),
	.areset (~arstn)
);
//описание pc
logic [32-1:0] pc; 
logic [32-1:0] next_pc;  
always_ff @(posedge clk, negedge arstn)
   if (~arstn) pc<=0;
   else pc <= next_pc;
//ввод isnst_mem
logic [32-1:0] instr; 
instr_mem #(.width(32), .depth(256)) intsr_mem1 (
   .arstn(arstn),
   .A(pc),
	.instr(instr)
);
//описание регистра после памяти инструкций (с синхронным сбросом)
logic [32-1:0] instr_reg; 
logic en;                    
always_ff @(posedge clk)
   if (~en) instr_reg<=0;
	else     instr_reg<=instr;
//описание регистрового файла
wire [4:0] rs1 = instr_reg[19:15]; 
wire [4:0] rs2 = instr_reg[24:20]; 
logic  [32-1:0] RD1; 
logic  [32-1:0] RD2;
logic  [32-1:0] WD3; 
logic [4:0] addr_wr;   
registers #(.width(32), .depth(32)) r1
(
   .clk(clk),
	.A1(rs1),
	.A2(rs2),
	.A3(addr_wr),
	.WD3(WD3),   
	.RD1(RD1),
	.RD2(RD2),
	.a0(out)
);
//описание второго блока конвейерных регситров
logic [16:0] control_ALU; 
logic [32-1:0] D1;  
logic [32-1:0] D2;      
wire [6:0] funct7 = instr_reg[31:25];
wire [2:0] funct3 = instr_reg[14:12];
wire [6:0] opcode = instr_reg[6:0];
always_ff @(posedge clk)
   control_ALU <= {funct7, funct3, opcode };
	
logic [32-1:0] w_D1;   
logic [32-1:0] w_D2;   
always_ff @(posedge clk) begin
   D1 <= w_D1;
	D2 <= w_D2;
end
wire [4:0] rd = instr_reg[11:7];
always_ff @(posedge clk) 
   addr_wr <= rd;	
//подключение ALU
logic [32-1:0] ALU_out; 
my_ALU my_ALU1
(
   .x1(D1),
	.x2(D2),
	.control_ALU(control_ALU),
	.ALU_out(ALU_out)
);
//подключение hazrd_unit
logic m1; 
logic [1:0] m2; 
logic m3; 
hazard_unit h1
(
   .clk(clk),
	.arstn(arstn),
	.en(en),
	.input_instr(instr), 
	.m1(m1),
	.m2(m2), 
	.m3(m3)
);
//выражение для imm
logic [32-1:0] imm; 
wire [19:0] imm20 = instr_reg[31:12];
wire [11:0] imm12 = instr_reg[31:20];
always_comb
   case (opcode)
	   `lui_opcode:  imm = {imm20, 12'd0 };
		`addi_opcode: imm = { {20{imm12[11]}} , imm12};
		default:     imm = 32'd0;
	endcase
//регистр, в котором хранится pc предыдущей инструкции
logic [32-1:0] prev_pc; //+
always_ff @(posedge clk)
   if (en) prev_pc <= pc;		
//шина с сохраненной pc для jal
logic [32-1:0] save_pc; 
assign save_pc = prev_pc + 4;
assign WD3 = ALU_out;		
//мультиплесор m1
assign w_D1 = m1? ALU_out:RD1;
//мультиплексор m2
always_comb
   case (m2)
	   2'b00:   w_D2 = RD2;
	   2'b01:   w_D2 = ALU_out;
	   2'b10:   w_D2 = imm;
		2'b11:   w_D2 = save_pc;
	   default: w_D2 = RD2;	
	endcase	
//сигналы для следующего pc без перехода
logic [32-1:0] not_brench_pc; 
assign not_brench_pc = pc + 4;
//блок, реализующий комбинационную логику смещения
logic [32-1:0] brench_pc;
offset_res o1
(
   .instr_reg(instr_reg),
	.prev_pc(prev_pc),
	.brench_pc(brench_pc)
);
//логика переходов (условных и безусловных)
logic brench; 
brench_logic b1
(
   .instr_reg(instr_reg),
	.R1(w_D1),
	.R2(w_D2),
	.brench(brench)
);
//мультиплесор на pc
assign next_pc = brench? brench_pc:not_brench_pc;
assign en = ~brench;
endmodule





	
	
	








	
	
	
	



