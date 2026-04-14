module top_module(
  input clk,
  input rst,
  input temp_in,
  output reg fan_pwm,
  output reg overtemp
);parameter fan_freq = 100000; // fan PWM frequency in Hz
parameter fan_min_duty = 10; // minimum duty cycle of fan PWM
parameter fan_max_duty = 90; // maximum duty cycle of fan PWM
parameter temp_min = 15; // minimum temperature threshold
parameter temp_max = 35; // maximum temperature threshold
parameter overtemp_duration = 100; // duration of over-temperature signal in clock cycles

reg [31:0] overtemp_counter;

always @(posedge clk) begin
  if (rst) begin
    fan_pwm <= 0;
    overtemp <= 0;
    overtemp_counter <= 0;
  end else begin
    if (temp_in >= temp_min && temp_in <= temp_max) begin
      fan_pwm <= (temp_in - temp_min) * (fan_max_duty - fan_min_duty) / (temp_max - temp_min) + fan_min_duty;
      overtemp <= 0;
      overtemp_counter <= 0;
    end else begin
      fan_pwm <= fan_max_duty;
      overtemp <= 1;
      if (overtemp_counter < overtemp_duration) begin
        overtemp_counter <= overtemp_counter + 1;
      end else begin
        overtemp_counter <= 0;
      end
    end
  end
end

endmodule