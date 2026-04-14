module wallace_tree_adder(
    input [3:0] A,
    input [3:0] B,
    output [4:0] SUM
);
    wire [7:0] P; // Partial products
    wire [3:0] S1, S2, S3; // First stage sums
    wire [3:0] C1, C2; // Carry bits

    // Generate partial products
    assign P[0] = A[0] & B[0];
    assign P[1] = A[0] & B[1];
    assign P[2] = A[0] & B[2];
    assign P[3] = A[0] & B[3];

    assign P[4] = A[1] & B[0];
    assign P[5] = A[1] & B[1];
    assign P[6] = A[1] & B[2];
    assign P[7] = A[1] & B[3];

    // First stage (grouping)
    assign S1[0] = P[1] ^ P[4];
    assign C1[0] = P[1] & P[4];

    assign S1[1] = P[2] ^ P[5];
    assign C1[1] = P[2] & P[5];

    assign S1[2] = P[3] ^ P[6];
    assign C1[2] = P[3] & P[6];

    assign S1[3] = P[7];

    // Second stage (reducing)
    assign S2[0] = S1[0] ^ S1[1];
    assign C2[0] = S1[0] & S1[1];

    assign S2[1] = S1[2] ^ C1[1];
    assign C2[1] = S1[2] & C1[1];

    assign S2[2] = S1[3] ^ C2[0];
    assign C2[2] = S1[3] & C2[0];

    // Final sum and carry
    assign SUM[0] = S2[0];
    assign SUM[1] = S2[1];
    assign SUM[2] = C2[1];
    assign SUM[3] = C2[2];
    assign SUM[4] = C1[2];

endmodule