module top_module(
    input [3:0] A,
    input [3:0] B,
    output equal,
    output greater
);assign equal = (A == B) ? 1'b1 : 1'b0;
    assign greater = (A > B) ? 1'b1 : 1'b0;

endmodule