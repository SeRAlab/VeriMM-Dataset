module top_module(X,Y,S,Z);parameter N = 32; 
	
	
	input wire [N-1:0] X, Y; 
	input wire S; 
	output wire [N-1:0] Z; 
	
	assign Z = S ? Y : X; 


endmodule