module top_module (
	input x, 
	input y, 
	input z, 
	input w,
	output reg g);assign g = (x & y & z & w) | (x & ~y & z & ~w) | (~x & y & z & ~w) | (~x & ~y & z & w);

endmodule