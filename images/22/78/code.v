module image_convolution (
    input [8*9-1:0] pixel_matrix, // 3x3 matrix of 8-bit pixels
    input [8*9-1:0] kernel,        // 3x3 matrix of 8-bit kernel values
    output reg [15:0] output_pixel  // 16-bit output pixel
);

integer i, j;
always @(*) begin
    output_pixel = 0; // Initialize output
    for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j < 3; j = j + 1) begin
            output_pixel = output_pixel + 
                pixel_matrix[(i*3+j)*8 +: 8] * kernel[(i*3+j)*8 +: 8];
        end
    end
end

endmodule