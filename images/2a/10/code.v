module adaptive_lms_filter (
    input clk,
    input reset,
    input [15:0] x,          // Input signal
    input [15:0] d,          // Desired signal
    output reg [15:0] y,     // Output signal
    output reg [15:0] error   // Error signal
);
    parameter N = 4;  // Number of taps
    parameter mu = 16'h0001;  // Step size
    reg [15:0] w [0:N-1];      // Weights
    reg [15:0] x_delay [0:N-1]; // Delayed input signals

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000;
                x_delay[i] <= 16'h0000;
            end
            y <= 16'h0000;
            error <= 16'h0000;
        end else begin
            // Shift the input samples
            for (i = N-1; i > 0; i = i - 1) begin
                x_delay[i] <= x_delay[i-1];
            end
            x_delay[0] <= x;

            // Calculate the output
            y <= 16'h0000;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (w[i] * x_delay[i]);
            end

            // Calculate the error
            error <= d - y;

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * error * x_delay[i]);
            end
        end
    end
endmodule