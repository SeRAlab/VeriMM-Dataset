module top_module (
	input r, 
	input s, 
	input t, 
	input u,
	output reg v);assign v = (r & s & t & u) | (r & ~s & t & ~u) | (~r & s & t & ~u) | (~r & ~s & t & u);

endmodule