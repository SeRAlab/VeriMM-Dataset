module gaussian_blur(
    input [7:0] pixel00, pixel01, pixel02,
    input [7:0] pixel10, pixel11, pixel12,
    input [7:0] pixel20, pixel21, pixel22,
    output [7:0] blurred_pixel
);
    wire [15:0] sum;
    
    assign sum = (pixel00 * 1) + (pixel01 * 2) + (pixel02 * 1) +
                 (pixel10 * 2) + (pixel11 * 4) + (pixel12 * 2) +
                 (pixel20 * 1) + (pixel21 * 2) + (pixel22 * 1);
                 
    assign blurred_pixel = sum / 16;
endmodule