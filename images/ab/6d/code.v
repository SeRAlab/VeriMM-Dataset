module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter k = 2; // number of bits in the input look-up table (LUT)

reg [m-1:0] lut [0:(2**k)-1]; // LUT with 2^k entries

// Define the entries in the LUT as Boolean functions of the input signals
initial begin
  lut[0] = {1'b0, 1'b0}; // f(0,0) = 00
  lut[1] = {1'b1, 1'b0}; // f(0,1) = 10
  lut[2] = {1'b0, 1'b1}; // f(1,0) = 01
  lut[3] = {1'b1, 1'b1}; // f(1,1) = 11
end

// Use the LUT to compute the output signals
assign out = lut[in];

endmodule