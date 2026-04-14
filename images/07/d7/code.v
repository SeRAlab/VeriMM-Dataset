module adaptive_lms_filter (
    input clk,
    input rst,
    input [15:0] x,           // Input signal
    input [15:0] d,           // Desired output
    output reg [15:0] y,      // Filtered output
    output reg [15:0] w0,     // Weight 0
    output reg [15:0] w1,     // Weight 1
    output reg [15:0] w2      // Weight 2
);
    parameter mu = 16'h0002;  // Step size for LMS algorithm
    reg [15:0] x0, x1, x2;    // Delayed inputs
    reg [31:0] error;         // Error signal

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            w0 <= 0;
            w1 <= 0;
            w2 <= 0;
            x0 <= 0;
            x1 <= 0;
            x2 <= 0;
        end else begin
            // Shift input samples
            x0 <= x;
            x1 <= x0;
            x2 <= x1;
            
            // Compute output
            y <= (w0 * x0) + (w1 * x1) + (w2 * x2);

            // Calculate error
            error <= d - y;

            // Update weights
            w0 <= w0 + (mu * error * x0) >> 16;
            w1 <= w1 + (mu * error * x1) >> 16;
            w2 <= w2 + (mu * error * x2) >> 16;
        end
    end
endmodule