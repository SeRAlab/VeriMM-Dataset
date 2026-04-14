module IIR_Filter #(parameter a1 = 1, b0 = 1, b1 = 1) (
    input clk,
    input rst,
    input signed [15:0] x, // Input signal
    output reg signed [15:0] y // Output signal
);
    reg signed [15:0] x_prev; // Previous input
    reg signed [15:0] y_prev; // Previous output

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'd0;
            x_prev <= 16'd0;
            y_prev <= 16'd0;
        end else begin
            y <= (a1 * y_prev) + (b0 * x) + (b1 * x_prev);
            x_prev <= x;
            y_prev <= y;
        end
    end
endmodule