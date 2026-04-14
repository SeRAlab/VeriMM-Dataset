module top_module(X,if_do,Y);parameter N = 32;
	

	
	input  wire [N-1:0] X;
	input wire if_do;
	output wire [N-1:0] Y;
	
	assign Y = if_do? X : ~X;


endmodule