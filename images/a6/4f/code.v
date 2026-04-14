module top_module (
	input [2:0] g,
	output [5:0] double_bits,
	output [2:0] half_bits);assign double_bits = {g[2], g[2], g[1], g[1], g[0], g[0]};
	assign half_bits = {3{g[0]}};
	
endmodule