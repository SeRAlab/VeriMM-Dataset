module rgb_to_yuv (
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output [7:0] Y,
    output [7:0] U,
    output [7:0] V
);
    assign Y = (R * 77 + G * 150 + B * 29) >> 8;  // Y calculation
    assign U = ((B - Y) * 255 / 112) + 128;         // U calculation
    assign V = ((R - Y) * 255 / 74) + 128;          // V calculation
endmodule