module IIR_Filter (
    input wire clk,
    input wire reset,
    input wire signed [15:0] x_n,
    input wire signed [15:0] x_n1,
    output reg signed [15:0] y_n,
    output reg signed [15:0] y_n1
);
    parameter signed [15:0] b0 = 16'h7FFF; // Example coefficient
    parameter signed [15:0] b1 = 16'h7FFF; // Example coefficient
    parameter signed [15:0] a1 = 16'h8000; // Example coefficient
    parameter signed [15:0] a2 = 16'h8000; // Example coefficient

    reg signed [15:0] y_n2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y_n <= 16'h0000;
            y_n1 <= 16'h0000;
            y_n2 <= 16'h0000;
        end else begin
            y_n2 <= y_n1;
            y_n1 <= y_n;
            y_n <= (b0 * x_n + b1 * x_n1 - a1 * y_n1 - a2 * y_n2) >>> 15; // Adjust for fixed-point representation
        end
    end
endmodule