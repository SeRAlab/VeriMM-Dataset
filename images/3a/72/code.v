module matrix_multiplier(  
    input [7:0] matrix_a, // 2x2 matrix A: a11, a12, a21, a22  
    input [7:0] matrix_b, // 2x2 matrix B: b11, b12, b21, b22  
    output [15:0] matrix_out // 2x2 matrix Out: c11, c12, c21, c22  
);  
    wire [3:0] a11 = matrix_a[7:4];  
    wire [3:0] a12 = matrix_a[3:0];  
    wire [3:0] a21 = matrix_a[7:4];  
    wire [3:0] a22 = matrix_a[3:0];  
    
    wire [3:0] b11 = matrix_b[7:4];  
    wire [3:0] b12 = matrix_b[3:0];  
    wire [3:0] b21 = matrix_b[7:4];  
    wire [3:0] b22 = matrix_b[3:0];  
    
    // Matrix multiplication  
    wire [7:0] c11 = a11 * b11 + a12 * b21;  
    wire [7:0] c12 = a11 * b12 + a12 * b22;  
    wire [7:0] c21 = a21 * b11 + a22 * b21;  
    wire [7:0] c22 = a21 * b12 + a22 * b22;  
    
    assign matrix_out = {c11, c12, c21, c22};  
endmodule