module top_module(
    input [3:0] A,
    output [3:0] Y
);assign Y = ~A + 1;

endmodule