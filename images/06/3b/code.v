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
        Y = (R * 77 + G * 150 + B * 29) >> 8; // 0.299*255 -> 77, 0.587*255 -> 150, 0.114*255 -> 29

        // Calculate U
        U = ((R * -36 + G * -74 + B * 112) >> 8) + 128; // -0.14713*255 -> -36, -0.28886*255 -> -74, 0.436*255 -> 112

        // Calculate V
        V = ((R * 112 + G * -94 + B * -18) >> 8) + 128; // 0.615*255 -> 112, -0.51499*255 -> -94, -0.10001*255 -> -18

        // Clamp values to [0, 255]
        Y = (Y < 0) ? 0 : (Y > 255) ? 255 : Y;
        U = (U < 0) ? 0 : (U > 255) ? 255 : U;
        V = (V < 0) ? 0 : (V > 255) ? 255 : V;
    end
endmodule