module rgb_to_yuv (
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output [7:0] Y,
    output [7:0] U,
    output [7:0] V
);
    assign Y = (R * 76 + G * 150 + B * 29) >> 8; // Y calculation
    assign U = ((R * -43 + G * -85 + B * 128) >> 8) + 128; // U calculation
    assign V = ((R * 112 + G * -94 + B * -18) >> 8) + 128; // V calculation
endmodule