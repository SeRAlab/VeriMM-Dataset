module top_module (
	input [19:0] f,
	output [18:0] out_or,
	output [19:0] out_xor);assign out_or = f[18:0] | f[19:1];
	assign out_xor = f ^ {f[0], f[19:1]};
	
endmodule