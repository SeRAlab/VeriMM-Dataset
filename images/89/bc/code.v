module top_module(
  input in0,
  input in1,
  input in2,
  input in3,
  input in4,
  input clk,
  input reset,
  output reg q0,
  output reg q1,
  output reg q2,
  output reg q3
);wire lut_out;
  assign lut_out = in0 & in1 & in2 & in3 & in4;

  always @(posedge clk or negedge reset) begin
    if (~reset) begin
      q0 <= 1'b0;
      q1 <= 1'b0;
      q2 <= 1'b0;
      q3 <= 1'b0;
    end else begin
      q0 <= lut_out;
      q1 <= q0;
      q2 <= q1;
      q3 <= q2;
    end
  end

endmodule