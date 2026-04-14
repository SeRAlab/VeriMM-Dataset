module pipelined_alu (
    input clk,
    input rst,
    input [1:0] opcode,
    input [15:0] operand_a,
    input [15:0] operand_b,
    output reg [15:0] result,
    output reg valid
);

    reg [15:0] stage1_a, stage1_b;
    reg [1:0] stage1_opcode;
    reg [15:0] stage2_result;
    reg [1:0] stage2_opcode;
    reg stage3_valid;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_a <= 0;
            stage1_b <= 0;
            stage1_opcode <= 0;
            stage2_result <= 0;
            stage2_opcode <= 0;
            stage3_valid <= 0;
            result <= 0;
            valid <= 0;
        end else begin
            // Stage 1: Fetch
            stage1_a <= operand_a;
            stage1_b <= operand_b;
            stage1_opcode <= opcode;

            // Stage 2: Decode
            stage2_result <= (stage1_opcode == 2'b00) ? (stage1_a + stage1_b) : 
                             (stage1_opcode == 2'b01) ? (stage1_a - stage1_b) : 
                             (stage1_opcode == 2'b10) ? (stage1_a & stage1_b) : 0;
            stage2_opcode <= stage1_opcode;

            // Stage 3: Execute
            stage3_valid <= 1;

            // Stage 4: Memory (not used in this case, just pass through)
            // Stage 5: Write-back
            result <= stage2_result;
            valid <= stage3_valid;
        end
    end
endmodule