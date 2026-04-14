module pipelined_processor (
    input clk,
    input rst,
    input [31:0] instruction,
    output reg [5:0] opcode,
    output reg [31:0] operand1,
    output reg [31:0] operand2
);

    reg [31:0] instruction_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_reg <= 32'b0;
            opcode <= 6'b0;
            operand1 <= 32'b0;
            operand2 <= 32'b0;
        end else begin
            // Stage 1: Instruction Fetch
            instruction_reg <= instruction;
            // Stage 2: Instruction Decode
            opcode <= instruction_reg[31:26];
            operand1 <= instruction_reg[25:21];
            operand2 <= instruction_reg[20:16];
        end
    end
endmodule