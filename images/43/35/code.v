module top_module(
  output [(4 - 1):0] op,
  input clk,
  input ce,
  input clr);assign op = 4'b1111;
endmodule