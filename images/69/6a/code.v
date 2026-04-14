module top_module(
  input temp_sensor_out,
  input [n-1:0] control,
  output fan_control,
  output alarm
);parameter n = 4; // number of control signals

// Linear equation to convert temp_sensor_out to temperature value
reg signed [15:0] temperature_value;
always @(*) begin
  temperature_value = (temp_sensor_out * 100) - 2731;
end

// Threshold value based on control signals
reg signed [15:0] threshold_value;
always @(*) begin
  case (control)
    4'b0000: threshold_value = 2500; // Default threshold value
    4'b0001: threshold_value = 3000; // Increase threshold value by 5 degrees Celsius
    4'b0010: threshold_value = 3500; // Increase threshold value by 10 degrees Celsius
    4'b0100: threshold_value = 4000; // Increase threshold value by 15 degrees Celsius
    4'b1000: threshold_value = 4500; // Increase threshold value by 20 degrees Celsius
    default: threshold_value = 2500; // Default threshold value
  endcase
end

// Set alarm signal if temperature exceeds threshold
reg alarm_signal;
always @(temperature_value, threshold_value) begin
  if (temperature_value > threshold_value) begin
    alarm_signal = 1'b1;
  end else begin
    alarm_signal = 1'b0;
  end
end

// Set fan control signal based on temperature value and control signals
reg signed [15:0] fan_control_value;
always @(temperature_value, control) begin
  case (control)
    4'b0000: fan_control_value = 0; // Default fan speed
    4'b0001: fan_control_value = 1000; // Increase fan speed by 10%
    4'b0010: fan_control_value = 2000; // Increase fan speed by 20%
    4'b0100: fan_control_value = 3000; // Increase fan speed by 30%
    4'b1000: fan_control_value = 4000; // Increase fan speed by 40%
    default: fan_control_value = 0; // Default fan speed
  endcase
  
  if (temperature_value > threshold_value) begin
    fan_control_value = fan_control_value * 2; // Double fan speed if temperature exceeds threshold
  end
  
end

assign fan_control = fan_control_value;
assign alarm = alarm_signal;

endmodule