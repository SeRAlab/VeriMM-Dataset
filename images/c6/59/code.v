module binary_adder (
    input [3:0] A,
    input [3:0] B,
    input CI,
    output [3:0] SUM,
    output COUT_N
);

    assign SUM = A + B + CI;
    assign COUT_N = (A[3] & B[3]) | (A[3] & CI) | (B[3] & CI);

endmodule