module top_module(
  input wire  D0, D1,
  input wire S,
  output wire Y);assign Y = S ? D1: D0;endmodule