module top_module(out,select,enable);input [4:0] select;
	input enable;
	output [31:0] out;
	assign out = enable << select;endmodule