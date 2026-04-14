module adaptive_lms_filter (
    input clk,
    input reset,
    input [15:0] x,     // Input signal
    input [15:0] d,     // Desired output signal
    output reg [15:0] y, // Filtered output
    output reg [15:0] w0, // Weight 0
    output reg [15:0] w1  // Weight 1
);
    parameter STEP_SIZE = 16'h0001; // Step size for weight update

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w0 <= 16'h0000;
            w1 <= 16'h0000;
            y <= 16'h0000;
        end else begin
            // Calculate output
            y <= (w0 * x) + (w1 * d);
            // Update weights
            w0 <= w0 + (STEP_SIZE * (d - y) * x);
            w1 <= w1 + (STEP_SIZE * (d - y) * d);
        end
    end
endmodule