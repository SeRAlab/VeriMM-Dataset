module simple_mux (
	input [3:0] a,
	input [3:0] b,
	input select,
	output [3:0] y);assign y = (select) ? b : a;

endmodule