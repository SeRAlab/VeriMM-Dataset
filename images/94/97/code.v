module top_module( A, ab, B, cd, Y );input [1:0] A; 
  input ab; 
  input [1:0] B; 
  input cd; 
  output [1:0] Y; 
  wire abcd, p, q; 
  assign abcd = ~(ab & cd); 
  assign p = (~(A[1] & B[1])) ^ abcd; 
  assign q = (~(A[0] & B[0])) ^ abcd; 
  assign Y = { p, q }; 
 endmodule