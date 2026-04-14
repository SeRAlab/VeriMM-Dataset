module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x_n,  // current input
    input signed [15:0] x_n_1,  // previous input
    output reg signed [15:0] y_n  // current output
);
    parameter signed [15:0] a1 = 16'h1A2B; // example coefficient
    parameter signed [15:0] a2 = 16'h1C2D; // example coefficient
    parameter signed [15:0] b1 = 16'h1E2F; // example coefficient
    parameter signed [15:0] b2 = 16'h2031; // example coefficient

    reg signed [15:0] y_n_1; // previous output
    reg signed [15:0] y_n_2; // output two cycles back

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_n <= 16'h0000;
            y_n_1 <= 16'h0000;
            y_n_2 <= 16'h0000;
        end else begin
            y_n <= (a1 * x_n + a2 * x_n_1 + b1 * y_n_1 + b2 * y_n_2) >>> 15; // scaling down
            y_n_2 <= y_n_1;
            y_n_1 <= y_n;
        end
    end
endmodule