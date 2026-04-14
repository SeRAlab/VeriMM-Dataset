module matrix_mult(input [3:0] a11, input [3:0] a12, input [3:0] a21, input [3:0] a22,  
                   input [3:0] b11, input [3:0] b12, input [3:0] b21, input [3:0] b22,  
                   output [7:0] c11, output [7:0] c12, output [7:0] c21, output [7:0] c22);  

    assign c11 = a11 * b11 + a12 * b21;  
    assign c12 = a11 * b12 + a12 * b22;  
    assign c21 = a21 * b11 + a22 * b21;  
    assign c22 = a21 * b12 + a22 * b22;  

endmodule