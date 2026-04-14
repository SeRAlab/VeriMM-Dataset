module instruction_pipeline (
    input clk,
    input enable,
    input [0:0] instruction_in, // 1-bit instruction input
    output reg [0:0] instruction_out // 1-bit instruction output
);
    reg [0:0] IF_reg; // IF stage register
    reg [0:0] ID_reg; // ID stage register

    always @(posedge clk) begin
        if (enable) begin
            IF_reg <= instruction_in; // Stage 1: Instruction Fetch
            ID_reg <= IF_reg;          // Stage 2: Instruction Decode
            instruction_out <= ID_reg; // Stage 3: Instruction Execute
        end
    end
endmodule