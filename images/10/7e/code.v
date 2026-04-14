module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x, // input signal
    output reg signed [15:0] y // output signal
);
    parameter signed [15:0] b0 = 16'h1A6C; // Example coefficient
    parameter signed [15:0] b1 = 16'h1A6C; // Example coefficient
    parameter signed [15:0] b2 = 16'h1A6C; // Example coefficient
    parameter signed [15:0] a1 = 16'hE5A6; // Example coefficient
    parameter signed [15:0] a2 = 16'h7C9A; // Example coefficient

    reg signed [15:0] y_1, y_2; // previous output samples
    reg signed [15:0] x_1, x_2; // previous input samples

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            y_1 <= 16'h0000;
            y_2 <= 16'h0000;
            x_1 <= 16'h0000;
            x_2 <= 16'h0000;
        end else begin
            y <= b0 * x + b1 * x_1 + b2 * x_2 - a1 * y_1 - a2 * y_2;
            x_2 <= x_1;
            x_1 <= x;
            y_2 <= y_1;
            y_1 <= y;
        end
    end
endmodule