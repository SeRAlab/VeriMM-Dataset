module top_module(x,y, oout);input [3:0] x;
	input [3:0] y;
	output [3:0] oout;
	
	assign oout = x|y;
	
endmodule