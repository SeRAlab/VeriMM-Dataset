module top_module(
    input [3:0] A,
    input VPWR,
    input VGND,
    output [3:0] X
);assign X[0] = A[0];
    assign X[1] = A[0] ^ A[1];
    assign X[2] = A[1] ^ A[2];
    assign X[3] = A[2] ^ A[3];

endmodule