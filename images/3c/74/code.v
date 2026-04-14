module backpropagation (
    input clk,
    input reset,
    input [3:0] X0, X1, X2, X3, X4, // 4-bit training inputs
    input [3:0] T,                 // 4-bit target output
    output reg [3:0] W0, W1, W2, W3, W4 // 4-bit weights
);
    parameter LR = 4'b0001; // Learning rate (1 in decimal)
    reg [3:0] output_net;
    reg [3:0] error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            W0 <= 4'b0000;
            W1 <= 4'b0000;
            W2 <= 4'b0000;
            W3 <= 4'b0000;
            W4 <= 4'b0000;
        end else begin
            output_net = (X0 * W0 + X1 * W1 + X2 * W2 + X3 * W3 + X4 * W4);
            error = T - output_net;

            // Update weights
            W0 <= W0 + (error * X0) >> 2; // Shift to manage overflow
            W1 <= W1 + (error * X1) >> 2;
            W2 <= W2 + (error * X2) >> 2;
            W3 <= W3 + (error * X3) >> 2;
            W4 <= W4 + (error * X4) >> 2;
        end
    end
endmodule