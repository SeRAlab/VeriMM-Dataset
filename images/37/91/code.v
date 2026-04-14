module dwt_haar (
    input [15:0] x0, x1, x2, x3,  // 4 input samples
    output [15:0] a0, a1, d0, d1  // 2 output approximate and 2 detail coefficients
);
    assign a0 = (x0 + x1) >> 1; // Approximation coefficient 1
    assign a1 = (x2 + x3) >> 1; // Approximation coefficient 2
    assign d0 = (x0 - x1);       // Detail coefficient 1
    assign d1 = (x2 - x3);       // Detail coefficient 2
endmodule