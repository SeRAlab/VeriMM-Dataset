module IIR_Filter (
    input clk,
    input reset,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);

    // Coefficients (example values)
    parameter signed [15:0] b0 = 16'h0001, b1 = 16'h0002, b2 = 16'h0003, b3 = 16'h0004, b4 = 16'h0005;
    parameter signed [15:0] a1 = 16'h0006, a2 = 16'h0007, a3 = 16'h0008, a4 = 16'h0009;

    reg signed [15:0] x [0:4]; // delay line for input
    reg signed [15:0] y [0:4]; // delay line for output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y_out <= 16'h0000;
            x[0] <= 16'h0000;
            x[1] <= 16'h0000;
            x[2] <= 16'h0000;
            x[3] <= 16'h0000;
            x[4] <= 16'h0000;
            y[0] <= 16'h0000;
            y[1] <= 16'h0000;
            y[2] <= 16'h0000;
            y[3] <= 16'h0000;
            y[4] <= 16'h0000;
        end else begin
            // Shift delay line
            x[4] <= x[3];
            x[3] <= x[2];
            x[2] <= x[1];
            x[1] <= x[0];
            x[0] <= x_in;

            y[4] <= y[3];
            y[3] <= y[2];
            y[2] <= y[1];
            y[1] <= y[0];

            // Calculate new output
            y_out <= (b0 * x[0] + b1 * x[1] + b2 * x[2] + b3 * x[3] + b4 * x[4]) >> 4; // Divide by 16 for scaling
            y[0] <= (y[1] * a1 + y[2] * a2 + y[3] * a3 + y[4] * a4) >> 4; // Divide by 16 for scaling
        end
    end
endmodule