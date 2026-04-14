module top_module(
  input [n*k-1:0] in,
  output out
);parameter n = 2; // number of input signals
parameter k = 2; // number of bits in the input signal
parameter m = 4; // number of entries in the LUT (2^k)

reg [m-1:0] lut [0:(2**k)-1];
integer index;

// Define the m entries as Boolean functions of the input signals
// In this example, we implement a 2-input XOR function
initial begin
  lut[0] = 1'b0;
  lut[1] = 1'b1;
  lut[2] = 1'b1;
  lut[3] = 1'b0;
end

// Generate an index into the LUT based on the input signals
always @(*) begin
  index = in[k-1:0]; // Changed from in[1:k] to in[k-1:0]
end

// Output the corresponding value from the LUT
assign out = lut[index];

endmodule