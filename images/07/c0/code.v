module adaptive_lms_filter (
    input clk,
    input reset,
    input signed [15:0] x,        // Input signal
    input signed [15:0] d,        // Desired signal
    input signed [15:0] step_size, // Step size for coefficient update
    output signed [15:0] y        // Output signal
);
    parameter N = 5; // Number of filter taps
    reg signed [15:0] w[N-1:0];    // Filter coefficients
    reg signed [15:0] x_buf[N-1:0]; // Input buffer
    reg signed [15:0] error;        // Error signal
    integer i;

    assign y = w[0] * x_buf[0] + w[1] * x_buf[1] + w[2] * x_buf[2] + w[3] * x_buf[3] + w[4] * x_buf[4];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset coefficients
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'b0;
            end
        end else begin
            // Shift input buffer
            for (i = N-1; i > 0; i = i - 1) begin
                x_buf[i] <= x_buf[i-1];
            end
            x_buf[0] <= x; // New input
            
            error <= d - y; // Calculate error

            // Update coefficients
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (step_size * error * x_buf[i]) >> 15; // Coefficient update
            end
        end
    end
endmodule