module top_module(
  input clk,
  input reset,
  input enable,
  input d,
  output reg q
);reg q_next;

  always @(posedge clk) begin
    if (reset) begin
      q_next <= 1'b0;
    end else if (enable) begin
      q_next <= d;
    end else begin
      q_next <= q;
    end
  end

  assign q = q_next;

endmodule