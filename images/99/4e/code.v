module top_module(
  input [n-1:0] in,
  output [n-1:0] out
);parameter n = 4; // number of bits in the input and output signals

// AND operation
assign out = in[0];
genvar i;
generate
  for (i = 1; i < n; i = i + 1) begin
    assign out[i] = out[i-1] & in[i];
  end
endgenerate

// OR operation
assign out = in[0];
generate
  for (i = 1; i < n; i = i + 1) begin
    assign out[i] = out[i-1] | in[i];
  end
endgenerate

// XOR operation
assign out = in[0];
generate
  for (i = 1; i < n; i = i + 1) begin
    assign out[i] = out[i-1] ^ in[i];
  end
endgenerate

// NOT operation
assign out = ~in;

endmodule