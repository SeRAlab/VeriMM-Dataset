module top_module (
	input [3:0] h,
	output [2:0] out_and,
	output [3:0] out_xor);assign out_and = h[2:0] & h[3:1];
	assign out_xor = h ^ {h[0], h[3:1]};
	
endmodule