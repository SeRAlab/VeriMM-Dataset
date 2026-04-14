module top_module (
	input a, 
	input b, 
	output reg c);assign c = ~(a ^ b);

endmodule