module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x,      // input sample
    output reg signed [15:0] y   // output sample
);
    reg signed [15:0] y_prev1, y_prev2; // previous outputs
    reg signed [15:0] x_prev1, x_prev2; // previous inputs
    parameter signed [15:0] b0 = 16'h0001, b1 = 16'h0001, b2 = 16'h0001;
    parameter signed [15:0] a1 = -16'h0008, a2 = 16'h0004; // multiply by 0.5 and 0.25

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            y_prev1 <= 16'h0000;
            y_prev2 <= 16'h0000;
            x_prev1 <= 16'h0000;
            x_prev2 <= 16'h0000;
        end else begin
            y <= b0 * x + b1 * x_prev1 + b2 * x_prev2 - a1 * y_prev1 - a2 * y_prev2;
            x_prev2 <= x_prev1;
            x_prev1 <= x;
            y_prev2 <= y_prev1;
            y_prev1 <= y;
        end
    end
endmodule