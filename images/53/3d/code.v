module top_module(
  input signed [15:0] in1,
  input signed [15:0] in2,
  input signed [15:0] in3,
  input signed [15:0] in4,
  output signed [15:0] out1,
  output signed [15:0] out2,
  output signed [15:0] out3,
  output signed [15:0] out4
);parameter n = 4; // number of input audio samples
parameter m = 4; // number of output audio samples

// Compression algorithm
// This is a simple algorithm that takes the average of the input samples
// and outputs the same value for all output samples
assign out1 = (in1 + in2 + in3 + in4) / n;
assign out2 = out1;
assign out3 = out1;
assign out4 = out1;

endmodule