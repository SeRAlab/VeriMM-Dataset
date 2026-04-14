module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x, // Input signal
    output reg signed [15:0] y // Output signal
);
    // IIR filter coefficients (example values)
    parameter signed [15:0] b0 = 16'h1F00; // Feedforward coefficient
    parameter signed [15:0] b1 = 16'h1D00;
    parameter signed [15:0] b2 = 16'h1B00;
    parameter signed [15:0] b3 = 16'h1900;
    parameter signed [15:0] b4 = 16'h1700;
    parameter signed [15:0] a1 = 16'h0F00; // Feedback coefficient
    parameter signed [15:0] a2 = 16'h0D00;
    parameter signed [15:0] a3 = 16'h0B00;
    parameter signed [15:0] a4 = 16'h0900;
    
    reg signed [15:0] x_delay [0:4]; // Input delay line
    reg signed [15:0] y_delay [0:4]; // Output delay line

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            x_delay[0] <= 0;
            x_delay[1] <= 0;
            x_delay[2] <= 0;
            x_delay[3] <= 0;
            x_delay[4] <= 0;
            y_delay[0] <= 0;
            y_delay[1] <= 0;
            y_delay[2] <= 0;
            y_delay[3] <= 0;
            y_delay[4] <= 0;
        end else begin
            // Shift delay lines
            x_delay[4] <= x_delay[3];
            x_delay[3] <= x_delay[2];
            x_delay[2] <= x_delay[1];
            x_delay[1] <= x_delay[0];
            x_delay[0] <= x;

            y_delay[4] <= y_delay[3];
            y_delay[3] <= y_delay[2];
            y_delay[2] <= y_delay[1];
            y_delay[1] <= y_delay[0];
            y_delay[0] <= y;

            // IIR filter equation
            y <= (b0 * x_delay[0] + b1 * x_delay[1] + b2 * x_delay[2] + b3 * x_delay[3] + b4 * x_delay[4]
                - a1 * y_delay[1] - a2 * y_delay[2] - a3 * y_delay[3] - a4 * y_delay[4]) >>> 15; // Scaling
        end
    end
endmodule