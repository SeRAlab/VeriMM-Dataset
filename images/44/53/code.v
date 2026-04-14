module top_module(
    output reg [6:0] opcode,
    output reg [2:0] dest_reg,
    output reg [2:0] src_reg_a,
    output reg [2:0] src_reg_b,
    output reg PL,
    output reg JB,
    output reg BC,
    input [15:0] instruction
    );always @(*) begin
        opcode = instruction[15:14];
        dest_reg = instruction[11:9];
        src_reg_a = instruction[5:3];
        src_reg_b = instruction[2:0];
        PL = (instruction[15] == 1) && (instruction[14] == 0);
        JB = (instruction[15] == 1) && (instruction[14] == 1);
        BC = (instruction[15] == 1) && (instruction[14] == 1);
    end

endmodule