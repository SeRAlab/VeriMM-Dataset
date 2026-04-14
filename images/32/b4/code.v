module CSA_3input (
    input [4:0] A,
    input [4:0] B,
    input [4:0] C,
    output [5:0] SUM
);
    wire [4:0] carry;
    wire [4:0] sum_half;
    wire [4:0] sum_full;

    // Half adders for the first two inputs
    assign sum_half[0] = A[0] ^ B[0];
    assign carry[0] = A[0] & B[0];

    assign sum_half[1] = A[1] ^ B[1];
    assign carry[1] = A[1] & B[1];

    assign sum_half[2] = A[2] ^ B[2];
    assign carry[2] = A[2] & B[2];

    assign sum_half[3] = A[3] ^ B[3];
    assign carry[3] = A[3] & B[3];

    assign sum_half[4] = A[4] ^ B[4];
    assign carry[4] = A[4] & B[4];

    // Full adders using carry from the half adders
    assign sum_full[0] = sum_half[0] ^ C[0];
    assign carry[0] = sum_half[0] & C[0];

    assign sum_full[1] = sum_half[1] ^ C[1] ^ carry[0];
    assign carry[1] = (sum_half[1] & C[1]) | (carry[0] & (sum_half[1] ^ C[1]));

    assign sum_full[2] = sum_half[2] ^ C[2] ^ carry[1];
    assign carry[2] = (sum_half[2] & C[2]) | (carry[1] & (sum_half[2] ^ C[2]));

    assign sum_full[3] = sum_half[3] ^ C[3] ^ carry[2];
    assign carry[3] = (sum_half[3] & C[3]) | (carry[2] & (sum_half[3] ^ C[3]));

    assign sum_full[4] = sum_half[4] ^ C[4] ^ carry[3];
    assign carry[4] = (sum_half[4] & C[4]) | (carry[3] & (sum_half[4] ^ C[4]));

    // Final carry-out
    assign SUM = {carry[4], sum_full};

endmodule