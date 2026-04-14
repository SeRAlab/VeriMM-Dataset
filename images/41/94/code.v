module top_module (
	input [7:0] s,
	input [7:0] t,
	output [7:0] u);assign u = ~(s | t);

endmodule