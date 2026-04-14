module LU_Decomposition (
    input [31:0] A11, A12, A21, A22,
    output reg [31:0] L11, L12, L21, L22,
    output reg [31:0] U11, U12, U21, U22
);
    always @* begin
        // Initialize L and U to zero
        L11 = 0; L12 = 0; L21 = 0; L22 = 0;
        U11 = 0; U12 = 0; U21 = 0; U22 = 0;

        // LU decomposition calculations for 2x2 matrix
        L11 = 1; // L11 is always 1
        L12 = A12; // L12 = A12
        L21 = A21 / A11; // L21 = A21 / A11
        L22 = 1; // L22 is always 1
        
        U11 = A11; // U11 = A11
        U12 = A12; // U12 = A12
        U21 = 0; // U21 = 0
        U22 = A22 - L21 * U12; // U22 = A22 - L21 * U12
    end
endmodule