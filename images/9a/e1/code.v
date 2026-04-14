module top_module(operandIn, registerIn, resultOut, markOut, operation);input [0:15] operandIn;
	input [0:15] registerIn;
	input [0:3] operation;
	output [0:15] resultOut;
	output [0:1] markOut;
	
	assign resultOut = (( operation == 4'h0 ) ? registerIn :
	                   (( operation == 4'h1 ) ? operandIn :
					   (( operation == 4'h2 ) ? registerIn + operandIn :
					   (( operation == 4'h3 ) ? registerIn - operandIn :
					                             registerIn ))));
	assign markOut = ( resultOut == 0 ) ? 2'b00 :
	                 (( resultOut > 0 ) ? 2'b11 : 2'b10 );endmodule