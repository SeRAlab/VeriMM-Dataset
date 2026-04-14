module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x, // input signal
    output reg signed [15:0] y // output signal
);
    parameter signed [15:0] b0 = 16'h0001;
    parameter signed [15:0] b1 = 16'h0002;
    parameter signed [15:0] b2 = 16'h0003;
    parameter signed [15:0] a1 = 16'h0004;
    parameter signed [15:0] a2 = 16'h0005;

    reg signed [15:0] x1, x2; // previous inputs
    reg signed [15:0] y1, y2; // previous outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 16'h0;
            x2 <= 16'h0;
            y1 <= 16'h0;
            y2 <= 16'h0;
            y <= 16'h0;
        end else begin
            y <= (b0 * x) + (b1 * x1) + (b2 * x2) - (a1 * y1) - (a2 * y2);
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule