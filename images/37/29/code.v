module pipeline_7_stage (
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 4'b0;
            stage2 <= 4'b0;
            stage3 <= 4'b0;
            stage4 <= 4'b0;
            stage5 <= 4'b0;
            stage6 <= 4'b0;
            stage7 <= 4'b0;
            data_out <= 4'b0;
        end else begin
            stage1 <= data_in;
            stage2 <= stage1 + 1;
            stage3 <= stage2 + 1;
            stage4 <= stage3 + 1;
            stage5 <= stage4 + 1;
            stage6 <= stage5 + 1;
            stage7 <= stage6 + 1;
            data_out <= stage7;
        end
    end
endmodule