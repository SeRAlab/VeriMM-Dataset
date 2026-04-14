module image_convolution (
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    input [7:0] kernel00, input [7:0] kernel01, input [7:0] kernel02,
    input [7:0] kernel10, input [7:0] kernel11, input [7:0] kernel12,
    input [7:0] kernel20, input [7:0] kernel21, input [7:0] kernel22,
    output [7:0] result
);

wire [15:0] conv00 = pixel00 * kernel00;
wire [15:0] conv01 = pixel01 * kernel01;
wire [15:0] conv02 = pixel02 * kernel02;
wire [15:0] conv10 = pixel10 * kernel10;
wire [15:0] conv11 = pixel11 * kernel11;
wire [15:0] conv12 = pixel12 * kernel12;
wire [15:0] conv20 = pixel20 * kernel20;
wire [15:0] conv21 = pixel21 * kernel21;
wire [15:0] conv22 = pixel22 * kernel22;

assign result = (conv00 + conv01 + conv02 + 
                 conv10 + conv11 + conv12 +
                 conv20 + conv21 + conv22) >> 8;

endmodule