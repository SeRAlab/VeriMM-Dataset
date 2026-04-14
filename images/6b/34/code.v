module top_module(clk, rst, addr, en, we, datain, tag_v, tag);input [4:0] addr;
  input clk;
  input [23:0] datain;
  input en;
  input rst;
  output [22:0] tag;
  output tag_v;
  input we;
  assign tag = 23'b00000000000000000000000;
  assign tag_v = 1'b0;endmodule