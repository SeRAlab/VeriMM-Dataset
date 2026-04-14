module gradient_descent(
    input [7:0] x,           // Current value of x (0 to 255)
    input [7:0] learning_rate, // Learning rate (0 to 255)
    output [7:0] x_new       // Updated value of x
);
    wire [15:0] gradient;    // Intermediate calculation for gradient
    wire [15:0] update;      // Calculation for x_new

    // Calculate gradient f'(x) = 2 * x
    assign gradient = 2 * x;

    // Calculate new value of x: x_new = x - learning_rate * gradient
    assign update = x - (learning_rate * gradient) >> 8; // Right shift to adjust for scaling
    assign x_new = (update < 0) ? 0 : (update > 255) ? 255 : update[7:0]; // Clamp the output to 0-255 range
endmodule