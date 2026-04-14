module top_module(A, B, Cin, Sum, Cout);input [3:0] A, B;
  input Cin;
  output [3:0] Sum;
  output Cout;

  wire [3:0] temp_sum;
  wire temp_cout;

  // First bit
  assign temp_sum[0] = A[0] ^ B[0] ^ Cin;
  assign temp_cout = (A[0] & B[0]) | (A[0] & Cin) | (B[0] & Cin);

  // Second bit
  assign temp_sum[1] = A[1] ^ B[1] ^ temp_cout;
  assign temp_cout = (A[1] & B[1]) | (A[1] & temp_cout) | (B[1] & temp_cout);

  // Third bit
  assign temp_sum[2] = A[2] ^ B[2] ^ temp_cout;
  assign temp_cout = (A[2] & B[2]) | (A[2] & temp_cout) | (B[2] & temp_cout);

  // Fourth bit
  assign temp_sum[3] = A[3] ^ B[3] ^ temp_cout;
  assign Cout = temp_cout;

  assign Sum = temp_sum;

endmodule