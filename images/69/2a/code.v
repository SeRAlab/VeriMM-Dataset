module top_module(
    x, y, s, o
);input [2:0] x, y;
    input s;
    output [2:0] o;

    assign o = ({3{~s}} & x) | ({3{s}} & y);endmodule