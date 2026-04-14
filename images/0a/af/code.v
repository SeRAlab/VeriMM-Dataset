module instruction_pipeline (
    input clk,
    input rst,
    input [15:0] instruction_in,
    output reg [15:0] instruction_out
);
    reg [15:0] IF_reg, ID_reg, EX_reg, MEM_reg, WB_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_reg <= 16'b0;
            ID_reg <= 16'b0;
            EX_reg <= 16'b0;
            MEM_reg <= 16'b0;
            WB_reg <= 16'b0;
        end else begin
            IF_reg <= instruction_in; // Stage 1: Instruction Fetch
            ID_reg <= IF_reg;          // Stage 2: Instruction Decode
            EX_reg <= ID_reg;          // Stage 3: Execute
            MEM_reg <= EX_reg;         // Stage 4: Memory Access
            WB_reg <= MEM_reg;         // Stage 5: Write Back
            instruction_out <= WB_reg; // Output after Write Back
        end
    end
endmodule