module top_module(din, clock, qout);input din;
	input clock;
	output reg qout;
	
	always @(posedge clock)
		qout <= din;endmodule