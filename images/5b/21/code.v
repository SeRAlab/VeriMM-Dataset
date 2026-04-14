module top_module(
    input clk,
    input reset,
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] out
);reg [3:0] stage1_a, stage1_b;
reg [3:0] stage2_a, stage2_b;
reg [7:0] stage3_out;

always @(posedge clk) begin
    if (reset) begin
        stage1_a <= 0;
        stage1_b <= 0;
        stage2_a <= 0;
        stage2_b <= 0;
        stage3_out <= 0;
    end else begin
        stage1_a <= a;
        stage1_b <= b;
        stage2_a <= stage1_a << 1;
        stage2_b <= stage1_b >> 1;
        stage3_out <= (stage2_a + stage1_a) * (stage2_b + stage1_b);
        out <= stage3_out;
    end
end

endmodule