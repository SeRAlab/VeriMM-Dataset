module LU_Decomposition (
    input [3:0] A11, A12, A21, A22,
    output reg [3:0] L11, L12, L21, L22,
    output reg [3:0] U11, U12, U21, U22
);
    always @(*) begin
        // LU Decomposition for a 2x2 matrix
        L11 = A11;
        L12 = A12 / L11; // Assuming L11 != 0
        L21 = A21;
        L22 = A22 - L12 * L21; // L22 = A22 - L21 * U12
        U11 = L11; // U11 is same as L11
        U12 = A12; // U12 is the same as A12
        U21 = 0; // 0 for L21 in U matrix
        U22 = L22; // U22 is computed from L22
    end
endmodule