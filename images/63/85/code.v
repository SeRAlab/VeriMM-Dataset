module decoder_2to4(A, Y);
     input [1:0] A;
     output [3:0] Y;

     wire A0n, A1n;

     not (A0n, A[0]);
     not (A1n, A[1]);

     and (Y[0], A0n, A1n);
     and (Y[1], A[0], A1n);
     and (Y[2], A0n, A[1]);
     and (Y[3], A[0], A[1]);
endmodule