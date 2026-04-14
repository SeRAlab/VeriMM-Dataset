module top_module(
  input clk,
  input en,
  output clk_gated
);assign clk_gated = clk & en;

endmodule