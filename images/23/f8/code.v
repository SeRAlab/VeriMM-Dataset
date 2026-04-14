module pipelined_processor(
    input clk,
    input rst,
    input [3:0] opcode, // 4-bit opcode for the operation
    input [15:0] operand1,
    input [15:0] operand2,
    output reg [15:0] result,
    output reg valid
);
    // State registers for pipeline stages
    reg [15:0] IF_operand1, IF_operand2;
    reg [3:0] ID_opcode;
    reg [15:0] EX_result;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            IF_operand1 <= 0;
            IF_operand2 <= 0;
            ID_opcode <= 0;
            EX_result <= 0;
            result <= 0;
            valid <= 0;
        end else begin
            // Instruction Fetch Stage
            IF_operand1 <= operand1;
            IF_operand2 <= operand2;
            
            // Instruction Decode Stage
            ID_opcode <= opcode;
            
            // Execute Stage
            case (ID_opcode)
                4'b0001: EX_result <= IF_operand1 + IF_operand2; // ADD
                4'b0010: EX_result <= IF_operand1 - IF_operand2; // SUB
                4'b0011: EX_result <= IF_operand1 * IF_operand2; // MUL
                4'b0100: EX_result <= IF_operand1 / IF_operand2; // DIV
                default: EX_result <= 0;
            endcase
            
            // Write Back Stage
            result <= EX_result;
            valid <= 1; // Mark that valid result is available
        end
    end
endmodule