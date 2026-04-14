module matrix_inverse(  
    input [15:0] matrix_in, // 2x2 matrix input (4 bits per element)  
    output reg [15:0] matrix_out // 2x2 matrix output (4 bits per element)  
);  
    wire signed [3:0] a = matrix_in[15:12];  
    wire signed [3:0] b = matrix_in[11:8];  
    wire signed [3:0] c = matrix_in[7:4];  
    wire signed [3:0] d = matrix_in[3:0];  

    wire signed [7:0] det = a * d - b * c; // determinant  

    always @(*) begin  
        if (det == 0) begin  
            matrix_out = 16'h0000; // Not invertible  
        end else begin  
            // Inverse of 2x2 matrix: (1/det) * | d  -b |  
            //                               | -c   a |  
            matrix_out = {d, -b, -c, a} / det;  
        end  
    end  
endmodule