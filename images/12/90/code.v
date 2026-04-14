module iir_filter(
    input clk,
    input rst,
    input signed [15:0] x,  // input sample
    output reg signed [15:0] y // output sample
);

    reg signed [15:0] x_prev1, x_prev2; // previous input samples
    reg signed [15:0] y_prev1, y_prev2; // previous output samples

    parameter signed [15:0] b0 = 16'h1FFF; // feedforward coefficient 0
    parameter signed [15:0] b1 = 16'h1FFF; // feedforward coefficient 1
    parameter signed [15:0] b2 = 16'h1FFF; // feedforward coefficient 2
    parameter signed [15:0] a1 = 16'h1FFF; // feedback coefficient 1
    parameter signed [15:0] a2 = 16'h1FFF; // feedback coefficient 2

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'b0;
            x_prev1 <= 16'b0;
            x_prev2 <= 16'b0;
            y_prev1 <= 16'b0;
            y_prev2 <= 16'b0;
        end else begin
            y <= (b0 * x + b1 * x_prev1 + b2 * x_prev2 - a1 * y_prev1 - a2 * y_prev2) >>> 15;
            x_prev2 <= x_prev1;
            x_prev1 <= x;
            y_prev2 <= y_prev1;
            y_prev1 <= y;
        end
    end
endmodule