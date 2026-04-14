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
        Y = (R * 76 + G * 150 + B * 29) >> 8;  // Y = 0.299R + 0.587G + 0.114B
        
        // Calculate U
        U = ((-R * 37 - G * 74 + B * 112) >> 8) + 128; // U = -0.14713R - 0.28886G + 0.436B + 128
        
        // Calculate V
        V = ((R * 79 - G * 75 - B * 19) >> 8) + 128; // V = 0.615R - 0.51498G - 0.10001B + 128
    end
endmodule