`timescale 1 ns/1 ns
module tb_pipeline_processor ();
logic clk_50, arstn;
logic  [31:0] out;
pipeline_processor dut
(
   .clk_50(clk_50),
	.arstn(arstn),
	.out(out)
);
parameter T=10;
//блок для генерации тактового сигнала
initial begin
    clk_50<=0;
	 forever begin
	     #(T/2);  clk_50<=~clk_50;
		  end
	end	
//блок сброса
initial begin
    arstn<=0;
	 #1;
	 arstn<=1;
	end
task 	wait_task (int a);
   repeat (a) @(posedge clk_50);
endtask
//блок ожидания
initial begin 
   wait_task (500);
	$finish();
end

endmodule