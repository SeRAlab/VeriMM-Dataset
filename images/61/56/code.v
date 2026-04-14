module top_module(
  input [n-1:0] in,
  output out
);parameter n = 4; // number of input signals
parameter m = 1; // number of output signals

// Define the truth table as an array of 2^n values
reg [m-1:0] lut [0:2**n-1];

// Initialize the truth table with the desired Boolean function
initial begin
  lut[0] = 1'b0;
  lut[1] = 1'b1;
  lut[2] = 1'b1;
  lut[3] = 1'b0;
  // continue with the remaining entries for the desired Boolean function
end

// Use the input signals to index into the array and retrieve the corresponding output value
assign out = lut[in];

endmodule