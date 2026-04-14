module bilinear_interpolation (
    input [7:0] P11, // Pixel value at (1,1)
    input [7:0] P12, // Pixel value at (1,2)
    input [7:0] P21, // Pixel value at (2,1)
    input [7:0] P22, // Pixel value at (2,2)
    input [7:0] u,    // Fractional coordinate u (0 to 255)
    input [7:0] v,    // Fractional coordinate v (0 to 255)
    output reg [7:0] P_out // Interpolated pixel value
);

    always @(*) begin
        P_out = ((P11 * (256 - u) * (256 - v) +
                   P12 * u * (256 - v) +
                   P21 * (256 - u) * v +
                   P22 * u * v) >> 16);
    end

endmodule