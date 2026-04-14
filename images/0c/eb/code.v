module pipeline (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] IF_ID_instruction,
    output reg [31:0] ID_EX_instruction,
    output reg [31:0] EX_MEM_instruction,
    output reg [31:0] MEM_WB_instruction
);
    
    reg [31:0] instruction_buffer;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instruction <= 32'b0;
            ID_EX_instruction <= 32'b0;
            EX_MEM_instruction <= 32'b0;
            MEM_WB_instruction <= 32'b0;
            instruction_buffer <= 32'b0;
        end else begin
            // Pipeline stages
            IF_ID_instruction <= instruction_in; // Stage 1: Instruction Fetch
            ID_EX_instruction <= IF_ID_instruction; // Stage 2: Instruction Decode
            EX_MEM_instruction <= ID_EX_instruction; // Stage 3: Execute
            MEM_WB_instruction <= EX_MEM_instruction; // Stage 4: Memory Access
        end
    end

endmodule