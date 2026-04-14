module top_module(
  input in,
  input ctrl,
  output reg out // Change output to reg type
);parameter k = 10; // gain of amplifier at maximum control signal value
parameter max_val = 100; // maximum output signal amplitude

reg [31:0] gain; // variable gain amplifier
reg [31:0] out_amp; // output signal amplitude

always @(*) begin
  gain = k * ctrl; // compute gain based on control signal
  out_amp = in * gain; // amplify input signal
  if (out_amp > max_val) begin // limit output signal amplitude
    out = max_val;
  end else begin
    out = out_amp;
  end
end

endmodule