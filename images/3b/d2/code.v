module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x, // Input signal
    output reg signed [15:0] y // Output signal
);
    parameter signed [15:0] b0 = 16'h1FFF; // Example coefficient
    parameter signed [15:0] b1 = 16'h1FFF; // Example coefficient
    parameter signed [15:0] b2 = 16'h1FFF; // Example coefficient
    parameter signed [15:0] a1 = 16'hFFFF; // Example coefficient
    parameter signed [15:0] a2 = 16'h7FFF; // Example coefficient

    reg signed [15:0] x_prev1, x_prev2; // Previous inputs
    reg signed [15:0] y_prev1, y_prev2; // Previous outputs

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'h0;
            x_prev1 <= 16'h0;
            x_prev2 <= 16'h0;
            y_prev1 <= 16'h0;
            y_prev2 <= 16'h0;
        end else begin
            // Update the output based on the IIR equation
            y <= b0 * x + b1 * x_prev1 + b2 * x_prev2 
                 - a1 * y_prev1 - a2 * y_prev2;

            // Shift previous values
            x_prev2 <= x_prev1;
            x_prev1 <= x;
            y_prev2 <= y_prev1;
            y_prev1 <= y;
        end
    end
endmodule