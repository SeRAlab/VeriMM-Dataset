module instruction_pipeline (
    input clk,
    input reset,
    input [7:0] instruction_in,
    output reg [7:0] instruction_out,
    output reg [7:0] result
);
    reg [7:0] instruction_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_reg <= 8'b0;
            instruction_out <= 8'b0;
            result <= 8'b0;
        end else begin
            // Stage 1: Fetch instruction
            instruction_reg <= instruction_in;

            // Stage 2: Execute instruction (simple add operation)
            instruction_out <= instruction_reg;
            result <= instruction_reg + 8'b00000001; // Example operation
        end
    end
endmodule