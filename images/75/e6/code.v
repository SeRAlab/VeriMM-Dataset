module top_module (
	input w, 
	input x, 
	input y, 
	input z,
	output reg p);assign p = (~w & ~x & ~y & ~z) | (w & ~x & y & z) | (~w & x & y & z) | (~w & ~x & y & ~z) | (w & ~x & ~y & z) | (w & x & y & z);

endmodule