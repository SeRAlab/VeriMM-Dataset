module add4(input [3:0] A, input [3:0] B, input Cin, output [3:0] S, output Cout);

   wire [3:0] temp;
   assign temp[0] = A[0] ^ B[0] ^ Cin;
   assign Cout = A[0]&B[0] | A[0]&Cin | B[0]&Cin;

   assign temp[1] = A[1] ^ B[1] ^ Cout;
   assign Cout = A[1]&B[1] | A[1]&Cout | B[1]&Cout;

   assign temp[2] = A[2] ^ B[2] ^ Cout;
   assign Cout = A[2]&B[2] | A[2]&Cout | B[2]&Cout;

   assign temp[3] = A[3] ^ B[3] ^ Cout;
   assign S = temp;

endmodule