module top_module(A,B,C,D,EP);input wire A,B,C,D; 
	output wire EP;	

	assign EP = A^B^C^D; 

endmodule