module adaptive_lms_filter (
    input clk,
    input rst,
    input signed [15:0] x,      // Input signal
    input signed [15:0] d,      // Desired signal
    output reg signed [15:0] y   // Output signal
);
    parameter N = 5;            // Number of taps
    parameter mu = 16'sd1;      // Step size
    reg signed [15:0] w [0:N-1]; // Coefficients
    reg signed [15:0] x_buf [0:N-1]; // Input buffer
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'sd0; // Initialize weights
                x_buf[i] <= 16'sd0; // Initialize buffer
            end
            y <= 16'sd0; // Initialize output
        end else begin
            // Shift input buffer
            for (i = N-1; i > 0; i = i - 1) begin
                x_buf[i] <= x_buf[i-1];
            end
            x_buf[0] <= x; // New input

            // Calculate output
            y <= 16'sd0;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (w[i] * x_buf[i]); // Filter output
            end

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * (d - y) * x_buf[i]); // LMS update
            end
        end
    end
endmodule