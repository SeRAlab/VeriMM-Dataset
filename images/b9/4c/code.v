module top_module(
  input clk,
  input reset,
  input a,
  input b,
  input c,
  output reg y
);reg d_ff_out;

  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      d_ff_out <= 1'b0;
    end else begin
      d_ff_out <= a ^ b ^ c;
    end
  end

  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      y <= 1'b0;
    end else begin
      y <= d_ff_out;
    end
  end

endmodule