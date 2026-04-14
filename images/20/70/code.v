module simple_nn (
    input clk,
    input rst,
    input [7:0] x1,    // Input feature 1
    input [7:0] x2,    // Input feature 2
    input [7:0] w1,    // Weight 1 for input feature 1
    input [7:0] w2,    // Weight 2 for input feature 2
    input [7:0] b,     // Bias
    input [7:0] grad,  // Gradient for backpropagation
    output reg [7:0] y_out // Output
);
    reg [7:0] h; // Hidden layer output
    reg [7:0] w1_update, w2_update; // Weight updates

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 0;
            w1_update <= 0;
            w2_update <= 0;
        end else begin
            // Forward pass
            h <= (x1 * w1 + x2 * w2 + b);
            y_out <= h; 

            // Backpropagation to update weights
            w1_update <= w1 - (grad * x1);
            w2_update <= w2 - (grad * x2);
        end
    end
endmodule