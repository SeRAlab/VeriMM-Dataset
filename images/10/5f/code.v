module pipeline_processor (
    input clk,
    input reset,
    input [31:0] instruction,
    output reg [31:0] result
);

    reg [31:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1 <= 32'b0;
            stage2 <= 32'b0;
            stage3 <= 32'b0;
            stage4 <= 32'b0;
            stage5 <= 32'b0;
            stage6 <= 32'b0;
            stage7 <= 32'b0;
            result <= 32'b0;
        end else begin
            stage1 <= instruction; // Instruction fetch
            stage2 <= stage1;      // Instruction decode
            stage3 <= stage2;      // Execute
            stage4 <= stage3;      // Memory access
            stage5 <= stage4;      // Write back
            stage6 <= stage5;      // Additional processing
            stage7 <= stage6;      // Final output
            result <= stage7;      // Output result
        end
    end
endmodule