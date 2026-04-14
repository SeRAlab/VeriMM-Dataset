module morphological_dilation(
    input [8:0] image,       // 3x3 image represented as a 9-bit input
    output reg dilated_pixel // Result of dilation
);

always @(*) begin
    // Dilation: Set output to 1 if any neighbor is 1
    if (image[0] | image[1] | image[2] | 
        image[3] | image[4] | image[5] | 
        image[6] | image[7] | image[8]) 
        dilated_pixel = 1'b1;
    else 
        dilated_pixel = 1'b0;
end

endmodule