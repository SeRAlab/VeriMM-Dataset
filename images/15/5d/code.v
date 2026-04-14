module pipeline_processor(
    input wire clk,
    input wire reset,
    input wire [4:0] instruction,
    output reg [2:0] opcode,
    output reg [1:0] instr_type
);
    // Pipeline registers
    reg [4:0] instruction_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_reg <= 5'b0;
            opcode <= 3'b0;
            instr_type <= 2'b0;
        end else begin
            instruction_reg <= instruction; // Stage 1: IF
            // Stage 2: ID
            opcode <= instruction_reg[4:2]; // 3-bit opcode from instruction
            instr_type <= instruction_reg[1:0]; // 2-bit instruction type
        end
    end
endmodule