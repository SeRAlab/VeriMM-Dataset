module top_module(
  output [(8 - 1):0] op,
  input clk,
  input ce,
  input clr);assign op = 8'b11001000;
endmodule