module image_convolution(
    input [7:0] pixel00, pixel01, pixel02,
    input [7:0] pixel10, pixel11, pixel12,
    input [7:0] pixel20, pixel21, pixel22,
    input [7:0] kernel00, kernel01, kernel02,
    input [7:0] kernel10, kernel11, kernel12,
    input [7:0] kernel20, kernel21, kernel22,
    output reg signed [15:0] output_pixel
);
    
    always @(*) begin
        output_pixel = (pixel00 * kernel00) + (pixel01 * kernel01) + (pixel02 * kernel02) +
                       (pixel10 * kernel10) + (pixel11 * kernel11) + (pixel12 * kernel12) +
                       (pixel20 * kernel20) + (pixel21 * kernel21) + (pixel22 * kernel22);
    end

endmodule