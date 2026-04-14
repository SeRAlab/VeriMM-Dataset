module linear_regression (
    input [15:0] x,  // Input value
    input signed [15:0] a,  // Coefficient
    input signed [15:0] b,  // Intercept
    output signed [31:0] y   // Output result
);
    assign y = (a * x) + b;  // Linear regression formula
endmodule