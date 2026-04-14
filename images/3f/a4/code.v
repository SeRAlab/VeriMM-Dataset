module pipelined_processor(
    input clk,
    input rst,
    input [31:0] instruction_in,
    output reg [31:0] result_out
);
    // Pipeline registers
    reg [31:0] IF_ID_instruction;
    reg [31:0] ID_EX_instruction;
    reg [31:0] EX_MEM_result;
    reg [31:0] MEM_WB_result;

    // Control signals
    reg [1:0] ALU_op;

    // Stages
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_ID_instruction <= 32'b0;
            ID_EX_instruction <= 32'b0;
            EX_MEM_result <= 32'b0;
            MEM_WB_result <= 32'b0;
            result_out <= 32'b0;
        end else begin
            // Instruction Fetch stage
            IF_ID_instruction <= instruction_in;
            // Instruction Decode stage
            ID_EX_instruction <= IF_ID_instruction;
            // Execute stage
            // Simple ALU operation (addition for example)
            EX_MEM_result <= ID_EX_instruction + 1; // Dummy operation
            // Memory Access stage
            MEM_WB_result <= EX_MEM_result;
            // Write Back stage
            result_out <= MEM_WB_result;
        end
    end
endmodule