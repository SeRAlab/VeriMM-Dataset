module dwt_1d (
    input [3:0] x0, x1, x2, x3,     // 4 sample inputs
    output [3:0] approx,            // Approximate coefficients
    output [3:0] detail             // Detail coefficients
);
    // Compute approximate coefficients (Low-pass filter)
    assign approx = (x0 + x1 + x2 + x3) >> 2; // Average of inputs

    // Compute detail coefficients (High-pass filter)
    assign detail = (x0 - x1 + x2 - x3) >> 2; // Difference of inputs

endmodule