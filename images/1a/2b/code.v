module matrix_multiplier (  
    input [3:0] A, // Matrix A: 2x2 represented as 4 bits  
    input [3:0] B, // Matrix B: 2x2 represented as 4 bits  
    output reg [15:0] C // Output matrix C: 2x2 represented as 16 bits  
);  
    always @(*) begin  
        // Assigning the output based on matrix multiplication  
        C[15:12] = A[3:2] * B[3:2] + A[1:0] * B[1:0]; // C[0][0]  
        C[11:8]  = A[3:2] * B[1:0] + A[1:0] * B[3:2]; // C[0][1]  
        C[7:4]   = A[3:2] * B[3:2] + A[1:0] * B[1:0]; // C[1][0]  
        C[3:0]   = A[3:2] * B[1:0] + A[1:0] * B[3:2]; // C[1][1]  
    end  
endmodule