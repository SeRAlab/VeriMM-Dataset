module image_dilation (
    input [8:0] image, // 3x3 binary image
    output [8:0] dilated_image // 3x3 dilated binary image
);
    assign dilated_image = (image[0] | image[1] | image[2] |
                            image[3] | image[4] | image[5] |
                            image[6] | image[7] | image[8]) ? 9'b111111111 : 9'b000000000;
endmodule