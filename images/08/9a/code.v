module gradient_descent (
    input clk,
    input rst,
    input [15:0] x,   // current guess
    input [15:0] lr,  // learning rate
    output reg [15:0] x_new // updated guess
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            x_new <= 16'b0; // reset output to 0
        else
            x_new <= x - (lr * (2 * (x - 16'd3))); // gradient descent update
    end
endmodule