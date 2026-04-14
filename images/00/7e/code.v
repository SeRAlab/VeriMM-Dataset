module matrix_multiplier (  
    input [3:0] A11, A12,  
    input [3:0] A21, A22,  
    input [3:0] B11, B12,  
    input [3:0] B21, B22,  
    output [3:0] C11, C12,  
    output [3:0] C21, C22  
);  

assign C11 = A11 * B11 + A12 * B21;  
assign C12 = A11 * B12 + A12 * B22;  
assign C21 = A21 * B11 + A22 * B21;  
assign C22 = A21 * B12 + A22 * B22;  

endmodule