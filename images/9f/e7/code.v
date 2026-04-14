module top_module(
  input [n-1:0] harvest,
  input clk, // Added clk input
  output reg [7:0] storage // Changed storage to be reg type and 8 bits
);parameter n = 2; // number of energy harvesting signals

reg [7:0] adc_output; // 8-bit ADC output
reg [7:0] storage_reg; // 8-bit storage register
reg charging; // charging signal

// Analog-to-digital converter
always @(*) begin
  if (harvest[0] > 0) adc_output = 255; // maximum value for harvest1
  else if (harvest[1] > 0) adc_output = 127; // half value for harvest2
  else adc_output = 0; // minimum value if no input
end

// Charging control
always @(posedge clk) begin
  if (adc_output > storage_reg) charging = 1; // charge if ADC output is higher than storage
  else charging = 0; // stop charging if storage is full
end

// Storage update
always @(posedge clk) begin
  if (charging) storage_reg <= storage_reg + 1; // increment storage if charging
  else storage_reg <= storage_reg; // hold storage if not charging
end

// Output
always @(posedge clk) begin
  storage <= storage_reg; // output storage register on clock edge
end

endmodule