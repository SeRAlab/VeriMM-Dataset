module gaussian_blur (
    input [8:0] pixel00, input [8:0] pixel01, input [8:0] pixel02,
    input [8:0] pixel10, input [8:0] pixel11, input [8:0] pixel12,
    input [8:0] pixel20, input [8:0] pixel21, input [8:0] pixel22,
    output reg [8:0] output_pixel
);
    always @(*) begin
        output_pixel = (pixel00 * 61 + pixel01 * 124 + pixel02 * 61 +
                        pixel10 * 124 + pixel11 * 244 + pixel12 * 124 +
                        pixel20 * 61 + pixel21 * 124 + pixel22 * 61) / 1024;
    end
endmodule