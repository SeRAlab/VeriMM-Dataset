module pipeline_arithmetic (
    input clk,
    input rst_n,
    input [1:0] operation, // 00: ADD, 01: SUB
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] result
);
    reg [31:0] stage1_op1, stage1_op2;
    reg [1:0] stage1_op;
    reg [31:0] stage2_result;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_op1 <= 32'b0;
            stage1_op2 <= 32'b0;
            stage1_op <= 2'b00;
            stage2_result <= 32'b0;
            result <= 32'b0;
        end else begin
            // Stage 1: Instruction Fetch/Decode
            stage1_op1 <= operand1;
            stage1_op2 <= operand2;
            stage1_op <= operation;

            // Stage 2: Execute
            case (stage1_op)
                2'b00: stage2_result <= stage1_op1 + stage1_op2; // ADD
                2'b01: stage2_result <= stage1_op1 - stage1_op2; // SUB
                default: stage2_result <= 32'b0;
            endcase

            // Stage 3: Write Back
            result <= stage2_result;
        end
    end
endmodule