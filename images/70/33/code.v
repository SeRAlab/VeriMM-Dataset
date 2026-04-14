module top_module(
  input [n-1:0] in,
  input vref,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 4; // number of output signals
parameter vlow = 0; // low voltage level of input signals
parameter vhigh = 1; // high voltage level of input signals
parameter vreflow = 0; // low voltage level of reference signal
parameter vrefhigh = 1; // high voltage level of reference signal

  assign out = (in < vref) ? vlow : ((in > vref) ? vhigh : vreflow);

endmodule