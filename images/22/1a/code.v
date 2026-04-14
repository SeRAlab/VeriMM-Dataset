module instruction_pipeline (
    input wire clk,
    input wire [3:0] instruction,
    output reg [1:0] opcode,
    output reg [1:0] operand
);

    always @(posedge clk) begin
        opcode <= instruction[3:2];
        operand <= instruction[1:0];
    end
endmodule