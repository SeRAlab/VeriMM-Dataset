module adaptive_lms_filter (
    input clk,
    input reset,
    input signed [15:0] x,         // Input signal
    input signed [15:0] d,         // Desired signal
    output reg signed [15:0] y,     // Output signal
    output reg signed [15:0] error   // Error signal
);
    parameter N = 4;                // Number of taps
    parameter mu = 16'h0001;        // Step size
    reg signed [15:0] w [0:N-1];     // Coefficients
    reg signed [15:0] x_delay [0:N-1]; // Delay line

    integer i;

    // Initialize coefficients
    initial begin
        for (i = 0; i < N; i = i + 1) begin
            w[i] = 16'h0000;          // Start with zero coefficients
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000;      // Reset coefficients
            end
            y <= 16'h0000;              // Reset output
            error <= 16'h0000;          // Reset error
        end else begin
            // Shift delay line
            x_delay[0] <= x;
            for (i = 1; i < N; i = i + 1) begin
                x_delay[i] <= x_delay[i-1];
            end

            // Compute output
            y <= 16'h0000;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (w[i] * x_delay[i]); // Output calculation
            end

            // Compute error
            error <= d - y;

            // Update coefficients
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * error * x_delay[i]); // LMS coefficient update
            end
        end
    end
endmodule