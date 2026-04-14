module butterworth_filter (
    input [15:0] x,          // Input signal
    output reg [15:0] y      // Output filtered signal
);
    parameter [15:0] b0 = 16'h0C3F; // Coefficients of the Butterworth filter
    parameter [15:0] b1 = 16'h0C3F;
    parameter [15:0] b2 = 16'h0C3F;
    parameter [15:0] b3 = 16'h0C3F;
    parameter [15:0] b4 = 16'h0C3F;
    parameter [15:0] b5 = 16'h0C3F;

    reg [15:0] x_delay [0:4]; // Delay line for input samples
    reg [15:0] y_delay [0:4]; // Delay line for output samples

    integer i;

    always @(*) begin
        // Shift delay lines
        for (i = 4; i > 0; i = i - 1) begin
            x_delay[i] = x_delay[i - 1];
            y_delay[i] = y_delay[i - 1];
        end
        x_delay[0] = x;

        // Implementing the filter equation: y[n] = b0*x[n] + b1*x[n-1] + ... - (a1*y[n-1] + a2*y[n-2] + ...)
        y = (b0 * x_delay[0] + b1 * x_delay[1] + b2 * x_delay[2] + b3 * x_delay[3] + b4 * x_delay[4]) >> 5; // Shift for scaling
    end
endmodule