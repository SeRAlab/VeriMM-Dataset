module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x_n,   // current input
    input signed [15:0] x_n1,  // previous input
    output reg signed [15:0] y_n,   // current output
    output reg signed [15:0] y_n1    // previous output
);
    // Coefficients (configurable)
    parameter signed [15:0] a1 = 16'h1F00; // coefficient for y[n-1]
    parameter signed [15:0] a2 = 16'h0F00; // coefficient for y[n-2]
    parameter signed [15:0] b0 = 16'h1F00; // coefficient for x[n]
    parameter signed [15:0] b1 = 16'h1F00; // coefficient for x[n-1]

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_n <= 16'h0000;
            y_n1 <= 16'h0000;
        end else begin
            // IIR filter equation: y[n] = b0*x[n] + b1*x[n-1] - a1*y[n-1] - a2*y[n-2]
            y_n <= (b0 * x_n + b1 * x_n1 - a1 * y_n1 - a2 * y_n) >>> 16; // right shift for scaling
            y_n1 <= y_n; // update previous output
        end
    end
endmodule