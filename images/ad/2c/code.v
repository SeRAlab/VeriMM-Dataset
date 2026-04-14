module top_module(
	a, b, dout, con
);input [8:0] a, b;
	output [17:0] dout;
	input con;

	
	assign dout = a * b;

endmodule