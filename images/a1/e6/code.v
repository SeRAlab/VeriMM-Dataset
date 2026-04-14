module top_module (
	input [3:0] a,
	input [1:0] sh,
	output [3:0] b);assign b = a >> sh;
	
endmodule