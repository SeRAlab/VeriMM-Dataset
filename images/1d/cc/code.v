module adaptive_lms #(parameter N = 5) (
    input wire clk,
    input wire reset,
    input wire signed [15:0] x,   // Input signal
    input wire signed [15:0] d,   // Desired signal
    input wire signed [15:0] mu,   // Step size
    output reg signed [15:0] y     // Filtered signal output
);
    reg signed [15:0] w [0:N-1];   // Filter coefficients
    reg signed [15:0] e;            // Error signal
    integer i;

    // Initialize weights on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'b0;
            end
            y <= 16'b0;
        end else begin
            // Calculate output
            y <= 16'b0;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + w[i] * x;
            end
            
            // Calculate error
            e <= d - y;

            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * e * x) >>> 15; // Right shift to adjust for bit growth
            end
        end
    end
endmodule