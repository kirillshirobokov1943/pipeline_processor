`include "defines.svh"
module registers #(parameter width = 32, depth = 32, ad_width = $clog2 (depth))
(
   input logic              clk,
	input logic  [ad_width-1:0]       A1,
	input logic  [ad_width-1:0]       A2,
	input logic  [ad_width-1:0]       A3,
	input logic  [width-1:0] WD3,
	output logic [width-1:0] RD1,
	output logic [width-1:0] RD2,
	output logic [width-1:0] a0
);

logic [width-1:0] x [depth-1:0];

assign x[0]='d0;
assign x[2]='d0;
assign x[3]='d0;

always_ff @(posedge clk)
   if (A3==5'd1) x[1] <= WD3;

genvar i;	
generate 
for (i=4; i<=depth-1; i++) begin: forloop
   always_ff @(posedge clk)
      if (A3==i) x[i] <= WD3;
	end
endgenerate
	
assign RD1 = x[A1];
assign RD2 = x[A2];
assign a0 = x[10];
endmodule