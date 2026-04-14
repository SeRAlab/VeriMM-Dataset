module pipeline_processor (
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    input control,
    output reg [7:0] result
);
    reg [3:0] stage1_A, stage1_B;
    reg stage1_control;
    reg [3:0] stage2_A, stage2_B;
    reg stage2_control;
    reg [7:0] stage3_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_A <= 0;
            stage1_B <= 0;
            stage1_control <= 0;
            stage2_A <= 0;
            stage2_B <= 0;
            stage2_control <= 0;
            stage3_result <= 0;
            result <= 0;
        end else begin
            // Stage 1
            stage1_A <= A;
            stage1_B <= B;
            stage1_control <= control;

            // Stage 2
            stage2_A <= stage1_A;
            stage2_B <= stage1_B;
            stage2_control <= stage1_control;

            // Stage 3
            if (stage2_control == 0)
                stage3_result <= stage2_A + stage2_B; // Addition
            else
                stage3_result <= stage2_A * stage2_B; // Multiplication

            // Stage 4
            result <= stage3_result; // Output after 5 cycles
        end
    end
endmodule