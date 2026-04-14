module pipeline_processor(
    input clk,
    input rst,
    input [31:0] instruction,
    output reg [31:0] result
);
    reg [31:0] IF_ID_instruction;
    reg [31:0] ID_EX_instruction;
    reg [31:0] EX_MEM_instruction;
    reg [31:0] MEM_WB_instruction;

    // Register file (simplified)
    reg [31:0] reg_file[0:31];
    reg [31:0] alu_result;

    // Pipeline stages
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_instruction <= 32'b0;
            ID_EX_instruction <= 32'b0;
            EX_MEM_instruction <= 32'b0;
            MEM_WB_instruction <= 32'b0;
            result <= 32'b0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_ID_instruction <= instruction;

            // Stage 2: Instruction Decode
            ID_EX_instruction <= IF_ID_instruction;

            // Stage 3: Execute
            alu_result <= reg_file[ID_EX_instruction[25:21]] + reg_file[ID_EX_instruction[20:16]];
            EX_MEM_instruction <= {alu_result, ID_EX_instruction[15:0]}; // Store result for MEM stage

            // Stage 4: Memory Access
            MEM_WB_instruction <= EX_MEM_instruction;

            // Stage 5: Write Back
            result <= MEM_WB_instruction[31:0]; // Write result back to register
        end
    end
endmodule