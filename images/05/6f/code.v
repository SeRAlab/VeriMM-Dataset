module adaptive_lms_filter (
    input clk,
    input reset,
    input signed [15:0] x,     // Input signal
    input signed [15:0] d,     // Desired signal
    output signed [15:0] y,    // Output signal
    output signed [15:0] e      // Error signal
);
    parameter N = 4; // Number of filter taps
    parameter mu = 16'h0001; // Step size (adaptation rate)
    
    reg signed [15:0] w [0:N-1]; // Filter coefficients
    reg signed [15:0] x_delay [0:N-1]; // Delayed input values
    reg signed [15:0] y_out; // Output signal
    reg signed [15:0] e_out; // Error signal

    integer i;

    // Initialize filter coefficients and delays
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000; // Initialize weights to zero
                x_delay[i] <= 16'h0000; // Initialize delays to zero
            end
            y_out <= 16'h0000; // Initialize output to zero
            e_out <= 16'h0000; // Initialize error to zero
        end else begin
            // Shift input values
            for (i = N-1; i > 0; i = i - 1) begin
                x_delay[i] <= x_delay[i-1];
            end
            x_delay[0] <= x; // New input value

            // Calculate output
            y_out = 16'h0000;
            for (i = 0; i < N; i = i + 1) begin
                y_out = y_out + (w[i] * x_delay[i]);
            end

            // Calculate error
            e_out = d - y_out;

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * e_out * x_delay[i]);
            end
        end
    end

    assign y = y_out;
    assign e = e_out;

endmodule