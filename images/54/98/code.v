module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output [3:0] OUT
);wire [3:0] B_NEG;
    wire CARRY_IN;
    wire CARRY_OUT;

    assign B_NEG = ~B + 1;

    assign CARRY_IN = SUB & 1'b1;
    assign CARRY_OUT = (SUB & (A < B)) | (~SUB & (OUT < A+B));

    assign OUT = SUB ? A + B_NEG + CARRY_IN : A + B + CARRY_IN;

endmodule