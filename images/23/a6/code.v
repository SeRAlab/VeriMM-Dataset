module gradient_descent (
    input  signed [15:0] x,    // Current value
    input  signed [15:0] alpha, // Learning rate
    output signed [15:0] x_new  // Updated value
);
    parameter signed [15:0] gradient = 1; // Constant gradient
    assign x_new = x - (alpha * gradient);
endmodule