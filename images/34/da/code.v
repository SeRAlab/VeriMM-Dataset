module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);
    // Coefficients for a 4th-order IIR filter (example values)
    parameter signed [15:0] b0 = 16'h1A2B;
    parameter signed [15:0] b1 = 16'h1A2B;
    parameter signed [15:0] b2 = 16'h1A2B;
    parameter signed [15:0] b3 = 16'h1A2B;
    parameter signed [15:0] a1 = 16'h1A2B;
    parameter signed [15:0] a2 = 16'h1A2B;
    parameter signed [15:0] a3 = 16'h1A2B;
    parameter signed [15:0] a4 = 16'h1A2B;

    reg signed [15:0] x [0:3]; // Input samples
    reg signed [15:0] y [0:3]; // Output samples

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 16'b0;
            x[0] <= 16'b0; x[1] <= 16'b0; x[2] <= 16'b0; x[3] <= 16'b0;
            y[0] <= 16'b0; y[1] <= 16'b0; y[2] <= 16'b0; y[3] <= 16'b0;
        end else begin
            // Shift input samples
            x[3] <= x[2]; x[2] <= x[1]; x[1] <= x[0]; x[0] <= x_in;
            // Shift output samples
            y[3] <= y[2]; y[2] <= y[1]; y[1] <= y[0];

            // Calculate new output
            y_out <= (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] - 
                       a1 * y[1] - a2 * y[2] - a3 * y[3]) >>> 15; // Adjust for fixed point
            y[0] <= y_out;
        end
    end
endmodule