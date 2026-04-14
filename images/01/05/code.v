module bilinear_interp (
    input [7:0] P00,
    input [7:0] P01,
    input [7:0] P10,
    input [7:0] P11,
    input [7:0] x, // fractional x coordinate (4 integer + 4 fractional bits)
    input [7:0] y, // fractional y coordinate (4 integer + 4 fractional bits)
    output reg [15:0] out // output interpolated pixel value
);
    wire [15:0] R1, R2;
    wire [15:0] x_frac, y_frac;

    assign x_frac = {4'b0000, x[3:0]}; // fractional part of x
    assign y_frac = {4'b0000, y[3:0]}; // fractional part of y

    assign R1 = (P00 * (16'hF0 - x_frac) + P01 * x_frac) >> 8; // Interpolate in x direction
    assign R2 = (P10 * (16'hF0 - x_frac) + P11 * x_frac) >> 8; // Interpolate in x direction

    always @(*) begin
        out = (R1 * (16'hF0 - y_frac) + R2 * y_frac) >> 8; // Final interpolation in y direction
    end
endmodule