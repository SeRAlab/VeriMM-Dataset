module IIR_Filter (
    input clk,
    input rst,
    input en,
    input signed [15:0] x, // current input sample
    output reg signed [15:0] y // current output sample
);
    // Coefficients
    parameter signed [15:0] b0 = 16'h0A00; // feedforward coefficient
    parameter signed [15:0] b1 = 16'h0500; // feedforward coefficient
    parameter signed [15:0] a1 = 16'hF300; // feedback coefficient
    parameter signed [15:0] a2 = 16'hF800; // feedback coefficient

    // Delay elements
    reg signed [15:0] x_delay_1;
    reg signed [15:0] x_delay_2;
    reg signed [15:0] y_delay_1;
    reg signed [15:0] y_delay_2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            x_delay_1 <= 0;
            x_delay_2 <= 0;
            y_delay_1 <= 0;
            y_delay_2 <= 0;
        end else if (en) begin
            // IIR filter equation
            y <= (b0 * x + b1 * x_delay_1 + a1 * y_delay_1 + a2 * y_delay_2) >>> 12;

            // Update delays
            x_delay_2 <= x_delay_1;
            x_delay_1 <= x;
            y_delay_2 <= y_delay_1;
            y_delay_1 <= y;
        end
    end
endmodule