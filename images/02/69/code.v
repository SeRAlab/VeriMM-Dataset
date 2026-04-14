module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x, // input sample
    output reg signed [15:0] y // output sample
);

    parameter signed [15:0] a1 = 16'sd1, a2 = 16'sd1, a3 = 16'sd1, a4 = 16'sd1; // feedback coefficients
    parameter signed [15:0] b0 = 16'sd1, b1 = 16'sd1, b2 = 16'sd1, b3 = 16'sd1, b4 = 16'sd1; // feedforward coefficients

    reg signed [15:0] x_delay [0:4]; // delay line for input samples
    reg signed [15:0] y_delay [0:4]; // delay line for output samples

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'sd0;
            x_delay[0] <= 16'sd0;
            x_delay[1] <= 16'sd0;
            x_delay[2] <= 16'sd0;
            x_delay[3] <= 16'sd0;
            x_delay[4] <= 16'sd0;
            y_delay[0] <= 16'sd0;
            y_delay[1] <= 16'sd0;
            y_delay[2] <= 16'sd0;
            y_delay[3] <= 16'sd0;
            y_delay[4] <= 16'sd0;
        end else begin
            // Shift input samples
            x_delay[4] <= x_delay[3];
            x_delay[3] <= x_delay[2];
            x_delay[2] <= x_delay[1];
            x_delay[1] <= x_delay[0];
            x_delay[0] <= x;

            // Shift output samples
            y_delay[4] <= y_delay[3];
            y_delay[3] <= y_delay[2];
            y_delay[2] <= y_delay[1];
            y_delay[1] <= y_delay[0];
            // IIR filter equation
            y <= (b0 * x_delay[0] + b1 * x_delay[1] + b2 * x_delay[2] + b3 * x_delay[3] + b4 * x_delay[4]
                  - a1 * y_delay[1] - a2 * y_delay[2] - a3 * y_delay[3] - a4 * y_delay[4]) >>> 15;
            y_delay[0] <= y;
        end
    end
endmodule