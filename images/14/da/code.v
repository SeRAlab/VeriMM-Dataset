module morphological_dilation (
    input [8:0] image,  // 3x3 binary image as a single 9-bit input
    output reg [8:0] dilated_image // 3x3 binary dilated image as a single 9-bit output
);
    integer i, j;
    always @(*) begin
        dilated_image = 0; // Initialize the output
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                if (image[i*3 + j] == 1) begin
                    // Set the surrounding pixels if the current pixel is 1
                    dilated_image[(i-1)*3 + (j-1)] = 1; // Top-left
                    dilated_image[(i-1)*3 + j] = 1;     // Top
                    dilated_image[(i-1)*3 + (j+1)] = 1; // Top-right
                    dilated_image[i*3 + (j-1)] = 1;     // Left
                    dilated_image[i*3 + j] = 1;         // Center
                    dilated_image[i*3 + (j+1)] = 1;     // Right
                    dilated_image[(i+1)*3 + (j-1)] = 1; // Bottom-left
                    dilated_image[(i+1)*3 + j] = 1;     // Bottom
                    dilated_image[(i+1)*3 + (j+1)] = 1; // Bottom-right
                end
            end
        end
    end
endmodule