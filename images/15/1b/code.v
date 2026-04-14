module conv_3x3(
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    input [7:0] kernel00, input [7:0] kernel01, input [7:0] kernel02,
    input [7:0] kernel10, input [7:0] kernel11, input [7:0] kernel12,
    input [7:0] kernel20, input [7:0] kernel21, input [7:0] kernel22,
    output reg [15:0] conv_out
);
    always @(*) begin
        conv_out = (pixel00 * kernel00) + (pixel01 * kernel01) + (pixel02 * kernel02) +
                   (pixel10 * kernel10) + (pixel11 * kernel11) + (pixel12 * kernel12) +
                   (pixel20 * kernel20) + (pixel21 * kernel21) + (pixel22 * kernel22);
    end
endmodule