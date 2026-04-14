module top_module(
  input [n-1:0] in,
  output [n-1:0] out
);parameter n = 4; // number of bits in the input signal

// Binary to Gray conversion algorithm
assign out[0] = in[0];
generate
  genvar i;
  for (i = 1; i < n; i = i + 1) begin : gray_conversion
    assign out[i] = in[i] ^ in[i-1];
  end
endgenerate

// Gray to Binary conversion algorithm
assign out[0] = in[0];
generate
  genvar j; // changed from 'i' to 'j' to avoid redeclaration
  for (j = 1; j < n; j = j + 1) begin : binary_conversion
    assign out[j] = out[j-1] ^ in[j];
  end
endgenerate

endmodule