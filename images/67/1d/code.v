module top_module(
  input signed [n-1:0] input_signal,
  output reg [n-1:0] output_signal
);parameter n = 8; // number of bits in the input signal

always @(*) begin
  if (input_signal[n-1] == 0) begin // if sign bit is 0, output input signal as is
    output_signal = input_signal;
  end else begin // if sign bit is 1, negate input signal and output the result
    output_signal = ~input_signal + 1;
  end
end

endmodule