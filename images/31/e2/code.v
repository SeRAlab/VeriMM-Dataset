module iir_filter (
    input clk,
    input signed [15:0] x, // Input signal (16 bits)
    output reg signed [15:0] y // Output signal (16 bits)
);
    // Filter coefficients
    parameter signed [15:0] b0 = 16'h1FFF; // b0 coefficient
    parameter signed [15:0] b1 = 16'h1FFF; // b1 coefficient
    parameter signed [15:0] a1 = 16'h1FFF; // a1 coefficient
    parameter signed [15:0] a2 = 16'h1FFF; // a2 coefficient

    reg signed [15:0] y_prev1; // y[n-1]
    reg signed [15:0] y_prev2; // y[n-2]

    always @(posedge clk) begin
        // Compute output based on the difference equation
        y <= (b0 * x + b1 * y_prev1 - a1 * y_prev1 - a2 * y_prev2) >>> 15; // Right shift for scaling
        // Update previous values
        y_prev2 <= y_prev1;
        y_prev1 <= y;
    end
endmodule