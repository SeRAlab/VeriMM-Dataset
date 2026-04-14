module gradient_descent(
    input [15:0] a,  // coefficient of x^2
    input [15:0] b,  // coefficient of x
    input [15:0] c,  // constant term
    input signed [15:0] x,  // current x value
    output signed [15:0] next_x  // next x value after one gradient descent step
);
    parameter signed learning_rate = 16'h0001; // learning rate

    // Compute the gradient (f'(x) = 2ax + b)
    wire signed [31:0] gradient;
    assign gradient = (2 * a * x) + b;

    // Compute the next x value
    assign next_x = x - (learning_rate * gradient[15:0]);
endmodule