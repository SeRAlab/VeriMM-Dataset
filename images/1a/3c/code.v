module pipeline_processor(
    input clk,
    input rst,
    input [31:0] instruction,
    output reg [31:0] result
);
    reg [31:0] IF_ID_instruction;
    reg [31:0] ID_EX_operand1, ID_EX_operand2;
    reg [31:0] EX_MEM_result;
    reg [4:0] ID_EX_opcode, EX_MEM_opcode;
    reg valid;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_instruction <= 32'b0;
            ID_EX_operand1 <= 32'b0;
            ID_EX_operand2 <= 32'b0;
            EX_MEM_result <= 32'b0;
            valid <= 1'b0;
        end else begin
            // Fetch stage
            IF_ID_instruction <= instruction;

            // Decode stage
            ID_EX_opcode <= IF_ID_instruction[31:27];
            ID_EX_operand1 <= IF_ID_instruction[26:21];
            ID_EX_operand2 <= IF_ID_instruction[20:15];

            // Execute stage
            if (ID_EX_opcode == 5'b00001) begin // ADD
                EX_MEM_result <= ID_EX_operand1 + ID_EX_operand2;
            end else if (ID_EX_opcode == 5'b00010) begin // SUB
                EX_MEM_result <= ID_EX_operand1 - ID_EX_operand2;
            end

            // Memory Access stage (not used in this simple example)
            
            // Write Back stage
            result <= EX_MEM_result;
        end
    end
endmodule