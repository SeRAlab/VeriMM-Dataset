module instruction_pipeline (
    input wire clk,
    input wire rst,
    input wire [31:0] instruction_in,
    output reg [31:0] result_out
);
    reg [31:0] PC; // Program Counter
    reg [31:0] IF_ID_instruction;
    reg [31:0] ID_EX_instruction;
    reg [31:0] EX_MEM_instruction;
    reg [31:0] MEM_WB_instruction;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 0;
            result_out <= 0;
        end else begin
            // Pipeline stages
            IF_ID_instruction <= instruction_in; // Instruction Fetch
            ID_EX_instruction <= IF_ID_instruction; // Instruction Decode
            EX_MEM_instruction <= ID_EX_instruction; // Execute
            MEM_WB_instruction <= EX_MEM_instruction; // Memory Access
            
            // Example: Just pass the instruction to the output for now
            result_out <= MEM_WB_instruction;
            PC <= PC + 4; // Increment PC for next instruction
        end
    end
endmodule