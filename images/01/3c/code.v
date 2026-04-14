module bilinear_interpolation (
    input [7:0] I00, // Pixel intensity at (0,0)
    input [7:0] I01, // Pixel intensity at (0,1)
    input [7:0] I10, // Pixel intensity at (1,0)
    input [7:0] I11, // Pixel intensity at (1,1)
    output reg [7:0] I_interp // Interpolated intensity
);
    always @(*) begin
        // Bilinear interpolation formula
        I_interp = (I00 + I01 + I10 + I11) >> 2; // Average of four pixels
    end
endmodule