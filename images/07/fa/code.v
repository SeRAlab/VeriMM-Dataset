module matrix_multiply(  
    input [15:0] matrix_a,  
    input [15:0] matrix_b,  
    output reg [15:0] matrix_out  
);  
    always @(*) begin  
        matrix_out[3:0] = (matrix_a[3:0] * matrix_b[3:0]) + (matrix_a[7:4] * matrix_b[11:8]); // Row 1, Col 1  
        matrix_out[7:4] = (matrix_a[3:0] * matrix_b[7:4]) + (matrix_a[7:4] * matrix_b[15:12]); // Row 1, Col 2  
        matrix_out[11:8] = (matrix_a[11:8] * matrix_b[3:0]) + (matrix_a[15:12] * matrix_b[11:8]); // Row 2, Col 1  
        matrix_out[15:12] = (matrix_a[11:8] * matrix_b[7:4]) + (matrix_a[15:12] * matrix_b[15:12]); // Row 2, Col 2  
    end  
endmodule