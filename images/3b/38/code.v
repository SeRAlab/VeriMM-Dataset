module adaptive_lms(
    input clk,
    input reset,
    input signed [15:0] x,  // Input signal
    input signed [15:0] d,  // Desired signal
    output reg signed [15:0] y // Filter output
);
    parameter N = 4; // Number of filter taps
    parameter signed [15:0] mu = 16'h0001; // Step size for adaptation

    reg signed [15:0] w [0:N-1]; // Filter coefficients
    reg signed [15:0] x_delayed [0:N-1]; // Delayed input signals

    integer i;

    // Initializing weights and delayed signals
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000; // Initialize weights to 0
                x_delayed[i] <= 16'h0000; // Initialize delayed signals to 0
            end
            y <= 16'h0000; // Initialize output
        end else begin
            // Shift delayed inputs
            for (i = N-1; i > 0; i = i - 1) begin
                x_delayed[i] <= x_delayed[i-1];
            end
            x_delayed[0] <= x;

            // Calculate filter output
            y <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + w[i] * x_delayed[i];
            end

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + mu * (d - y) * x_delayed[i];
            end
        end
    end
endmodule