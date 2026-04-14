module matrix_inversion_2x2(  
    input [15:0] matrix_in,  // 4 elements of 2x2 matrix (a, b, c, d)  
    output reg [15:0] matrix_out,  // 4 elements of the inverted matrix (a_inv, b_inv, c_inv, d_inv)  
    output reg valid  // Indicates if the output is valid  
);  
    wire signed [15:0] a, b, c, d;  
    assign a = matrix_in[15:12];  
    assign b = matrix_in[11:8];  
    assign c = matrix_in[7:4];  
    assign d = matrix_in[3:0];  
    
    wire signed [15:0] det;  
    assign det = a * d - b * c;  // Determinant of the matrix  
   
    always @(*) begin  
        if (det != 0) begin  
            matrix_out = {d / det, -b / det, -c / det, a / det};  
            valid = 1;  
        end else begin  
            matrix_out = 0;  
            valid = 0;  
        end  
    end  
endmodule