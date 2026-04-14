module lms_filter #(parameter N = 5, parameter mu = 8'h1A) (
    input clk,
    input rst,
    input [15:0] x,            // Input signal
    input [15:0] d,            // Desired signal
    output reg [15:0] y        // Output signal
);
    reg [15:0] w [0:N-1];      // Coefficients
    reg [15:0] x_buffer [0:N-1]; // Input buffer
    integer i;

    // Initialize weights
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000; // Initialize weights to zero
            end
        end else begin
            // Shift input buffer
            for (i = N-1; i > 0; i = i - 1) begin
                x_buffer[i] <= x_buffer[i-1];
            end
            x_buffer[0] <= x; // New input

            // Compute output
            y <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (w[i] * x_buffer[i]);
            end

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * (d - y) * x_buffer[i]);
            end
        end
    end
endmodule