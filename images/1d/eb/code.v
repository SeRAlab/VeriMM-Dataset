module bilinear_interpolation (
    input [7:0] Q11, // Top-left pixel
    input [7:0] Q12, // Top-right pixel
    input [7:0] Q21, // Bottom-left pixel
    input [7:0] Q22, // Bottom-right pixel
    input [7:0] x_frac, // x fractional part
    input [7:0] y_frac, // y fractional part
    output reg [7:0] interpolated_pixel // Output interpolated pixel
);

    wire [15:0] top, bottom, result;
    
    // Calculate the contribution of each pixel
    wire [15:0] Q11_contrib = (Q11 * (256 - x_frac) * (256 - y_frac)) >> 16;
    wire [15:0] Q12_contrib = (Q12 * x_frac * (256 - y_frac)) >> 16;
    wire [15:0] Q21_contrib = (Q21 * (256 - x_frac) * y_frac) >> 16;
    wire [15:0] Q22_contrib = (Q22 * x_frac * y_frac) >> 16;

    // Sum the contributions
    assign top = Q11_contrib + Q12_contrib;
    assign bottom = Q21_contrib + Q22_contrib;
    assign result = top + bottom;

    // Round and assign to output
    always @(*) begin
        interpolated_pixel = result[15:8] + (result[7] ? 8'b1 : 8'b0); // Round to nearest
    end
endmodule