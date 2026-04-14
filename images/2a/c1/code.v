module pipelined_processor(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    input CTRL, // 0 for addition, 1 for subtraction
    output reg [7:0] RESULT
);

    reg [7:0] stage1_A, stage1_B;
    reg stage1_CTRL;
    reg [7:0] stage2_A, stage2_B;
    reg stage2_CTRL;
    reg [7:0] stage3_A, stage3_B;
    reg stage3_CTRL;
    reg [7:0] stage4_A, stage4_B;
    reg stage4_CTRL;
    reg [7:0] stage5_A, stage5_B;
    reg stage5_CTRL;
    reg [7:0] stage6_A, stage6_B;
    reg stage6_CTRL;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all pipeline registers
            stage1_A <= 8'b0;
            stage1_B <= 8'b0;
            stage1_CTRL <= 0;
            stage2_A <= 8'b0;
            stage2_B <= 8'b0;
            stage2_CTRL <= 0;
            stage3_A <= 8'b0;
            stage3_B <= 8'b0;
            stage3_CTRL <= 0;
            stage4_A <= 8'b0;
            stage4_B <= 8'b0;
            stage4_CTRL <= 0;
            stage5_A <= 8'b0;
            stage5_B <= 8'b0;
            stage5_CTRL <= 0;
            stage6_A <= 8'b0;
            stage6_B <= 8'b0;
            stage6_CTRL <= 0;
            RESULT <= 8'b0;
        end else begin
            // Pipeline stages
            stage1_A <= A;
            stage1_B <= B;
            stage1_CTRL <= CTRL;

            stage2_A <= stage1_A;
            stage2_B <= stage1_B;
            stage2_CTRL <= stage1_CTRL;

            stage3_A <= stage2_A;
            stage3_B <= stage2_B;
            stage3_CTRL <= stage2_CTRL;

            stage4_A <= stage3_A;
            stage4_B <= stage3_B;
            stage4_CTRL <= stage3_CTRL;

            stage5_A <= stage4_A;
            stage5_B <= stage4_B;
            stage5_CTRL <= stage4_CTRL;

            stage6_A <= stage5_A;
            stage6_B <= stage5_B;
            stage6_CTRL <= stage5_CTRL;

            // Final result computation
            if (stage6_CTRL == 0) 
                RESULT <= stage6_A + stage6_B; // Addition
            else 
                RESULT <= stage6_A - stage6_B; // Subtraction
        end
    end
endmodule