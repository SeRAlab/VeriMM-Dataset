module pipelined_processor (
    input clk,
    input reset,
    input [3:0] instruction_in,
    output reg [3:0] result_out
);

    reg [3:0] IF_ID_instruction;
    reg [3:0] ID_EX_instruction;
    reg [3:0] EX_MEM_instruction;
    reg [3:0] MEM_WB_instruction;

    reg [3:0] ALU_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instruction <= 4'd0;
            ID_EX_instruction <= 4'd0;
            EX_MEM_instruction <= 4'd0;
            MEM_WB_instruction <= 4'd0;
            result_out <= 4'd0;
        end else begin
            // Pipeline stages
            IF_ID_instruction <= instruction_in; // IF Stage

            // ID stage (simple decoding logic)
            ID_EX_instruction <= IF_ID_instruction; // ID Stage

            // EX stage (perform operation)
            case (ID_EX_instruction[3:0])
                4'b0000: ALU_result <= ALU_result + 1; // ADD
                4'b0001: ALU_result <= ALU_result - 1; // SUB
                4'b0010: ALU_result <= ALU_result & 1; // AND
                4'b0011: ALU_result <= ALU_result | 1; // OR
                default: ALU_result <= ALU_result; // NOP
            endcase
            EX_MEM_instruction <= ID_EX_instruction; // Pass to MEM stage

            // MEM stage (no operation in this simple case)
            MEM_WB_instruction <= EX_MEM_instruction; // Pass to WB stage

            // WB stage (write back result)
            result_out <= ALU_result; // Write back to output
        end
    end
endmodule