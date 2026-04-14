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
        Y = (R * 299 + G * 587 + B * 114) / 1000;

        // Calculate U
        U = (B - Y) * 493 / 1000;

        // Calculate V
        V = (R - Y) * 877 / 1000;
    end
endmodule