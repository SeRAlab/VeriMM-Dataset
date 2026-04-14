module decoder_3to8(A, Y);
    input [2:0] A;
    output [7:0] Y;

    wire [2:0] A_not;

    not (A_not[0], A[0]);
    not (A_not[1], A[1]);
    not (A_not[2], A[2]);

    and (Y[0], A_not[2], A_not[1], A_not[0]);
    and (Y[1], A_not[2], A_not[1], A[0]);
    and (Y[2], A_not[2], A[1], A_not[0]);
    and (Y[3], A_not[2], A[1], A[0]);
    and (Y[4], A[2], A_not[1], A_not[0]);
    and (Y[5], A[2], A_not[1], A[0]);
    and (Y[6], A[2], A[1], A_not[0]);
    and (Y[7], A[2], A[1], A[0]);
endmodule