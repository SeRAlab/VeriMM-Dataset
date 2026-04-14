module top_module(clk, rst, wIn, ld, wOut);input clk,rst, ld;
  input [1:0] wIn;
  output reg [2:0] wOut;
  always@(posedge clk, posedge rst)begin
    if (rst) wOut <= 0;
    else if (ld) wOut <= 2*wIn;
    else wOut <= wOut;
  end
endmodule