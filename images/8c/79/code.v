module top_module( A, out );input [3:0] A;
  output [3:0] out;
  wire   \A[3] , \A[2] , \A[1] ;
  assign out[3] = 1'b0;
  assign \A[3]  = A[3];
  assign out[2] = \A[3] ;
  assign \A[2]  = A[2];
  assign out[1] = \A[2] ;
  assign \A[1]  = A[1];
  assign out[0] = \A[1] ;endmodule