module top_module(
  input clk,
  input input_signal,
  output reg [7:0] digital_output
);parameter clk_frequency = 1000000; // 1MHz
parameter sampling_rate = 1000; // 1kHz
parameter counter_max = clk_frequency / sampling_rate;

reg [15:0] counter = 0;
reg [15:0] quantized_signal;

always @(posedge clk) begin
  counter <= counter + 1;
  if (counter == counter_max) begin
    counter <= 0;
    quantized_signal <= (input_signal * 255) / 5;
    digital_output <= quantized_signal[7:0];
  end
end


endmodule