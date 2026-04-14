module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] X,  // Input sample
    output reg signed [15:0] Y // Output sample
);
    reg signed [15:0] Y_prev;  // Y[n-1]
    reg signed [15:0] Y_prev2; // Y[n-2]
    reg signed [15:0] X_prev;   // X[n-1]

    // Coefficients
    parameter signed [15:0] a1 = 16'sd3276; // a1 = 0.1
    parameter signed [15:0] a2 = 16'sd1638; // a2 = 0.05
    parameter signed [15:0] b0 = 16'sd32768; // b0 = 1.0
    parameter signed [15:0] b1 = 16'sd16384; // b1 = 0.5

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Y <= 16'sd0;
            Y_prev <= 16'sd0;
            Y_prev2 <= 16'sd0;
            X_prev <= 16'sd0;
        end else begin
            Y <= (a1 * Y_prev) + (a2 * Y_prev2) + (b0 * X) + (b1 * X_prev);
            Y_prev2 <= Y_prev;
            Y_prev <= Y;
            X_prev <= X;
        end
    end
endmodule