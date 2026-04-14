module gradient_descent (
    input [15:0] x,      // Current point
    input [15:0] alpha,  // Learning rate
    output [15:0] new_x  // New point after gradient descent
);
    // Constant gradient value
    parameter GRADIENT = 16'd1;

    // Calculate new_x as x - alpha * gradient
    assign new_x = x - (alpha * GRADIENT);
endmodule