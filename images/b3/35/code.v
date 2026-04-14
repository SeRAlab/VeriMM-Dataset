module top_module(
  input clk,
  input reset,
  input signed [7:0] a,
  input signed [7:0] b,
  output reg signed [7:0] sum,
  output reg overflow
);always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
      sum <= 8'b0;
      overflow <= 1'b0;
    end else begin
      sum <= a + b;
      if ((a[7] == b[7]) && (a[7] != sum[7]))
        overflow <= 1'b1;
      else
        overflow <= 1'b0;
    end
  end

endmodule