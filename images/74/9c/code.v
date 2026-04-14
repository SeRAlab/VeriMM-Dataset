module top_module(D, Clk, Q);input D, Clk;
  output reg Q;

  always @ (D, Clk)
	if (Clk)
		Q = D;
		
endmodule