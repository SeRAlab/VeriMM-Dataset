module pipeline_processor (
    input clk,
    input reset,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1 <= 5'b0;
            stage2 <= 5'b0;
            stage3 <= 5'b0;
            stage4 <= 5'b0;
            stage5 <= 5'b0;
            stage6 <= 5'b0;
            stage7 <= 5'b0;
            data_out <= 5'b0;
        end else begin
            stage1 <= data_in;
            stage2 <= stage1;
            stage3 <= stage2;
            stage4 <= stage3;
            stage5 <= stage4;
            stage6 <= stage5;
            stage7 <= stage6;
            data_out <= stage7;
        end
    end
endmodule