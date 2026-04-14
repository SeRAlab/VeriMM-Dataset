module rgb_to_yuv (
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output reg [7:0] Y,
    output reg [7:0] U,
    output reg [7:0] V
);

always @(*) begin
    // Calculate Y
    Y = (R * 77 + G * 150 + B * 29) >> 8;

    // Calculate U
    U = ((-R * 44 - G * 87 + B * 128) >> 8) + 128;

    // Calculate V
    V = ((R * 115 - G * 94 - B * 18) >> 8) + 128;

    // Ensure outputs are within valid 8-bit range
    Y = (Y > 255) ? 255 : (Y < 0) ? 0 : Y;
    U = (U > 255) ? 255 : (U < 0) ? 0 : U;
    V = (V > 255) ? 255 : (V < 0) ? 0 : V;
end

endmodule