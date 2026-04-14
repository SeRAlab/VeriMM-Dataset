module two_bit_adder(
  input [1:0] A,
  input [1:0] B,
  output [1:0] S,
  output C
);

  // Calculate the sum of the least significant bits of A and B
  wire sum_lsb = A[0] ^ B[0];

  // Calculate the sum of the most significant bits of A and B along with the carry out from the previous step
  wire sum_msb = A[1] ^ B[1] ^ sum_lsb;
  wire carry_out = (A[1] & B[1]) | (A[1] & sum_lsb) | (B[1] & sum_lsb);

  // Combine the two sums and the carry out to produce the final output
  assign S = {sum_msb, sum_lsb};
  assign C = carry_out;

endmodule