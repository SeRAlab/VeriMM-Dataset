module top_module(memoryIn, addressIn, choose, resultOut);input [0:15] memoryIn;
	input [0:15] addressIn;
	input choose;
	output [0:15] resultOut;
	
	assign resultOut = choose ? addressIn : memoryIn;endmodule