module adaptive_lms(
    input wire clk,
    input wire rst,
    input wire [15:0] x,      // Input signal
    input wire [15:0] d,      // Desired signal
    output reg [15:0] y,      // Filtered output signal
    output reg [15:0] w0,     // Weight 0
    output reg [15:0] w1      // Weight 1
);

    parameter mu = 16'h0001;  // Step size (adjust as needed)
    reg [15:0] y_temp;         // Temporary output signal
    reg [15:0] error;          // Error signal

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w0 <= 16'h0000;
            w1 <= 16'h0000;
            y <= 16'h0000;
        end else begin
            // Calculate filter output
            y_temp <= (w0 * x) + (w1 * x); // Simple two-tap filter
            y <= y_temp;

            // Calculate error
            error <= d - y_temp;

            // Update weights
            w0 <= w0 + (mu * error * x);
            w1 <= w1 + (mu * error * x);
        end
    end
endmodule