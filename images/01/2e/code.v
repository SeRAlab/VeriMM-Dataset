module pipeline(
    input clk,
    input rst,
    input [7:0] instruction_in,
    output reg [7:0] instruction_out,
    output reg stall
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
            instruction_out <= 8'b0;
            stall <= 1'b0;
        end else begin
            // Instruction Fetch Stage
            IF_ID_instruction <= instruction_in;

            // Instruction Decode Stage
            if (EX_MEM_instruction == IF_ID_instruction) begin
                stall <= 1;
            end else begin
                stall <= 0;
                ID_EX_instruction <= IF_ID_instruction;
            end

            // Execution Stage
            EX_MEM_instruction <= ID_EX_instruction;

            // Memory Access Stage
            MEM_WB_instruction <= EX_MEM_instruction;

            // Write Back Stage
            instruction_out <= MEM_WB_instruction;
        end
    end
endmodule