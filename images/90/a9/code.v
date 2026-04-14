module top_module(A, B, out);input [63:0]  A;
	input [63:0]  B;
	output [63:0] out;
	
	assign  out = A + B;
  
endmodule