module matrix_mult (  
    input [7:0] A00, A01, // First row of matrix A  
    input [7:0] A10, A11, // Second row of matrix A  
    input [7:0] B00, B01, // First row of matrix B  
    input [7:0] B10, B11, // Second row of matrix B  
    output [15:0] C00, C01, // First row of matrix C  
    output [15:0] C10, C11  // Second row of matrix C  
);  
    assign C00 = A00 * B00 + A01 * B10;  
    assign C01 = A00 * B01 + A01 * B11;  
    assign C10 = A10 * B00 + A11 * B10;  
    assign C11 = A10 * B01 + A11 * B11;  
endmodule