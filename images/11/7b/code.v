module pipeline_adder(
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] sum
);
    reg [7:0] IF_a, IF_b;
    reg [7:0] ID_a, ID_b;
    reg [7:0] EX_sum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            IF_a <= 0;
            IF_b <= 0;
            ID_a <= 0;
            ID_b <= 0;
            EX_sum <= 0;
            sum <= 0;
        end else begin
            // Stage 1: Instruction Fetch
            IF_a <= a;
            IF_b <= b;

            // Stage 2: Instruction Decode
            ID_a <= IF_a;
            ID_b <= IF_b;

            // Stage 3: Execute
            EX_sum <= ID_a + ID_b;

            // Stage 4: Memory Access
            // No memory access in this simple example

            // Stage 5: Write Back
            sum <= EX_sum;
        end
    end
endmodule