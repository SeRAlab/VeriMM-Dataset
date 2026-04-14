module gaussian_blur(  
    input [71:0] pixel_matrix,  // 3x3 matrix of 8-bit pixels  
    output reg [7:0] blurred_pixel  
);  
    integer i;  
    reg [15:0] sum;  // To hold the sum of pixel values  
    always @(*) begin  
        sum = 0;  
        for (i = 0; i < 9; i = i + 1) begin  
            sum = sum + pixel_matrix[8*i +: 8];  // Extract each 8-bit pixel  
        end  
        blurred_pixel = sum / 9;  // Average the sum to get the blurred pixel value  
    end  
endmodule