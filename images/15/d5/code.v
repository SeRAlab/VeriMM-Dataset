module pipelined_processor(
    input clk,
    input reset,
    input [4:0] in_a, // Input register A
    input [4:0] in_b, // Input register B
    input [4:0] in_c, // Input register C
    input [4:0] in_d, // Input register D
    input [4:0] in_e, // Input register E
    output reg [4:0] out // Output register
);

reg [4:0] stage1, stage2, stage3, stage4;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stage1 <= 0;
        stage2 <= 0;
        stage3 <= 0;
        stage4 <= 0;
        out <= 0;
    end else begin
        // Stage 1: ADD
        stage1 <= in_a + in_b; // ADD operation

        // Stage 2: SUB
        stage2 <= stage1 - in_c; // SUB operation

        // Stage 3: AND
        stage3 <= stage2 & in_d; // AND operation

        // Stage 4: OR
        stage4 <= stage3 | in_e; // OR operation

        // Output: NOT
        out <= ~stage4; // NOT operation
    end
end

endmodule