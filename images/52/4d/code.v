module top_module(
	input clk,rst_n,
	input [31:0]mem_out,
	output reg [31:0]Data
   );always@(*)
	begin
		if(~rst_n) Data = 32'bx;
		else Data = mem_out;
	end

endmodule