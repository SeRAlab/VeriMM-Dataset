module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x_in, // Input sample
    output reg signed [15:0] y_out // Output sample
);
    parameter signed [15:0] b0 = 16'h1A; // Coefficient b0
    parameter signed [15:0] b1 = 16'h2B; // Coefficient b1
    parameter signed [15:0] b2 = 16'h3C; // Coefficient b2
    parameter signed [15:0] a1 = 16'h4D; // Coefficient a1
    parameter signed [15:0] a2 = 16'h5E; // Coefficient a2

    reg signed [15:0] x1, x2; // Previous inputs
    reg signed [15:0] y1, y2; // Previous outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 16'd0;
            x2 <= 16'd0;
            y1 <= 16'd0;
            y2 <= 16'd0;
            y_out <= 16'd0;
        end else begin
            // IIR filter formula
            y_out <= (b0 * x_in + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >> 15; // Right shift for scaling
            // Update previous inputs and outputs
            x2 <= x1;
            x1 <= x_in;
            y2 <= y1;
            y1 <= y_out;
        end
    end
endmodule