module pipeline_processor(
    input clk,
    input reset,
    input [4:0] instruction,
    output reg [4:0] stage1,
    output reg [4:0] stage2,
    output reg [4:0] stage3,
    output reg [4:0] stage4,
    output reg [4:0] stage5,
    output reg [4:0] stage6,
    output reg [4:0] stage7
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1 <= 5'b00000;
            stage2 <= 5'b00000;
            stage3 <= 5'b00000;
            stage4 <= 5'b00000;
            stage5 <= 5'b00000;
            stage6 <= 5'b00000;
            stage7 <= 5'b00000;
        end else begin
            stage1 <= instruction;
            stage2 <= stage1;
            stage3 <= stage2;
            stage4 <= stage3;
            stage5 <= stage4;
            stage6 <= stage5;
            stage7 <= stage6;
        end
    end
endmodule