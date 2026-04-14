module top_module(
  input [n-1:0] in,
  output [n-1:0] out1,
  output [n-1:0] out2
);parameter n = 8; // number of bits in the input signal
parameter s = 3; // number of bits to be shifted

// Left Shift
assign out1 = {in[s-1:0], {n-s{1'b0}}};

// Right Shift
assign out2 = { {n-s{1'b0}}, in[n-1:s] };

// Arithmetic Shift
assign out1 = (in[n-1] == 1'b0) ? { {n-s{1'b0}}, in[n-1:s] } : { {n-s{1'b1}}, in[n-1:s] };

endmodule