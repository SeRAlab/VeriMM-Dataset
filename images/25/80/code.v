module sobel_edge_detector(
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    output [10:0] gradient_magnitude
);
    wire signed [10:0] Gx;
    wire signed [10:0] Gy;

    assign Gx = (pixel00 * -1) + (pixel01 * 0) + (pixel02 * 1) +
                (pixel10 * -2) + (pixel11 * 0) + (pixel12 * 2) +
                (pixel20 * -1) + (pixel21 * 0) + (pixel22 * 1);

    assign Gy = (pixel00 * -1) + (pixel01 * -2) + (pixel02 * -1) +
                (pixel10 * 0) + (pixel11 * 0) + (pixel12 * 0) +
                (pixel20 * 1) + (pixel21 * 2) + (pixel22 * 1);

    assign gradient_magnitude = (Gx < 0 ? -Gx : Gx) + (Gy < 0 ? -Gy : Gy);
endmodule