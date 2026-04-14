module LU_decomposition(
    input [31:0] A11, A12,
    input [31:0] A21, A22,
    output reg [31:0] L11, L21, L22,
    output reg [31:0] U11, U12, U22
);
    always @(*) begin
        // LU decomposition for a 2x2 matrix
        L11 = 1; // L11 is always 1
        L21 = A21 / A11; // L21 = A21 / A11
        L22 = A22 - (L21 * A12); // L22 = A22 - L21 * A12
        
        U11 = A11; // U11 = A11
        U12 = A12; // U12 = A12
        U22 = L22; // U22 = L22
    end
endmodule