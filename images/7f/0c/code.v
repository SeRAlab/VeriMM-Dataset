module top_module(
  input [7:0] A,
  input [7:0] B,
  output [7:0] sum
);wire [7:0] temp_sum;
  wire carry;

  assign temp_sum[0] = A[0] ^ B[0];
  assign carry = A[0] & B[0];

  generate
    genvar i;
    for (i = 1; i < 8; i = i + 1) begin : adder_loop
      assign temp_sum[i] = A[i] ^ B[i] ^ carry;
      assign carry = (A[i] & B[i]) | (A[i] & carry) | (B[i] & carry);
    end
  endgenerate

  assign sum = temp_sum;

endmodule