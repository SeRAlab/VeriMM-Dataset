module bilinear_interpolation(
    input [7:0] P0,
    input [7:0] P1,
    input [7:0] P2,
    input [7:0] P3,
    input [7:0] X_frac,
    input [7:0] Y_frac,
    output reg [15:0] result
);

    wire [15:0] R1, R2;
    wire [15:0] P0_weighted, P1_weighted, P2_weighted, P3_weighted;

    // Calculate weighted contributions from each pixel
    assign P0_weighted = P0 * (16'h100 - X_frac) * (16'h100 - Y_frac);
    assign P1_weighted = P1 * X_frac * (16'h100 - Y_frac);
    assign P2_weighted = P2 * (16'h100 - X_frac) * Y_frac;
    assign P3_weighted = P3 * X_frac * Y_frac;

    // Sum contributions and normalize
    assign R1 = P0_weighted + P1_weighted;
    assign R2 = P2_weighted + P3_weighted;

    always @(*) begin
        result = (R1 + R2) >> 16; // Normalize the result
    end
endmodule