module top_module(
  input [n-1:0] sensor,
  input clk, // Added clk input
  output reg dimming // Changed output to reg type
);parameter n = 4; // number of sensors

reg [7:0] digital_sensor [n-1:0]; // digital signals for each sensor
reg [7:0] ambient_light; // calculated ambient light level
reg [7:0] dimming_level; // calculated dimming level
integer i; // Declare integer for loop index

// ADC circuit
always @ (posedge clk) begin
  for (i = 0; i < n; i = i + 1) begin
    digital_sensor[i] <= sensor[i];
  end
end

// Ambient light calculation
always @ (posedge clk) begin
  ambient_light <= (digital_sensor[0] + digital_sensor[1] + digital_sensor[2] + digital_sensor[3]) / n;
end

// Dimming control circuit
always @ (posedge clk) begin
  if (ambient_light < 64) begin
    dimming_level <= 255; // maximum brightness
  end else if (ambient_light < 128) begin
    dimming_level <= 192; // 75% brightness
  end else if (ambient_light < 192) begin
    dimming_level <= 128; // 50% brightness
  end else if (ambient_light < 256) begin
    dimming_level <= 64; // 25% brightness
  end else begin
    dimming_level <= 0; // Off or no brightness
  end
end

// Output dimming signal
always @ (posedge clk) begin
  dimming <= dimming_level; // Update dimming on clock
end

endmodule