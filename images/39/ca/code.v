module IIR_Filter (
    input wire clk,
    input wire reset,
    input wire signed [15:0] x_in,  // Input signal
    output reg signed [15:0] y_out   // Output signal
);
    // Coefficients for the IIR filter
    parameter signed [15:0] b0 = 16'h1FFF; // b0 coefficient
    parameter signed [15:0] b1 = 16'h1FFF; // b1 coefficient
    parameter signed [15:0] b2 = 16'h1FFF; // b2 coefficient
    parameter signed [15:0] a1 = 16'h1FFF; // a1 coefficient
    parameter signed [15:0] a2 = 16'h1FFF; // a2 coefficient

    reg signed [15:0] x1, x2; // Previous input values
    reg signed [15:0] y1, y2; // Previous output values

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
            y_out <= 0;
        end else begin
            // Compute the output
            y_out <= (b0 * x_in + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >>> 15; // Scale down
            // Update the delay elements
            x2 <= x1;
            x1 <= x_in;
            y2 <= y1;
            y1 <= y_out;
        end
    end
endmodule