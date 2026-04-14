module gradient_descent (
    input [15:0] X,      // Current position
    input [15:0] LR,     // Learning rate
    input [15:0] G,      // Gradient
    output [15:0] X_new  // New position
);
    assign X_new = X - (LR * G) >> 8; // Adjusting for fixed-point representation
endmodule