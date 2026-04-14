module top_module(X, Y, S);input[3:0] X, Y;
	
	output reg [4:0] S;
	
	
	always @(X, Y)
		S = X + Y;
		
	endmodule