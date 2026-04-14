module top_module(operand, result);input [31:0] operand;
	output [31:0] result;
	
	assign result[31:16] = operand[15:0];
	assign result[15:0] = 16'b0000000000000000;
	
endmodule