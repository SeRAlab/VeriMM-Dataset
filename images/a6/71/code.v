module top_module(
  input clk,
  input reset,
  input trigger,
  input [9:0] duration,
  output reg pulse
);reg [9:0] count;
  reg pulse_reg;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      count <= 0;
      pulse_reg <= 0;
    end else if (trigger) begin
      count <= duration;
      pulse_reg <= 1;
    end else if (count > 0) begin
      count <= count - 1;
      pulse_reg <= 1;
    end else begin
      pulse_reg <= 0;
    end
  end

  assign pulse = pulse_reg;

endmodule