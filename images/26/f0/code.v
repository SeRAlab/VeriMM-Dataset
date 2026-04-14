module IIR_Filter (
    input clk,
    input rst,
    input signed [15:0] x,  // Input signal
    output reg signed [15:0] y // Output signal
);
    // Coefficients (for example purposes, these can be changed)
    parameter signed [15:0] b0 = 16'h0A00, b1 = 16'h1400, b2 = 16'h0A00; // feedforward coefficients
    parameter signed [15:0] a1 = 16'hE000, a2 = 16'h0C00, a3 = 16'hE000; // feedback coefficients

    reg signed [15:0] x_reg [0:4]; // previous inputs
    reg signed [15:0] y_reg [0:3]; // previous outputs

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 0;
            for (i = 0; i < 5; i = i + 1) begin
                x_reg[i] <= 0;
            end
            for (i = 0; i < 4; i = i + 1) begin
                y_reg[i] <= 0;
            end
        end else begin
            // Shift registers
            x_reg[0] <= x;
            for (i = 1; i < 5; i = i + 1) begin
                x_reg[i] <= x_reg[i-1];
            end
            for (i = 1; i < 4; i = i + 1) begin
                y_reg[i] <= y_reg[i-1];
            end
            
            // Calculate y
            y <= (b0 * x_reg[0] + b1 * x_reg[1] + b2 * x_reg[2]
                  - a1 * y_reg[1] - a2 * y_reg[2] - a3 * y_reg[3]) >>> 14; // Shift right for scaling
        end
    end
endmodule