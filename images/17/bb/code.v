module LU_Decomposition(  
    input [3:0] matrix_in,  
    output reg [3:0] matrix_out  
);  
    wire [1:0] a, b, c, d;  
    assign a = matrix_in[3:2]; // First row of the matrix  
    assign b = matrix_in[1:0]; // Second row of the matrix  
  
    // Perform LU Decomposition for 2x2 Matrix  
    always @(*) begin  
        matrix_out[3:2] = a; // L11, L12  
        matrix_out[1:0] = {a[0], b[1]}; // U21, U22  
    end  
endmodule