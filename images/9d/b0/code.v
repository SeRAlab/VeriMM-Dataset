module top_module(
    input [3:0] A,
    input [3:0] B,
    input C0,
    output [3:0] F,
    output C4
);wire [3:0] sum;
    wire [3:0] carry;

    assign sum = A + B + C0;
    assign carry = (A[3] & B[3]) | (A[3] & C0) | (B[3] & C0);

    assign F = sum;
    assign C4 = carry[3];

endmodule