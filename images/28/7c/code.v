module pipeline_cpu (
    input clk,
    input rst,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out
);

    reg [31:0] IF_ID_instruction;
    reg [31:0] ID_EX_instruction;
    reg [31:0] EX_MEM_instruction;
    reg [31:0] MEM_WB_instruction;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_instruction <= 32'b0;
            ID_EX_instruction <= 32'b0;
            EX_MEM_instruction <= 32'b0;
            MEM_WB_instruction <= 32'b0;
            instruction_out <= 32'b0;
        end else begin
            // Instruction Fetch stage
            IF_ID_instruction <= instruction_in;

            // Instruction Decode stage
            ID_EX_instruction <= IF_ID_instruction;

            // Execute stage
            EX_MEM_instruction <= ID_EX_instruction;

            // Memory Access stage
            MEM_WB_instruction <= EX_MEM_instruction;

            // Write Back stage
            instruction_out <= MEM_WB_instruction;
        end
    end
endmodule