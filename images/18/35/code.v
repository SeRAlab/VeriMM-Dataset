module iir_filter (
    input clk,
    input rst,
    input [15:0] x, // Input signal
    output reg [15:0] y // Output signal
);
    // Filter coefficients (can be adjusted)
    parameter [15:0] a1 = 16'h1FFF; // Coefficient for previous output
    parameter [15:0] a2 = 16'h1FFF; // Coefficient for second previous output
    parameter [15:0] b0 = 16'h1FFF; // Coefficient for current input
    parameter [15:0] b1 = 16'h1FFF; // Coefficient for previous input

    reg [15:0] y_prev1, y_prev2; // Previous output values
    reg [15:0] x_prev; // Previous input value

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'b0;
            y_prev1 <= 16'b0;
            y_prev2 <= 16'b0;
            x_prev <= 16'b0;
        end else begin
            // IIR filter equation
            y <= (b0 * x) + (b1 * x_prev) - (a1 * y_prev1) - (a2 * y_prev2);
            // Update previous values
            y_prev2 <= y_prev1;
            y_prev1 <= y;
            x_prev <= x;
        end
    end
endmodule