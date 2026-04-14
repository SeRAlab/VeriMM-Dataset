module top_module(A, B, Y);input [3:0] A, B;
   output [3:0] Y;

   wire [3:0] X;

   assign X[0] = ~(A[0] & B[0]);
   assign X[1] = ~(A[1] & B[1]);
   assign X[2] = ~(A[2] & B[2]);
   assign X[3] = ~(A[3] & B[3]);

   assign Y[0] = ~(A[0] & X[0] | B[0] & X[0]);
   assign Y[1] = ~(A[1] & X[1] | B[1] & X[1]);
   assign Y[2] = ~(A[2] & X[2] | B[2] & X[2]);
   assign Y[3] = ~(A[3] & X[3] | B[3] & X[3]);

endmodule