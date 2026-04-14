module IIR_Filter(
    input clk,
    input rst,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);

    // Coefficients for the 4th-order IIR filter
    parameter signed [15:0] b0 = 16'h1; // Feedforward coefficient
    parameter signed [15:0] b1 = 16'h1; // Feedforward coefficient
    parameter signed [15:0] b2 = 16'h1; // Feedforward coefficient
    parameter signed [15:0] b3 = 16'h1; // Feedforward coefficient
    parameter signed [15:0] a1 = 16'h1; // Feedback coefficient
    parameter signed [15:0] a2 = 16'h1; // Feedback coefficient
    parameter signed [15:0] a3 = 16'h1; // Feedback coefficient
    parameter signed [15:0] a4 = 16'h1; // Feedback coefficient

    reg signed [15:0] x [0:3]; // input history
    reg signed [15:0] y [0:3]; // output history

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_out <= 16'h0;
            x[0] <= 16'h0;
            x[1] <= 16'h0;
            x[2] <= 16'h0;
            x[3] <= 16'h0;
            y[0] <= 16'h0;
            y[1] <= 16'h0;
            y[2] <= 16'h0;
            y[3] <= 16'h0;
        end else begin
            // Shift the input and output history
            x[3] <= x[2];
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= x_in;

            y[3] <= y[2];
            y[2] <= y[1];
            y[1] <= y[0];

            // Calculate the output using the filter equation
            y_out <= (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] - 
                       a1 * y[1] - a2 * y[2] - a3 * y[3]) >>> 4; // Shift right for scaling
            y[0] <= y_out; // Store current output
        end
    end
endmodule