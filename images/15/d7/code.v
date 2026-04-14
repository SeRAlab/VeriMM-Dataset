module LU_Decomposition (
    input [15:0] A11, A12, A21, A22, // Elements of the input matrix
    output reg [15:0] L11, L12, L21, L22, // Elements of the lower triangular matrix
    output reg [15:0] U11, U12, U21, U22 // Elements of the upper triangular matrix
);
    
always @(*) begin
    // LU decomposition for a 2x2 matrix
    L11 = A11; // L11 = A11
    L12 = 0;   // L12 = 0
    L21 = A21 / L11; // L21 = A21 / L11
    L22 = A22 - L21 * A12; // L22 = A22 - L21 * A12
    
    U11 = A11; // U11 = A11
    U12 = A12; // U12 = A12
    U21 = 0;   // U21 = 0
    U22 = L22; // U22 = L22
end
endmodule