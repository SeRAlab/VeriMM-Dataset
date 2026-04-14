module top_module(
    input [width-1:0] A,
    output [width-1:0] Z
    );parameter width = 8;
    assign Z = (A == 0) ? 0 : 1;
endmodule