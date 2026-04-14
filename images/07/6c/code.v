module morphological_dilation (
    input [8:0] img, // 3x3 image represented as 9 bits
    output reg dilated_pixel // Output of the dilation operation
);

always @(*) begin
    // Dilation: output is 1 if any input pixel is 1
    dilated_pixel = (img[0] | img[1] | img[2] |
                     img[3] | img[4] | img[5] |
                     img[6] | img[7] | img[8]);
end

endmodule