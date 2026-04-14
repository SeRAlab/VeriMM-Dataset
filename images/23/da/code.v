module pipelined_cpu (
    input clk,
    input reset,
    input [31:0] instruction,
    output reg [31:0] result
);
    reg [31:0] IF_ID_instr, ID_EX_instr, EX_MEM_instr, MEM_WB_instr;
    reg [31:0] ID_EX_a, ID_EX_b, EX_MEM_result, MEM_WB_result;
    reg [4:0] ID_EX_rd, EX_MEM_rd, MEM_WB_rd;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instr <= 0;
            ID_EX_instr <= 0;
            EX_MEM_instr <= 0;
            MEM_WB_instr <= 0;
            result <= 0;
        end else begin
            // Instruction Fetch Stage
            IF_ID_instr <= instruction;

            // Instruction Decode Stage
            ID_EX_instr <= IF_ID_instr;
            ID_EX_a <= // extract source register from ID_EX_instr
            ID_EX_b <= // extract second source register from ID_EX_instr
            ID_EX_rd <= // extract destination register from ID_EX_instr

            // Execute Stage
            EX_MEM_instr <= ID_EX_instr;
            case (ID_EX_instr[31:26]) // opcode
                6'b000000: EX_MEM_result <= ID_EX_a + ID_EX_b; // ADD
                6'b000001: EX_MEM_result <= ID_EX_a - ID_EX_b; // SUB
                // Other operations...
            endcase
            EX_MEM_rd <= ID_EX_rd;

            // Memory Access Stage
            MEM_WB_instr <= EX_MEM_instr;
            MEM_WB_result <= EX_MEM_result;

            // Write Back Stage
            result <= MEM_WB_result; // write back the result
        end
    end
endmodule