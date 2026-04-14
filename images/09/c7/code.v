module pipeline_processor(
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] result_out
);
    reg [31:0] IF_ID_instr;
    reg [31:0] ID_EX_instr;
    reg [31:0] EX_MEM_instr;
    reg [31:0] MEM_WB_instr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instr <= 32'b0;
            ID_EX_instr <= 32'b0;
            EX_MEM_instr <= 32'b0;
            MEM_WB_instr <= 32'b0;
            result_out <= 32'b0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_ID_instr <= instruction_in;

            // Stage 2: Instruction Decode
            ID_EX_instr <= IF_ID_instr;

            // Stage 3: Execute
            EX_MEM_instr <= ID_EX_instr;

            // Stage 4: Memory Access
            MEM_WB_instr <= EX_MEM_instr;

            // Stage 5: Write Back
            result_out <= MEM_WB_instr; // Assuming the instruction is directly the result for simplicity
        end
    end
endmodule