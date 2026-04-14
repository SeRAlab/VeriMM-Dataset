module LU_decomposition(  
    input [3:0] A11, A12, A21, A22,  
    output reg [3:0] L11, L12, L21, L22,  
    output reg [3:0] U11, U12, U21, U22  
);  
    always @(*) begin  
        // Compute U  
        U11 = A11;  
        U12 = A12;  
        U21 = A21;  
        U22 = A22 - (A21 * A12) / A11;  
          
        // Compute L  
        L11 = 1;  // L11 is always 1  
        L12 = 0;  // L12 is always 0  
        L21 = A21 / A11;  
        L22 = 1;  // L22 is always 1  
    end  
endmodule