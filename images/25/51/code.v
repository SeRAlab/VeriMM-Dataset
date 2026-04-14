module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x,      // Current input
    input signed [15:0] a,      // Feedback input
    output reg signed [15:0] y,  // Current output
    output reg signed [15:0] b   // Feedback output
);
    parameter signed [15:0] b0 = 16'd1;
    parameter signed [15:0] b1 = 16'd2;
    parameter signed [15:0] a1 = 16'd1;
    parameter signed [15:0] a2 = 16'd1;

    reg signed [15:0] y_prev1, y_prev2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'd0;
            b <= 16'd0;
            y_prev1 <= 16'd0;
            y_prev2 <= 16'd0;
        end else begin
            y <= (b0 * x) + (b1 * y_prev1) - (a1 * a) - (a2 * y_prev2);
            b <= a;  // Update feedback output
            y_prev2 <= y_prev1;  // Shift previous outputs
            y_prev1 <= y;
        end
    end
endmodule