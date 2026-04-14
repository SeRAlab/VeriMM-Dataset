module top_module(input[7:0] x, 
					output[7:0] result, 
					output carry);assign carry = x[0];
	assign result = x >> 1;endmodule