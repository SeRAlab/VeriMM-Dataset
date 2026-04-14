module iir_filter (
    input clk,
    input rst,
    input [15:0] x, // Input signal
    output reg [15:0] y // Output signal
);
    reg [15:0] a1, b0, b1; // Coefficients
    reg [15:0] x1, y1; // Delayed signals

    // Initialize coefficients
    initial begin
        a1 = 16'h1; // Feedback coefficient
        b0 = 16'h1; // Feedforward coefficient
        b1 = 16'h1; // Feedforward coefficient
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0;
            x1 <= 16'h0;
            y1 <= 16'h0;
        end else begin
            // IIR filter equation: y[n] = b0*x[n] + b1*x[n-1] - a1*y[n-1]
            y <= b0 * x + b1 * x1 - a1 * y1;
            x1 <= x; // Store current input for next cycle
            y1 <= y; // Store current output for next cycle
        end
    end
endmodule