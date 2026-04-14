module linear_regression (
    input signed [15:0] x1,
    input signed [15:0] x2,
    input signed [15:0] w1,
    input signed [15:0] w2,
    input signed [15:0] b,
    output signed [15:0] y
);
    assign y = (w1 * x1 + w2 * x2) >>> 8 + b; // Using shift right to adjust for fixed-point
endmodule