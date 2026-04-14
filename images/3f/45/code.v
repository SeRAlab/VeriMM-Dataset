module gradient_descent (
    input [15:0] x,      // Current value
    input [15:0] alpha,   // Learning rate
    input [15:0] grad,    // Gradient
    output [15:0] x_new   // New value after gradient descent
);
    assign x_new = x - (alpha * grad) >> 8; // Right shift to divide by 256 (assuming fixed-point representation)
endmodule