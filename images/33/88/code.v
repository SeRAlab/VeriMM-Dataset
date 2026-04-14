module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x,  // Input signal
    output reg signed [15:0] y // Output signal
);
    // Coefficients (example values)
    parameter signed [15:0] b0 = 16'h0A00; // 0.625 in Q15 format
    parameter signed [15:0] b1 = 16'h0A00; // 0.625 in Q15 format
    parameter signed [15:0] b2 = 16'h0400; // 0.25 in Q15 format
    parameter signed [15:0] a1 = 16'hF800; // -0.875 in Q15 format
    parameter signed [15:0] a2 = 16'hF300; // -0.8125 in Q15 format
    
    reg signed [15:0] y1, y2; // Previous outputs
    reg signed [15:0] x1, x2; // Previous inputs
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'd0;
            y1 <= 16'd0;
            y2 <= 16'd0;
            x1 <= 16'd0;
            x2 <= 16'd0;
        end else begin
            y <= b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
            // Update previous inputs and outputs
            x2 <= x1;
            x1 <= x;
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule