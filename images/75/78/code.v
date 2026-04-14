module top_module(
    input [3:0] A,
    input [3:0] B,
    input shift,
    output [3:0] result
);assign result = shift ? (A << B) : A;

endmodule