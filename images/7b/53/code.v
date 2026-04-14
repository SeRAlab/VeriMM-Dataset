module top_module(
   output S,
	output Co,
	input X,
	input Y,
	input C   
 );assign S = X^Y^C;
assign Co = ((X&Y)| (X^Y)&C);

endmodule