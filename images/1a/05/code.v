module gaussian_blur (
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    output reg [7:0] blurred_pixel
);
    always @(*) begin
        blurred_pixel = (pixel00 * 75 + pixel01 * 125 + pixel02 * 75 +
                         pixel10 * 125 + pixel11 * 200 + pixel12 * 125 +
                         pixel20 * 75 + pixel21 * 125 + pixel22 * 75) / 1000;
    end
endmodule