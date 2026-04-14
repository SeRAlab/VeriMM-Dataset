module LU_Decomposition (
    input [3:0] matrix,
    output reg [3:0] L,
    output reg [3:0] U
);
    reg [3:0] A, B, C, D;
    
    always @(*) begin
        A = matrix[3:2];
        B = matrix[1:0];
        C = matrix[3:2];
        D = matrix[1:0];
        
        // Initialize L and U
        L = 4'b0001; // L11 = 1
        U = {A, B}; // U11 = A, U12 = B
        
        if (A != 0) begin
            L[2] = C / A; // L21 = C / A
            U[3] = D - (L[2] * B); // U22 = D - (L21 * U12)
        end else begin
            L[2] = 0; // Avoid division by zero
            U[3] = D; // Just keep U22 as D
        end
    end
endmodule