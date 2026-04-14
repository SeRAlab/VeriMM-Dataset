module adaptive_lms_filter (
    input clk,
    input rst,
    input signed [15:0] x,          // Input signal
    input signed [15:0] d,          // Desired output signal
    output reg signed [15:0] y,      // Filtered output
    output reg signed [15:0] error    // Error signal
);
    parameter N = 4;                 // Number of filter taps
    parameter mu = 16'h0001;         // Step size for adaptation
    reg signed [15:0] w [0:N-1];     // Coefficients
    reg signed [15:0] x_delay [0:N-1]; // Delay line

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset coefficients and delay line
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000;
                x_delay[i] <= 16'h0000;
            end
            y <= 16'h0000;
            error <= 16'h0000;
        end else begin
            // Shift input samples in delay line
            for (i = N-1; i > 0; i = i - 1) begin
                x_delay[i] <= x_delay[i-1];
            end
            x_delay[0] <= x;

            // Compute output
            y <= 16'h0000;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (w[i] * x_delay[i]);
            end

            // Compute error
            error <= d - y;

            // Update coefficients
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * error * x_delay[i]);
            end
        end
    end
endmodule