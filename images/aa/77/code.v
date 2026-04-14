module top_module(output reg [7:0] Q, input [7:0] D, input  Clk);always @(posedge Clk)
  Q=D;endmodule