module bilinear_interpolation (
    input [7:0] I00,
    input [7:0] I01,
    input [7:0] I10,
    input [7:0] I11,
    input [7:0] frac_x,
    input [7:0] frac_y,
    output reg [15:0] I_out
);
    always @(*) begin
        I_out = ( ( (255 - frac_x) * (255 - frac_y) * I00 ) + 
                   ( (255 - frac_x) * frac_y * I01 ) + 
                   ( frac_x * (255 - frac_y) * I10 ) + 
                   ( frac_x * frac_y * I11 ) ) >> 16;
    end
endmodule