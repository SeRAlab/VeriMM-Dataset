module rgb_to_yuv (
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output [7:0] Y,
    output [7:0] U,
    output [7:0] V
);

    wire signed [15:0] Y_temp;
    wire signed [15:0] U_temp;
    wire signed [15:0] V_temp;

    assign Y_temp = (R * 299 + G * 587 + B * 114) / 1000; // Y calculation
    assign U_temp = (-R * 14713 - G * 28886 + B * 43600 + 1280000) / 10000; // U calculation
    assign V_temp = (R * 61500 - G * 51499 - B * 10001 + 1280000) / 10000; // V calculation

    assign Y = (Y_temp < 0) ? 0 : (Y_temp > 255) ? 255 : Y_temp[7:0];
    assign U = (U_temp < 0) ? 0 : (U_temp > 255) ? 255 : U_temp[7:0];
    assign V = (V_temp < 0) ? 0 : (V_temp > 255) ? 255 : V_temp[7:0];

endmodule