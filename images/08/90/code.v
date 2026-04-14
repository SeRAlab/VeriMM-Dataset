module rgb_to_yuv (
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output reg [7:0] Y,
    output reg [7:0] U,
    output reg [7:0] V
);

always @(*) begin
    // Compute Y
    Y = (R * 299 + G * 587 + B * 114) / 1000;

    // Compute U
    U = ((-R * 14713 - G * 28886 + B * 43600) / 100000 + 128);
    
    // Compute V
    V = ((R * 61500 - G * 51499 - B * 10001) / 100000 + 128);

    // Clipping Y, U, V to be in 0 to 255
    Y = (Y < 0) ? 0 : (Y > 255) ? 255 : Y;
    U = (U < 0) ? 0 : (U > 255) ? 255 : U;
    V = (V < 0) ? 0 : (V > 255) ? 255 : V;
end

endmodule