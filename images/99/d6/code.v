module top_module(
  input clk,
  input reset,
  input enable,
  output reg q0,
  output reg q1,
  output reg q2
);reg d0, d1, d2;

  always @(posedge clk) begin
    if (reset) begin
      q0 <= 1'b0;
      q1 <= 1'b0;
      q2 <= 1'b0;
    end else if (enable) begin
      d0 <= q0 ^ q1;
      d1 <= q1 ^ q2;
      d2 <= q2 ^ enable;
      q0 <= d0;
      q1 <= d1;
      q2 <= d2;
    end
  end

endmodule