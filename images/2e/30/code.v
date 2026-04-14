module matrix_inverse_2x2 (  
    input [15:0] matrix,  // 4 bits for each element of the matrix: matrix[15:12], matrix[11:8], matrix[7:4], matrix[3:0]  
    output reg [15:0] inverse, // Inverse matrix output  
    output reg valid // Valid signal to indicate if inverse is computable  
);  
    wire [15:0] det;  
    wire [15:0] a, b, c, d;  

    assign a = matrix[15:12];  
    assign b = matrix[11:8];  
    assign c = matrix[7:4];  
    assign d = matrix[3:0];  

    assign det = a * d - b * c;  

    always @(*) begin  
        if (det == 16'b0) begin  
            valid = 1'b0;  
            inverse = 16'b0;  
        end else begin  
            valid = 1'b1;  
            inverse = {d, -b, -c, a} / det;  
        end  
    end  
endmodule