module adaptive_lms_filter (
    input clk,
    input reset,
    input signed [15:0] x,       // Input signal
    input signed [15:0] d,       // Desired signal
    input signed [15:0] mu,      // Step size
    output reg signed [15:0] y,   // Output signal (filtered)
    output reg signed [15:0] w0,  // Coefficient 0
    output reg signed [15:0] w1   // Coefficient 1
);

    reg signed [31:0] error;
    reg signed [31:0] x0, x1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0;
            w0 <= 0;
            w1 <= 0;
        end else begin
            // Shift the input for the filter
            x1 <= x0;
            x0 <= x;

            // Calculate the output
            y <= (w0 * x0 + w1 * x1) >> 16;

            // Calculate the error
            error <= d - y;

            // Update the coefficients
            w0 <= w0 + (mu * error * x0) >> 16;
            w1 <= w1 + (mu * error * x1) >> 16;
        end
    end
endmodule