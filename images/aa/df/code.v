module top_module(A, B, clk, fetch, res, exception);input [31:0] A, B;
	input clk, fetch;
	output [31:0] res;
	output exception;
	
	assign res = A / B;
	assign exception = 1'b0;
endmodule