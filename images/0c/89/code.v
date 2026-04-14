module pipeline_adder (
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result
);
    reg [7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 0;
            stage2 <= 0;
            stage3 <= 0;
            stage4 <= 0;
            stage5 <= 0;
            stage6 <= 0;
            stage7 <= 0;
            result <= 0;
        end else begin
            stage1 <= a + b;         // Stage 1: Fetch a and b
            stage2 <= stage1;        // Stage 2: Decode
            stage3 <= stage2;        // Stage 3: Execute
            stage4 <= stage3;        // Stage 4: Memory access
            stage5 <= stage4;        // Stage 5: Writeback
            stage6 <= stage5;        // Stage 6: Final processing
            stage7 <= stage6;        // Stage 7: Output stage
            result <= stage7;        // Output the final result
        end
    end
endmodule