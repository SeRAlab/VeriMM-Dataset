module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);
    // Filter coefficients
    parameter signed [15:0] b0 = 16'h1F; // Example coefficients
    parameter signed [15:0] b1 = 16'h1E;
    parameter signed [15:0] b2 = 16'h1D;
    parameter signed [15:0] a1 = 16'h1C;
    parameter signed [15:0] a2 = 16'h1B;
    
    reg signed [15:0] x_1, x_2; // Delayed inputs
    reg signed [15:0] y_1, y_2; // Delayed outputs
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 16'b0;
            x_1 <= 16'b0;
            x_2 <= 16'b0;
            y_1 <= 16'b0;
            y_2 <= 16'b0;
        end else begin
            // Shift the input samples and output samples
            x_2 <= x_1;
            x_1 <= x_in;
            y_2 <= y_1;
            y_1 <= y_out;

            // IIR filter equation
            y_out <= (b0 * x_in + b1 * x_1 + b2 * x_2 - a1 * y_1 - a2 * y_2) >>> 15; // Right shift for scaling
        end
    end
endmodule