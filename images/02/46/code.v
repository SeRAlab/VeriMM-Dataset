module bilinear_interpolation(
    input [7:0] Q11,
    input [7:0] Q12,
    input [7:0] Q21,
    input [7:0] Q22,
    input [7:0] u, // weight for x
    input [7:0] v, // weight for y
    output reg [15:0] output_pixel
);
    
    wire [15:0] R1, R2, R3, R4;

    // Intermediate interpolated results
    assign R1 = (Q11 * (255 - u) + Q21 * u) / 255;
    assign R2 = (Q12 * (255 - u) + Q22 * u) / 255;
    assign R3 = (R1 * (255 - v) + R2 * v) / 255;

    always @(*) begin
        output_pixel = R3;
    end
endmodule