module IIR_Filter (
    input clk,
    input reset,
    input signed [15:0] x, // input sample
    output reg signed [15:0] y // output sample
);
    // Coefficients (16-bit signed integers)
    parameter signed [15:0] a1 = 16'h0001; // example coefficient
    parameter signed [15:0] a2 = 16'h0002; // example coefficient
    parameter signed [15:0] b0 = 16'h0004; // example coefficient
    parameter signed [15:0] b1 = 16'h0003; // example coefficient
    parameter signed [15:0] b2 = 16'h0001; // example coefficient

    reg signed [15:0] x_delay [0:2]; // Delayed input samples
    reg signed [15:0] y_delay [0:2]; // Delayed output samples

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'h0000;
            x_delay[0] <= 16'h0000;
            x_delay[1] <= 16'h0000;
            x_delay[2] <= 16'h0000;
            y_delay[0] <= 16'h0000;
            y_delay[1] <= 16'h0000;
            y_delay[2] <= 16'h0000;
        end else begin
            // Shift the samples
            x_delay[2] <= x_delay[1];
            x_delay[1] <= x_delay[0];
            x_delay[0] <= x;

            y_delay[2] <= y_delay[1];
            y_delay[1] <= y_delay[0];
            y_delay[0] <= y;

            // Calculate the output
            y <= a1 * y_delay[0] + a2 * y_delay[1] + b0 * x_delay[0] + b1 * x_delay[1] + b2 * x_delay[2];
        end
    end
endmodule