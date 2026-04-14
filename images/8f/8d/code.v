module top_module(eq, a, b);parameter N = 1024;
	input [N-1:0] a, b;
	
	
	output wire eq;

	
	
	
  assign eq = ~| (a ^ b);endmodule