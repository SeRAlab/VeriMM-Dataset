module top_module(
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  input cin,
  output [3:0] S,
  output cout
);wire [3:0] sum;
  wire c1, c2, c3;

  assign c1 = A[0] & B[0];
  assign c2 = (A[0] ^ B[0]) & cin;
  assign c3 = A[0] | B[0];

  assign sum[0] = A[0] ^ B[0] ^ cin;
  
  assign c1 = c1 | (sum[0] & c3);
  assign c2 = c2 | (sum[0] & c3);

  assign c1 = c1 | (A[1] & B[1]);
  assign c2 = c2 | (A[1] & B[1]) | (sum[1] & c3);

  assign sum[1] = A[1] ^ B[1] ^ c1;

  assign c1 = c1 | (A[2] & B[2]);
  assign c2 = c2 | (A[2] & B[2]) | (sum[2] & c3);

  assign sum[2] = A[2] ^ B[2] ^ c1;

  assign c1 = c1 | (A[3] & B[3]);
  assign c2 = c2 | (A[3] & B[3]) | (sum[3] & c3);

  assign sum[3] = A[3] ^ B[3] ^ c1;

  assign cout = c2 | (sum[3] & c3);

  assign S = sum;

endmodule