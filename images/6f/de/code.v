module top_module(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] max,
    output equal_flag
);reg [7:0] stage1_max;
reg stage1_equal_flag;
reg [7:0] stage2_max;
reg stage2_equal_flag;

always @(*) begin
    if (a > b) begin
        stage1_max = a;
        stage1_equal_flag = 0;
    end else if (a < b) begin
        stage1_max = b;
        stage1_equal_flag = 0;
    end else begin
        stage1_max = a;
        stage1_equal_flag = 1;
    end
end

always @(*) begin
    if (stage1_max > stage2_max) begin
        stage2_max = stage1_max;
        stage2_equal_flag = stage1_equal_flag;
    end else if (stage1_max < stage2_max) begin
        stage2_max = stage2_max;
        stage2_equal_flag = stage2_equal_flag;
    end else begin
        stage2_max = stage1_max;
        stage2_equal_flag = 1;
    end
end

assign max = stage2_max;
assign equal_flag = stage2_equal_flag;

endmodule