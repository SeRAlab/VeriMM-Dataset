module top_module(
  input [7:0] analog_in,
  input enable,
  input clk, // Added clk input
  output reg [7:0] pwm_out
);parameter resolution = 8; // PWM resolution in bits

reg [resolution-1:0] duty_cycle;

always @(*) begin
  duty_cycle = (analog_in * (2**resolution - 1)) / 255; // Adjusted duty cycle calculation
end

always @(posedge clk) begin
  if (enable) begin
    pwm_out <= duty_cycle;
  end else begin
    pwm_out <= 0;
  end
end

endmodule