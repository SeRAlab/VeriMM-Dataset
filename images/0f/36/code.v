module image_convolution (
    input [7:0] pixel00, pixel01, pixel02,
    input [7:0] pixel10, pixel11, pixel12,
    input [7:0] pixel20, pixel21, pixel22,
    input [7:0] kernel00, kernel01, kernel02,
    input [7:0] kernel10, kernel11, kernel12,
    input [7:0] kernel20, kernel21, kernel22,
    output [7:0] conv_result
);

wire [15:0] product00, product01, product02;
wire [15:0] product10, product11, product12;
wire [15:0] product20, product21, product22;

assign product00 = pixel00 * kernel00;
assign product01 = pixel01 * kernel01;
assign product02 = pixel02 * kernel02;
assign product10 = pixel10 * kernel10;
assign product11 = pixel11 * kernel11;
assign product12 = pixel12 * kernel12;
assign product20 = pixel20 * kernel20;
assign product21 = pixel21 * kernel21;
assign product22 = pixel22 * kernel22;

assign conv_result = (product00 + product01 + product02 +
                      product10 + product11 + product12 +
                      product20 + product21 + product22) >> 8;

endmodule