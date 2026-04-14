module erosion_3x3(
    input [8:0] image,  // 3x3 image represented as a 9-bit input
    output reg eroded_pixel  // Single output bit
);
    always @(*) begin
        // Erosion condition: if all pixels covered by the structuring element are 1's
        if (image[0] & image[1] & image[2] & 
            image[3] & image[4] & image[5] & 
            image[6] & image[7] & image[8]) 
            eroded_pixel = 1; // Output 1 if erosion is successful
        else 
            eroded_pixel = 0; // Output 0 otherwise
    end
endmodule