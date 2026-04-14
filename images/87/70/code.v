module top_module(
  input [3:0] A, B,
  input CIN,
  output [3:0] S,
  output COUT
);wire [3:0] sum;
  
  // Full Adder
  assign sum[0] = A[0] ^ B[0] ^ CIN;
  assign COUT = (A[0] & B[0]) | (CIN & (A[0] ^ B[0]));
  
  assign sum[1] = A[1] ^ B[1] ^ COUT;
  assign COUT = (A[1] & B[1]) | (COUT & (A[1] ^ B[1]));
  
  assign sum[2] = A[2] ^ B[2] ^ COUT;
  assign COUT = (A[2] & B[2]) | (COUT & (A[2] ^ B[2]));
  
  assign sum[3] = A[3] ^ B[3] ^ COUT;
  assign S = sum;

endmodule