module gradient_descent(
    input clk,
    input rst,
    input [31:0] x,      // Current position
    input [31:0] alpha,  // Learning rate
    input [31:0] grad,   // Gradient
    output reg [31:0] new_x // Updated position
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            new_x <= 32'b0; // Reset new_x to 0
        end else begin
            new_x <= x - (alpha * grad); // Update position
        end
    end
endmodule