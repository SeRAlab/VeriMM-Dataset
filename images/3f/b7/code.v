module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x,     // Current input sample
    output reg signed [15:0] y  // Current output sample
);
    reg signed [15:0] x1, x2;   // Previous input samples
    reg signed [15:0] y1, y2;    // Previous output samples

    // Filter coefficients
    parameter signed [15:0] b0 = 16'h0001; // Example coefficient
    parameter signed [15:0] b1 = 16'h0002; // Example coefficient
    parameter signed [15:0] b2 = 16'h0003; // Example coefficient
    parameter signed [15:0] a1 = 16'h0004; // Example coefficient
    parameter signed [15:0] a2 = 16'h0005; // Example coefficient

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'b0;
            x1 <= 16'b0;
            x2 <= 16'b0;
            y1 <= 16'b0;
            y2 <= 16'b0;
        end else begin
            y <= (b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 16;
            // Shift previous samples
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule