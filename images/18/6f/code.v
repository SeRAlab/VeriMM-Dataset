module LU_Decomposition (  
    input [15:0] A11, A12,  
    input [15:0] A21, A22,  
    output reg [15:0] L11, L12,  
    output reg [15:0] L21, L22,  
    output reg [15:0] U11, U12,  
    output reg [15:0] U21, U22  
);  

    always @* begin  
        // Initialize L and U  
        L11 = 16'd1; // L11 is always 1  
        L12 = 16'd0;  
        L21 = A21 / A11;  
        L22 = 16'd0; // L22 is not used directly  

        U11 = A11;  
        U12 = A12;  
        U21 = 16'd0; // U21 is not used directly  
        U22 = A22 - (L21 * U12);  
    end  
endmodule