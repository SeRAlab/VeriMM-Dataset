module top_module(
  output [(2 - 1):0] op,
  input clk,
  input ce,
  input clr);localparam [(2 - 1):0] const_value = 2'b00;
  assign op = 2'b00;
endmodule