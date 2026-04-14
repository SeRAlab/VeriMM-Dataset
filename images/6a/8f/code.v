module top_module(
  input wire [15:0] analog_in,
  output reg [n-1:0] digital_out
);parameter n = 8; // number of bits in digital output signal
parameter vref = 5; // reference voltage for analog input signal

integer i;
reg [15:0] voltage_level;
reg [n-1:0] binary_signal;

always @(*) begin
  for (i = 0; i < (1 << n); i = i + 1) begin
    voltage_level = (vref * i) / ((1 << n) - 1);
    if (analog_in >= voltage_level) begin
      binary_signal = i;
    end
  end
  digital_out = binary_signal;
end

endmodule