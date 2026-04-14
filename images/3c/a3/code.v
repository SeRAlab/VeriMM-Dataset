module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x, // Input sample
    output reg signed [15:0] y // Output sample
);
    // Coefficients for the IIR filter
    parameter signed [15:0] b0 = 16'h0001; // Feedforward coefficient
    parameter signed [15:0] b1 = 16'h0002; // Feedforward coefficient
    parameter signed [15:0] a1 = 16'h0001; // Feedback coefficient
    reg signed [15:0] x_delay1, y_delay1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            x_delay1 <= 16'h0000;
            y_delay1 <= 16'h0000;
        end else begin
            y <= b0 * x + b1 * x_delay1 - a1 * y_delay1;
            x_delay1 <= x;
            y_delay1 <= y;
        end
    end
endmodule