module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x_n,      // Current input sample
    output reg signed [15:0] y_n   // Current output sample
);
    // Filter coefficients
    parameter signed [15:0] a1 = 16'h0A00; // Example coefficient a1
    parameter signed [15:0] a2 = 16'h0800; // Example coefficient a2
    parameter signed [15:0] b0 = 16'h0B00; // Example coefficient b0
    parameter signed [15:0] b1 = 16'h0400; // Example coefficient b1
    parameter signed [15:0] b2 = 16'h0200; // Example coefficient b2

    reg signed [15:0] x_n_1, x_n_2; // Previous inputs
    reg signed [15:0] y_n_1, y_n_2; // Previous outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_n <= 16'h0000;
            x_n_1 <= 16'h0000;
            x_n_2 <= 16'h0000;
            y_n_1 <= 16'h0000;
            y_n_2 <= 16'h0000;
        end else begin
            // Shift previous inputs and outputs
            x_n_2 <= x_n_1;
            x_n_1 <= x_n;
            y_n_2 <= y_n_1;
            y_n_1 <= y_n;

            // IIR filter equation
            y_n <= (a1 * y_n_1 + a2 * y_n_2 + b0 * x_n + b1 * x_n_1 + b2 * x_n_2) >>> 10; // Right shift to adjust for fixed point
        end
    end
endmodule