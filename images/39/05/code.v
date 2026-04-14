module iir_filter (
    input clk,
    input reset,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);
    reg signed [15:0] y1, y2; // Previous outputs
    reg signed [15:0] b0 = 16'h0A; // Coefficient b0
    reg signed [15:0] b1 = 16'h05; // Coefficient b1
    reg signed [15:0] a1 = 16'h02;  // Coefficient a1

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y1 <= 16'h0000;
            y2 <= 16'h0000;
            y_out <= 16'h0000;
        end else begin
            y_out <= (b0 * x_in + b1 * y1 - a1 * y2) >>> 4; // Fixed point multiplication and shifting
            y2 <= y1;
            y1 <= y_out;
        end
    end
endmodule