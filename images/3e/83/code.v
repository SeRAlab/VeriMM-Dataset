module echo_cancellation(
    input clk,
    input rst,
    input signed [15:0] x_in,  // input signal
    input signed [15:0] d_in,  // desired signal (original signal)
    output reg signed [15:0] y_out // output signal
);
    parameter N = 5; // Number of taps
    reg signed [15:0] w [0:N-1]; // Coefficients
    reg signed [15:0] x [0:N-1]; // Delay line
    reg signed [15:0] error; // Error signal
    integer i;

    // Initialize coefficients
    initial begin
        for (i = 0; i < N; i = i + 1) begin
            w[i] = 16'h0; // start with zero coefficients
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 16'h0;
            error <= 16'h0;
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0;
            end
        end else begin
            // Shift delay line
            for (i = N-1; i > 0; i = i - 1) begin
                x[i] <= x[i-1];
            end
            x[0] <= x_in;

            // Calculate output
            y_out <= 16'h0;
            for (i = 0; i < N; i = i + 1) begin
                y_out <= y_out + (w[i] * x[i]);
            end
            
            // Calculate error
            error <= d_in - y_out;

            // Update coefficients (LMS algorithm)
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (error * x[i] >> 4); // mu = 1/16 for step size
            end
        end
    end
endmodule