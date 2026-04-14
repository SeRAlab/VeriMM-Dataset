module top_module (
	input x, 
	input y, 
	input z, 
	input w,
	output reg v);assign v = (x & ~y & z & w) | (~x & y & w) | (x & y & ~z & ~w) | (x & ~z & ~w);

endmodule