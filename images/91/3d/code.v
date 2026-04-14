module top_module(
  input clk,
  input reset,
  input in,
  output reg out
);reg q1, q2;

always @(posedge clk, negedge reset) begin
  if (!reset) begin
    q1 <= 0;
    q2 <= 0;
    out <= 0;
  end else begin
    q1 <= ~q1;
    q2 <= ~q2;
    out <= q1 ^ q2;
  end
end

endmodule