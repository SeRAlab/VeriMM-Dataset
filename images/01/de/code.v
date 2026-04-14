module LMS_Filter (
    input wire clk,
    input wire reset,
    input wire signed [15:0] x,      // Input signal
    input wire signed [15:0] d,      // Desired signal
    input wire signed [15:0] mu,      // Step size
    output reg signed [15:0] y,       // Filtered output
    output reg signed [15:0] w0,      // Weight 0
    output reg signed [15:0] w1       // Weight 1
);

reg signed [15:0] x_delayed; // Delayed input signal

always @(posedge clk or posedge reset) begin
    if (reset) begin
        w0 <= 16'sd0;
        w1 <= 16'sd0;
        y <= 16'sd0;
        x_delayed <= 16'sd0;
    end else begin
        y <= w0 * x + w1 * x_delayed; // Filter output
        x_delayed <= x; // Update delayed input
        // Update weights using LMS algorithm
        w0 <= w0 + (mu * (d - y) * x) >>> 15; // Adjust weight 0
        w1 <= w1 + (mu * (d - y) * x_delayed) >>> 15; // Adjust weight 1
    end
end

endmodule