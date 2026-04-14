module top_module(
  input clk,
  input en,
  output gated_clk
);assign gated_clk = en ? clk : 1'b0;

endmodule