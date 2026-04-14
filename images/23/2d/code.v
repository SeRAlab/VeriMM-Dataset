module pipelined_processor (
    input clk,
    input reset,
    input [1:0] opcode, // 00: ADD, 01: SUB
    input [7:0] operand1,
    input [7:0] operand2,
    output reg [7:0] result
);

    reg [7:0] IF_reg_operand1, IF_reg_operand2;
    reg [1:0] ID_reg_opcode;
    reg [7:0] EX_reg_result;

    // Stage IF (Instruction Fetch)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_reg_operand1 <= 8'b0;
            IF_reg_operand2 <= 8'b0;
        end else begin
            IF_reg_operand1 <= operand1;
            IF_reg_operand2 <= operand2;
        end
    end

    // Stage ID (Instruction Decode)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_reg_opcode <= 2'b0;
        end else begin
            ID_reg_opcode <= opcode;
        end
    end

    // Stage EX (Execute)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EX_reg_result <= 8'b0;
        end else begin
            case (ID_reg_opcode)
                2'b00: EX_reg_result <= IF_reg_operand1 + IF_reg_operand2; // ADD
                2'b01: EX_reg_result <= IF_reg_operand1 - IF_reg_operand2; // SUB
                default: EX_reg_result <= 8'b0;
            endcase
        end
    end

    // Stage WB (Write Back)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 8'b0;
        end else begin
            result <= EX_reg_result;
        end
    end

endmodule