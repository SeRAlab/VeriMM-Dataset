module gradient_descent (
    input clk,
    input reset,
    input [15:0] x,
    input [15:0] d,
    input [15:0] lr,
    output reg [15:0] theta
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            theta <= 16'h0000; // Initialize theta to 0
        end else begin
            theta <= theta - (lr * d); // Update theta
        end
    end
endmodule