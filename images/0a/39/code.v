module bilinear_interpolation (
    input [7:0] I00, // pixel value (0,0)
    input [7:0] I01, // pixel value (0,1)
    input [7:0] I10, // pixel value (1,0)
    input [7:0] I11, // pixel value (1,1)
    input [7:0] frac_x, // fractional x coordinate (0-255)
    input [7:0] frac_y, // fractional y coordinate (0-255)
    output reg [7:0] I_interp // interpolated pixel value
);
    
    wire [15:0] I00_weighted, I01_weighted, I10_weighted, I11_weighted;
    
    // Calculate weighted contributions
    assign I00_weighted = I00 * (256 - frac_x) * (256 - frac_y);
    assign I01_weighted = I01 * (256 - frac_x) * frac_y;
    assign I10_weighted = I10 * frac_x * (256 - frac_y);
    assign I11_weighted = I11 * frac_x * frac_y;

    // Compute the final interpolated value
    always @(*) begin
        I_interp = (I00_weighted + I01_weighted + I10_weighted + I11_weighted) >> 16; // Right shift to adjust for scaling
    end
endmodule