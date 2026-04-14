module top_module(
    input [3:0] a,
    input [3:0] b,
    input mode,
    output [3:0] out
);wire [3:0] sum;
    wire [3:0] neg_b;

    assign neg_b = ~b + 1;
    assign sum = a + b;

    assign out = (mode == 1) ? sum : (a + neg_b);

endmodule