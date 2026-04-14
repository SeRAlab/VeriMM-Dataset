module top_module(
  clk, reset, D, Q
);parameter W = 16;

input clk;
input reset;
input signed [W:0] D;
output signed [W:0] Q;
reg signed [W:0] Q;

  always @ (posedge clk or posedge reset) begin
    if (reset)
      Q = 0;
    else
      Q = D;
  end
endmodule