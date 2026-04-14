module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);
    // Coefficients
    parameter signed [15:0] b0 = 16'h3333; // 0.2 in Q15 format
    parameter signed [15:0] b1 = 16'h4CCC; // 0.3 in Q15 format
    parameter signed [15:0] b2 = 16'h7FFF; // 0.5 in Q15 format
    parameter signed [15:0] a1 = -16'h6666; // -0.4 in Q15 format
    parameter signed [15:0] a2 = 16'h199A; // 0.1 in Q15 format
    
    reg signed [15:0] x1, x2; // Delayed input samples
    reg signed [15:0] y1, y2; // Delayed output samples
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
            y_out <= 0;
        end else begin
            // IIR Filter calculation:
            y_out <= (b0 * x_in + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 15;
            // Update delays
            x2 <= x1;
            x1 <= x_in;
            y2 <= y1;
            y1 <= y_out;
        end
    end
endmodule