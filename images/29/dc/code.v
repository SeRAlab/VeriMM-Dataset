module adaptive_lms_filter(
    input clk,
    input reset,
    input [15:0] x,          // Input signal
    input [15:0] d,          // Desired signal
    output reg [15:0] y,     // Filtered output
    output reg [15:0] error, // Error signal
    output reg [15:0] coeff0, // Coefficient 0
    output reg [15:0] coeff1, // Coefficient 1
    output reg [15:0] coeff2, // Coefficient 2
    output reg [15:0] coeff3  // Coefficient 3
);
    parameter N = 4; // Number of taps
    parameter mu = 16'h0001; // Step size for adaptation
    reg [15:0] x_history [0:N-1]; // Input signal history
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0;
            error <= 0;
            coeff0 <= 0;
            coeff1 <= 0;
            coeff2 <= 0;
            coeff3 <= 0;
            for (i = 0; i < N; i = i + 1) begin
                x_history[i] <= 0;
            end
        end else begin
            // Shift input history
            for (i = N-1; i > 0; i = i - 1) begin
                x_history[i] <= x_history[i-1];
            end
            x_history[0] <= x; // New input sample

            // Compute output
            y <= (coeff0 * x_history[0]) + 
                  (coeff1 * x_history[1]) + 
                  (coeff2 * x_history[2]) + 
                  (coeff3 * x_history[3]);

            // Compute error
            error <= d - y;

            // Update coefficients
            coeff0 <= coeff0 + (mu * error * x_history[0]);
            coeff1 <= coeff1 + (mu * error * x_history[1]);
            coeff2 <= coeff2 + (mu * error * x_history[2]);
            coeff3 <= coeff3 + (mu * error * x_history[3]);
        end
    end
endmodule