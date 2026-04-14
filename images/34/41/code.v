module pipeline (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out,
    output reg [31:0] result
);
    reg [31:0] IF_ID_instr;
    reg [31:0] ID_EX_instr;
    reg [31:0] EX_MEM_result;
    reg [31:0] MEM_WB_result;

    // Hazard detection logic
    reg stall;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_instr <= 0;
            ID_EX_instr <= 0;
            EX_MEM_result <= 0;
            MEM_WB_result <= 0;
            instruction_out <= 0;
            result <= 0;
            stall <= 0;
        end else begin
            // Instruction Fetch
            IF_ID_instr <= instruction_in;

            // Instruction Decode
            ID_EX_instr <= IF_ID_instr;
            
            // Execute stage (example: simple addition)
            EX_MEM_result <= ID_EX_instr + 1; // Simplistic operation for demo

            // Memory Access stage
            MEM_WB_result <= EX_MEM_result;

            // Write Back stage
            result <= MEM_WB_result;
            instruction_out <= ID_EX_instr;
        end
    end
endmodule