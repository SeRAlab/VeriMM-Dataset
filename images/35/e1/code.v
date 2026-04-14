module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x, // input
    output reg signed [15:0] y // output
);
    parameter signed [15:0] a1 = 16'h0001; // example coefficient
    parameter signed [15:0] a2 = 16'h0002; // example coefficient
    parameter signed [15:0] b0 = 16'h0001; // example coefficient
    parameter signed [15:0] b1 = 16'h0001; // example coefficient

    reg signed [15:0] y_prev1, y_prev2;
    reg signed [15:0] x_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            y_prev1 <= 16'h0000;
            y_prev2 <= 16'h0000;
            x_prev <= 16'h0000;
        end else begin
            y <= (a1 * y_prev1) + (a2 * y_prev2) + (b0 * x) + (b1 * x_prev);
            y_prev2 <= y_prev1;
            y_prev1 <= y;
            x_prev <= x;
        end
    end
endmodule