module top_module(
  input [8*n-1:0] data_in,
  input [15:0] checksum_in,
  output [15:0] checksum_out,
  output valid
);parameter n = 16; // number of data bytes

reg [15:0] sum_a = n; // initialize sum_a to n
reg [15:0] sum_b = 0; // initialize sum_b to 0

// Compute the Adler checksum of the input data
genvar i;
generate
  for (i = 0; i < n; i = i + 1) begin : adler_loop
    always @* begin
      sum_a = (sum_a + data_in[i*8 +: 8]) % 65521;
      sum_b = (sum_b + sum_a) % 65521;
    end
  end
endgenerate

// Output the computed checksum value
assign checksum_out = (sum_b << 16) | sum_a;

// Check the validity of a received data and checksum pair
assign valid = (checksum_out == checksum_in);

endmodule