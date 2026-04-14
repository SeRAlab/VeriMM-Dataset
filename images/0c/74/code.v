module LU_Decomposition(
    input [3:0] L11, L12, L21, L22,  // Lower triangular matrix L
    input [3:0] U11, U12, U21, U22,  // Upper triangular matrix U
    output reg [7:0] A11, A12, A21, A22 // Output matrix A
);
    always @(*) begin
        // Calculate A = L * U
        A11 = L11 * U11; 
        A12 = L11 * U12 + L12 * U22; 
        A21 = L21 * U11; 
        A22 = L21 * U12 + L22 * U22; 
    end
endmodule