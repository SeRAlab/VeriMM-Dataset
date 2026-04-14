module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x,       // Current input
    output reg signed [15:0] y    // Current output
);

    // Filter coefficients
    parameter signed [15:0] a1 = 16'h0A00; // 0.625
    parameter signed [15:0] a2 = 16'h0400; // 0.25
    parameter signed [15:0] b0 = 16'h0A00; // 0.625
    parameter signed [15:0] b1 = 16'h0A00; // 0.625
    parameter signed [15:0] b2 = 16'h0400; // 0.25

    reg signed [15:0] x_prev1, x_prev2;
    reg signed [15:0] y_prev1, y_prev2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            x_prev1 <= 16'h0000;
            x_prev2 <= 16'h0000;
            y_prev1 <= 16'h0000;
            y_prev2 <= 16'h0000;
        end else begin
            // Update the output using the IIR filter equation
            y <= (a1 * y_prev1 + a2 * y_prev2 + b0 * x + b1 * x_prev1 + b2 * x_prev2) >>> 10; // Scaling
            // Update previous values
            x_prev2 <= x_prev1;
            x_prev1 <= x;
            y_prev2 <= y_prev1;
            y_prev1 <= y;
        end
    end
endmodule