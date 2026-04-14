module top_module(reset, clk, PC_next, PC);input reset; 
	input clk;
	input [31:0] PC_next; 
	output reg [31:0] PC;         
	always @(posedge reset or posedge clk)
	begin
	if (reset)
		PC <= 32'h80000000;
	else
		PC <= PC_next;
	end
endmodule