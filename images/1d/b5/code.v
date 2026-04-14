module iir_filter (
    input clk,
    input reset,
    input [15:0] x,
    output reg [15:0] z
);
    parameter a0 = 16'h0001;
    parameter a1 = 16'h0002;
    parameter a2 = 16'h0003;
    parameter b1 = 16'h0004;
    parameter b2 = 16'h0005;

    reg [15:0] x_prev1, x_prev2;
    reg [15:0] z_prev1, z_prev2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            z <= 16'h0000;
            x_prev1 <= 16'h0000;
            x_prev2 <= 16'h0000;
            z_prev1 <= 16'h0000;
            z_prev2 <= 16'h0000;
        end else begin
            z <= a0 * x + a1 * x_prev1 + a2 * x_prev2 - b1 * z_prev1 - b2 * z_prev2;
            x_prev2 <= x_prev1;
            x_prev1 <= x;
            z_prev2 <= z_prev1;
            z_prev1 <= z;
        end
    end
endmodule