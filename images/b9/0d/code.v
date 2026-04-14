module top_module(channels, select, op);input [15:0][15:0] channels;
	input [3:0] select;
	output [15:0] op;
	
	assign op = channels[select];endmodule