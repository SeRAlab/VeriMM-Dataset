module IIR_Filter (
    input clk,
    input reset,
    input [3:0] x, // 4-bit input
    output reg [3:0] y // 4-bit output
);
    reg [3:0] y_prev; // Previous output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 4'b0000;
            y_prev <= 4'b0000;
        end else begin
            y <= (x >> 1) + (y_prev >> 2); // y[n] = 0.5 * x[n] + 0.25 * y[n-1]
            y_prev <= y; // Update previous output
        end
    end
endmodule