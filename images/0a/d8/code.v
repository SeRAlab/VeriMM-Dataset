module iir_filter (
    input clk,
    input rst,
    input signed [15:0] x, // Input signal
    output reg signed [15:0] y // Output signal
);
    parameter signed [15:0] b0 = 16'h0A; // Example coefficient
    parameter signed [15:0] b1 = 16'h14; // Example coefficient
    parameter signed [15:0] b2 = 16'h1E; // Example coefficient
    parameter signed [15:0] a1 = 16'h0C; // Example coefficient
    parameter signed [15:0] a2 = 16'h05; // Example coefficient

    reg signed [15:0] y_1, y_2; // Outputs from previous cycles

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            y_1 <= 16'h0000;
            y_2 <= 16'h0000;
        end else begin
            y <= b0 * x + b1 * y_1 + b2 * y_2 - a1 * y_1 - a2 * y_2;
            y_2 <= y_1;
            y_1 <= y;
        end
    end
endmodule