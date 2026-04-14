module adaptive_lms_filter #(parameter N = 4, parameter STEP_SIZE = 8'b00000001) (
    input clk,
    input rst,
    input signed [15:0] x, // Input signal
    input signed [15:0] d, // Desired signal
    output reg signed [15:0] y // Output signal
);
    reg signed [15:0] w [0:N-1]; // Filter weights
    reg signed [15:0] error;
    integer i;

    // Initialize weights
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'b0;
            end
            y <= 16'b0;
        end else begin
            // Compute output
            y <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (w[i] * x);
            end

            // Compute error
            error <= d - y;

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (STEP_SIZE * error * x);
            end
        end
    end
endmodule