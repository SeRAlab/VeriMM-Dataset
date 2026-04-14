module top_module (
	input [9:0] m,
	output [8:0] out_or2,
	output [8:0] out_xor2);assign out_or2 = m[8:0] | m[9:1];
	assign out_xor2 = m[8:0] ^ m[9:1];
	
endmodule