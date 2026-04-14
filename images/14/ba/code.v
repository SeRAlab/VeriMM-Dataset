module gaussian_blur (
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    output [7:0] blurred_pixel
);
    wire [15:0] sum;
    
    assign sum = (pixel00 + pixel01 + pixel02 +
                  pixel10 + pixel11 + pixel12 +
                  pixel20 + pixel21 + pixel22) / 9;
    
    assign blurred_pixel = sum[7:0];
endmodule