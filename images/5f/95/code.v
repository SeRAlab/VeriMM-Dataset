module top_module(
	input [7:0] A,
	input [7:0] B,
	
	output AgtB,
	output AeqB,
	output AltB

);assign AeqB = A==B;
assign AgtB = A>B;
assign AltB = A<B;

endmodule