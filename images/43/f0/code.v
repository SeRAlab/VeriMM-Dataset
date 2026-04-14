module top_module(
    Y,
    A
);output Y;
    input  A;

    assign Y = ~A;

endmodule