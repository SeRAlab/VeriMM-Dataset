module top_module(din, rin, clock, qout);input [6:0]din;
	input clock, rin;
	output reg [6:0]qout;
	
	always @(posedge clock)
		if (rin==1) qout <= din;endmodule