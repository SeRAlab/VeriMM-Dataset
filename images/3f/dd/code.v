module IIR_Filter(
    input clk,
    input rst,
    input signed [15:0] x, // Input signal
    output reg signed [15:0] y // Output signal
);
    parameter signed [15:0] a1 = 16'h0C00; // Feedback coefficient 1
    parameter signed [15:0] a2 = 16'h0800; // Feedback coefficient 2
    parameter signed [15:0] b0 = 16'h1A00; // Feedforward coefficient 0
    parameter signed [15:0] b1 = 16'h1C00; // Feedforward coefficient 1

    reg signed [15:0] z1, z2; // State variables

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z1 <= 16'h0000;
            z2 <= 16'h0000;
            y <= 16'h0000;
        end else begin
            y <= (b0 * x + b1 * z1 + z2) >>> 10; // Output calculation
            // Update state variables
            z2 <= z1;
            z1 <= (a1 * y + a2 * z2) >>> 10; // Feedback calculation
        end
    end
endmodule