module pipelined_adder (
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    output reg [8:0] sum
);
    reg [7:0] stage1_a, stage1_b;
    reg [7:0] stage2_a, stage2_b;
    reg [7:0] stage3_a, stage3_b;
    reg [8:0] stage4_sum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_a <= 0;
            stage1_b <= 0;
            stage2_a <= 0;
            stage2_b <= 0;
            stage3_a <= 0;
            stage3_b <= 0;
            stage4_sum <= 0;
            sum <= 0;
        end else begin
            // Stage 1
            stage1_a <= a;
            stage1_b <= b;
            // Stage 2
            stage2_a <= stage1_a;
            stage2_b <= stage1_b;
            // Stage 3
            stage3_a <= stage2_a;
            stage3_b <= stage2_b;
            // Stage 4
            stage4_sum <= stage3_a + stage3_b;
            // Output
            sum <= stage4_sum;
        end
    end
endmodule