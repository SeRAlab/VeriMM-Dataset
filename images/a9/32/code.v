module top_module(s, cO, A, B, cI);output s, cO;
	input  A, B, cI;
	
	wire w0;
	assign w0 = A ^ B;
	assign s  = w0 ^ cI;
	assign cO = (~w0 & B) | (w0 & cI);endmodule