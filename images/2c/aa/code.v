module erosion_3x3(
    input wire [8:0] image,  // 3x3 binary image represented as a 9-bit vector
    output wire result        // Erosion result
);
    assign result = (image[0] & image[1] & image[2] & 
                     image[3] & image[4] & image[5] & 
                     image[6] & image[7] & image[8]);
endmodule