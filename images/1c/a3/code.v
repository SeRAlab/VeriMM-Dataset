module instruction_pipeline (
    input clk,
    input rst,
    input [15:0] instruction_in,
    output reg [15:0] instruction_out
);
    reg [15:0] IF_reg;
    reg [15:0] ID_reg;
    reg [15:0] EX_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_reg <= 16'b0;
            ID_reg <= 16'b0;
            EX_reg <= 16'b0;
            instruction_out <= 16'b0;
        end else begin
            // Instruction Fetch
            IF_reg <= instruction_in;
            // Instruction Decode
            ID_reg <= IF_reg;
            // Instruction Execute
            EX_reg <= ID_reg;
            // Final output after execution
            instruction_out <= EX_reg;
        end
    end
endmodule