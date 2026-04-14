module top_module(
  input signed [15:0] temperature,
  input [15:0] pressure,
  input [7:0] humidity,
  output signed [15:0] temp_out,
  output [15:0] press_out,
  output [7:0] hum_out
);// Convert temperature from Celsius to Fahrenheit
  assign temp_out = temperature * 9 / 5 + 32;

  // Output pressure and humidity readings as is
  assign press_out = pressure;
  assign hum_out = humidity;

endmodule