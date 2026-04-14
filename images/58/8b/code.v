module top_module(
  input clk,
  input reset,
  input [7:0] temperature,
  output reg fan_on,
  output reg [7:0] fan_speed
);parameter THRESHOLD_TEMP = 30; // Threshold temperature in degrees Celsius
  parameter MAX_SPEED = 255; // Maximum fan speed

  reg [7:0] target_speed; // Target fan speed based on temperature

  always @(posedge clk) begin
    if (reset) begin
      fan_on <= 0;
      fan_speed <= 0;
      target_speed <= 0;
    end else begin
      if (temperature < THRESHOLD_TEMP) begin
        fan_on <= 0;
        fan_speed <= 0;
        target_speed <= 0;
      end else begin
        fan_on <= 1;
        target_speed <= (temperature - THRESHOLD_TEMP) * (MAX_SPEED / 100);
        if (fan_speed < target_speed) begin
          fan_speed <= fan_speed + 1;
        end else if (fan_speed > target_speed) begin
          fan_speed <= fan_speed - 1;
        end
      end
    end
  end

endmodule