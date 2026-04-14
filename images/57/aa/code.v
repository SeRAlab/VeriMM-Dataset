module top_module(D, Clk, Q);input D, Clk;
	output reg Q;

	always @ (posedge Clk)
		
		Q = D;
	
endmodule