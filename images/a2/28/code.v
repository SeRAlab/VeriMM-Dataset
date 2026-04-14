module decoder_3to8(A, D);
     input [2:0] A;
     output [7:0] D;

     wire A0n, A1n, A2n;

     not (A0n, A[0]);
     not (A1n, A[1]);
     not (A2n, A[2]);

     and (D[0], A0n, A1n, A2n);
     and (D[1], A[0], A1n, A2n);
     and (D[2], A0n, A[1], A2n);
     and (D[3], A[0], A[1], A2n);
     and (D[4], A0n, A1n, A[2]);
     and (D[5], A[0], A1n, A[2]);
     and (D[6], A0n, A[1], A[2]);
     and (D[7], A[0], A[1], A[2]);
endmodule