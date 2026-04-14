module top_module(clk, rst, addr, en, we, datain, dataout);input [6:0] addr;
  input clk;
  input [31:0] datain;
  output [31:0] dataout;
  input en;
  input rst;
  input [3:0] we;
  assign dataout = 0;endmodule