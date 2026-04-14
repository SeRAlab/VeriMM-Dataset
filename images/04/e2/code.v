module pipeline_processor (
    input clk,
    input reset,
    input [15:0] instruction,
    output reg [15:0] result
);
    reg [15:0] IF_ID_instruction;
    reg [15:0] ID_EX_instruction;
    reg [15:0] EX_MEM_result;
    reg [15:0] MEM_WB_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instruction <= 16'b0;
            ID_EX_instruction <= 16'b0;
            EX_MEM_result <= 16'b0;
            MEM_WB_result <= 16'b0;
            result <= 16'b0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_ID_instruction <= instruction;

            // Stage 2: Instruction Decode
            ID_EX_instruction <= IF_ID_instruction;

            // Stage 3: Execute
            EX_MEM_result <= ID_EX_instruction + 1; // Simple add operation for demonstration

            // Stage 4: Memory Access
            MEM_WB_result <= EX_MEM_result;

            // Stage 5: Write Back
            result <= MEM_WB_result;
        end
    end
endmodule