module IIR_Filter (
    input wire clk,
    input wire reset,
    input wire [15:0] x,      // input sample
    output reg [15:0] y       // output sample
);
    // Filter coefficients (fixed point representation)
    parameter [15:0] b0 = 16'h2000; // Coefficient for x[n]
    parameter [15:0] b1 = 16'h1000; // Coefficient for x[n-1]
    parameter [15:0] b2 = 16'h0800; // Coefficient for x[n-2]
    parameter [15:0] a1 = 16'h3000; // Coefficient for y[n-1]
    parameter [15:0] a2 = 16'h1000; // Coefficient for y[n-2]

    reg [15:0] x1, x2; // Previous inputs
    reg [15:0] y1, y2; // Previous outputs

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset internal states
            x1 <= 16'h0000;
            x2 <= 16'h0000;
            y1 <= 16'h0000;
            y2 <= 16'h0000;
            y <= 16'h0000;
        end else begin
            // Update outputs based on the difference equation
            y <= (b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >> 14; // Scaling down
            // Update previous states
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule