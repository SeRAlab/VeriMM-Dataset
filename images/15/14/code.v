module pipelined_adder (
    input clk,
    input rst,
    input [7:0] in_a,
    input [7:0] in_b,
    output reg [7:0] result,
    output reg valid
);
    reg [7:0] IF_reg_a, IF_reg_b;
    reg [7:0] ID_reg_a, ID_reg_b;
    reg [7:0] EX_reg_a, EX_reg_b;
    reg [7:0] MEM_reg_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_reg_a <= 0;
            IF_reg_b <= 0;
            ID_reg_a <= 0;
            ID_reg_b <= 0;
            EX_reg_a <= 0;
            EX_reg_b <= 0;
            MEM_reg_result <= 0;
            result <= 0;
            valid <= 0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_reg_a <= in_a;
            IF_reg_b <= in_b;

            // Stage 2: Instruction Decode
            ID_reg_a <= IF_reg_a;
            ID_reg_b <= IF_reg_b;

            // Stage 3: Execute
            EX_reg_a <= ID_reg_a;
            EX_reg_b <= ID_reg_b;

            // Stage 4: Memory Access (No memory in this case)
            MEM_reg_result <= EX_reg_a + EX_reg_b;

            // Stage 5: Write Back
            result <= MEM_reg_result;
            valid <= 1; // Indicate valid output
        end
    end
endmodule