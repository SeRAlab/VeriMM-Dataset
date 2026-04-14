module top_module(
    input [3:0] A,
    output [3:0] B
);assign B = A + (A << 1);

endmodule