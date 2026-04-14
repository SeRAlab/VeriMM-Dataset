module top_module(
  input clk,
  input rst,
  input [7:0] pwm_in,
  input [7:0] pwm_min,
  input [7:0] pwm_max,
  output reg [7:0] pwm_out,
  output reg [7:0] servo_angle
);parameter pwm_resolution = 256; // PWM resolution (i.e., number of steps between min and max)

reg [7:0] pwm_count = 0; // PWM counter
reg [7:0] pwm_target = 0; // PWM target value
reg [7:0] pwm_step = 0; // PWM step size

always @(posedge clk or posedge rst) begin
  if (rst) begin
    pwm_count <= 0;
    pwm_target <= pwm_min;
    pwm_step <= 0;
  end else begin
    if (pwm_count == pwm_resolution - 1) begin
      pwm_count <= 0;
      pwm_target <= pwm_in;
      pwm_step <= (pwm_target - pwm_out) / pwm_resolution;
    end else begin
      pwm_count <= pwm_count + 1;
      pwm_out <= pwm_out + pwm_step;
    end
  end
end

always @(posedge clk or posedge rst) begin
  if (rst) begin
    servo_angle <= pwm_min;
  end else begin
    servo_angle <= pwm_out;
  end
end

endmodule