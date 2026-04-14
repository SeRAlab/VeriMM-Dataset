module top_module(
    input signed [15:0] num1,
    input signed [15:0] num2,
    output reg out
);reg signed [15:0] stage1_num1, stage1_num2;
reg signed [15:0] stage2_num1, stage2_num2;
reg signed [15:0] stage3_num1, stage3_num2;

always @(num1, num2) begin
    stage1_num1 <= num1;
    stage1_num2 <= num2;
end

always @(stage1_num1, stage1_num2) begin
    stage2_num1 <= stage1_num1 - stage1_num2;
    stage2_num2 <= 0;
end

always @(stage2_num1, stage2_num2) begin
    stage3_num1 <= stage2_num1;
    stage3_num2 <= stage2_num2 - stage2_num1[15];
end

always @(stage3_num2) begin
    out <= ~stage3_num2[15];
end

endmodule