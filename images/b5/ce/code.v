module top_module(input clk,
              input  din,
              output reg dout);reg                din_flop;
  always @(negedge clk) din_flop <= din;
  always @(posedge clk) dout <= din_flop;
endmodule