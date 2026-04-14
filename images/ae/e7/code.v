module top_module(
    input wire nE1, nE2, E3,
    input wire [2 : 0] A,
    output wire [7 : 0] nY
    );wire enable;

    assign enable = !nE1 && !nE2 && E3;

    assign nY[0] = nE1 || enable && !(!A[2] && !A[1] && !A[0]);
    assign nY[1] = nE1 || enable && !(!A[2] && !A[1] && A[0]);
    assign nY[2] = nE1 || enable && !(!A[2] && A[1] && !A[0]);
    assign nY[3] = nE1 || enable && !(!A[2] && A[1] && A[0]);
    assign nY[4] = nE1 || enable && !(A[2] && !A[1] && !A[0]);
    assign nY[5] = nE1 || enable && !(A[2] && !A[1] && A[0]);
    assign nY[6] = nE1 || enable && !(A[2] && A[1] && !A[0]);
    assign nY[7] = nE1 || enable && !(A[2] && A[1] && A[0]);

endmodule