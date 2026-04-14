module LU_Decomposition (
    input [15:0] A11, A12,
    input [15:0] A21, A22,
    output reg [15:0] L11, L12, L21, L22,
    output reg [15:0] U11, U12, U21, U22
);
    always @(*) begin
        // Lower triangular matrix L
        L11 = A11;
        L12 = 0;  // Assume L12 is 0 for 2x2 matrix
        L21 = A21 / A11;  // L21 = A21 / A11
        L22 = 0;  // Assume L22 is 0 for 2x2 matrix

        // Upper triangular matrix U
        U11 = A11;
        U12 = A12;  // U12 = A12
        U21 = 0;  // Assume U21 is 0 for 2x2 matrix
        U22 = A22 - (L21 * U12);  // U22 = A22 - L21 * U12
    end
endmodule