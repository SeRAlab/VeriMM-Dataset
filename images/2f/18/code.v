module iir_filter (
    input clk,
    input reset,
    input [15:0] x, // input data
    output reg [15:0] y // output data
);
    reg [15:0] y1, y2; // previous outputs
    reg [15:0] b0 = 16'h1999; // 0.2 in fixed-point
    reg [15:0] b1 = 16'h4CCCC; // 0.3 in fixed-point
    reg [15:0] b2 = 16'h7FFF; // 0.5 in fixed-point
    reg [15:0] a1 = 16'h199A; // 0.4 in fixed-point
    reg [15:0] a2 = 16'h199B; // 0.6 in fixed-point

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 0;
            y1 <= 0;
            y2 <= 0;
        end else begin
            y <= (b0 * x + b1 * y1 + b2 * y2 - a1 * y1 - a2 * y2) >> 16; // Fixed-point division
            y2 <= y1;
            y1 <= y;
        end
    end
endmodule