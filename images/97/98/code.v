module top_module(
    input a,
    input b,
    input sel,
    output out
);wire w1;

    assign w1 = ~sel & a;
    assign out = sel & b | w1;

endmodule