module matrix_multiplier(  
    input [7:0] A00, A01, A10, A11,  // Matrix A  
    input [7:0] B00, B01, B10, B11,  // Matrix B  
    output [7:0] C00, C01, C10, C11   // Matrix C (result)  
);  
    assign C00 = A00 * B00 + A01 * B10;  
    assign C01 = A00 * B01 + A01 * B11;  
    assign C10 = A10 * B00 + A11 * B10;  
    assign C11 = A10 * B01 + A11 * B11;  
endmodule