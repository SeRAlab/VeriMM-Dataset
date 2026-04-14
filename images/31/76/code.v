module pipeline_processor (
    input clk,
    input rst,
    input [7:0] instruction,
    output reg [7:0] result
);
    reg [7:0] IF_ID_instruction;
    reg [7:0] ID_EX_instruction;
    reg [7:0] EX_MEM_instruction;
    reg [7:0] MEM_WB_instruction;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_instruction <= 8'b0;
            ID_EX_instruction <= 8'b0;
            EX_MEM_instruction <= 8'b0;
            MEM_WB_instruction <= 8'b0;
            result <= 8'b0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_ID_instruction <= instruction;

            // Stage 2: Instruction Decode
            ID_EX_instruction <= IF_ID_instruction;

            // Stage 3: Execute
            EX_MEM_instruction <= ID_EX_instruction; // Here you could implement an actual operation

            // Stage 4: Memory Access
            MEM_WB_instruction <= EX_MEM_instruction; // Just passing the instruction for this example

            // Stage 5: Write Back
            result <= MEM_WB_instruction; // Output the instruction as result
        end
    end
endmodule