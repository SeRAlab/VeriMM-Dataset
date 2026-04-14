module dff_ce_clr(clk, clr, ce, d, q);

  input clk, clr, ce, d;
  output q;
  reg q;

  always @(posedge clk)
    if (clr)
      q <= 1'b0;
    else if (ce)
      q <= d;

endmodule