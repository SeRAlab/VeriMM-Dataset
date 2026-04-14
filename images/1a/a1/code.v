module gradient_descent (
    input clk,
    input rst,
    input [15:0] a,   // Coefficient a
    input [15:0] b,   // Coefficient b
    input [15:0] c,   // Coefficient c
    input [15:0] learning_rate,
    input [3:0] iterations,
    output reg [15:0] optimized_x
);
    reg [15:0] x;     // Current value of x
    reg [3:0] count;  // Iteration counter

    // Initial conditions
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'b0; // Start with x = 0
            optimized_x <= 16'b0;
            count <= 4'b0;
        end else if (count < iterations) begin
            // Gradient descent update
            x <= x - (learning_rate * (2 * a * x + b));
            count <= count + 1;
        end else begin
            optimized_x <= x; // Output the optimized x after iterations
        end
    end
endmodule