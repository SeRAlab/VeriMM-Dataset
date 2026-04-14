module iir_filter(
    input clk,
    input rst,
    input signed [15:0] x, // Input signal
    output reg signed [15:0] y // Output signal
);
    parameter b0 = 16'h0A; // Coefficient for x[n]
    parameter b1 = 16'h0B; // Coefficient for x[n-1]
    parameter b2 = 16'h0C; // Coefficient for x[n-2]
    parameter a1 = 16'h0D; // Coefficient for y[n-1]
    parameter a2 = 16'h0E; // Coefficient for y[n-2]

    reg signed [15:0] x1, x2; // x[n-1], x[n-2]
    reg signed [15:0] y1, y2; // y[n-1], y[n-2]

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0;
            x1 <= 16'h0;
            x2 <= 16'h0;
            y1 <= 16'h0;
            y2 <= 16'h0;
        end else begin
            y <= (b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 16;
            // Update x and y history
            x2 <= x1; 
            x1 <= x; 
            y2 <= y1; 
            y1 <= y; 
        end
    end
endmodule