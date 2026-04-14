module top_module(
  input [n-1:0] data_in,
  output [n+m-1:0] parity_out
);parameter n = 8; // number of data bits
parameter m = 4; // number of parity bits
parameter k = 4; // number of check bits per data block

wire [n+k-1:0] encoded_data;
wire [m-1:0] parity_bits;

// Hamming code algorithm for error correction
// computes the parity bits for each data block
genvar i;
generate
  for (i = 0; i < n; i = i + k) begin : hamming_code
    assign encoded_data[i+k-1:i] = {data_in[i+k-1:i], 1'b0, data_in[i+k-2:i-k+1], 1'b0};
    assign parity_bits = {encoded_data[i]^encoded_data[i+1]^encoded_data[i+3],
                         encoded_data[i]^encoded_data[i+2]^encoded_data[i+3],
                         encoded_data[i+1]^encoded_data[i+2]^encoded_data[i+3],
                         encoded_data[i+k]};
  end
endgenerate

// output the (n + m)-bit word on the parity_out port
assign parity_out = {data_in, parity_bits};

endmodule