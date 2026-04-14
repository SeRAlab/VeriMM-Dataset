module top_module(
  input [k-1:0] in,
  output [n-1:0] out
);parameter n = 10; // number of output bits
parameter k = 4; // number of input bits
parameter [k*n-1:0] H = {4'b1100, 4'b1010, 4'b1001, 4'b0110, 4'b0101, 4'b0011}; // parity-check matrix for the LDPC code

// Encoder
genvar i, j;
generate
  for (i = 0; i < n; i = i + 1) begin : encode
    wire [k-1:0] row = H[i*k +: k];
    assign out[i] = ^{in & row};
  end
endgenerate

// Decoder
wire [k-1:0] decoded;
generate
  for (i = 0; i < k; i = i + 1) begin : decode
    wire [n-1:0] column;
    for (j = 0; j < n; j = j + 1) begin
      assign column[j] = H[j*k + i];
    end
    assign decoded[i] = ^{out & column};
  end
endgenerate

// Connect decoded bits to input ports
assign in = decoded;

endmodule