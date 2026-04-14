module top_module(En, Clk, Clr, Q);input En, Clk, Clr;
  output reg Q;

  always @ (posedge Clk)
	if (~Clr) begin
		Q <= 1'b0;
	end else if (En) begin
		Q <= !Q;
	end

endmodule