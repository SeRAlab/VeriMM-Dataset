module adaptive_lms_filter (
    input wire clk,
    input wire rst,
    input wire signed [15:0] x,         // input signal
    input wire signed [15:0] d,         // desired signal
    output reg signed [15:0] y          // output signal
);

    parameter N = 4;                    // number of taps
    parameter mu = 16'h0001;            // step size for weight adjustment

    reg signed [15:0] w [0:N-1];        // weights
    reg signed [15:0] x_delay [0:N-1];  // delayed input signals

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset weights and delayed inputs
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000;          // Initialize weights to zero
                x_delay[i] <= 16'h0000;    // Initialize delays to zero
            end
            y <= 16'h0000;                  // Reset output
        end else begin
            // Shift input samples
            for (i = N-1; i > 0; i = i - 1) begin
                x_delay[i] <= x_delay[i-1];
            end
            x_delay[0] <= x;                // New input sample

            // Calculate output
            y <= 16'h0000;                  // Initialize output
            for (i = 0; i < N; i = i + 1) begin
                y <= y + w[i] * x_delay[i]; // Multiply and sum
            end

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * (d - y) * x_delay[i]) >>> 8; // LMS weight update
            end
        end
    end
endmodule