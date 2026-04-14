module top_module(commandIn, operationOut, addressOut);input [0:23] commandIn;
	output [0:7] operationOut;
	output [0:15] addressOut;
	
	assign operationOut = commandIn[0:7];
	assign addressOut = commandIn[8:23];endmodule