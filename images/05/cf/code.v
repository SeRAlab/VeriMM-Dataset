module linear_regression (
    input signed [15:0] x,  // Input variable
    input signed [15:0] m,  // Slope
    input signed [15:0] b,  // Intercept
    output signed [31:0] y   // Output variable
);
    assign y = (m * x) + b; // Compute y = mx + b
endmodule