module top_module(
  input clk,
  input rst,
  input signed [15:0] pwm_in,
  input signed [15:0] set_point,
  output signed [15:0] pwm_out
);parameter f_clk = 50_000_000; // frequency of the clock signal
parameter f_pwm = 50; // frequency of the PWM signal
parameter t_min = 1000; // minimum pulse width of the PWM signal
parameter t_max = 2000; // maximum pulse width of the PWM signal
parameter k_p = 1; // proportional gain of the servo control system
parameter k_i = 1; // integral gain of the servo control system
parameter k_d = 1; // derivative gain of the servo control system

reg signed [15:0] error;
reg signed [15:0] integral;
reg signed [15:0] derivative;
reg signed [15:0] control_signal;
reg [31:0] pwm_counter;
reg [31:0] pwm_width;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    error <= 0;
    integral <= 0;
    derivative <= 0;
    control_signal <= 0;
    pwm_counter <= 0;
    pwm_width <= 0;
  end else begin
    error <= set_point - pwm_in;
    integral <= integral + error;
    derivative <= error - derivative;
    control_signal <= k_p * error + k_i * integral + k_d * derivative;
    pwm_counter <= pwm_counter + 1;
    if (pwm_counter >= f_clk / f_pwm) begin
      pwm_counter <= 0;
      pwm_width <= (control_signal * (t_max - t_min) / 2^16) + (t_min + t_max) / 2;
    end
  end
end

assign pwm_out = (pwm_counter < pwm_width) ? 1 : 0;

endmodule