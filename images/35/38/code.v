module image_convolution (
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    output [15:0] conv_out
);
    parameter [7:0] K00 = 8'd1, K01 = 8'd1, K02 = 8'd1;
    parameter [7:0] K10 = 8'd1, K11 = 8'd1, K12 = 8'd1;
    parameter [7:0] K20 = 8'd1, K21 = 8'd1, K22 = 8'd1;

    assign conv_out = (K00 * pixel00 + K01 * pixel01 + K02 * pixel02 +
                       K10 * pixel10 + K11 * pixel11 + K12 * pixel12 +
                       K20 * pixel20 + K21 * pixel21 + K22 * pixel22);
endmodule