module clk_gate (
  input clk,
  input en,
  output clk_gated
);

  assign clk_gated = clk & en;

endmodule