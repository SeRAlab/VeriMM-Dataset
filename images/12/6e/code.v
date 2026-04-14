module RGB_to_YUV (
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output [7:0] Y,
    output [7:0] U,
    output [7:0] V
);

assign Y = (R * 299 + G * 587 + B * 114) / 1000;
assign U = (B - Y) * 439 / 1000 + 128;
assign V = (R - Y) * 877 / 1000 + 128;

endmodule