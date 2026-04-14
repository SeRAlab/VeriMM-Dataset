module top_module(
  input clk,
  input reset,
  input enable,
  input d,
  output reg q
);reg q0, q1, q2;

always @(posedge clk) begin
  if (reset) begin
    q0 <= 1'b0;
    q1 <= 1'b0;
    q2 <= 1'b0;
  end
  else if (enable) begin
    q0 <= d;
    q1 <= q0;
    q2 <= q1;
  end
end

assign q = q2;

endmodule