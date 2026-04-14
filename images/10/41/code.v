module LU_Decomposition(  
    input [3:0] matrix,  
    output reg [3:0] L,  
    output reg [3:0] U  
);  
    wire [1:0] a = matrix[3:2];  
    wire [1:0] b = matrix[1:0];  

    always @(*) begin  
        // Assuming matrix is [[a11, a12], [a21, a22]]  
        // U is upper triangular  
        U[3:2] = a;  
        U[1:0] = b - (a[0] * b[0]) / a[0];  

        // L is lower triangular  
        L[3:2] = {1'b0, (b[0] / a[0])};  
        L[1:0] = {1'b0, 1'b1};  
    end  
endmodule