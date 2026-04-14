module portfolio_optimizer(
    input [3:0] w1, w2, w3,   // Weights of the assets
    input [3:0] r1, r2, r3,   // Returns of the assets
    output [4:0] total_return  // Total portfolio return
);
    assign total_return = (w1 * r1 + w2 * r2 + w3 * r3) >> 2; // Right shift to adjust for fixed point
endmodule