module top_module(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] y
);

    assign y = sel ? b : a;  // 8-bit wide 2-to-1 multiplexer

endmodule