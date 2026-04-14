module top_module (
	input x, 
	input y, 
	input z, 
	input w,
	output reg q);assign q = (x & y & z & w) | (x & ~y & z & ~w) | (~x & y & z & w) | (x & ~y & ~z & w);

endmodule