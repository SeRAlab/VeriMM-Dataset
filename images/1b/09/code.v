module matrix_multiply (
    input [3:0] A0, A1, // Row 1 of Matrix A
    input [3:0] B0, B1, // Row 1 of Matrix B
    input [3:0] A2, A3, // Row 2 of Matrix A
    input [3:0] B2, B3, // Row 2 of Matrix B
    output [3:0] C0, C1, // Row 1 of Result Matrix C
    output [3:0] C2, C3  // Row 2 of Result Matrix C
);
    assign C0 = A0 * B0 + A1 * B2; // C[0][0]
    assign C1 = A0 * B1 + A1 * B3; // C[0][1]
    assign C2 = A2 * B0 + A3 * B2; // C[1][0]
    assign C3 = A2 * B1 + A3 * B3; // C[1][1]
endmodule