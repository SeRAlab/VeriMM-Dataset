module pipelined_adder (
    input clk,
    input rst,
    input [23:0] operand_a,
    input [23:0] operand_b,
    output reg [23:0] result
);
    reg [23:0] IF_instr_a, IF_instr_b;
    reg [23:0] ID_instr_a, ID_instr_b;
    reg [23:0] EX_result;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_instr_a <= 0;
            IF_instr_b <= 0;
            ID_instr_a <= 0;
            ID_instr_b <= 0;
            EX_result <= 0;
            result <= 0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_instr_a <= operand_a;
            IF_instr_b <= operand_b;

            // Stage 2: Instruction Decode
            ID_instr_a <= IF_instr_a;
            ID_instr_b <= IF_instr_b;

            // Stage 3: Execute
            EX_result <= ID_instr_a + ID_instr_b;

            // Stage 4: Write Back
            result <= EX_result;
        end
    end
endmodule