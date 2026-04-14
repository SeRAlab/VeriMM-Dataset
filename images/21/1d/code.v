module gradient_descent(
    input [15:0] x_current,
    input [15:0] learning_rate,
    output [15:0] x_new
);
    wire [31:0] gradient;
    
    // Compute gradient as 2 * x_current
    assign gradient = 2 * x_current;
    
    // Compute new value
    assign x_new = x_current - (learning_rate * gradient >> 16); // Right shift to scale down
endmodule