module pipeline_processor (
    input clk,
    input reset,
    input [3:0] operand1,
    input [3:0] operand2,
    input [1:0] opcode,
    output reg [3:0] result
);
    reg [3:0] stage1_operand1;
    reg [3:0] stage1_operand2;
    reg [1:0] stage1_opcode;

    reg [3:0] stage2_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_operand1 <= 4'b0;
            stage1_operand2 <= 4'b0;
            stage1_opcode <= 2'b0;
            result <= 4'b0;
        end else begin
            // Stage 1: Fetch
            stage1_operand1 <= operand1;
            stage1_operand2 <= operand2;
            stage1_opcode <= opcode;

            // Stage 2: Process
            case (stage1_opcode)
                2'b00: stage2_result <= stage1_operand1 + stage1_operand2; // ADD
                2'b01: stage2_result <= stage1_operand1 - stage1_operand2; // SUB
                2'b10: stage2_result <= stage1_operand1 & stage1_operand2; // AND
                2'b11: stage2_result <= stage1_operand1 | stage1_operand2; // OR
                default: stage2_result <= 4'b0;
            endcase

            result <= stage2_result;
        end
    end
endmodule