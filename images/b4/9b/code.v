module top_module (
	input [5:0] e,
	output [4:0] out_sum,
	output [4:0] out_and,
	output [5:0] out_xor);assign out_sum = e[4:0] + e[5:1];
	assign out_and = e[4:0] & e[5:1];
	assign out_xor = e ^ {e[0], e[5:1]};
	
endmodule