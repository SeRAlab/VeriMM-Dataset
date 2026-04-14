module linear_regression (
    input [7:0] x1, // First input
    input [7:0] x2, // Second input
    output [15:0] y // Output prediction
);
    // Define weights and bias
    parameter w1 = 8; // Weight for x1
    parameter w2 = 5; // Weight for x2
    parameter b  = 2; // Bias

    assign y = (w1 * x1) + (w2 * x2) + b; // Linear regression equation

endmodule