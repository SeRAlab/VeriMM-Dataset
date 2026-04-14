module adaptive_lms_filter #(
    parameter N = 5, // Number of taps
    parameter DATA_WIDTH = 8,
    parameter COEF_WIDTH = 8
) (
    input clk,
    input rst,
    input signed [DATA_WIDTH-1:0] x, // Input signal
    input signed [DATA_WIDTH-1:0] d, // Desired signal
    output reg signed [DATA_WIDTH-1:0] y // Output signal
);
    reg signed [COEF_WIDTH-1:0] coeffs [0:N-1]; // Coefficients
    reg signed [DATA_WIDTH-1:0] x_delayed [0:N-1]; // Delayed input signals
    reg signed [DATA_WIDTH-1:0] error; // Error signal
    reg signed [COEF_WIDTH-1:0] mu = 8'h02; // Step size

    integer i;

    // Initialize coefficients to zero
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                coeffs[i] <= 0;
            end
            y <= 0;
        end else begin
            // Shift input samples
            x_delayed[0] <= x;
            for (i = 1; i < N; i = i + 1) begin
                x_delayed[i] <= x_delayed[i-1];
            end

            // Compute output
            y <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (coeffs[i] * x_delayed[i]);
            end

            // Compute error
            error <= d - y;

            // Update coefficients
            for (i = 0; i < N; i = i + 1) begin
                coeffs[i] <= coeffs[i] + (mu * error * x_delayed[i]);
            end
        end
    end
endmodule