module gradient_descent (
    input clk,
    input rst,
    input valid,
    input [31:0] x,   // current position
    input [31:0] lr,  // learning rate
    output reg [31:0] new_x // updated position
);

    parameter gradient = 1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            new_x <= 32'b0; // Reset new_x
        end else if (valid) begin
            // Calculate new position
            new_x <= x - (lr * gradient);
        end
    end
endmodule