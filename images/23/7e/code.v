module bilinear_interpolation (
    input [7:0] p00, // top-left pixel
    input [7:0] p01, // top-right pixel
    input [7:0] p10, // bottom-left pixel
    input [7:0] p11, // bottom-right pixel
    input [7:0] x,   // fractional x coordinate (0-255)
    input [7:0] y,   // fractional y coordinate (0-255)
    output reg [7:0] pixel_out
);
    reg [15:0] p0, p1, p2, p3; // intermediate calculations
    reg [15:0] temp1, temp2;

    always @(*) begin
        p0 = p00 * (256 - x) + p01 * x; // interpolate top row
        p1 = p10 * (256 - x) + p11 * x; // interpolate bottom row
        
        temp1 = p0 * (256 - y);
        temp2 = p1 * y;

        pixel_out = (temp1 + temp2) >> 16; // final interpolation
    end
endmodule