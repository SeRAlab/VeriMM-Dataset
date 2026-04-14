module d_ff_with_sync_clr (Clk, D, Q, Clr);
  input Clk, D, Clr;
  output reg Q;
  always @ ( posedge Clk)
	 if (Clr)
	 begin
		Q <= 1'b0;
	 end else
	 begin
		Q <= D;
	 end
endmodule