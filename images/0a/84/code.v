module gradient_descent(
    input wire clk,
    input wire rst,
    input wire [15:0] x,     // Current position
    input wire [15:0] alpha,  // Learning rate
    input wire [15:0] g,      // Gradient
    output reg [15:0] x_new   // Updated position
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_new <= 16'b0;
        end else begin
            x_new <= x - (alpha * g) >> 8; // Scaling for fixed-point arithmetic
        end
    end
endmodule