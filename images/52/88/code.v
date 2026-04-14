module top_module(
   input [7:0] x,
	input [7:0] y,
	output [7:0] z
);assign z = ( y > x) ? y : x;
endmodule