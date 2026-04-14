module dwt_haar (
    input [3:0] x, // 4-bit input
    output [3:0] approx, // 4-bit approximate coefficients
    output [3:0] detail // 4-bit detail coefficients
);
    wire [1:0] x0, x1;
    assign x0 = x[3:2]; // First two bits
    assign x1 = x[1:0]; // Last two bits

    // Haar wavelet transform calculations
    assign approx = (x0 + x1) >> 1; // Average
    assign detail = x0 - x1; // Difference

endmodule