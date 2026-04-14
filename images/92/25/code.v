module top_module(
  input sig_in,
  input ref_in,
  output sig_out
);parameter gain_max = 100; // maximum gain of the amplifier
parameter gain_min = 10; // minimum gain of the amplifier
parameter gain_step = 5; // step size of gain adjustment

reg [7:0] gain; // 8-bit register to store the gain value

always @(*) begin
  if (sig_in > ref_in) begin
    gain = gain - gain_step; // decrease gain if input signal is greater than reference signal
  end else if (sig_in < ref_in) begin
    gain = gain + gain_step; // increase gain if input signal is less than reference signal
  end
  if (gain > gain_max) begin
    gain = gain_max; // limit gain to maximum value
  end else if (gain < gain_min) begin
    gain = gain_min; // limit gain to minimum value
  end
end

assign sig_out = sig_in * gain; // output amplified signal with constant amplitude

endmodule