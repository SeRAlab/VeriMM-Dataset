module iir_filter(
    input clk,
    input reset,
    input signed [15:0] x,
    output reg signed [15:0] y_out
);

parameter signed [15:0] b0 = 16'h0001;
parameter signed [15:0] b1 = 16'h0001;
parameter signed [15:0] b2 = 16'h0001;
parameter signed [15:0] a1 = 16'h0001;
parameter signed [15:0] a2 = 16'h0001;

reg signed [15:0] y_prev1;
reg signed [15:0] y_prev2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        y_out <= 16'h0000;
        y_prev1 <= 16'h0000;
        y_prev2 <= 16'h0000;
    end else begin
        y_out <= b0 * x + b1 * y_prev1 + b2 * y_prev2 - a1 * y_out - a2 * y_prev2;
        y_prev2 <= y_prev1;
        y_prev1 <= y_out;
    end
end
endmodule