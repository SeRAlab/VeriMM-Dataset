module instruction_pipeline (
    input clk,
    input rst,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out
);

    reg [31:0] IF_reg, ID_reg, EX_reg, MEM_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_reg <= 0;
            ID_reg <= 0;
            EX_reg <= 0;
            MEM_reg <= 0;
            instruction_out <= 0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_reg <= instruction_in;

            // Stage 2: Instruction Decode
            ID_reg <= IF_reg;

            // Stage 3: Execute
            EX_reg <= ID_reg;

            // Stage 4: Memory Access
            MEM_reg <= EX_reg;

            // Stage 5: Write Back
            instruction_out <= MEM_reg;
        end
    end
endmodule