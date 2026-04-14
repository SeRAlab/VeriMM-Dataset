module dwt_haar (
    input [7:0] x0, x1, x2, x3,
    output [7:0] a, d
);
    assign a = (x0 + x1 + x2 + x3) >> 2; // Approximation coefficient
    assign d = (x0 - x1 + x2 - x3) >> 2; // Detail coefficient
endmodule