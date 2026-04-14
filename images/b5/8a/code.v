module top_module(
    input [3:0] A,
    input [1:0] B,
    output [3:0] Q
);assign Q = (B[1]) ? ({A[1:0], A[3:2]}) >> B : (B[0]) ? A << B : A;

endmodule