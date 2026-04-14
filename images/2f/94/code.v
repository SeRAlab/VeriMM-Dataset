module conv2d_3x3 (  
    input [26:0] input_matrix, // 3x3 input matrix flattened: {a00, a01, a02, a10, a11, a12, a20, a21, a22}  
    input [26:0] kernel,       // 3x3 kernel flattened: {k00, k01, k02, k10, k11, k12, k20, k21, k22}  
    output reg [8:0] output_value // Output value  
);  
    integer i;  
    always @* begin  
        output_value = 9'b0;  
        // Perform convolution  
        for (i = 0; i < 9; i = i + 1) begin  
            output_value = output_value + (input_matrix[i * 3 +: 3] * kernel[i * 3 +: 3]);  
        end  
    end  
endmodule