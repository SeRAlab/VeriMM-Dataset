module IIR_Filter (
    input wire clk,
    input wire reset,
    input wire signed [15:0] x, // Input sample
    output reg signed [15:0] y  // Output sample
);
    // Coefficients for the 4th-order IIR filter
    parameter signed [15:0] a1 = 16'h0A00;
    parameter signed [15:0] a2 = 16'h0B00;
    parameter signed [15:0] a3 = 16'h0C00;
    parameter signed [15:0] a4 = 16'h0D00;
    parameter signed [15:0] b0 = 16'h0E00;
    parameter signed [15:0] b1 = 16'h0F00;
    parameter signed [15:0] b2 = 16'h1000;
    parameter signed [15:0] b3 = 16'h1100;
    parameter signed [15:0] b4 = 16'h1200;

    // Internal registers to hold previous inputs and outputs
    reg signed [15:0] x_reg [0:4]; // Delay line for input
    reg signed [15:0] y_reg [0:4]; // Delay line for output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0;
            x_reg[0] <= 0; x_reg[1] <= 0; x_reg[2] <= 0; x_reg[3] <= 0; x_reg[4] <= 0;
            y_reg[0] <= 0; y_reg[1] <= 0; y_reg[2] <= 0; y_reg[3] <= 0; y_reg[4] <= 0;
        end else begin
            // Shift input samples
            x_reg[4] <= x_reg[3];
            x_reg[3] <= x_reg[2];
            x_reg[2] <= x_reg[1];
            x_reg[1] <= x_reg[0];
            x_reg[0] <= x;

            // Shift output samples
            y_reg[4] <= y_reg[3];
            y_reg[3] <= y_reg[2];
            y_reg[2] <= y_reg[1];
            y_reg[1] <= y_reg[0];

            // IIR filter calculation
            y <= (b0 * x_reg[0] + b1 * x_reg[1] + b2 * x_reg[2] + b3 * x_reg[3] + b4 * x_reg[4]) >> 12; // Example scaling
            y <= y - (a1 * y_reg[1] + a2 * y_reg[2] + a3 * y_reg[3] + a4 * y_reg[4]) >> 12; // Example scaling
            y_reg[0] <= y;
        end
    end
endmodule