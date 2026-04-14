module matrix_multiply (  
    input [7:0] A00, A01, A10, A11,  
    input [7:0] B00, B01, B10, B11,  
    output [15:0] C00, C01, C10, C11  
);  
    assign C00 = A00 * B00 + A01 * B10;  
    assign C01 = A00 * B01 + A01 * B11;  
    assign C10 = A10 * B00 + A11 * B10;  
    assign C11 = A10 * B01 + A11 * B11;  
endmodule