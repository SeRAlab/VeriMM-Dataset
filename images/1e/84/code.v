module iir_filter(
    input clk,
    input reset,
    input signed [15:0] x_in,      // Input signal
    output reg signed [15:0] y_out  // Output signal
);
    // Coefficients for the 2nd-order IIR filter
    parameter signed [15:0] b0 = 16'h0001; // Feedforward coefficient
    parameter signed [15:0] b1 = 16'h0002; // Feedforward coefficient
    parameter signed [15:0] b2 = 16'h0001; // Feedforward coefficient
    parameter signed [15:0] a1 = 16'hFFFF; // Feedback coefficient
    parameter signed [15:0] a2 = 16'hFFFE; // Feedback coefficient

    // Internal registers to hold state
    reg signed [15:0] x_1, x_2;  // Previous inputs
    reg signed [15:0] y_1, y_2;  // Previous outputs

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_1 <= 16'h0000;
            x_2 <= 16'h0000;
            y_1 <= 16'h0000;
            y_2 <= 16'h0000;
            y_out <= 16'h0000;
        end else begin
            // IIR filter calculation
            y_out <= b0 * x_in + b1 * x_1 + b2 * x_2 - a1 * y_1 - a2 * y_2;

            // Update previous values
            x_2 <= x_1;
            x_1 <= x_in;
            y_2 <= y_1;
            y_1 <= y_out;
        end
    end
endmodule