module gradient_descent (
    input [15:0] x,      // Current value of the parameter
    input [15:0] g,      // Gradient
    input [15:0] lr,     // Learning rate
    output [15:0] new_x  // New value of the parameter
);
    assign new_x = x - (lr * g) >> 8; // Scale down the product to fit in 16 bits
endmodule