module top_module(
    input [3:0] a,
    input [3:0] b,
    input sel,
    output [3:0] y
);

    assign y = sel ? b : a;  // 2-to-1 multiplexer

endmodule