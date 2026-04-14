module top_module(
  input [n-1:0] in,
  output reg [7:0] out
);parameter n = 4; // number of bits of resolution
parameter Vref = 5; // maximum value of the analog output voltage in volts

reg [n-1:0] binary_weights;
reg [n-1:0] resistor_values;
reg [7:0] voltage;

// Calculate binary weights
integer i;
initial begin
  binary_weights[0] = 1;
  for (i = 1; i < n; i = i + 1) begin
    binary_weights[i] = binary_weights[i-1] * 2;
  end
end

// Calculate resistor values
integer j;
initial begin
  resistor_values[0] = Vref / binary_weights[0];
  for (j = 1; j < n; j = j + 1) begin
    resistor_values[j] = resistor_values[j-1] / 2;
  end
end

// Calculate output voltage
always @(*) begin
  voltage = 0;
  for (i = 0; i < n; i = i + 1) begin
    voltage = voltage + (in[i] * resistor_values[i]);
  end
  out = voltage;
end

endmodule