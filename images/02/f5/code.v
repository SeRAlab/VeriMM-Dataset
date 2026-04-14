module bilinear_interpolation (
    input [7:0] I00,  // Intensity value at (0,0)
    input [7:0] I01,  // Intensity value at (0,1)
    input [7:0] I10,  // Intensity value at (1,0)
    input [7:0] I11,  // Intensity value at (1,1)
    input [7:0] x,    // x fractional part (0-255)
    input [7:0] y,    // y fractional part (0-255)
    output reg [15:0] I // Interpolated intensity value
);
    always @(*) begin
        // Bilinear interpolation formula
        I = ((I00 * (255 - x) * (255 - y)) + 
             (I01 * (255 - x) * y) + 
             (I10 * x * (255 - y)) + 
             (I11 * x * y)) / 65535;  // Normalizing the result
    end
endmodule