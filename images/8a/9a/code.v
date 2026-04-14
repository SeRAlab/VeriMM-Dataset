module top_module(
  input wire [15:0] input_signal,
  input wire [15:0] desired_level,
  output reg [15:0] output_signal // changed from wire to reg
);parameter k = 10; // gain constant

reg [31:0] gain_factor;
reg [31:0] temp_output_signal;

always @(*) begin
  gain_factor = (desired_level << k) / input_signal;
  temp_output_signal = input_signal * gain_factor;
  if (temp_output_signal > 16'hFFFF) begin
    output_signal = 16'hFFFF; // changed <= to =
  end else begin
    output_signal = temp_output_signal[31:16]; // changed <= to =
  end
end

endmodule