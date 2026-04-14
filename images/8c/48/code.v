module top_module (
	input [29:0] u,
	output [28:0] out_or4,
	output [28:0] out_xor4);assign out_or4 = u[28:0] | u[29:1];
	assign out_xor4 = u[28:0] ^ u[29:1];
	
endmodule