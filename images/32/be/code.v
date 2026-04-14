module gradient_descent_optimizer(
    input wire clk,
    input wire [15:0] grad,
    output reg [15:0] x
);
    parameter LEARNING_RATE = 16'h0001; // Set learning rate

    initial begin
        x = 16'h0000; // Initial value of x
    end

    always @(posedge clk) begin
        x <= x - (grad * LEARNING_RATE); // Update x using gradient
    end
endmodule