module top_module(
  input a,
  input b,
  input clk,
  output reg out
);reg delayed_a;
  reg delayed_b;

  always @(posedge clk) begin
    delayed_a <= a;
    delayed_b <= b;
  end

  always @(posedge clk) begin
    out <= delayed_a & delayed_b;
  end

endmodule