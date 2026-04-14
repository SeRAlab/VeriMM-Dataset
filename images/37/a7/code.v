module iir_filter(
    input clk,
    input rst,
    input signed [15:0] x,      // input sample
    output reg signed [15:0] y   // output sample
);
    reg signed [15:0] z1, z2; // delay elements
    parameter signed [15:0] b0 = 16'h0A00; // coefficient for x[n]
    parameter signed [15:0] b1 = 16'h0A00; // coefficient for x[n-1]
    parameter signed [15:0] b2 = 16'h0A00; // coefficient for x[n-2]
    parameter signed [15:0] a1 = 16'hF000; // coefficient for y[n-1]
    parameter signed [15:0] a2 = 16'hF000; // coefficient for y[n-2]

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z1 <= 16'h0000;
            z2 <= 16'h0000;
            y <= 16'h0000;
        end else begin
            y <= (b0 * x + b1 * z1 + b2 * z2 - a1 * y - a2 * (y - z1)) >>> 15; // Fixed-point multiplication and shifting
            z2 <= z1;
            z1 <= x;
        end
    end
endmodule