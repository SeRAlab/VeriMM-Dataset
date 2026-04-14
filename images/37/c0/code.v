module IIR_Filter (
    input wire clk,
    input wire reset,
    input wire signed [15:0] x, // Input signal
    output reg signed [15:0] y // Output signal
);

    // Filter coefficients (example values)
    parameter signed [15:0] b0 = 16'h0A00; // Coefficient for x[n]
    parameter signed [15:0] b1 = 16'h0A00; // Coefficient for x[n-1]
    parameter signed [15:0] b2 = 16'h0A00; // Coefficient for x[n-2]
    parameter signed [15:0] a1 = 16'hF000; // Coefficient for y[n-1]
    parameter signed [15:0] a2 = 16'hE000; // Coefficient for y[n-2]

    reg signed [15:0] x1, x2; // Previous input samples
    reg signed [15:0] y1, y2; // Previous output samples

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0;
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
        end else begin
            // IIR filter equation
            y <= (b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 15; // right shift for fixed-point
            // Update previous samples
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule