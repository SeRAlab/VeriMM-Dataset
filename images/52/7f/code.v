module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output [3:0] OUT
);assign OUT = SUB ? B - A : A + B;

endmodule