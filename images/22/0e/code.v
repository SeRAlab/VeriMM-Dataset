module RGB_to_YUV (
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output reg [7:0] Y,
    output reg [7:0] U,
    output reg [7:0] V
);

always @(*) begin
    Y = (R * 76 + G * 150 + B * 29) >> 8; // Scaling to fit within 8 bits
    U = ((-R * 43 - G * 85 + B * 128) >> 8) + 128;
    V = ((R * 112 - G * 107 - B * 21) >> 8) + 128;
end

endmodule