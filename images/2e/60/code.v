module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x,      // Input signal
    input signed [15:0] b0,     // Feedforward coefficient
    input signed [15:0] b1,     // Feedforward coefficient
    input signed [15:0] b2,     // Feedforward coefficient
    input signed [15:0] a1,     // Feedback coefficient
    input signed [15:0] a2,     // Feedback coefficient
    output reg signed [15:0] y   // Output signal
);
    reg signed [15:0] x1, x2;   // Previous inputs
    reg signed [15:0] y1, y2;   // Previous outputs

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
            y <= 0;
        end else begin
            // Direct Form II implementation
            y <= b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
            // Shift registers
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule