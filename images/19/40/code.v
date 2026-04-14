module iir_filter (
    input wire clk,
    input wire rst,
    input wire signed [15:0] x, // Input signal
    output reg signed [15:0] y // Output signal
);
    parameter signed [15:0] a = 16'h0001; // Coefficient a
    parameter signed [15:0] b = 16'h0001; // Coefficient b

    reg signed [15:0] y_prev; // Previous output

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            y_prev <= 16'h0000;
        end else begin
            y <= (a * x + b * y_prev) >>> 1; // Shift right by 1 to normalize
            y_prev <= y;
        end
    end
endmodule