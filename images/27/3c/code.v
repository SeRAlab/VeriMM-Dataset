module pipelined_processor (
    input clk,
    input reset,
    input [3:0] instruction_1,
    input [3:0] instruction_2,
    output reg [3:0] result_1,
    output reg [3:0] result_2
);
    reg [3:0] IF_ID_inst_1, IF_ID_inst_2;
    reg [3:0] ID_EX_inst_1, ID_EX_inst_2;
    reg [3:0] EX_MEM_inst_1, EX_MEM_inst_2;
    reg [3:0] MEM_WB_inst_1, MEM_WB_inst_2;

    // Registers to hold result of the operations
    reg [3:0] ALU_out_1, ALU_out_2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_inst_1 <= 0;
            IF_ID_inst_2 <= 0;
            ID_EX_inst_1 <= 0;
            ID_EX_inst_2 <= 0;
            EX_MEM_inst_1 <= 0;
            EX_MEM_inst_2 <= 0;
            MEM_WB_inst_1 <= 0;
            MEM_WB_inst_2 <= 0;
            result_1 <= 0;
            result_2 <= 0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_ID_inst_1 <= instruction_1;
            IF_ID_inst_2 <= instruction_2;

            // Stage 2: Instruction Decode
            ID_EX_inst_1 <= IF_ID_inst_1;
            ID_EX_inst_2 <= IF_ID_inst_2;

            // Stage 3: Execute
            case (ID_EX_inst_1)
                4'b0001: ALU_out_1 <= ID_EX_inst_1 + ID_EX_inst_2; // ADD
                4'b0010: ALU_out_1 <= ID_EX_inst_1 - ID_EX_inst_2; // SUB
                4'b0011: ALU_out_1 <= ID_EX_inst_1 & ID_EX_inst_2; // AND
                4'b0100: ALU_out_1 <= ID_EX_inst_1 | ID_EX_inst_2; // OR
                default: ALU_out_1 <= 0;
            endcase

            // Stage 4: Memory Access
            EX_MEM_inst_1 <= ALU_out_1;

            // Stage 5: Write Back
            MEM_WB_inst_1 <= EX_MEM_inst_1;
            result_1 <= MEM_WB_inst_1;
        end
    end
endmodule