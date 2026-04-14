module IIR_Filter (
    input clk,
    input reset,
    input signed [15:0] x,  // Input signal
    output reg signed [15:0] y  // Output signal
);
    // Coefficients (can be adjusted as needed)
    parameter signed [15:0] b0 = 16'h0A00; // Example coefficient
    parameter signed [15:0] b1 = 16'h0B00; // Example coefficient
    parameter signed [15:0] b2 = 16'h0C00; // Example coefficient
    parameter signed [15:0] a1 = 16'hF100; // Example coefficient
    parameter signed [15:0] a2 = 16'hE200; // Example coefficient

    reg signed [15:0] x_1, x_2; // Previous inputs
    reg signed [15:0] y_1, y_2; // Previous outputs

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'b0;
            x_1 <= 16'b0;
            x_2 <= 16'b0;
            y_1 <= 16'b0;
            y_2 <= 16'b0;
        end else begin
            y <= (b0 * x + b1 * x_1 + b2 * x_2 - a1 * y_1 - a2 * y_2) >>> 15; // Right shift for scaling
            x_2 <= x_1;
            x_1 <= x;
            y_2 <= y_1;
            y_1 <= y;
        end
    end
endmodule