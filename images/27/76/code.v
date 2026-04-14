module pipeline (
    input clk,
    input reset,
    input [4:0] instruction_in,
    output reg [4:0] instruction_out
);
    reg [4:0] IF_REG, ID_REG, EX_REG, MEM_REG;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_REG <= 5'b00000;
            ID_REG <= 5'b00000;
            EX_REG <= 5'b00000;
            MEM_REG <= 5'b00000;
            instruction_out <= 5'b00000;
        end else begin
            IF_REG <= instruction_in;      // Stage 1: Instruction Fetch
            ID_REG <= IF_REG;              // Stage 2: Instruction Decode
            EX_REG <= ID_REG;              // Stage 3: Execute
            MEM_REG <= EX_REG;             // Stage 4: Memory Access
            instruction_out <= MEM_REG;    // Stage 5: Write Back
        end
    end
endmodule