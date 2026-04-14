module top_module(
    input [7:0] D,
    input DIR,
    output [7:0] Q
);reg [7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8;

always @(*) begin
    stage1 = D;
    stage2 = stage1;
    stage3 = stage2;
    stage4 = stage3;
    stage5 = stage4;
    stage6 = stage5;
    stage7 = stage6;
    stage8 = stage7;
end

always @(posedge DIR) begin
    if (DIR == 0) begin
        stage1 <= stage2;
        stage2 <= stage3;
        stage3 <= stage4;
        stage4 <= stage5;
        stage5 <= stage6;
        stage6 <= stage7;
        stage7 <= stage8;
        stage8 <= stage1;
    end else begin
        stage8 <= stage7;
        stage7 <= stage6;
        stage6 <= stage5;
        stage5 <= stage4;
        stage4 <= stage3;
        stage3 <= stage2;
        stage2 <= stage1;
        stage1 <= stage8;
    end
end

assign Q = stage1;

endmodule