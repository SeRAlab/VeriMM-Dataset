module top_module(sum, x, y, clk);output reg [7:0] sum;
  input [7:0] x, y;
  input clk;

  reg [7:0] t1, t2;

  always @(posedge clk) begin
    t1 <= x + y;
    t2 <= t1 + 1;
    sum <= t2;
  end
endmodule