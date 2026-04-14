module top_module(
  input [99:0] in,
  output [99:0] out
);// Reverse every 4 bits in the input vector
  wire [99:0] reversed;
  genvar i;
  generate
    for (i = 0; i < 100; i = i + 4) begin : reverse
      assign reversed[i+3:i] = in[i+3:i]; // Corrected part select order
    end
  endgenerate

  // Compute the bitwise XOR of the original and reversed vectors
  assign out = in ^ reversed;

endmodule