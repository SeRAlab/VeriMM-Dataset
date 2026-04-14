module adaptive_lms_filter(
    input wire clk,
    input wire reset,
    input wire signed [15:0] x,        // Input signal
    input wire signed [15:0] d,        // Desired signal
    output reg signed [15:0] y,        // Output signal
    output reg signed [15:0] error      // Error signal
);
    parameter N = 4;                    // Number of filter taps
    parameter mu = 16'h0001;            // Step size for LMS
    reg signed [15:0] w [0:N-1];        // Coefficients
    reg signed [15:0] x_reg [0:N-1];    // Delay line
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize coefficients and delay line
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000;
                x_reg[i] <= 16'h0000;
            end
            y <= 16'h0000;
            error <= 16'h0000;
        end else begin
            // Shift input signal into delay line
            for (i = N-1; i > 0; i = i - 1) begin
                x_reg[i] <= x_reg[i-1];
            end
            x_reg[0] <= x;

            // Compute output signal
            y <= 16'h0000;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (w[i] * x_reg[i]);
            end

            // Compute error signal
            error <= d - y;

            // Update coefficients
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * error * x_reg[i]);
            end
        end
    end
endmodule