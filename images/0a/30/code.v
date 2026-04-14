module IIR_Filter (
    input clk,
    input reset,
    input signed [15:0] x,
    output reg signed [15:0] y
);
    reg signed [15:0] x1, x2; // previous inputs
    reg signed [15:0] y1, y2; // previous outputs

    parameter signed [15:0] b0 = 16'd1;
    parameter signed [15:0] b1 = 16'd2;
    parameter signed [15:0] b2 = 16'd1;
    parameter signed [15:0] a1 = 16'd2;
    parameter signed [15:0] a2 = 16'd1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'd0;
            x1 <= 16'd0;
            x2 <= 16'd0;
            y1 <= 16'd0;
            y2 <= 16'd0;
        end else begin
            y <= b0*x + b1*x1 + b2*x2 - a1*y1 - a2*y2;
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule