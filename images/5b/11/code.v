module top_module(
  input [n-1:0] in,
  output out,
  input clk // Added clock input
);parameter n = 4; // number of input signals
parameter threshold = 100; // touch threshold value

// Capacitive touch sensor implementation
reg [n-1:0] cap_values;
wire cap_touch = (|cap_values) > threshold;

always @ (posedge clk) begin
  // Measure capacitance of touch sensor
  cap_values <= in;
end

// Use an intermediate signal to combine outputs from both sensors
wire touch_signal; // Intermediate signal for touch detection

// Resistive touch sensor implementation
reg [n-1:0] res_values;
wire res_touch = (&res_values) < threshold;

always @ (posedge clk) begin
  // Measure resistance of touch sensor
  res_values <= in;
end

assign touch_signal = cap_touch || res_touch; // Combine touches from both sensors
assign out = touch_signal; // Output if either sensor is activated

endmodule