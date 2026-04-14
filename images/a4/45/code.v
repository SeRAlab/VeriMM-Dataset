module top_module(
    input [7:0] a, b,
    input sel,
    output [7:0] f
);assign f = sel?b:a;

endmodule